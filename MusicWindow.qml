import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick 2.12
import QtMultimedia 5.0
Window {
    id:mainrect
    visible: true
    width: 800
    height: 480
    MediaPlayer {
        id: mediaPlayer
    }
    TabView {
        id: frame
        height: mainrect.height
        width:mainrect.width
        anchors.margins: 4
        Tab { title: "Coloured"
            Coloured{
                id:colored
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin:  5
                border.color: "white"
                onSongClicked: {
                    if(songName!="Stop"){
                    mediaPlayer.source = "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/Coloured/" +songName+ ".mp3"
                    mediaPlayer.play()
                    }
                    else{
                         mediaPlayer.stop();
                    }
                }


            }
        }
        Tab { title: "Natural"
            Natural{
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                border.color: "white"
                anchors.bottom: parent.bottom
                anchors.bottomMargin:  5
                onNaturalsongClicked: {
                        console.log("Clicked song:", songName)
                        if(songName!="Stop"){
                        mediaPlayer.source = "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/Nature/" +songName+ ".mp3"
                        mediaPlayer.play()
                        }
                        else{
                             mediaPlayer.stop();
                        }
                }
            }
        }
        Tab { title: "Binaural"
            Binaural{
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin:  5
                border.color: "white"
                onBinSongClicked: {
                    if(songName!="Stop"){
                        mediaPlayer.source = "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/Binaural/" +songName+ ".mp3"
                        mediaPlayer.play()
                        }
                        else{
                             mediaPlayer.stop();
                        }
                }
            }

        }
        Tab { title: "Vehicle"
            Vehicle{
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin:  5
                border.color: "white"
                onVehiclesongClicked: {
                    if(songName!="Stop"){
                    mediaPlayer.source = "file:///home/ai/Downloads/firebase_qt/icons8-reload-100/images/Vehicle/"+songName+".mp3"
                    mediaPlayer.play()
                    }
                    else{
                         mediaPlayer.stop();
                    }
                }

            }

        }

        style: TabViewStyle {
            frameOverlap: 1
            tab: Rectangle {
                color: styleData.selected ? "black" :"lightsteelblue"
                implicitWidth: mainrect.width/4
                implicitHeight: mainrect.height*0.08
                radius: 2
                Text {
                    id: tabtext
                    anchors.centerIn: parent
                    text: styleData.title
                    font.bold:true
                    color: styleData.selected ? "#00FFFF" : "white"
                    font.pointSize: 15
                }
            }
            frame: Rectangle { color: "black"
            }
        }
    }
}

