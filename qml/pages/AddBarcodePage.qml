import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../localdb.js" as DB

Dialog {
    id: addCodePage
    canAccept: name.text.trim().length > 0 && code.text !== ""
               && barcodetype.currentIndex !== -1

    property var dataModel: ListModel {}

    function appendBarcodeOnlyFromList(name) {
        dataModel.append({
                             "Name": name
                         })
    }

    Component.onCompleted: {
        DB.readBarcodeOnlyList()
    }

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
        var result = DB.writeBarcode(name.text.trim(),
                                     barcodetype.currentItem.text,
                                     description.text.trim(), code.text.trim(),
                                     mainapp.groupName, "",
                                     barcodetype.currentIndex)
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

            ComboBox {
                id: barcodetype
                label: qsTr("Barcode type")
                value: currentIndex === -1 ? qsTr("pick code type") : currentItem.text
                menu: ContextMenu {
                    Repeater {
                        model: dataModel
                        MenuItem {
                            text: model.Name
                        }
                    }
                }
                currentIndex: -1
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
                readOnly: barcodetype.currentIndex === -1
            }

            TextField {
                id: description
                placeholderText: qsTr("Optional description")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: code.focus = true
                readOnly: barcodetype.currentIndex === -1
            }
            TextField {
                id: code
                placeholderText: qsTr("Code")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.onClicked: accept()
                readOnly: barcodetype.currentIndex === -1
            }
            Row {
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingSmall
                y: Theme.paddingMedium
                Image {
                    id: infoIcon
                    source: "image://theme/icon-m-about"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Label {
                    text: qsTr("The app 'BarCode' can be used to scan images on your device to extract the code and indicate the potential barcode type used.")
                    width: col.width - (Theme.paddingMedium + Theme.paddingSmall + infoIcon.width)
                    wrapMode: Text.Wrap
                    font {
                        italic: true
                        pixelSize: Theme.fontSizeSmall
                    }
                    color: Theme.secondaryColor
                }
            }
            Separator {
                color: Theme.primaryColor
                x: Theme.paddingLarge
                width: parent.width / 3
            }
            Row {
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingSmall
                y: Theme.paddingMedium
                Image {
                    source: "image://theme/icon-m-about"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Label {
                    text: qsTr("Formats like QR code can generate a different image than the original one without affecting the embedded text.")
                    width: col.width - (Theme.paddingMedium + Theme.paddingSmall + infoIcon.width)
                    wrapMode: Text.Wrap
                    font {
                        italic: true
                        pixelSize: Theme.fontSizeSmall
                    }
                    color: Theme.secondaryColor
                }
            }
            SectionHeader {
                text: qsTr("Example code")
                visible: barcodetype.currentIndex !== -1
            }
            Image {
                id: barcodeExample
                source: barcodetype.currentIndex
                        !== -1 ? "/usr/share/harbour-barwal/qml/images/"
                                 + barcodetype.currentItem.text + ".svg" : "/usr/share/icons/hicolor/128x128/apps/harbour-barwal.png"
                visible: barcodetype.currentIndex !== -1
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
