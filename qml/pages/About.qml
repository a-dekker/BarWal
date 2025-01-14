import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.barwal.Launcher 1.0

Page {
    id: aboutPage
    property bool largeScreen: Screen.width > 540
    property string zint_version: ""

    App {
        id: bar
    }

    Component.onCompleted: {
        getZintVersion()
    }

    function getZintVersion() {
        zint_version = bar.launch("/usr/bin/zint -v").replace(
                    /(\r\n|\n|\r)/gm, "").replace("Zint version ", "")
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {}

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }
            SectionHeader {
                text: qsTr("Info")
                visible: isPortrait || (largeScreen && Screen.width > 1080)
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || (largeScreen && Screen.width > 1080)
            }
            Label {
                text: "BarWal"
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: isLandscape ? (largeScreen ? "/usr/share/icons/hicolor/256x256/apps/harbour-barwal.png" : "/usr/share/icons/hicolor/86x86/apps/harbour-barwal.png") : (largeScreen ? "/usr/share/icons/hicolor/256x256/apps/harbour-barwal.png" : "/usr/share/icons/hicolor/128x128/apps/harbour-barwal.png")
            }
            Label {
                text: qsTr("Version") + " " + version
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
            }
            Label {
                text: qsTr("Your wallet for all your scannable codes")
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
                horizontalAlignment: Text.Center
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            SectionHeader {
                text: qsTr("Author")
                visible: isPortrait || (largeScreen && Screen.width > 1080)
            }
            Label {
                text: "© Arno Dekker 2021-" + buildyear
                anchors.horizontalCenter: parent.horizontalCenter
            }
            SectionHeader {
                text: qsTr("Backend")
                visible: isPortrait || (largeScreen && Screen.width > 1080)
            }
            Label {
                x: Theme.paddingLarge
                color: Theme.primaryColor
                text: "<a href=\"https://sourceforge.net/p/zint/code/ci/master/tree/\">Zint</a>" + " "
                          + zint_version
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
