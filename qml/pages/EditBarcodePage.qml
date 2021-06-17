import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Dialog {
    id: editCodePage
    canAccept: name.text.trim().length > 0

    property string barcode_name: ""
    property int barcode_index: 0
    property string barcode_description: ""
    property string barcode_code: ""
    property string barcode_type: ""
    property var dataModel: ListModel {}

    function appendBarcodeFromList(name, linecount) {
        dataModel.append({
                             "Name": name,
                             "LineCount": linecount
                         })
        if (name === barcode_type) {
            barcode_index = linecount
        }
    }

    Component.onCompleted: {
        DB.readBarcodeList()
        barcodetype.currentIndex = barcode_index
    }

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
            menu: ContextMenu {
                Repeater {
                    model: dataModel
                    MenuItem {
                        text: model.Name
                    }
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
                         mainapp.groupName, "", barcode_name)
        mainapp.barcodesChanged = true
    }
}
