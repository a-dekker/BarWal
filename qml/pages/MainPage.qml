import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Page {
    id: groupPage
    // To enable PullDownMenu, place our content in a SilicaFlickable
    function appendGroup(groupname) {
        barcodeGroupList.model.append({
                                          "GroupName": groupname
                                      })
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (mainapp.groupsChanged) {
                barcodeGroupList.model.clear()
                DB.readBarcodeGroups()
                mainapp.groupsChanged = false
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        SilicaListView {
            id: barcodeGroupList
            anchors.fill: parent
            header: PageHeader {
                title: qsTr("BarWal")
            }
            PullDownMenu {
                MenuItem {
                    text: qsTr("About")
                    onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
                }
                MenuItem {
                    text: qsTr("Add Group")
                    onClicked: pageStack.push(Qt.resolvedUrl(
                                                  "AddBarcodeGroupPage.qml"))
                }
            }
            VerticalScrollDecorator {}
            model: ListModel {}
            delegate: ListItem {
                id: listItem
                Label {
                    id: group
                    text: GroupName
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Theme.fontSizeMedium
                    color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                onClicked: {
                    mainapp.groupName = GroupName
                    pageStack.push(Qt.resolvedUrl("BarcodesPage.qml"))
                }
                menu: ContextMenu {
                    id: menu

                    MenuItem {
                        text: qsTr("Edit")
                        onClicked: pageStack.push(
                                       Qt.resolvedUrl(
                                           "EditBarcodeGroupPage.qml"), {
                                           "barcode_group": barcodeGroupList.model.get(
                                                               index).GroupName
                                       })
                    }
                    MenuItem {
                        text: qsTr("Remove")
                        onClicked: Remorse.itemAction(listItem, "Deleting",
                                                      function () {
                                                          DB.removeBarcodeGroup(
                                                                      GroupName)
                                                          barcodeGroupList.model.clear()
                                                          DB.readBarcodeGroups()
                                                      })
                    }
                }
            }

            function loadBarcodeGroups() {
                DB.readBarcodeGroups()
            }

            Component.onCompleted: {
                DB.initializeDB()
                loadBarcodeGroups()
            }

            ViewPlaceholder {
                enabled: barcodeGroupList.count === 0
                text: qsTr("No groups defined")
                hintText: qsTr("Choose \"Add Group\" from the pulley menu.")
            }
        }
    }
}
