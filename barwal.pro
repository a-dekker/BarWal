# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop on filename must be changed
#   -  filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-barwal

CONFIG += sailfishapp

SOURCES += src/barwal.cpp \
    src/osread.cpp \
    src/settings.cpp

HEADERS += \
    src/osread.h \
    src/settings.h

DEPLOYMENT_PATH = /usr/share/$${TARGET}

OTHER_FILES += qml/barwal.qml \
    qml/cover/CoverPage.qml \
    rpm/barwal.changes.in \
    rpm/barwal.spec \
    translations/*.ts \
    harbour-barwal.desktop \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    qml/pages/AddBarcodePage.qml \
    qml/AddBarcodeGroupPage.qml \
    qml/BarcodeDisplayPage.qml \
    qml/BarcodesPage.qml \
    qml/EditBarcodeGroupPage.qml \
    qml/EditBarcodePage.qml \
    qml/localdb.js


INSTALLS += translations

TRANSLATIONS = translations/harbour-barwal-de.ts

# only include these files for translation:
lupdate_only {
    SOURCES = qml/*.qml \
              qml/pages/*.qml
}

icon86.files += icons/86x86/harbour-barwal.png
icon86.path = /usr/share/icons/hicolor/86x86/apps

icon108.files += icons/108x108/harbour-barwal.png
icon108.path = /usr/share/icons/hicolor/108x108/apps

icon128.files += icons/128x128/harbour-barwal.png
icon128.path = /usr/share/icons/hicolor/128x128/apps

icon172.files += icons/172x172/harbour-barwal.png
icon172.path = /usr/share/icons/hicolor/172x172/apps

icon256.files += icons/256x256/harbour-barwal.png
icon256.path = /usr/share/icons/hicolor/256x256/apps

translations.files = translations
translations.path = $${DEPLOYMENT_PATH}

INSTALLS += icon86 icon108 icon128 icon172 icon256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
