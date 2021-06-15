import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Page {
    id: barcodePage
    // To enable PullDownMenu, place our content in a SilicaFlickable
    function appendBarcode(name, type, description, code, comboindex) {
        barcodeList.model.append({
                                     "Name": name,
                                     "Type": type,
                                     "Description": description,
                                     "Code": code,
                                     "ComboIndex": comboindex
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
                contentHeight: Theme.itemSizeMedium // two line delegate
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        id: barcode
                        anchors.bottom: sublabel.top
                        text: Name
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeMedium
                        color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                    Label {
                        id: sublabel
                        text: Description
                        font.pixelSize: Theme.fontSizeSmall
                        color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                onClicked: {
                    mainapp.code = Code
                    mainapp.codeType = Type.split(":")[0]
                    mainapp.codeDescription = Name
                    pageStack.push(Qt.resolvedUrl("BarcodeDisplayPage.qml"))
                }

                onPressAndHold: menu.active ? menu.hide() : menu.open(listItem)

                menu: ContextMenu {
                    id: menu

                    MenuItem {
                        text: qsTr("Edit")
                        onClicked: pageStack.push(Qt.resolvedUrl(
                                                      "EditBarcodePage.qml"), {
                                                      "barcode_name": barcodeList.model.get(
                                                                          index).Name,
                                                      "barcode_index": barcodeList.model.get(
                                                                          index).ComboIndex,
                                                      "barcode_description": barcodeList.model.get(
                                                                                 index).Description,
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
                    MenuItem {
                        text: qsTr("Details")
                        onClicked:  pageStack.push(Qt.resolvedUrl(
                                                      "BarcodeInfoPage.qml"), {
                                                      "barcode_name": barcodeList.model.get(
                                                                          index).Name,
                                                      "barcode_description": barcodeList.model.get(
                                                                                 index).Description,
                                                      "barcode_code": barcodeList.model.get(
                                                                          index).Code,
                                                      "barcode_type": barcodeList.model.get(
                                                                          index).Type
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
