import QtQuick 2.5
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Page {
    id: move2GroupPage

    property string barcode_name: ""
    property var dataModel: ListModel {}
    property int itemIndex

    function appendGroup(groupname, isdefault) {
        dataModel.append({
                             "GroupName": groupname
                         })
    }

    function loadBarcodeGroups() {
        DB.readBarcodeGroupMove()
    }

    RemorsePopup {
        id: remorse
    }

    Component.onCompleted: {
        loadBarcodeGroups()
        groupList.currentIndex = mainapp.groupNameIdx
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        clip: true

        ScrollDecorator {}

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: barcode_name
            }

            ComboBox {
                id: groupList
                label: qsTr("Move to group")
                menu: ContextMenu {
                    Repeater {
                        model: dataModel
                        MenuItem {
                            text: model.GroupName
                            onClicked: {
                                remorse.execute(qsTr("Moving"), function () {
                                    if (model.GroupName !== mainapp.groupName) {
                                        DB.moveBarcode(barcode_name,
                                                       model.GroupName)
                                        mainapp.barcodesChanged = true
                                    }
                                    pageStack.pop()
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}
