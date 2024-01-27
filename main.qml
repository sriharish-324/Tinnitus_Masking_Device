import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 1.3
import QtQuick.Window 2.12
import QtQuick.Controls 2.3
import QtMultimedia 5.15
import QtQuick.Controls.Styles 1.3
import QtGraphicalEffects 1.12

Window {
    width: 800
    height: 480
    visible: true
    title: qsTr("Frequency")
    property int index: 0
    property int playAutomatically : 1
    property  int flag: 0
    property variant win;
    property var currentVolume:20000
    property int flagin:0
    Timer {
        id: dataUpdateTimer
        interval: 10000
        running: false
        onTriggered: {
            stage.text = db.getCurrentTinnitusStage();
            future.text = db.getLatestFutureTinnitusStage();
            rft.text = db.getRecommendedFrequency();
            console.log(playAutomatically)
            if(playAutomatically==1 && future.text!="Normal"|| parseInt(pulse.text)>=90 ){
//               demo.generateReverseSound(parseInt(cft.text))
//               play.source ="file:///home/ai/Downloads/icons8-reload-100/images/icons8-pause-100.png"
//               flag =1
            }

            interval=10000+3000
            dataUpdateTimer.start();
        }
    }
    Timer {
        id: automate
        interval: 5000
        running: false
        onTriggered: {
            //            if(stage.text!="Neutral"|| parseInt(pulse.text)>=90){
            //            demo.generateReverseSound(parseInt(cft.text))
            //            }
            //            else{
            //            demo.stopSound()
            //            }
            //            automate.start()
        }
    }
    Timer {
        id: dbtimer
        interval: 13000
        running: false
        onTriggered: {
            interval=13000+500
            db.refreshDatabase();
            dbtimer.start();
        }
    }

    Timer {
        id: volumeTimer
        interval: 2000
        repeat: true
        running: false
        onTriggered: {
            if (currentVolume > 0) {
                demo.startDescendingVolume(currentVolume);
                currentVolume -= 100
            } else {
                intenplayplay.source ="file:///home/ai/Downloads/icons8-reload-100/images/icons8-play-100.png"
                flagin =0
                volumeTimer.stop();
                console.log("stop")
                demo.stopSound()
                volumeTimer.stop();
                intern.text="Your Hearing Intensity is "+demo.calculateHearingIntensity(currentVolume,20).toString()
            }
        }
    }


    Timer {
        id: snsortimer
        interval: 5000
        running: false
        onTriggered: {

            pulse.text =demo.gen().toString()
            db. writeFrequencyToFirebase(" ",pulse.text.toString()+"|"+future.text.toString()+"|"+root.model.get(root.model.count-1).text+"|"+demo.galvonic().toString())
            snsortimer.start()
        }
    }
    Rectangle{
        id : mainrect
        height: parent.height
        width: parent.width
        color: "#141b2d"

        Rectangle{
            id: leftrect
            height:420
            width:380
            color:"#242c40"
            anchors.top: mainrect.top
            anchors.topMargin: 15
            anchors.left: mainrect.left
            anchors.leftMargin: 10
            anchors.bottom: mainrect.bottom
            anchors.bottomMargin: 10
            Rectangle{
                id:checkIntensity
                height: 40
                width: 105
                radius: 8
                visible:switchestext.text=="I"?true:false
                color:"#242c40"
                anchors.top:leftrect.top
                anchors.topMargin: 160
                anchors.left: leftrect.left
                anchors.leftMargin: 130
                Text{
                    id:intern
                    text:"Check Intensity"
                    anchors.centerIn: parent
                    color: '#00a2e2'
                    font.bold: true
                    font.family: "ubuntu"
                }

                MouseArea{
                    anchors.fill: checkIntensity
                    onClicked: {
                        //      demo.startDescendingVolume()
                        //    reduceVolume();
                    }
                    onPressed: {
                        checkIntensity.color="#141b2d"
                    }
                    onReleased: {
                        checkIntensity.color="#242c40"
                    }
                }

            }

            Image {
                id: intenplayplay
                source: "file:///home/ai/Downloads/icons8-reload-100/images/icons8-play-100.png"
                height :(mainrect.height*0.06 + mainrect.width *0.08)/2.5
                width:(mainrect.height*0.06 + mainrect.width *0.08)/2.5
                anchors.left: checkIntensity.left
                anchors.leftMargin: 30
                anchors.top: checkIntensity.bottom
                anchors.topMargin: 35
                visible:switchestext.text=="I"?true:false
                MouseArea{
                    anchors.fill:intenplayplay
                    onClicked: {
                        if(flagin==0){
                            intenplayplay.source ="file:///home/ai/Downloads/icons8-reload-100/images/icons8-pause-100.png"
                            flagin =1
                            //demo.startDescendingVolume()
                            volumeTimer.start()
                            demo.volume(50)

                        }
                        else if (flagin ==1){
                            intenplayplay.source ="file:///home/ai/Downloads/icons8-reload-100/images/icons8-play-100.png"
                            flagin =0
                            volumeTimer.stop();
                            demo.stopSound()
                            intern.text="Your Hearing Intensity is "+demo.calculateHearingIntensity(20.00,currentVolume).toString()
                            console.debug(currentVolume)
                        }
                    }
                }
            }

            Rectangle {
                id:popup
                anchors.top: leftrect.top
                anchors.topMargin: 20
                anchors.left: leftrect.left
                anchors.leftMargin: 30
                anchors.right: leftrect.right
                anchors.rightMargin: 40
                width:100
                height:20
                color: "transparent"
                visible: true
                Text {
                    id:notification
                    anchors.centerIn: parent
                    color:"white"
                    font.pixelSize: 15
                    font.family: "Helvetica"
                }
                Timer {
                    id: timer
                    interval: 1500;
                    running: false;
                    repeat: false
                    onTriggered: {
                        popup.visible =false
                    }
                }
                onVisibleChanged: {
                    if(visible)
                        timer.running = true;
                }
            }
            Label{
                id:inference
                visible:switchestext.text=="I"?false:true
                anchors.left: leftrect.left
                anchors.top: leftrect.top
                anchors.topMargin: mainrect.height *0.03
                anchors.leftMargin: mainrect.width *0.02
                text: "Null"
                color:"#e95e76"
                font.bold: false
                font.family: "ubuntu"
                font.pointSize:(mainrect.height+mainrect.width) /120
            }
            Switch {
                id: switches
                anchors.right: leftrect.right
                anchors.top: leftrect.top
                anchors.topMargin: mainrect.height *0.03
                anchors.rightMargin: mainrect.width *0.02
                indicator: Rectangle {
                    implicitWidth: mainrect.width*0.09
                    implicitHeight: mainrect.height*0.05
                    radius:5
                    color: switches.checked ? "#fd6e6c" : "#8568fe"
                    border.color:switches.checked ?"#fd6e6c":"#8568fe"
                    Text {
                        id: switchestext
                        text: switches.checked ?"I":"R";
                        color: switches.checked ?"I":"R";
                        font.family: "Helvetica"
                        anchors.centerIn: parent
                        font.pointSize:(leftrect.height*0.13+leftrect.width*0.20)/15
                        font.bold:true
                    }
                    //                Rectangle {
                    //                    x: switches.checked ? parent.width - width : 0
                    //                    width: mainrect.width*0.015
                    //                    height: mainrect.height*0.05
                    //                    radius:5
                    //                    color: "white"
                    //                    border.color: switches.checked ? "Dark Gray": "#999999"
                    //                }

                }
                onCheckedChanged:  {
                    intern.text="Check Intensity"
                }
            }

            Dial {
                id: dial
                from:0
                to: 15000
                visible:switchestext.text=="I"?false:true
                stepSize: 10
                anchors.top: leftrect.top
                anchors.left: leftrect.left
                anchors.topMargin: 50
                anchors.leftMargin: 115
                Label{
                    id : dialValue
                    anchors.centerIn: dial
                    text: "0"
                    color:"white"
                    font.bold: false
                    font.family: "Helvetica"
                    font.pointSize:(mainrect.height+mainrect.width) /120
                }
                Label{
                    id : hz
                    anchors.top: dialValue.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: (dial.height+dial.width)/4.5
                    text: "Hz"
                    color:"white"
                    font.bold: true
                    font.family: "Helvetica"
                    font.pointSize:(mainrect.height+mainrect.width) /140
                }
                background: Rectangle {
                    x: dial.width / 2 - width / 2
                    y: dial.height / 2 - height / 2
                    implicitWidth: 140
                    implicitHeight: 140
                    width: Math.max(64, Math.min(dial.width, dial.height))
                    height: width
                    color: "transparent"
                    radius: width / 2
                    border.color: dial.pressed ? "#008efe" : "#229ebd"
                    border.width: 3
                    opacity: dial.enabled ? 1 : 0.3
                }

                handle: Rectangle {
                    id: handleItem
                    x: dial.background.x + dial.background.width / 2 - width / 2
                    y: dial.background.y + dial.background.height / 2 - height / 2
                    width: 14
                    height: 14
                    color: "#287e8f"
                    radius: 15
                    antialiasing: true
                    opacity: dial.enabled ? 1 : 0.3
                    transform: [
                        Translate {
                            y: -Math.min(dial.background.width, dial.background.height) * 0.4 + handleItem.height / 2
                        },
                        Rotation {
                            angle: dial.angle
                            origin.x: handleItem.width / 2
                            origin.y: handleItem.height / 2
                        }
                    ]

                }
                onValueChanged: {
                    dialValue.text=Math.round(dial.value)
                    // console.log(value)
                }
            }//dial
            Label{
                id : o
                visible:switchestext.text=="I"?false:true
                text: "0"
                color:"white"
                font.bold: true
                anchors.right: s1.left
                anchors.top: s1.top
                anchors.topMargin: 20
                font.family: "Helvetica"
                font.pointSize:(mainrect.height+mainrect.width) /150
            }
            Slider{
                id:s1
                from:0
                to:100
                value: 10
                visible:switchestext.text=="I"?false:true
                stepSize: 1
                anchors.top: dial.bottom
                anchors.topMargin: 7
                anchors.left: leftrect.left
                anchors.leftMargin: 50
                background: Rectangle {
                    x: s1.leftPadding
                    y: s1.topPadding + s1.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: s1.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#242c40"

                    Rectangle {
                        width: s1.visualPosition * parent.width
                        height: parent.height
                        color: "#30be76"
                        radius: 2
                    }
                }
                handle: Image {
                    id:handle
                    source:"file:///home/ai/Downloads/icons8-reload-100/images/speedarrow.png"
                    width: (mainrect.height*0.10 +  mainrect.width*0.10)/6
                    height:  (mainrect.height*0.10 +  mainrect.width*0.10)/6
                    anchors.bottom: s1.bottom
                    anchors.bottomMargin: 10
                    x:s1.visualPosition * (s1.width-width)
                    y: (s1.height-height)/2

                }
                onValueChanged:   {
                    demo.volume(s1.value)

                }
            }//slider
            Label{
                id : ioo
                text: "100"
                visible:switchestext.text=="I"?false:true
                color:"white"
                font.bold: true
                anchors.left: s1.right
                anchors.top: s1.top
                anchors.topMargin: 20
                font.family: "Helvetica"
                font.pointSize:(mainrect.height+mainrect.width) /150
            }

            ComboBox {
                id: root
                property color checkedColor: "#f7890f"
                visible:switchestext.text=="I"?false:true
                model:ListModel{
                    id: model
                    ListElement { text: "0Hz" }
                    ListElement { text: "550" }

                }
                anchors.bottom: leftrect.bottom
                anchors.bottomMargin: 80
                anchors.left:leftrect.left
                anchors.leftMargin:50
                width: mainrect.width*0.10
                height: mainrect.height*0.061
                delegate: ItemDelegate {
                    width: root.width
                    contentItem: Text {
                        text: modelData
                        anchors.centerIn: parent
                        color:"white"
                        font.family: "Helvetica"
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize:(mainrect.height*0.06 + mainrect.width*0.10)/17
                    }
                    background: Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                        radius:25
                        border.color:root.highlightedIndex === index ? root.checkedColor : "#242c40"
                    }
                }
                indicator: Canvas {
                    id: canvas
                    x:root.width - width - root.rightPadding
                    y: root.topPadding + (root.availableHeight - height) / 2
                    width: 12
                    height: 8
                    contextType: "2d"
                    onPaint: {
                        context.reset();
                        context.moveTo(0, 0);
                        context.lineTo(width, 0);
                        context.lineTo(width / 2, height);
                        context.closePath();
                        context.fillStyle = "white"
                        context.fill();
                    }
                }
                contentItem: Item {
                    width: root.background.width - root.indicator.width - 10
                    height: root.background.height
                    Text {
                        anchors.centerIn: parent
                        x: 10
                        text: root.displayText
                        elide: Text.ElideRight
                        font.family: "Helvetica"
                        font.weight: Font.Thin
                        font.pointSize:(mainrect.height*0.06 + mainrect.width*0.10)/14
                        color: root.down ? Qt.rgba(255, 255, 255, 0.75) : "white"
                    }
                }
                background: Rectangle {
                    implicitWidth: 150
                    implicitHeight: 41
                    color: "transparent"
                    border.color:"#f7890f"
                    border.width: root.visualFocus ? 2 : 1
                    radius:30
                }
                popup: Popup {
                    y: root.height - 1
                    width: root.width
                    implicitHeight:mainrect.height*0.19
                    padding: 1
                    contentItem: ListView {
                        implicitHeight: contentHeight
                        model: root.popup.visible ? root.delegateModel : null
                        clip: true
                        currentIndex: root.highlightedIndex

                    }
                    background: Rectangle {
                        color: "transparent"
                        radius: 20
                        border.color:"#f7890f"
                    }
                }
                onCurrentTextChanged: {
                    dial.value= parseInt(root.currentText.split("Hz"))
                }
            }

            Rectangle {
                id: save
                border.color: "#357bec"
                color: "transparent"
                anchors.left: leftrect.left
                visible:switchestext.text=="I"?false:true
                anchors.leftMargin: switchestext.text=="I"?(mainrect.height*0.25 + mainrect. width*0.5)/3.8:(mainrect.height*0.25 + mainrect. width*0.5)/3.5
                anchors.bottom: leftrect.bottom
                anchors.bottomMargin: 80
                width: mainrect.width*0.10
                height: mainrect.height*0.065
                radius: 15
                Text{
                    id:savetext
                    text:"Save"
                    anchors.centerIn: save
                    color:"white"
                    font.pointSize:(mainrect.height*0.06 + mainrect.width*0.10)/15
                    font.bold: false
                    font.family: "Helvetica"
                }
                MouseArea {
                    anchors.fill: save
                    onClicked: {
                        demo.serialData()
                        model.append({text:dialValue.text })
                        popup.visible=true
                        notification.text = "Saved "+dialValue.text+"Hz"
                        db.writeFrequencyToFirebase("",dialValue.text)
                        notification.color ="white"
                        popup.anchors.leftMargin= 10
                    }
                }
            }

            Image {
                id: play
                visible:switchestext.text=="I"?false:true
                source: "file:///home/ai/Downloads/icons8-reload-100/images/icons8-play-100.png"
                height :(mainrect.height*0.06 + mainrect.width *0.08)/2.5
                width:(mainrect.height*0.06 + mainrect.width *0.08)/2.5
                anchors.left: save.right
                anchors.leftMargin: 20
                anchors.bottom: leftrect.bottom
                anchors.bottomMargin: 77
                MouseArea{
                    anchors.fill:play
                    onClicked: {
                        if(flag==0){
                            play.source ="file:///home/ai/Downloads/icons8-reload-100/images/icons8-pause-100.png"
                            flag =1
                            if(switchestext.text=="I"){
                                demo.generateSound(Math.round(dial.value))
                                popup.visible=true
                                notification.text = "Playing Forward Sin: "+dialValue.text+"Hz"
                                notification.color ="white"
                                notification.font.family= "Helvetica"
                                popup.anchors.leftMargin= 8
                                notification.font.bold=false
                            }
                            if(switchestext.text=="R"){
                                var name=demo.generateReverseSound(Math.round(dial.value))
                                inference.text=name == 0?"Noise Canceled":"Noise"
                                inference.color=name==0?"#2dba5f":"#e95e76"
                                popup.visible=true
                                notification.text = "Playing Inverse Sin: "+dialValue.text+"Hz"
                                notification.font.family= "Helvetica"
                                notification.color ="white"
                                popup.anchors.leftMargin= 8
                                notification.font.bold=false
                            }
                        }
                        else if (flag ==1){
                            play.source ="file:///home/ai/Downloads/icons8-reload-100/images/icons8-play-100.png"
                            flag =0
                            demo.stopSound()
                            popup.visible=true
                            notification.text = "Stopped"
                            notification.font.family= "Helvetica"
                            notification.color ="white"
                            popup.anchors.leftMargin= 10
                            notification.font.bold=false
                        }
                    }
                }
            }

            Image {
                id: music
                source: "file:////home/ai/Downloads/firebase_qt/icons8-reload-100/images/music.png"
                height :(mainrect.height*0.06 + mainrect.width *0.08)/2.3
                width:(mainrect.height*0.06 + mainrect.width *0.08)/2.3
                anchors.left: play.right
                visible:switchestext.text=="I"?false:true
                anchors.leftMargin: 20
                anchors.bottom: leftrect.bottom
                anchors.bottomMargin: 77
                MouseArea{
                    anchors.fill: music
                    onClicked: {
                        var windows= Qt.createComponent("MusicWindow.qml")
                        win = windows.createObject(music)
                        win.show()
                    }

                }
            }

        }
        Rectangle{
            id:innerrect
            height:420
            width:370
            color:"#141b2d"
            anchors.top: mainrect.top
            anchors.topMargin: 15
            anchors.right: mainrect.right
            anchors.rightMargin: 20
            anchors.bottom: mainrect.bottom
            anchors.bottomMargin: 10
            border.color: "White"
            // color:"#242c40"

            Image {
                id: profile1
                source: "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/icons8-person-64 (1).png"
                height :100
                width:100
                anchors.left: innerrect.left
                anchors.leftMargin: 140
                anchors.top: innerrect.top
                anchors.topMargin: 15
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                    Qt.openUrlExternally("http://www.google.com")
                            }
                        }
            }

            Text{
                id:uname
                text:"Sri-DID324"
                anchors.top: profile1.bottom
                anchors.topMargin: -4
                font.family: "ubuntu"
                anchors.left: profile1.left
                anchors.leftMargin: 5
                font.pointSize: 12
                font.bold: true
                color:"White"
            }
            Text{
                id : pulselabel
                text:"Pulse Level: "
                anchors.top: uname.bottom
                anchors.topMargin: 17
                anchors.left: innerrect.left
                anchors.leftMargin: 50
                font.family: "ubuntu"
                font.pointSize: 10
                font.bold: true
                color:"White"
            }
            Text{
                id : pulse
                text:"70"
                color: text>95?"red":"green"
                anchors.top: uname.bottom
                anchors.topMargin: 16
                font.family: "ubuntu"
                anchors.left: cftlabel.right
                anchors.leftMargin: 67
                font.pointSize: 10
                font.bold: true

            }
            Text{
                id : cftlabel
                text:"Current Tinnitus Fq: "
                anchors.top: pulse.bottom
                anchors.topMargin: 14
                anchors.left: innerrect.left
                anchors.leftMargin: 50
                font.family: "ubuntu"
                font.pointSize: 10
                font.bold: true
                color:"White"
            }
            Text{
                id : cft
                text:root.model.get(root.model.count-1).text
                anchors.top: pulselabel.bottom
                anchors.topMargin: 16
                font.family: "ubuntu"
                anchors.left: cftlabel.right
                anchors.leftMargin: 67
                font.pointSize: 10
                font.bold: true
                color:"White"
            }
            Text{
                id : rftlabel
                text:"Advice Tinnitus Fq: "
                anchors.top: cftlabel.bottom
                anchors.topMargin: 14
                font.family: "ubuntu"
                anchors.left: innerrect.left
                anchors.leftMargin: 50
                font.pointSize: 10
                font.bold: true
                color:"White"
            }
