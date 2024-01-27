import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    id:mainrect
    height: parent.height
    width: parent.width
    property int remainingTime: 0
    property var fla2g: 0
    color:"black"
    property var flag :0
    signal naturalsongClicked(string songName)
    Rectangle{
        id:nature
        anchors.top: mainrect.top
        anchors.topMargin: 20
        anchors.left: mainrect.left
        anchors.leftMargin: 15
        height: 60
        width:parent.width-50
        color:"transparent"
        border.color: "transparent"
        Text {
            id: name
            text: qsTr("Ocean")
            font.pointSize: 20
            font.family: "Ubuntu"
            color: "white"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 7
        }
        Text {
            id: fq
            text: qsTr(" (Multi Fq)")
            font.pointSize: 10
            font.family: "Ubuntu"
            color: "white"
            anchors.left: name.right
            anchors.top: name.top
            anchors.topMargin: 15
        }
        MouseArea{
            id:naturemouse
            anchors.fill: nature
            hoverEnabled: true
            onClicked: {
                if(flag==0){
                    song1icon.source="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/pause.png"
                    flag=1
                    naturalsongClicked(name.text)
                }
                else if (flag==1){
                    song1icon.source ="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
                    flag =0
                    naturalsongClicked("Stop")
                }
            }

        }
        Rectangle{
            anchors.top: nature.bottom
            anchors.topMargin:  -15
            anchors.left: nature.left
            anchors.right: nature.right
            width: parent.width-50
            height: 2
            color: naturemouse.containsMouse?"White":"transparent"

        }

    }
    Image{
        id: song1icon
        source: "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
        height :(mainrect.height*0.06 + mainrect.width *0.08)/2.7
        width:(mainrect.height*0.06 + mainrect.width *0.08)/2.7
        anchors.left: nature.right
        anchors.leftMargin: -4
        anchors.top: nature.top
        anchors.topMargin: 10
        visible: naturemouse.containsMouse?true:false
    }
    Rectangle{
        id:song2
        anchors.top: nature.bottom
        anchors.topMargin: 0
        anchors.left: mainrect.left
        anchors.leftMargin: 15
        height: 60
        width:parent.width-50
        color:"transparent"
        border.color: "transparent"
        MouseArea{
            id:song2mouse
            anchors.fill: song2
            hoverEnabled: true
            onClicked: {
                if(flag==0){
                    song2icon.source="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/pause.png"
                    naturalsongClicked(song2name.text)
                    flag=1
                }
                else if (flag==1){
                    song2icon.source ="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
                    flag =0
                    naturalsongClicked("Stop")
                }
            }
        }
        Text {
            id: song2name
            text: qsTr("Thunderstrom")
            font.pointSize: 20
            font.family: "Ubuntu"
            color: "white"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 7
        }
        Text {
            id: fq2
            text: qsTr(" (Mid Fq)")
            font.pointSize: 10
            font.family: "Ubuntu"
            color: "white"
            anchors.left: song2name.right
            anchors.top: song2name.top
            anchors.topMargin: 15
        }
        Rectangle{
            anchors.top: song2.bottom
            anchors.topMargin: -15
            anchors.left: song2.left
            anchors.right: song2.right
            width: parent.width-50
            height: 2
            color: song2mouse.containsMouse?"white":"transparent"
        }
        Image{
            id: song2icon
            source: "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
            height :(mainrect.height*0.06 + mainrect.width *0.08)/2.7
            width:(mainrect.height*0.06 + mainrect.width *0.08)/2.7
            anchors.left: song2.right
            anchors.leftMargin: -4
            anchors.top: song2.top
            anchors.topMargin: 10
            visible: song2mouse.containsMouse?true:false
        }
    }
    Rectangle{
        id:song3
        anchors.top: song2.bottom
        anchors.topMargin: 0
        anchors.left: mainrect.left
        anchors.leftMargin: 15
        height: 60
        width:parent.width-50
        color:"transparent"
        border.color: "transparent"
        MouseArea{
            id:song3mouse
            anchors.fill: song3
            hoverEnabled: true
            onClicked: {

                if(flag==0){
                    song3icon.source="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/pause.png"
                    naturalsongClicked("Rainy")
                    flag=1
                }
                else if (flag==1){
                    song3icon.source ="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
                    flag =0
                    naturalsongClicked("Stop")
                }
            }
        }
        Text {
            id: song3name
            text: qsTr("Rainiy Days")
            font.pointSize: 20
            font.family: "Ubuntu"
            color: "white"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 7
        }
        Text {
            id: fq3
            text: qsTr(" (Mid Fq)")
            font.pointSize: 10
            font.family: "Ubuntu"
            color: "white"
            anchors.left: song3name.right
            anchors.top: song3name.top
            anchors.topMargin: 15
        }

        Rectangle{
            anchors.top: song3.bottom
            anchors.topMargin: -15
            anchors.left: song3.left
            anchors.right: song3.right
            width: parent.width-50
            height: 2
            color: song3mouse.containsMouse?"white":"transparent"
        }
        Image{
            id: song3icon
            source: "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
            height :(mainrect.height*0.06 + mainrect.width *0.08)/2.7
            width:(mainrect.height*0.06 + mainrect.width *0.08)/2.7
            anchors.left: song3.right
            anchors.leftMargin: -4
            anchors.top: song3.top
            anchors.topMargin: 10
            visible: song3mouse.containsMouse?true:false
        }
    }

    Rectangle{
        id:song4
        anchors.top: song3.bottom
        anchors.topMargin: 0
        anchors.left: mainrect.left
        anchors.leftMargin: 15
        height: 60
        width:parent.width-50
        color:"transparent"
        border.color: "transparent"
        MouseArea{
            id:song4mouse
            anchors.fill: song4
            hoverEnabled: true
            onClicked: {
                if(flag==0){
                    song4icon.source="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/pause.png"
                    naturalsongClicked(song4name.text)
                    flag=1
                }
                else if (flag==1){
                    song4icon.source ="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
                    flag =0
                    naturalsongClicked("Stop")
                }
            }
        }
        Text {
            id: song4name
            text: qsTr("Forest")
            font.pointSize: 20
            font.family: "Ubuntu"
            color: "white"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 7
        }
        Text {
            id: fq4
            text: qsTr(" (Multi Fq)")
            font.pointSize: 10
            font.family: "Ubuntu"
            color: "white"
            anchors.left: song4name.right
            anchors.top: song4name.top
            anchors.topMargin: 15
        }
        Rectangle{
            anchors.top: song4.bottom
            anchors.topMargin: -15
            anchors.left: song4.left
            anchors.right: song4.right
            width: parent.width-50
            height: 2
            color: song4mouse.containsMouse?"white":"transparent"
        }
        Image{
            id: song4icon
            source: "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
            height :(mainrect.height*0.06 + mainrect.width *0.08)/2.7
            width:(mainrect.height*0.06 + mainrect.width *0.08)/2.7
            anchors.left: song4.right
            anchors.leftMargin: -4
            anchors.top: song4.top
            anchors.topMargin: 10
            visible: song4mouse.containsMouse?true:false
        }
    }
    Rectangle{
        id:song5
        anchors.top: song4.bottom
        anchors.topMargin: 0
        anchors.left: mainrect.left
        anchors.leftMargin: 15
        height: 60
        width:parent.width-50
        color:"transparent"
        border.color: "transparent"
        MouseArea{
            id:song5mouse
            anchors.fill: song5
            hoverEnabled: true
            onClicked: {
                if(flag==0){
                    song5icon.source="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/pause.png"
                    naturalsongClicked(song5name.text)
                    flag=1
                }
                else if (flag==1){
                    song5icon.source ="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
                    flag =0
                     naturalsongClicked("Stop")
                }
            }
        }
        Text {
            id: song5name
            text: qsTr("River")
            font.pointSize: 20
            font.family: "Ubuntu"
            color: "white"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 7
        }
        Text {
            id: fq5
            text: qsTr(" (Mid Fq)")
            font.pointSize: 10
            font.family: "Ubuntu"
            color: "white"
            anchors.left: song5name.right
            anchors.top: song5name.top
            anchors.topMargin: 15
        }
        Rectangle{
            anchors.top: song5.bottom
            anchors.topMargin: -20
            anchors.left: song5.left
            anchors.right: song5.right
            width: parent.width-50
            height: 2
            color: song5mouse.containsMouse?"white":"transparent"
        }
        Image{
            id: song5icon
            source: "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/play.png"
            height :(mainrect.height*0.06 + mainrect.width *0.08)/2.7
            width:(mainrect.height*0.06 + mainrect.width *0.08)/2.7
            anchors.left: song5.right
            anchors.leftMargin: -4
            anchors.top: song5.top
            anchors.topMargin: 10
            visible: song5mouse.containsMouse?true:false
        }
    }

    Timer {
            id: stopTimer
                interval: {
                    const interval = 1000;  // Set interval to 1 second
                    remainingTime = controlforAction.model[controlforAction.currentIndex] * 60 * 1000;
                    console.log("Timer Interval:", interval);
                    return interval;
                }
                repeat: true
                onTriggered: {
                        remainingTime -= 1000;  // Subtract one second (1000 milliseconds)
                        if (remainingTime <= 0) {
                            stopTimer.stop();
                            controlforAction.visible=true
                            naturalsongClicked("Stop");
                        }
                    }
            }
    Image{
           id: star
           source: "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/on.png"
           height :(mainrect.height*0.06 + mainrect.width *0.08)/2.0
           width:(mainrect.height*0.06 + mainrect.width *0.08)/2.0
           anchors.top: song5.bottom
           anchors.topMargin: -10
           anchors.left: mainrect.left
           anchors.leftMargin: 15
           MouseArea{
               id:startm
               anchors.fill: star
               hoverEnabled: true
               onClicked: {
                   if(fla2g==0){
                       star.source="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/off.png"
                       stopTimer.start();
                       controlforAction.visible=false
                       fla2g=1
                   }
                   else if (fla2g==1){
                       star.source ="file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/on.png"
                       fla2g =0
                       controlforAction.visible=true
                       stopTimer.stop();
                   }
               }
           }
       }
    Tumbler {
            id: controlforAction
            model: ["1", "20","30","40","50","60"]
            anchors.top: song5.bottom
            height:65
            anchors.topMargin: -25
            anchors.right: mainrect.right
            anchors.rightMargin: 15
            visibleItemCount: 3
            onCurrentIndexChanged:{
                console.log("Selected Tumbler Value:", );
            }
            delegate: Text {
                text: modelData
                font.pointSize: 10
                font.bold: true
                color:"white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: 1.0 - Math.abs(Tumbler.displacement) / (controlforAction.visibleItemCount / 2)
            }

        }
    Text {
        anchors.top: star.top
        anchors.topMargin: 10
        anchors.right: mainrect.right
        anchors.rightMargin: 20
        font.family: "ubuntu"
        font.pointSize: 10
        font.bold:true
        text: stopTimer.running ? formatTime(remainingTime) + " left" : ""
        color: "white"
    }
    function formatTime(time) {
        var minutes = Math.floor(time / 60000);
        var seconds = Math.floor((time % 60000) / 1000);
        return pad(minutes) + "m:" + pad(seconds) + "s";
    }
    function pad(number) {
        return (number < 10 ? "0" : "") + number;
    }


}
