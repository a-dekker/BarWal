import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import harbour.barwal.Launcher 1.0
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

    App {
        id: bar
    }

    RemorsePopup {
        id: remorse
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
        notification.previewSummary = notificationType
        notification.publish()
    }

    Notification {
        id: notification
        itemCount: 1
    }

    Component.onCompleted: {
        DB.readBarcodeList()
        barcodetype.currentIndex = barcode_index
    }

    onAccepted: {
        DB.updateBarcode(name.text.trim(), barcodetype.currentItem.text,
                         description.text.trim(), code.text.trim(),
                         mainapp.groupName, "", barcode_name)
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
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: (parent.width * .80)
                text: qsTr("Import custom icon")
                onClicked: {
                    var base64_result = bar.launch(
                                "/usr/bin/base64 " + homedir + "/Pictures/barwal_icon.png")
                    if (base64_result === "") {
                        banner("ERROR",
                               "No data; barwal_icon.png missing from Pictures?")
                    } else {
                        base64_result = base64_result.replace(/\n/g, '')
                        remorse.execute(qsTr("Importing"), function () {
                            DB.updateIcon(barcode_name, base64_result)
                            mainapp.barcodesChanged = true
                        })
                    }
                }
            }
            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("<ul><li>Will import <b>barwal_icon.png</b> from Pictures</li><li>Icon has to be max 128x128px</li><li>Width should be exactly 128px</li></ul>")
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                width: (parent.width * .90)
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: (parent.width * .80)
                text: qsTr("Remove custom icon")
                onClicked: {
                    remorse.execute(qsTr("Removing"), function () {
                        DB.removeIcon(barcode_name)
                        mainapp.barcodesChanged = true
                    })
                }
            }
        }
    }
}
