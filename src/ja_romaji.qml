
import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

KeyboardLayout {
    KeyboardRow {
        CharacterKey { caption: "q"; captionShifted: "Q"; symView: "1"; symView2: "€" }
        CharacterKey { caption: "w"; captionShifted: "W"; symView: "2"; symView2: "£" }
        CharacterKey { caption: "e"; captionShifted: "E"; symView: "3"; symView2: "$"; accents: "eèéêë€"; accentsShifted: "EÈÉÊË€" }
        CharacterKey { caption: "r"; captionShifted: "R"; symView: "4"; symView2: "¥" }
        CharacterKey { caption: "t"; captionShifted: "T"; symView: "5"; symView2: "₹"; accents: "tþ"; accentsShifted: "TÞ" }
        CharacterKey { caption: "y"; captionShifted: "Y"; symView: "6"; symView2: "%"; accents: "yý¥"; accentsShifted: "YÝ¥" }
        CharacterKey { caption: "u"; captionShifted: "U"; symView: "7"; symView2: "<"; accents: "uûùúü"; accentsShifted: "UÛÙÚÜ" }
        CharacterKey { caption: "i"; captionShifted: "I"; symView: "8"; symView2: ">"; accents: "iîïìí"; accentsShifted: "IÎÏÌÍ" }
        CharacterKey { caption: "o"; captionShifted: "O"; symView: "9"; symView2: "["; accents: "oöôòó"; accentsShifted: "OÖÔÒÓ" }
        CharacterKey { caption: "p"; captionShifted: "P"; symView: "0"; symView2: "]" }
    }

    KeyboardRow {
        CharacterKey { caption: "a"; captionShifted: "A"; symView: "*"; symView2: "`"; accents: "aäàâáãå"; accentsShifted: "AÄÀÂÁÃÅ"}
        CharacterKey { caption: "s"; captionShifted: "S"; symView: "#"; symView2: "^"; accents: "sß$"; accentsShifted: "S$" }
        CharacterKey { caption: "d"; captionShifted: "D"; symView: "+"; symView2: "|"; accents: "dð"; accentsShifted: "DÐ" }
        CharacterKey { caption: "f"; captionShifted: "F"; symView: "-"; symView2: "_" }
        CharacterKey { caption: "g"; captionShifted: "G"; symView: "="; symView2: "§" }
        CharacterKey { caption: "h"; captionShifted: "H"; symView: "("; symView2: "{" }
        CharacterKey { caption: "j"; captionShifted: "J"; symView: ")"; symView2: "}" }
        CharacterKey { caption: "k"; captionShifted: "K"; symView: "!"; symView2: "¡" }
        CharacterKey { caption: "l"; captionShifted: "L"; symView: "?"; symView2: "¿" }
        CharacterKey { caption: "ー"; } //captionShifted: "L"; symView: "?"; symView2: "¿" }
    }

    KeyboardRow {
        ShiftKey { }

        CharacterKey { caption: "z"; captionShifted: "Z"; symView: "@"; symView2: "«" }
        CharacterKey { caption: "x"; captionShifted: "X"; symView: "&"; symView2: "»" }
        CharacterKey { caption: "c"; captionShifted: "C"; symView: "/"; symView2: "\""; accents: "cç"; accentsShifted: "CÇ" }
        CharacterKey { caption: "v"; captionShifted: "V"; symView: "\\"; symView2: "“" }
        CharacterKey { caption: "b"; captionShifted: "B"; symView: "'"; symView2: "”" }
        CharacterKey { caption: "n"; captionShifted: "N"; symView: ";"; symView2: "„"; accents: "nñ"; accentsShifted: "NÑ" }
        CharacterKey { caption: "m"; captionShifted: "M"; symView: ":"; symView2: "~" }

        BackspaceKey {}
    }

    SpacebarRow { }
}
