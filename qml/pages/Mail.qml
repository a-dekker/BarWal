import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../localdb.js" as DB

Dialog {
    id: mailCodePage
    canAccept: name.text.trim().length > 0 && description.text !== ""
               && mailaddr.text !== ""

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

    onAccepted: {
        var result = DB.writeBarcode(name.text.trim(), "QR Code",
                                     description.text.trim(), code.text.trim(),
                                     mainapp.groupName, "", 58)
        if (result === "ERROR") {
            banner("ERROR", qsTr("Could not add barcode!"))
        }
        mainapp.barcodesChanged = true
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        clip: true

        ScrollDecorator {}

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            DialogHeader {
                id: header
                acceptText: qsTr("Create code")
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
                EnterKey.onClicked: mailaddr.focus = true
            }
            TextField {
                id: mailaddr
                placeholderText: qsTr("Email address")
                inputMethodHints: Qt.ImhEmailCharactersOnly
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.onClicked: mailsubject.focus = true
            }
            TextField {
                id: mailsubject
                placeholderText: qsTr("Email subject")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.onClicked: mailbody.focus = true
            }
            TextField {
                id: mailbody
                placeholderText: qsTr("Email text")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.onClicked: accept()
            }
            Label {
                id: code
                width: parent.width
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.Center
                color: Theme.secondaryHighlightColor
                text: "mailto:" + mailaddr.text + "?subject=" + mailsubject.text
                      + "&body=" + mailbody.text

                visible: description.text !== "" && name.text !== ""
            }
        }
    }
}
