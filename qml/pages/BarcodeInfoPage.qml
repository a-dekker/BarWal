import QtQuick 2.5
import Sailfish.Silica 1.0

Page {
    id: codeInfoPage

    property string barcode_name: ""
    property string barcode_description: ""
    property string barcode_code: ""
    property string barcode_type: ""
    property string zint_code: ""
    property string barcode_icon: ""
    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge

    SilicaFlickable {
        anchors.fill: parent
        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        VerticalScrollDecorator {}

        Column {
            id: column

            width: codeInfoPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Barcode info")
            }
            Rectangle {
                height: Theme.paddingLarge
                width: Theme.paddingLarge
                color: "transparent"
            }
            Image {
                id: barcodeIcon
                source: barcode_icon !== "" ? "data:image/png;base64,"
                                              + barcode_icon : "image://theme/icon-l-image"
                sourceSize: Qt.size(Theme.itemSizeSmall, Theme.itemSizeSmall)
                anchors.horizontalCenter: parent.horizontalCenter
                visible: barcode_icon !== ""
            }
            Row {
                width: parent.width
                spacing: Theme.paddingMedium

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Barcode name")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: barcode_name
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingMedium

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Barcode description")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: barcode_description
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingMedium

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Barcode string")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: barcode_code
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingMedium

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Barcode group")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: mainapp.groupName
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingMedium

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Barcode type")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: barcode_type
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingMedium

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Referring zint code")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: zint_code
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
