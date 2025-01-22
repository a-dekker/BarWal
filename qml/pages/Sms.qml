import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../localdb.js" as DB

Dialog {
    id: smsCodePage
    canAccept: name.text.trim().length > 0 && description.text !== ""
               && smsnr.text !== ""

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
            //spacing: 5
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
                EnterKey.onClicked: smsnr.focus = true
            }
            TextField {
                id: smsnr
                placeholderText: qsTr("Telephone number")
                inputMethodHints: Qt.ImhDigitsOnly
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.onClicked: smsmessage.focus = true
            }
            TextField {
                id: smsmessage
                placeholderText: qsTr("Optional text body")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.onClicked: accept()
            }
            Label {
                id: code
                width: parent.width
                font.pixelSize: smsmessage.text === "" ? Theme.fontSizeExtraLarge : Theme.fontSizeMedium
                horizontalAlignment: Text.Center
                color: Theme.secondaryHighlightColor
                text: smsmessage.text === "" ? "sms:" + smsnr.text : "sms:" + smsnr.text + "?body=" + smsmessage.text.replace(/ /g, '%20')
                visible: description.text !== "" && name.text !== ""
            }
        }
    }
}
