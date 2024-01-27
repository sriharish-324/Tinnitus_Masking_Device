QT += quick \
    widgets
QT += multimedia
QT += bluetooth
QT += serialport
#QT += widgets multimedia

QT+= core gui
#QT+= network
CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        authhandler.cpp \
        main.cpp \
        sound.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =
QT_QPA_PLATFORM=wayland
# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    QAudioOutput \
    authhandler.h \
    qaudio.h \
    qaudiooutput.h \
    sound.h

