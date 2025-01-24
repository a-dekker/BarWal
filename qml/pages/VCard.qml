import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../localdb.js" as DB

Dialog {
    id: vCardCodePage
    canAccept: name.text.trim().length > 0 && description.text !== ""
               && firstname.text !== ""

    function banner(notificationType, message) {
        notification.close()
        var notificationCategory
        switch (notificationType) {
        case "OK":
            notificationCategory = "x-jolla.store.sideloading-success"
            break
        case "INFO":
            notificationCategory = "x-jolla.lipstick.credentials.needUpdate.notification"
            break
        case "WARNING":
            notificationCategory = "x-jolla.store.error"
            break
        case "ERROR":
            notificationCategory = "x-jolla.store.error"
            break
        }
        notification.category = notificationCategory
        notification.previewBody = message
        notification.previewSummary = "Barwal"
        notification.publish()
    }

    Notification {
        id: notification
        itemCount: 1
    }

    onAccepted: {
        var result = DB.writeBarcode(name.text.trim(), "QR Code",
                                     description.text.trim(), code.text.trim(),
                                     mainapp.groupName, "", 58)
        if (result === "ERROR") {
            banner("ERROR", qsTr("Could not add barcode!"))
        }
        mainapp.barcodesChanged = true
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        clip: true

        ScrollDecorator {}

        Column {
            id: col
            spacing: 5
            width: parent.width
            DialogHeader {
                id: header
                acceptText: qsTr("Create code")
            }

            TextField {
                id: name
                focus: true
                placeholderText: qsTr("Barcode name")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: description.focus = true
            }

            TextField {
                id: description
                placeholderText: qsTr("Barcode description")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: firstname.focus = true
            }
            TextField {
                id: firstname
                placeholderText: qsTr("First name")
                inputMethodHints: Qt.ImhNoPredictiveText
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: lastname.focus = true
            }
            TextField {
                id: lastname
                placeholderText: qsTr("Last name")
                inputMethodHints: Qt.ImhNoPredictiveText
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: mobile.focus = true
            }
            TextField {
                id: mobile
                placeholderText: qsTr("Mobile number")
                label: placeholderText
                width: parent.width
                text: ""
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: email.focus = true
            }
            TextField {
                id: email
                placeholderText: qsTr("E-mail")
                label: placeholderText
                width: parent.width
                text: ""
                inputMethodHints: Qt.ImhEmailCharactersOnly
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: company.focus = true
            }
            TextField {
                id: company
                placeholderText: qsTr("Company")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: jobtitle.focus = true
            }
            TextField {
                id: jobtitle
                placeholderText: qsTr("Job title")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: street.focus = true
            }
            TextField {
                id: street
                placeholderText: qsTr("Street")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: city.focus = true
            }
            TextField {
                id: city
                placeholderText: qsTr("City")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: zip.focus = true
            }
            TextField {
                id: zip
                placeholderText: qsTr("ZIP")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: state.focus = true
            }
            TextField {
                id: state
                placeholderText: qsTr("State")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: country.focus = true
            }
            TextField {
                id: country
                placeholderText: qsTr("Country")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: website.focus = true
            }
            TextField {
                id: website
                placeholderText: qsTr("Website")
                inputMethodHints: Qt.ImhUrlCharactersOnly
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: accept()
            }
            Label {
                id: code
                x: Theme.paddingLarge
                width: parent.width
                color: Theme.secondaryHighlightColor
                text: "BEGIN:VCARD\nVERSION:3.0\nN:"
                      + firstname.text + ";" + lastname.text + "\nFN:"
                      + firstname.text + " " + lastname.text + "\nORG:"
                      + company.text + "\nTITLE:" + jobtitle.text + "\nADR:;;"
                      + street.text + ";" + city.text + ";" + state.text + ";" + zip.text + ";"
                      + country.text + "\nTEL;type=CELL:" + mobile.text + "\nEMAIL;type=INTERNET;"
                      + email.text + "\nURL:" + website.text + "\nEND:VCARD"
                visible: description.text !== "" && name.text !== ""
            }
        }
    }
}
