import QtQuick 2.5
import Sailfish.Silica 1.0

Page {
    id: aboutPage
    property bool largeScreen: Screen.width > 540

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
            SectionHeader {
                text: qsTr("Author")
                visible: isPortrait || (largeScreen && Screen.width > 1080)
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            Label {
                text: "© Arno Dekker 2021"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                x: Theme.paddingLarge
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeTiny
                text: qsTr("Using ") + "<a href=\"https://sourceforge.net/p/zint/code/ci/master/tree/\">zint</a>" + qsTr(
                          " as backend")
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