//            Rectangle{
//                id:mouserect
//                anchors.top: innerrect.bottom
//                anchors.topMargin: 16
//                anchors.left: innerrect.right
//                anchors.leftMargin: 75
//                border.color: "White"
//                height: 20
//                width:80
//                color: "transparent"
                Text{
                    id : rft
                    text: db.getRecommendedFrequency();
                    anchors.top: cft.bottom
                    anchors.topMargin: 16
                    anchors.left: rftlabel.right
                    anchors.leftMargin: 75
                    font.pointSize: 10
                    font.bold: true
                    font.family: "ubuntu"
                    color:"White"
                    MouseArea{
                        anchors.fill: rft
                        height:30
                        width:80
                        onClicked: {
                            dial.value=rft.text
                            demo.generateReverseSound(parseInt(rft.text))
                            play.source ="file:///home/ai/Downloads/icons8-reload-100/images/icons8-pause-100.png"
                            flag =1
                        }
                    }
            //   }

            }
            Text{
                id : stagelabel
                text:"Current Tinnitus Stage: "
                anchors.top: rftlabel.bottom
                anchors.topMargin: 14
                anchors.left: innerrect.left
                anchors.leftMargin: 50
                font.pointSize: 10
                font.bold: true
                color:"White"
            }
            Text{
                id : stage
                text: db.getCurrentTinnitusStage()
                color: text=="Neutral"||text=="Normal"?"green":"red"
                anchors.top: rft.bottom
                font.family: "ubuntu"
                anchors.topMargin: 13
                anchors.left: stagelabel.right
                anchors.leftMargin: 40
                font.pointSize: 10
                font.bold: true

//                onTextChanged: {
//                    if(stage.text!="Neutral" || parseInt(pulse.text)>=90 && autoplayAutomatically ==true){
//                        demo.generateReverseSound(parseInt(cft.text))
//                        play.source ="file:///home/ai/Downloads/icons8-reload-100/images/icons8-pause-100.png"
//                        flag =1
//                    }
//                    else{
//                        demo.stopSound()
//                    }
//                }
            }
            Text{
                id : futurelabel
                text:"Possible Tinnitus Stage: "
                anchors.top: stagelabel.bottom
                anchors.topMargin: 16
                anchors.left: innerrect.left
                anchors.leftMargin: 50
                font.pointSize: 10
                font.bold: true
                color:"White"
            }
            Text{
                font.family: "ubuntu"
                id : future
                text:db.getLatestFutureTinnitusStage()=="Abnormal"?"Normal":db.getLatestFutureTinnitusStage();
                anchors.top: stage.bottom
                anchors.topMargin: 16
                anchors.left: futurelabel.right
                anchors.leftMargin:35
                font.pointSize: 10
                font.bold: true
                color: text=="Normal"?"green":"red"
                MouseArea{
                    anchors.fill: future
                    height:30
                    width:80
                    onClicked: {
                        playAutomatically = 0
                        console.log("click single")
                    }
                    onDoubleClicked: {
                        playAutomatically =1
                        console.log("double")
                    }
                }
            }

        }
        //        Rectangle{
        //            id:tabrect
        //            height:420
        //            width:350
        //            color:"#242c40"
        //            anchors.top: mainrect.top
        //            anchors.topMargin: 15
        //            anchors.right: mainrect.right
        //            anchors.rightMargin: 10
        //            anchors.bottom: mainrect.bottom
        //            anchors.bottomMargin: 10

        //            TableView {
        //                id:tableview
        //                anchors.top: tabrect.top
        //                anchors.topMargin: 10
        //                anchors.bottom: tabrect.bottom
        //                anchors.bottomMargin: 60
        //                anchors.right: tabrect.right
        //                anchors.rightMargin: 10
        //                anchors.left: tabrect.left
        //                anchors.leftMargin: 10
        //                width: 600
        //                height: 420
        //                TableViewColumn{ role: "x" ; title: "Pulse" ; width: tableview.width/4 ;resizable: true ; movable: true }
        //                TableViewColumn{ role: "y" ; title: "EMG" ; width: tableview.width/4 ;resizable: true ; movable: true }
        //                TableViewColumn{ role: "z" ; title: "Galvonic" ; width: tableview.width/4 ; resizable: true ; movable: true  }
        //                model: ListModel{
        //                    id: tV

        //                }

        //                alternatingRowColors: true
        //                backgroundVisible: true
        //                headerVisible: true
        //                itemDelegate: Item {
        //                    Text {
        //                        anchors.verticalCenter: parent.verticalCenter
        //                        elide: styleData.elideMode
        //                        text: styleData.value
        //                    } // text
        //                } // Item

        //                onDoubleClicked: {
        //                    tV.remove(tableview.currentIndex);
        //                }
        //            }// TableView
        //            Image {
        //                id: graph
        //                source: "file:///home/ai/Downloads/icons8-reload-100/images/icons8-combo-chart-60.png"
        //                height :(mainrect.height*0.06 + mainrect.width *0.08)/2.3
        //                width:(mainrect.height*0.06 + mainrect.width *0.08)/2.3
        //                anchors.left: tabrect.left
        //                anchors.leftMargin: 20
        //                anchors.bottom: tabrect.bottom
        //                anchors.bottomMargin: 16
        //            }
        //            Image {
        //                source: "file:///home/ai/Downloads/icons8-reload-100/images/icons8-reload-100.png"
        //                id: reload
        //                height :(mainrect.height*0.06 + mainrect.width *0.08)/2.5
        //                width:(mainrect.height*0.06 + mainrect.width *0.08)/2.5
        //                anchors.right: tabrect.right
        //                anchors.rightMargin: 20
        //                anchors.bottom: tabrect.bottom
        //                anchors.bottomMargin: 16
        //                MouseArea{
        //                    anchors.fill: reload
        //                    onClicked: {
        //                        tV.clear()
        //                        var str = db.refreshDatabase();
        //                        console.log(str);
        //                        var lines = str.split("|");

        //                        console.log(lines)
        //                        var emgValues = [];
        //                        var pulseValues = [];
        //                        var galValues = [];

        //                        for (var i = 0; i < lines.length; i++) {

        //                            if (lines[i] === "Emg") {
        //                                while(lines[i]!="Pulse"){
        //                                    emgValues[i]=lines[i];
        //                                    i++; // Skip next line (sensor data)
        //                                }
        //                                i--;
        //                            } else if (lines[i] === "Pulse") {
        //                                var num=0;
        //                                while(lines[i]!="Gal"){
        //                                    pulseValues[num]=lines[i];
        //                                    i++; num++;// Skip next line (sensor data)
        //                                }
        //                                i--;
        //                            } else if (lines[i] === "Gal") {
        //                                var num=0;
        //                                while(lines[i]!="End"){
        //                                    galValues[num]=lines[i];
        //                                    i++; num++;// Skip next line (sensor data)
        //                                }
        //                            }
        //                        }
        //                        for(var i =0;i<=emgValues.length;i++){
        //                            tV.append({
        //                                          x: emgValues[i+1],
        //                                          y: pulseValues[i+1],
        //                                          z: galValues[i+1]
        //                                      });
        //                        }
        //                    }
        //                }
        //            }
        //        }

    }

    Component.onCompleted: {
        timer.start();
        notification.text="Your are Signed In as "+"Sri"
        popup.visible=true
        timer.running = true;
        notification.font.family= "Helvetica"
        notification.color ="white"
        dataUpdateTimer.start();
        dbtimer.start();
        automate.start()
        snsortimer.start()
    }
}
