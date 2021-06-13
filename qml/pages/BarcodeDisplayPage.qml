import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.barwal.Launcher 1.0

Page {
    id: barcodeDisplayPage

    property string imagePath: ""

    App {
        id: bar
    }

    function getFileInfo() {
        var toolCmd = "/usr/bin/zint" + " -o " + "/tmp/barcode.png" + " --scale "
                + "5" + " -b " + mainapp.codeType + " -d " + mainapp.code

        console.log(toolCmd)
        bar.launch(toolCmd)
        imagePath = "/tmp/barcode.png"
    }

    Component.onCompleted: {
        getFileInfo()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width

        VerticalScrollDecorator {}

        PageHeader {
            id: pageHead
            title: mainapp.codeDescription
            description: mainapp.code
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
