import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../localdb.js" as DB

Dialog {
    canAccept: groupName.text.trim().length > 0

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
                var result = DB.writeBarcodeGroup(groupName.text.trim(), "")
                if (result === "ERROR") {
                    banner("ERROR", qsTr("Could not add group!"))
                }
                mainapp.groupsChanged = true
                pageStack.pop()
            }
        }
    }
    onAccepted: {
        var result = DB.writeBarcodeGroup(groupName.text.trim(), "")
        if (result === "ERROR") {
            banner("ERROR", qsTr("Could not add group!"))
        }
        mainapp.groupsChanged = true
    }
}
