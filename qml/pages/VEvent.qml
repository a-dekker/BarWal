import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../localdb.js" as DB

Dialog {
    id: vEventCodePage
    canAccept: name.text.trim().length > 0 && description.text !== ""
               && eventname.text !== ""

    property string starttime_utc: on_update_ux_time(startdate, starttime)
    property string startdate_formatted: on_update_ux_date(startdate, starttime)
    property string endtime_utc: on_update_ux_time(enddate, endtime)
    property string enddate_formatted: on_update_ux_date(startdate, starttime)

    QtObject {
        id: local_datetime
        property var locale: Qt.locale()
        property date currentDateTime: new Date()
        property string timezone: currentDateTime.toLocaleString(locale, "t")
        property string local_date: currentDateTime.toLocaleString(locale,
                                                                   "yyyy-MM-dd")
    }

    function get_local_time() {
        var loc_time = new Date()
        var local_time_formatted = ("0" + loc_time.getHours()).slice(
                    -2) + ":" + ("0" + loc_time.getMinutes(
                                     )).slice(-2) + ":" + ("0" + loc_time.getSeconds()).slice(
                    -2)
        return local_time_formatted
    }

    function on_update_ux_time(dateField, timeField) {
        var ux_sec_new = Math.round(
                    new Date(dateField.text + " " + timeField.text).getTime(
                        ) / 1000.0)
        var ux_millisec = new Date(ux_sec_new * 1000)
        var utc_datetime = ux_millisec.toUTCString().split(" ")
        var utc_time_formatted = utc_datetime[3]
        return utc_time_formatted.replace(/:/g, '')
    }

    function on_update_ux_date(dateField, timeField) {
        var ux_sec_new = Math.round(
                    new Date(dateField.text + " " + timeField.text).getTime(
                        ) / 1000.0)
        var ux_millisec = new Date(ux_sec_new * 1000)
        var utc_datetime = ux_millisec.toISOString()
        var utc_date_formatted = utc_datetime.substring(0, 10).replace(/-/g, '')
        return utc_date_formatted
    }

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
            Component {
                id: datePickerComponent
                DatePickerDialog {}
            }

            TextField {
                id: name
                focus: true
                placeholderText: qsTr("Name")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: description.focus = true
            }

            TextField {
                id: description
                placeholderText: qsTr("Description")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: eventname.focus = true
            }
            TextField {
                id: eventname
                placeholderText: qsTr("Event name")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: eventdescription.focus = true
            }
            TextField {
                id: eventdescription
                placeholderText: qsTr("Event description")
                label: placeholderText
                width: parent.width
                text: ""
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: location.focus = true
            }
            TextField {
                id: location
                placeholderText: qsTr("Location")
                label: placeholderText
                width: parent.width
                text: ""
            }
            Row {
                TextField {
                    id: startdate
                    label: qsTr("Pick start date")
                    readOnly: true
                    onClicked: {
                        var day = startdate.text.split("-")[2]
                        var month = startdate.text.split(
                                    "-")[1] - 1 // js: january = month[0]
                        var year = startdate.text.split("-")[0]
                        var dialog = pageStack.push(datePickerComponent, {
                                                        "date": new Date(year,
                                                                         month,
                                                                         day)
                                                    })
                        dialog.accepted.connect(function () {
                            startdate.text = dialog.year + "-"
                                    + (dialog.month > 9 ? dialog.month : "0" + dialog.month) + "-"
                                    + (dialog.day > 9 ? dialog.day : "0" + dialog.day)
                            startdate_formatted = on_update_ux_date(startdate,
                                                                    starttime)
                        })
                    }
                    width: col.width / 2
                    color: Theme.highlightColor
                    text: local_datetime.local_date
                }
                TextField {
                    id: starttime
                    label: qsTr("Pick start time")
                    readOnly: true
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl(
                                                        "TimeDialog.qml"), {
                                                        "infotext": "Time",
                                                        "hour": starttime.text.split(
                                                                    ":")[0],
                                                        "minute": starttime.text.split(
                                                                      ":")[1],
                                                        "second": starttime.text.split(
                                                                      ":")[2]
                                                    })
                        dialog.accepted.connect(function () {
                            starttime.text = (dialog.hour > 9 ? dialog.hour : "0" + dialog.hour)
                                    + ":" + (dialog.minute > 9 ? dialog.minute : "0"
                                                                 + dialog.minute) + ":"
                                    + (dialog.second > 9 ? dialog.second : "0" + dialog.second)
                            on_update_ux_time(startdate, starttime)
                        })
                    }
                    color: Theme.highlightColor
                    width: col.width / 2
                    horizontalAlignment: Text.AlignRight
                    text: get_local_time()
                }
            }
            Row {
                TextField {
                    id: enddate
                    label: qsTr("Pick end date")
                    readOnly: true
                    onClicked: {
                        var day = enddate.text.split("-")[2]
                        var month = enddate.text.split(
                                    "-")[1] - 1 // js: january = month[0]
                        var year = enddate.text.split("-")[0]
                        var dialog = pageStack.push(datePickerComponent, {
                                                        "date": new Date(year,
                                                                         month,
                                                                         day)
                                                    })
                        dialog.accepted.connect(function () {
                            enddate.text = dialog.year + "-"
                                    + (dialog.month > 9 ? dialog.month : "0" + dialog.month) + "-"
                                    + (dialog.day > 9 ? dialog.day : "0" + dialog.day)
                            enddate_formatted = on_update_ux_date(enddate,
                                                                  endtime)
                        })
                    }
                    width: col.width / 2
                    color: Theme.highlightColor
                    text: local_datetime.local_date
                }
                TextField {
                    id: endtime
                    label: qsTr("Pick end time")
                    readOnly: true
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl(
                                                        "TimeDialog.qml"), {
                                                        "infotext": "Time",
                                                        "hour": endtime.text.split(
                                                                    ":")[0],
                                                        "minute": endtime.text.split(
                                                                      ":")[1],
                                                        "second": endtime.text.split(
                                                                      ":")[2]
                                                    })
                        dialog.accepted.connect(function () {
                            endtime.text = (dialog.hour > 9 ? dialog.hour : "0" + dialog.hour) + ":"
                                    + (dialog.minute > 9 ? dialog.minute : "0"
                                                           + dialog.minute) + ":"
                                    + (dialog.second > 9 ? dialog.second : "0" + dialog.second)
                            on_update_ux_time(enddate, endtime)
                        })
                    }
                    color: Theme.highlightColor
                    width: col.width / 2
                    horizontalAlignment: Text.AlignRight
                    text: get_local_time()
                }
            }
            Label {
                id: code
                x: Theme.paddingLarge
                width: parent.width
                color: Theme.secondaryHighlightColor
                text: "BEGIN:VEVENT\n" + "SUMMARY:" + eventname.text
                      + "\nDESCRIPTION:" + eventdescription.text + "\nLOCATION:" + location.text
                      + "\nDTSTART:" + startdate_formatted + "T" + starttime_utc + "Z" + "\nDTEND:"
                      + enddate_formatted + "T" + endtime_utc + "Z" + "\nEND:VEVENT"
                visible: description.text !== "" && name.text !== ""
            }
        }
    }
}
