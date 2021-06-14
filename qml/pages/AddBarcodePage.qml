import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../localdb.js" as DB

Dialog {
    canAccept: name.text.trim().length > 0

    function banner(notificationType, message) {
        notification.close()
        var notificationCategory
        switch (notificationType) {
        case "OK":
            notificationCategory = "x-jolla.store.sideloading-success"
            break
        case "INFO":
            notificationCategory = "x-jolla.lipstick.credentials.needUpdate.notification"
            break
        case "WARNING":
            notificationCategory = "x-jolla.store.error"
            break
        case "ERROR":
            notificationCategory = "x-jolla.store.error"
            break
        }
        notification.category = notificationCategory
        notification.previewBody = message
        notification.previewSummary = "Barwal"
        notification.publish()
    }

    Notification {
        id: notification
        itemCount: 1
    }
    Column {
        id: col
        spacing: 5
        width: parent.width
        DialogHeader {
            id: header
            acceptText: qsTr("Create code")
        }

        ComboBox {
            id: barcode_type
            label: qsTr("Barcode type")
            menu: ContextMenu {
                MenuItem {
                    text: "1: Code 11"
                }
                MenuItem {
                    text: "2: Standard 2of5"
                }
                MenuItem {
                    text: "3: Interleaved 2of5"
                }
                MenuItem {
                    text: "4: IATA 2of5"
                }
                MenuItem {
                    text: "6: Data Logic"
                }
                MenuItem {
                    text: "7: Industrial 2of5"
                }
                MenuItem {
                    text: "8: Code 39"
                }
                MenuItem {
                    text: "9: Extended Code 39"
                }
                MenuItem {
                    text: "13: EAN"
                }
                MenuItem {
                    text: "14: EAN + Check"
                }
                MenuItem {
                    text: "16: GS1-128"
                }
                MenuItem {
                    text: "18: Codabar"
                }
                MenuItem {
                    text: "20: Code 128"
                }
                MenuItem {
                    text: "21: Leitcode"
                }
                MenuItem {
                    text: "22: Identcode"
                }
                MenuItem {
                    text: "23: Code 16k"
                }
                MenuItem {
                    text: "24: Code 49"
                }
                MenuItem {
                    text: "25: Code 93"
                }
                MenuItem {
                    text: "28: Flattermarken"
                }
                MenuItem {
                    text: "29: GS1 DataBar Omni"
                }
                MenuItem {
                    text: "30: GS1 DataBar Ltd"
                }
                MenuItem {
                    text: "31: GS1 DataBar Exp"
                }
                MenuItem {
                    text: "32: Telepen Alpha"
                }
                MenuItem {
                    text: "34: UPC-A"
                }
                MenuItem {
                    text: "35: UPC-A + Check"
                }
                MenuItem {
                    text: "37: UPC-E"
                }
                MenuItem {
                    text: "38: UPC-E + Check"
                }
                MenuItem {
                    text: "40: Postnet"
                }
                MenuItem {
                    text: "47: MSI Plessey"
                }
                MenuItem {
                    text: "49: FIM"
                }
                MenuItem {
                    text: "50: Logmars"
                }
                MenuItem {
                    text: "51: Pharma One-Track"
                }
                MenuItem {
                    text: "52: PZN"
                }
                MenuItem {
                    text: "53: Pharma Two-Track"
                }
                MenuItem {
                    text: "55: PDF417"
                }
                MenuItem {
                    text: "56: Compact PDF417"
                }
                MenuItem {
                    text: "57: Maxicode"
                }
                MenuItem {
                    text: "58: QR Code"
                }
                MenuItem {
                    text: "60: Code 128-B"
                }
                MenuItem {
                    text: "63: AP Standard Customer"
                }
                MenuItem {
                    text: "66: AP Reply Paid"
                }
                MenuItem {
                    text: "67: AP Routing"
                }
                MenuItem {
                    text: "68: AP Redirection"
                }
                MenuItem {
                    text: "69: ISBN"
                }
                MenuItem {
                    text: "70: RM4SCC"
                }
                MenuItem {
                    text: "71: Data Matrix"
                }
                MenuItem {
                    text: "72: EAN-14"
                }
                MenuItem {
                    text: "73: VIN"
                }
                MenuItem {
                    text: "74: Codablock-F"
                }
                MenuItem {
                    text: "75: NVE-18"
                }
                MenuItem {
                    text: "76: Japanese Post"
                }
                MenuItem {
                    text: "77: Korea Post"
                }
                MenuItem {
                    text: "79: GS1 DataBar Stack"
                }
                MenuItem {
                    text: "80: GS1 DataBar Stack Omni"
                }
                MenuItem {
                    text: "81: GS1 DataBar Exp Stack"
                }
                MenuItem {
                    text: "82: Planet"
                }
                MenuItem {
                    text: "84: MicroPDF"
                }
                MenuItem {
                    text: "85: USPS Intelligent Mail"
                }
                MenuItem {
                    text: "86: UK Plessey"
                }
                MenuItem {
                    text: "87: Telepen Numeric"
                }
                MenuItem {
                    text: "89: ITF-14"
                }
                MenuItem {
                    text: "90: KIX Code"
                }
                MenuItem {
                    text: "92: Aztec Code"
                }
                MenuItem {
                    text: "93: DAFT Code"
                }
                MenuItem {
                    text: "96: DPD Code"
                }
                MenuItem {
                    text: "97: Micro QR Code"
                }
                MenuItem {
                    text: "98: HIBC Code 128"
                }
                MenuItem {
                    text: "99: HIBC Code 39"
                }
                MenuItem {
                    text: "102: HIBC Data Matrix"
                }
                MenuItem {
                    text: "104: HIBC QR Code"
                }
                MenuItem {
                    text: "106: HIBC PDF417"
                }
                MenuItem {
                    text: "108: HIBC MicroPDF417"
                }
                MenuItem {
                    text: "110: HIBC Codablock-F"
                }
                MenuItem {
                    text: "112: HIBC Aztec Code"
                }
                MenuItem {
                    text: "115: DotCode"
                }
                MenuItem {
                    text: "116: Han Xin Code"
                }
                MenuItem {
                    text: "121: RM Mailmark"
                }
                MenuItem {
                    text: "128: Aztec Runes"
                }
                MenuItem {
                    text: "129: Code 32"
                }
                MenuItem {
                    text: "130: Comp EAN"
                }
                MenuItem {
                    text: "131: Comp GS1-128"
                }
                MenuItem {
                    text: "132: Comp DataBar Omni"
                }
                MenuItem {
                    text: "133: Comp DataBar Ltd"
                }
                MenuItem {
                    text: "134: Comp DataBar Exp"
                }
                MenuItem {
                    text: "135: Comp UPC-A"
                }
                MenuItem {
                    text: "136: Comp UPC-E"
                }
                MenuItem {
                    text: "137: Comp DataBar Stack"
                }
                MenuItem {
                    text: "138: Comp DataBar Stack Omni"
                }
                MenuItem {
                    text: "139: Comp DataBar Exp Stack"
                }
                MenuItem {
                    text: "140: Channel Code"
                }
                MenuItem {
                    text: "141: Code One"
                }
                MenuItem {
                    text: "142: Grid Matrix"
                }
                MenuItem {
                    text: "143: UPNQR"
                }
                MenuItem {
                    text: "144: Ultracode"
                }
                MenuItem {
                    text: "145: rMQR"
                }
            }
        }

        TextField {
            id: name
            focus: true
            placeholderText: qsTr("Name")
            label: placeholderText
            width: parent.width
            text: ""
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: description.focus = true
        }

        TextField {
            id: description
            placeholderText: qsTr("Description")
            label: placeholderText
            width: parent.width
            text: ""
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: code.focus = true
        }
        TextField {
            id: code
            placeholderText: qsTr("Code")
            label: placeholderText
            width: parent.width
            text: ""

            EnterKey.onClicked: accept()
        }
    }
    onAccepted: {
        var result = DB.writeBarcode(name.text.trim(),
                                     barcode_type.currentItem.text,
                                     description.text.trim(), code.text.trim(),
                                     mainapp.groupName, "",
                                     barcode_type.currentIndex)
        if (result === "ERROR") {
            banner("ERROR", qsTr("Could not add barcode!"))
        }
        mainapp.barcodesChanged = true
    }
}
