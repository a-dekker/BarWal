import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Page {
    id: barcodePage
    // To enable PullDownMenu, place our content in a SilicaFlickable
    function appendBarcode(name, type, description, code, zintcode) {
        barcodeList.model.append({
                                     "Name": name,
                                     "Type": type,
                                     "Description": description,
                                     "Code": code,
                                     "ZintCode": zintcode
                                 })
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            mainapp.barcodeDisplayed = false
            if (mainapp.barcodesChanged) {
                barcodeList.model.clear()
                DB.readBarcodes(mainapp.groupName)
                mainapp.barcodesChanged = false
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        SilicaListView {
            id: barcodeList
            anchors.fill: parent
            header: PageHeader {
                title: "BarWal"
                description: mainapp.groupName
            }
            PullDownMenu {
                MenuItem {
                    text: qsTr("About")
                    onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
                }
                MenuItem {
                    text: qsTr("Add code")
                    onClicked: pageStack.push(Qt.resolvedUrl(
                                                  "AddBarcodePage.qml"))
                }
            }
            VerticalScrollDecorator {}

            model: ListModel {}
            delegate: ListItem {
                id: listItem
                function img_src() {
                    switch (ZintCode) {
                    case 58:
                        return "../icons/qrcode-icon.png"
                    case 145:
                        return "../icons/qrcode-icon.png"
                    case 104:
                        return "../icons/qrcode-icon.png"
                    case 97:
                        return "../icons/qrcode-icon.png"
                    case 71:
                        return "../icons/datamatrix-icon.png"
                    case 92:
                        return "../icons/aztec-icon.png"
                    default:
                        return "../icons/barcode-icon.png"
                    }
                }

                contentHeight: Theme.itemSizeMedium // two line delegate
                Item {
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id: image
                        source: img_src()
                        x: Theme.paddingLarge
                        sourceSize: Qt.size(Theme.itemSizeSmall,
                                            Theme.itemSizeSmall)
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: parent.enabled ? 1.0 : 0.4
                        layer.effect: ShaderEffect {
                            property color color: Theme.primaryColor

                            fragmentShader: "
                            varying mediump vec2 qt_TexCoord0;
                            uniform highp float qt_Opacity;
                            uniform lowp sampler2D source;
                            uniform highp vec4 color;
                            void main() {
                                highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                                gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                            }
                            "
                        }
                        layer.enabled: true
                        layer.samplerName: "source"
                    }
                    Label {
                        id: barcode
                        anchors.bottom: sublabel.top
                        text: Name
                        anchors.left: image.right
                        anchors.leftMargin: Theme.paddingMedium
                        font.pixelSize: Theme.fontSizeMedium
                        color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                    Label {
                        id: sublabel
                        text: Description
                        font.pixelSize: Theme.fontSizeSmall
                        color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
                        anchors.leftMargin: Theme.paddingMedium
                        anchors.left: image.right
                    }
                }
                onClicked: {
                    mainapp.code = Code
                    mainapp.codeType = ZintCode
                    mainapp.codeDescription = Name
                    pageStack.push(Qt.resolvedUrl("BarcodeDisplayPage.qml"))
                }

                onPressAndHold: menu.active ? menu.hide() : menu.open(listItem)

                menu: ContextMenu {
                    id: menu

                    MenuItem {
                        text: qsTr("Details")
                        onClicked: pageStack.push(Qt.resolvedUrl(
                                                      "BarcodeInfoPage.qml"), {
                                                      "barcode_name": barcodeList.model.get(
                                                                          index).Name,
                                                      "barcode_description": barcodeList.model.get(
                                                                                 index).Description,
                                                      "barcode_code": barcodeList.model.get(
                                                                          index).Code,
                                                      "barcode_type": barcodeList.model.get(
                                                                          index).Type,
                                                      "zint_code": barcodeList.model.get(
                                                                       index).ZintCode
                                                  })
                    }
                    MenuItem {
                        text: qsTr("Edit")
                        onClicked: pageStack.push(Qt.resolvedUrl(
                                                      "EditBarcodePage.qml"), {
                                                      "barcode_name": barcodeList.model.get(
                                                                          index).Name,
                                                      "barcode_description": barcodeList.model.get(
                                                                                 index).Description,
                                                      "barcode_type": barcodeList.model.get(
                                                                          index).Type,
                                                      "barcode_code": barcodeList.model.get(
                                                                          index).Code
                                                  })
                    }
                    MenuItem {
                        text: qsTr("Remove")
                        onClicked: Remorse.itemAction(listItem, "Deleting",
                                                      function () {
                                                          DB.removeBarcode(Name)
                                                          barcodeList.model.clear()
                                                          DB.readBarcodes(
                                                                      mainapp.groupName)
                                                      })
                    }
                }
            }

            function loadBarcodes() {
                DB.readBarcodes(mainapp.groupName)
            }

            Component.onCompleted: {
                loadBarcodes()
            }

            ViewPlaceholder {
                enabled: barcodeList.count === 0
                text: qsTr("No barcodes defined")
                hintText: qsTr("Choose \"Add code\" from the pulley menu.")
            }
        }
    }
}
