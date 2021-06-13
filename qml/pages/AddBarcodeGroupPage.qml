import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Dialog {
    canAccept: groupName.text.trim().length > 0

    Column {
        id: col
        spacing: 5
        width: parent.width
        DialogHeader {
            id: header
            acceptText: qsTr("Create group")
        }

        TextField {
            id: groupName
            width: parent.width
            focus: true
            placeholderText: qsTr("Name")
            label: placeholderText
            text: ""
            EnterKey.text: "OK"
            EnterKey.enabled: text.trim().length > 0
            EnterKey.onClicked: {
                DB.writeBarcodeGroup(groupName.text.trim(), "")
                mainapp.groupsChanged = true
                pageStack.pop()
            }
        }
    }
    onAccepted: {
        DB.writeBarcodeGroup(groupName.text.trim(), "")
        mainapp.groupsChanged = true
    }
}
