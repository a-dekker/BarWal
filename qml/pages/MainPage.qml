import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Page {
    id: groupPage

    property bool hasStartGroup: false

    // To enable PullDownMenu, place our content in a SilicaFlickable
    function appendGroup(groupname, isdefault) {
        barcodeGroupList.model.append({
                                          "GroupName": groupname,
                                          "IsDefault": isdefault
                                      })
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (mainapp.barcodeGroupWasOpend) {
                mainapp.groupName = ""
            }
            if (mainapp.groupsChanged) {
                barcodeGroupList.model.clear()
                DB.readBarcodeGroups()
                mainapp.groupsChanged = false
            }
        }
    }
    RemorsePopup {
        id: remorse
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
                MenuItem {
                    enabled: hasStartGroup
                    text: qsTr("Clear auto-open group")
                    onClicked: {
                        remorse.execute(qsTr("Removing"), function () {
                            hasStartGroup = false
                            DB.removeGroupDefault()
                        })
                    }
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
                        text: qsTr("Rename")
                        onClicked: pageStack.push(
                                       Qt.resolvedUrl(
                                           "EditBarcodeGroupPage.qml"), {
                                           "barcode_group": barcodeGroupList.model.get(
                                                                index).GroupName
                                       })
                    }
                    MenuItem {
                        text: qsTr("Remove")
                        onClicked: Remorse.itemAction(listItem, qsTr("Deleting"),
                                                      function () {
                                                          DB.removeBarcodeGroup(
                                                                      GroupName)
                                                          barcodeGroupList.model.clear()
                                                          DB.readBarcodeGroups()
                                                      })
                    }
                    MenuItem {
                        text: qsTr("Auto open this group on start")
                        onClicked: Remorse.itemAction(listItem, qsTr("Auto open"),
                                                      function () {
                                                          hasStartGroup = true
                                                          DB.setGroupDefault(
                                                                      GroupName)
                                                      })
                    }
                }
            }

            function loadBarcodeGroups() {
                DB.readBarcodeGroups()
            }
            Timer {
                id: waitTimer
                interval: 500
                repeat: false
                onTriggered: {
                    if (mainapp.groupName !== "") {
                        pageStack.push(Qt.resolvedUrl("BarcodesPage.qml"))
                    }
                }
            }

            function loadDefaultGroup() {
                for (var i = 0; i < barcodeGroupList.model.count; ++i) {
                    if (barcodeGroupList.model.get(i).IsDefault === 1) {
                        hasStartGroup = true
                        mainapp.groupName = barcodeGroupList.model.get(
                                    i).GroupName
                    }
                }
            }

            Component.onCompleted: {
                DB.initializeDB()
                loadBarcodeGroups()
                loadDefaultGroup()
                waitTimer.start()
            }

            ViewPlaceholder {
                enabled: barcodeGroupList.count === 0
                text: qsTr("No groups defined")
                hintText: qsTr("Choose \"Add Group\" from the pulley menu.")
            }
        }
    }
}
