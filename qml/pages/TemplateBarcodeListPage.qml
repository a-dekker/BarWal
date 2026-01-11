import QtQuick 2.5
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        VerticalScrollDecorator {}

        Column {
            id: content
            width: parent.width

            PageHeader {
                title: qsTr("Form template (QR Code)")
            }

            MainPageButton {
                text: qsTr("Telephone number") + " 📞"
                onClicked: pageStack.push(Qt.resolvedUrl("Telephone.qml"))
            }
            MainPageButton {
                text: qsTr("vCard") + " 💳"
                onClicked: pageStack.push(Qt.resolvedUrl("VCard.qml"))
            }
            MainPageButton {
                text: qsTr("Calendar event") + " 📅"
                onClicked: pageStack.push(Qt.resolvedUrl("VEvent.qml"))
            }
            MainPageButton {
                text: qsTr("WiFi") + " 📶"
                onClicked: pageStack.push(Qt.resolvedUrl("Wifi.qml"))
            }
            MainPageButton {
                text: qsTr("SMS") + " ✉"
                onClicked: pageStack.push(Qt.resolvedUrl("Sms.qml"))
            }
            MainPageButton {
                text: qsTr("Email") + " ✉"
                onClicked: pageStack.push(Qt.resolvedUrl("Email.qml"))
            }
            MainPageButton {
                text: qsTr("Geolocation") + " 🌐"
                onClicked: pageStack.push(Qt.resolvedUrl("Geolocation.qml"))
            }
        }
    }
}
