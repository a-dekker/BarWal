import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Page {
    id: barcodePage
    // To enable PullDownMenu, place our content in a SilicaFlickable
    function appendBarcode(name, type, description, code, zintcode, icon) {
        barcodeList.model.append({
                                     "Name": name,
                                     "Type": type,
                                     "Description": description,
                                     "Code": code,
                                     "ZintCode": zintcode,
                                     "Icon": icon
                                 })
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            mainapp.barcodeDisplayed = false
            mainapp.barcodeGroupWasOpend = true
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
                    var imgUrl
                    if (Icon !== "") {
                        imgUrl = "data:image/png;base64," + Icon
                    } else {
                        switch (ZintCode) {
                        case 58:
                            imgUrl = "../icons/qrcode-icon"
                            break
                        case 145:
                            imgUrl = "../icons/qrcode-icon"
                            break
                        case 104:
                            imgUrl = "../icons/qrcode-icon"
                            break
                        case 97:
                            imgUrl = "../icons/qrcode-icon"
                            break
                        case 71:
                            imgUrl = "../icons/datamatrix-icon"
                            break
                        case 92:
                            imgUrl = "../icons/aztec-icon"
                            break
                        default:
                            imgUrl = "../icons/barcode-icon"
                            break
                        }
                        if (mainapp.isLightTheme) {
                            imgUrl = imgUrl + "-black.png"
                        } else {
                            imgUrl = imgUrl + ".png"
                        }
                    }
                    return imgUrl
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
                    if (Icon !== "") {
                        mainapp.iconsource = image.source
                    } else {
                        mainapp.iconsource = ""
                    }
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
                                                                       index).ZintCode,
                                                      "barcode_icon": barcodeList.model.get(
                                                                       index).Icon
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
                                                                          index).Code,
                                                      "barcode_icon": barcodeList.model.get(
                                                                       index).Icon
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
