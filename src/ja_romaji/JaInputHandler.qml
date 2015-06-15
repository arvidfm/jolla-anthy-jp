
import QtQuick 2.0
//import com.meego.maliitquick 1.0
import Sailfish.Silica 1.0
import com.jolla.keyboard 1.0
import se.behold.anthy 1.0
import ".."
import "../.."

import "parse_romaji.js" as Parser

InputHandler {

    property string preedit
    property var trie
    property bool trie_built: false

    Component.onCompleted: init()

    function init() {
        if (!Parser.trie_built) {
            Parser.build_hiragana_trie()
        }

        anthy.update_candidates('')
    }

    Anthy {
        id: anthy

        property var candidates: ListModel { }

        function update_candidates(str) {
            console.debug("Setting anthy string to '" + str + "'")
            candidates.clear()

            // WARNING: Before committing a segment or a prediction, the corresponding
            // set function (set_string/set_prediction_string) must be run.
            // We run set_prediction_string first here, followed by set_string,
            // so we don't need to re-run set_string when committing a segment.
            anthy.set_prediction_string(str)
            var pred = anthy.predictions()
            var predictions = []
            // don't add more than 15 predictions
            for (var i = 0; i < pred && i < 15; i++) {
                predictions.push(anthy.get_prediction(i))
            }

            anthy.set_string(str)
            var prim = ""
            var len = anthy.segments()

            // keep track of candidates already in the list
            // so we don't add duplicates
            var included_phrases = {}

            // the "primary" choice is the concatenation of the first candidate
            // for all segments
            for (var i = 0; i < len; i++) {
                prim += anthy.get_candidate(i, 0)
            }
            if (prim.length > 0) {
                candidates.append({text: prim, type: "full", segment: len, candidate: 0})
                included_phrases[prim] = true
            }

            var katakana = Parser.hiragana_to_katakana(str)
            var katakana_item = {text: katakana, type: "full", segment: -1, candidate: -1}


            len = anthy.segment_candidates(0)
            for (var i = 0; i < len; i++) {
                var s = anthy.get_candidate(0, i)
                if (s == katakana && i > 10) {
                    // move the katakana option ahead if included but more than 10 elements away
                    katakana_item.segment = 0
                    katakana_item.candidate = i
                    katakana_item.type = "partial"
                    continue
                }
                if (s != prim) {
                    included_phrases[s] = true
                    candidates.append({text: s, type: "partial", segment: 0, candidate: i})
                }
            }

            if (!(katakana in included_phrases) && katakana !== "") {
                candidates.insert(Math.min(5, candidates.count), katakana_item)
            }

            for (var i = 0; i < predictions.length; i++) {
                var cand = predictions[i]
                if (!(cand in included_phrases)) {
                    included_phrases[cand] = true
                    // add predictions after the primary choice
                    // (or first if there is no primary choice, i.e. preedit is empty)
                    candidates.insert(Math.min(i + 1, candidates.count), {text: cand, type: "prediction", segment: 0, candidate: i})
                }
            }

            candidatesUpdated()
        }

        function acceptPhrase(index, preedit) {
            var item = candidates.get(index)
            console.debug("accepting", index)
            console.debug("which is of the type", item.type, "and has the text", item.text)
            console.debug("segment", item.segment, "candidate", item.candidate)
            if (item.type == "full") {
                if (item.segment >= 0 && item.candidate >= 0) {
                    for (var i = 0; i < item.segment; i++) {
                        anthy.commit_segment(i, item.candidate)
                    }
                }
                commit(item.text)
            } else if (item.type == "prediction") {
                // NOTE: set_string was run before this, so we need to
                // re-run set_prediction_string to avoid a segfault
                anthy.set_prediction_string(preedit)
                anthy.commit_prediction(item.candidate)
                commit(item.text)
            } else {
                console.debug("getting legment length")
                var len = anthy.segment_length(item.segment)
                console.debug("segment length was", len)
                console.debug("commiting segment")
                // NOTE: no need to re-run set_string here since
                // we already ran it once following set_prediction_string
                anthy.commit_segment(item.segment, item.candidate)
                console.debug("commited segment")
                commit_partial(item.text, preedit.slice(len))
                console.debug("commited to text editor")
            }
        }

        signal candidatesUpdated
    }

    topItem: Component {
        TopItem {
            id: topItem
            Row {
                SilicaListView {
                    id: listView
                    model: anthy.candidates
                    orientation: ListView.Horizontal
                    width: topItem.width
                    height: topItem.height
                    boundsBehavior: !keyboard.expandedPaste && Clipboard.hasText ? Flickable.DragOverBounds : Flickable.StopAtBounds
                    header: pasteComponent
                    delegate: BackgroundItem {
                        id: backGround
                        onClicked: accept(model.index)
                        width: candidateText.width + Theme.paddingLarge * 2
                        height: topItem.height

                        Text {
                            id: candidateText
                            anchors.centerIn: parent
                            color: (backGround.down || index === 0) ? Theme.highlightColor : Theme.primaryColor
                            font { pixelSize: Theme.fontSizeSmall; family: Theme.fontFamily }
                            text: model.text
                        }
                    }
                    onCountChanged: positionViewAtBeginning()
                    onDraggingChanged: {
                        if (!dragging && !keyboard.expandedPaste && contentX < -(headerItem.width + Theme.paddingLarge)) {
                            keyboard.expandedPaste = true
                            positionViewAtBeginning()
                        }
                    }

                    Connections {
                        target: anthy
                        onCandidatesUpdated: listView.positionViewAtBeginning()
                    }

                    Connections {
                        target: Clipboard
                        onTextChanged: {
                            if (Clipboard.hasText) {
                                // need to have updated width before repositioning view
                                positionerTimer.restart()
                            }
                        }
                    }

                    Timer {
                        id: positionerTimer
                        interval: 10
                        onTriggered: listView.positionViewAtBeginning()
                    }
                }
            }
        }
    }

    Component {
        id: pasteComponent
        PasteButton {
            onClicked: {
                if (preedit.length > 0) {
                    commit(preedit)
                }
                MInputMethodQuick.sendCommit(Clipboard.text)
                keyboard.expandedPaste = false
            }
        }
    }

    function handleKeyClick() {
        var handled = false
        keyboard.expandedPaste = false

        if (pressedKey.key === Qt.Key_Space) {
            if (preedit !== "") {
                accept(0)

                if (keyboard.shiftState !== ShiftState.LockedShift) {
                    keyboard.shiftState = ShiftState.AutoShift
                }

                handled = true
            }
        } else if (pressedKey.key === Qt.Key_Return) {
            if (preedit !== "") {
                commit(preedit)
                handled = true
            }
        } else if (pressedKey.key === Qt.Key_Backspace && preedit !== "") {
            preedit = preedit.slice(0, preedit.length-1)
            anthy.update_candidates(preedit)
            MInputMethodQuick.sendPreedit(preedit)

            if (keyboard.shiftState !== ShiftState.LockedShift) {
                keyboard.shiftState = ShiftState.NoShift
            }

            handled = true
        } else if (pressedKey.text.length !== 0) {
            preedit = Parser.parse_romaji(preedit + pressedKey.text)
            anthy.update_candidates(preedit)

            if (keyboard.shiftState !== ShiftState.LockedShift) {
                keyboard.shiftState = ShiftState.NoShift
            }

            MInputMethodQuick.sendPreedit(preedit)
            handled = true
        }

        return handled
    }

    function accept(index) {
        console.debug("attempting to accept", index)
        anthy.acceptPhrase(index, preedit)
    }

    function reset() {
        preedit = ""
        anthy.update_candidates(preedit)
    }

    function commit(text) {
        MInputMethodQuick.sendCommit(text)
        reset()
    }

    function commit_partial(text, pe) {
        MInputMethodQuick.sendCommit(text)
        preedit = pe
        MInputMethodQuick.sendPreedit(preedit)
        anthy.update_candidates(preedit)
    }
}
