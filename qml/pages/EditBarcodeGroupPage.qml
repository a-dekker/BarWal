import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Dialog {
    canAccept: groupName.text.trim().length > 0

    property string barcode_group: ""

    Column {
        id: col
        spacing: 5
        width: parent.width
        DialogHeader {
            id: header
        }


        TextField {
            id: groupName
            width: parent.width
            focus: true
            placeholderText: qsTr("Name")
            label: placeholderText
            text: barcode_group
            EnterKey.text: "OK"
            EnterKey.enabled: text.trim().length > 0
            EnterKey.onClicked: {
                DB.updateBarcodeGroup(groupName.text.trim(), barcode_group)
                mainapp.groupsChanged = true
                pageStack.pop()
            }
        }
    }
    onAccepted: {
        DB.updateBarcodeGroup(groupName.text.trim(), barcode_group)
        mainapp.groupsChanged = true
    }
}
