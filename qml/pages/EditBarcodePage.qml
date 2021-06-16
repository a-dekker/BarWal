import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Dialog {
    canAccept: name.text.trim().length > 0

    property string barcode_name: ""
    property int barcode_index: -1
    property string barcode_description: ""
    property string barcode_code: ""

    Column {
        id: col
        spacing: 5
        width: parent.width
        DialogHeader {
            id: header
        }

        ComboBox {
            id: barcodetype
            label: qsTr("Barcode type")
            currentIndex: barcode_index
            menu: ContextMenu {
                MenuItem {
                    text: "Code 11"
                }
                MenuItem {
                    text: "Standard 2of5"
                }
                MenuItem {
                    text: "Interleaved 2of5"
                }
                MenuItem {
                    text: "IATA 2of5"
                }
                MenuItem {
                    text: "Data Logic"
                }
                MenuItem {
                    text: "Industrial 2of5"
                }
                MenuItem {
                    text: "Code 39"
                }
                MenuItem {
                    text: "Extended Code 39"
                }
                MenuItem {
                    text: "EAN"
                }
                MenuItem {
                    text: "EAN + Check"
                }
                MenuItem {
                    text: "GS1-128"
                }
                MenuItem {
                    text: "Codabar"
                }
                MenuItem {
                    text: "Code 128"
                }
                MenuItem {
                    text: "Leitcode"
                }
                MenuItem {
                    text: "Identcode"
                }
                MenuItem {
                    text: "Code 16k"
                }
                MenuItem {
                    text: "Code 49"
                }
                MenuItem {
                    text: "Code 93"
                }
                MenuItem {
                    text: "Flattermarken"
                }
                MenuItem {
                    text: "GS1 DataBar Omni"
                }
                MenuItem {
                    text: "GS1 DataBar Ltd"
                }
                MenuItem {
                    text: "GS1 DataBar Exp"
                }
                MenuItem {
                    text: "Telepen Alpha"
                }
                MenuItem {
                    text: "UPC-A"
                }
                MenuItem {
                    text: "UPC-A + Check"
                }
                MenuItem {
                    text: "UPC-E"
                }
                MenuItem {
                    text: "UPC-E + Check"
                }
                MenuItem {
                    text: "Postnet"
                }
                MenuItem {
                    text: "MSI Plessey"
                }
                MenuItem {
                    text: "FIM"
                }
                MenuItem {
                    text: "Logmars"
                }
                MenuItem {
                    text: "Pharma One-Track"
                }
                MenuItem {
                    text: "PZN"
                }
                MenuItem {
                    text: "Pharma Two-Track"
                }
                MenuItem {
                    text: "PDF417"
                }
                MenuItem {
                    text: "Compact PDF417"
                }
                MenuItem {
                    text: "Maxicode"
                }
                MenuItem {
                    text: "QR Code"
                }
                MenuItem {
                    text: "Code 128-B"
                }
                MenuItem {
                    text: "AP Standard Customer"
                }
                MenuItem {
                    text: "AP Reply Paid"
                }
                MenuItem {
                    text: "AP Routing"
                }
                MenuItem {
                    text: "AP Redirection"
                }
                MenuItem {
                    text: "ISBN"
                }
                MenuItem {
                    text: "RM4SCC"
                }
                MenuItem {
                    text: "Data Matrix"
                }
                MenuItem {
                    text: "EAN-14"
                }
                MenuItem {
                    text: "VIN"
                }
                MenuItem {
                    text: "Codablock-F"
                }
                MenuItem {
                    text: "NVE-18"
                }
                MenuItem {
                    text: "Japanese Post"
                }
                MenuItem {
                    text: "Korea Post"
                }
                MenuItem {
                    text: "GS1 DataBar Stack"
                }
                MenuItem {
                    text: "GS1 DataBar Stack Omni"
                }
                MenuItem {
                    text: "GS1 DataBar Exp Stack"
                }
                MenuItem {
                    text: "Planet"
                }
                MenuItem {
                    text: "MicroPDF"
                }
                MenuItem {
                    text: "USPS Intelligent Mail"
                }
                MenuItem {
                    text: "UK Plessey"
                }
                MenuItem {
                    text: "Telepen Numeric"
                }
                MenuItem {
                    text: "ITF-14"
                }
                MenuItem {
                    text: "KIX Code"
                }
                MenuItem {
                    text: "Aztec Code"
                }
                MenuItem {
                    text: "DAFT Code"
                }
                MenuItem {
                    text: "DPD Code"
                }
                MenuItem {
                    text: "Micro QR Code"
                }
                MenuItem {
                    text: "HIBC Code 128"
                }
                MenuItem {
                    text: "HIBC Code 39"
                }
                MenuItem {
                    text: "HIBC Data Matrix"
                }
                MenuItem {
                    text: "HIBC QR Code"
                }
                MenuItem {
                    text: "HIBC PDF417"
                }
                MenuItem {
                    text: "HIBC MicroPDF417"
                }
                MenuItem {
                    text: "HIBC Codablock-F"
                }
                MenuItem {
                    text: "HIBC Aztec Code"
                }
                MenuItem {
                    text: "DotCode"
                }
                MenuItem {
                    text: "Han Xin Code"
                }
                MenuItem {
                    text: "RM Mailmark"
                }
                MenuItem {
                    text: "Aztec Runes"
                }
                MenuItem {
                    text: "Code 32"
                }
                MenuItem {
                    text: "Comp EAN"
                }
                MenuItem {
                    text: "Comp GS1-128"
                }
                MenuItem {
                    text: "Comp DataBar Omni"
                }
                MenuItem {
                    text: "Comp DataBar Ltd"
                }
                MenuItem {
                    text: "Comp DataBar Exp"
                }
                MenuItem {
                    text: "Comp UPC-A"
                }
                MenuItem {
                    text: "Comp UPC-E"
                }
                MenuItem {
                    text: "Comp DataBar Stack"
                }
                MenuItem {
                    text: "Comp DataBar Stack Omni"
                }
                MenuItem {
                    text: "Comp DataBar Exp Stack"
                }
                MenuItem {
                    text: "Channel Code"
                }
                MenuItem {
                    text: "Code One"
                }
                MenuItem {
                    text: "Grid Matrix"
                }
                MenuItem {
                    text: "UPNQR"
                }
                MenuItem {
                    text: "Ultracode"
                }
                MenuItem {
                    text: "rMQR"
                }
            }
        }

        TextField {
            id: name
            focus: true
            placeholderText: qsTr("Name")
            label: placeholderText
            text: barcode_name
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: description.focus = true
        }

        TextField {
            id: description
            placeholderText: qsTr("Description")
            label: placeholderText
            width: parent.width
            text: barcode_description
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: code.focus = true
        }
        TextField {
            id: code
            placeholderText: qsTr("Code")
            label: placeholderText
            width: parent.width
            text: barcode_code

            EnterKey.onClicked: accept()
        }
    }
    onAccepted: {
        DB.updateBarcode(name.text.trim(), barcodetype.currentItem.text,
                        description.text.trim(), code.text.trim(),
                        mainapp.groupName, "", barcodetype.currentIndex, barcode_name)
        mainapp.barcodesChanged = true
    }
}
