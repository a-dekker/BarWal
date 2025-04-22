import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../localdb.js" as DB

Dialog {
    id: wifiCodePage
    canAccept: name.text.trim().length > 0 && description.text !== "" && ssid.text !== ""

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
            spacing: 5
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
                EnterKey.onClicked: ssid.focus = true
            }
            TextField {
                id: ssid
                placeholderText: qsTr("SSID")
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhPreferLowercase | Qt.ImhNoAutoUppercase
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.onClicked: wifipassword.focus = true
            }
            ComboBox {
                id: wifiprotection
                label: qsTr("Wifi protection")
                description: qsTr("Choose the security protocol")
                menu: ContextMenu {
                    MenuItem {
                        text: "WPA"
                    }
                    MenuItem {
                        text: "WEP"
                    }
                    MenuItem {
                        text: "nopass"
                    }
                }
            }
            TextField {
                id: wifipassword
                placeholderText: qsTr("Password")
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhPreferLowercase | Qt.ImhNoAutoUppercase
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.onClicked: accept()
            }
            ComboBox {
                id: ssidvisible
                label: qsTr("SSID hidden")
                description: qsTr("Visibility network access point")
                menu: ContextMenu {
                    MenuItem {
                        text: "false"
                    }
                    MenuItem {
                        text: "true"
                    }
                    MenuItem {
                        text: "blank"
                    }
                }
            }
            Label {
                id: code
                width: parent.width
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.Center
                color: Theme.secondaryHighlightColor
                text: "WIFI:S:" + ssid.text + ";T:" + wifiprotection.currentItem.text + ";P:"
                      + wifipassword.text + ";H:" + ssidvisible.currentItem.text + ";;"
                visible: description.text !== "" && name.text !== ""
            }
        }
    }
}
