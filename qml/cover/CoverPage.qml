

/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import QtQuick 2.5
import Sailfish.Silica 1.0

CoverBackground {
    id: covB

    BackgroundItem {
        anchors.fill: parent

        HighlightImage {
            id: coverBgImage
            color: Theme.primaryColor
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "cover_background.png"
            opacity: 0.2
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            visible: !mainapp.barcodeDisplayed
        }
    }

    Label {
        id: coverHeader
        text: "BarWal"
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingMedium
        horizontalAlignment: Text.Center
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeSmall
    }
    Label {
        id: subHeader
        anchors.top: coverHeader.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: "-" + mainapp.groupName + "-"
        width: parent.width
        visible: mainapp.groupName !== ""
        horizontalAlignment: Text.Center
        wrapMode: Text.Wrap
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeSmall
    }
    Image {
        id: barcodeIcon
        anchors.top: subHeader.bottom
        anchors.margins: Theme.paddingMedium
        anchors.horizontalCenter: parent.horizontalCenter
        source: mainapp.iconsource
        sourceSize: Qt.size(Theme.itemSizeSmall, Theme.itemSizeSmall)
        visible: mainapp.barcodeDisplayed
    }
    Label {
        id: barcodeText
        anchors.top: barcodeIcon.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.Center
        text: mainapp.codeDescription
        wrapMode: Text.Wrap
        width: parent.width
        visible: barcodeDisplayed
    }
    Image {
        anchors.top: barcodeText.bottom
        anchors.topMargin: Theme.paddingMedium
        source: mainapp.barcodeDisplayed ? "/tmp/barcode.svg" : "/usr/share/icons/hicolor/128x128/apps/harbour-barwal.png"
        anchors.horizontalCenter: parent.horizontalCenter
        cache: false
        fillMode: Image.PreserveAspectFit
        width: parent.width / 1.5
        visible: mainapp.barcodeDisplayed
    }
}
