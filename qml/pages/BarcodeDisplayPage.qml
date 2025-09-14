import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.barwal.Launcher 1.0
import Nemo.Notifications 1.0
import "../components"

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

    function stripCheckDigit() {
        // Remove checkdigit if needed to avoid length error message
        // Zint will add it by default for some codes
        var affected_zint_codes = ["89", "72"]
        for (var i = 0; i < affected_zint_codes.length; i++) {
            if (mainapp.codeType === affected_zint_codes[i]) {
                if (mainapp.code.length === 14) {
                    mainapp.code = mainapp.code.substring(
                                0, mainapp.code.length - 1)
                }
            }
        }
    }

    function getFileInfo() {
        stripCheckDigit()
        // write barcode text using base64 to file to avoid quote issues
        var code2file = "/bin/sh -c \"echo " + Qt.btoa(
                    mainapp.code) + " > /tmp/barcode.base64\""
        bar.launch(code2file)
        code2file = "/bin/sh -c \"cat /tmp/barcode.base64 | base64 -d > /tmp/barcode.txt\""
        bar.launch(code2file)
        var toolCmd = "/usr/bin/zint" + " -o " + "/tmp/barcode.svg" + " --scale " + "5"
                + " --filetype=SVG" + " -b " + mainapp.codeType + " -i /tmp/barcode.txt"
        console.log(toolCmd)
        var zint_result = bar.launch_stderr(toolCmd)
        if (zint_result !== "") {
            banner("ERROR", zint_result)
            imagePath = "image://theme/icon-l-attention"
            background.color = "Darkred"
        } else {
            imagePath = "/tmp/barcode.svg"
        }
    }

    function resize_barcode() {
        if (coverBgImage.scale === 1) {
            coverBgImage.scale = 0.5
        } else {
            coverBgImage.scale = 1
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

        FancyPageHeader {
            id: pageHead
            title: mainapp.codeDescription
            description: mainapp.code.split("\n")[0]
            iconSource: mainapp.iconsource
        }

        Rectangle {
            color: "white"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: pageHead.bottom
            id: background

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    resize_barcode()
                }
            }

            Image {
                id: coverBgImage
                anchors.fill: background
                asynchronous: true
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
