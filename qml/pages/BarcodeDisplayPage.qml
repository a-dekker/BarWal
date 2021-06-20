import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.barwal.Launcher 1.0
import Nemo.Notifications 1.0

Page {
    id: barcodeDisplayPage

    property string imagePath: ""

    App {
        id: bar
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

    function getFileInfo() {
        var toolCmd = "/usr/bin/zint" + " -o " + "/tmp/barcode.png" + " --scale "
                + "5" + " -b " + mainapp.codeType + " -d " + mainapp.code

        console.log(toolCmd)
        var zint_result = bar.launch_stderr(toolCmd)
        if (zint_result !== "") {
            banner("ERROR", zint_result)
            imagePath = "image://theme/icon-l-attention"
            background.color = "Darkred"
        } else {
            imagePath = "/tmp/barcode.png"
        }
    }

    Component.onCompleted: {
        getFileInfo()
        mainapp.barcodeDisplayed = true
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width

        VerticalScrollDecorator {}

        PageHeader {
            id: pageHead
            title: mainapp.codeDescription
            description: mainapp.code
                extraContent.children: [
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: mainapp.iconsource
                    }
                ]
        }
        Rectangle {
            color: "white"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: pageHead.bottom
            id: background
            Image {
                id: coverBgImage
                anchors.fill: background
                fillMode: Image.PreserveAspectFit
                source: imagePath
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                cache: false
                anchors.bottomMargin: Theme.paddingLarge
                anchors.topMargin: Theme.paddingLarge
                anchors.leftMargin: Theme.paddingLarge
                anchors.rightMargin: Theme.paddingLarge
                width: isPortrait ? background.width - (2 * Theme.paddingLarge) : background.width
                                    - (4 * Theme.paddingLarge)
            }
        }
    }
}
