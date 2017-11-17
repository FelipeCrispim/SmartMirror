import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtPositioning 5.3
import QtBluetooth 5.2
import Process 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 480
    title: qsTr("Hello World")
    property int dayInWeek: 7
    property int date: 0
    property int hours: 0
    property int minutes: 0
    property int seconds: 0
    Component.onCompleted: {
        root.timeChanged()
                stackView.push(introduction)
        //        blockScreen.visible = true
    }
    Process {
        id: process
        Component.onCompleted: {
            var command = "/Users/felipecrispim/dev/Qt-workspace/smart_mirror/twitter/twitter_time_line.py" +
                    " p_pedrinhu " + "/Users/felipecrispim/dev/Qt-workspace/smart_mirror/twitter/"
            process.start("python", command)
        }
        onAnswer: ttLabel.text = ans;
    }
    Timer {
        id: btTimer
        interval: 7000; running: false; repeat: true;
        onTriggered: {
            btModel.running = false
            btModel.running = true

            if(!btModel.savedDeviceFound){
                console.log("ñ achou")
                blockScreen.visible = true
            } else {
                blockScreen.visible = false
            }

            btModel.savedDeviceFound = false
        }
    }

    BluetoothDiscoveryModel {
        id: btModel
        property bool savedDeviceFound: true
        running: false
        discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
        onDeviceDiscovered: {
            if(device == bluetoothManager.deviceBluetooth){
                savedDeviceFound = true
            }

        }
    }

    Component {
        id: introduction
        Introduction {
            onFinishedSignup: btTimer.running = true
        }
    }

    PositionSource {
        id: coord
    }
    //    Component.onCompleted: getData()
    //http://api.wunderground.com/api/a43e3da295483298/conditions/q/-9,-35.7224.json
    function getData() {
        var xmlhttp = new XMLHttpRequest();
        var url = "http://api.wunderground.com/api/a43e3da295483298/conditions/q/-9,-35.7224.json";

        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState === XMLHttpRequest.DONE && xmlhttp.status == 200) {
                myFunction(xmlhttp.responseText);
            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.send();
    }

    Timer {
        interval: 1000; running: true; repeat: true;
        onTriggered: root.timeChanged()
    }
    function timeChanged() {
        var date = new Date;
        root.date = date.getDate() //1 to 31
        root.dayInWeek =  date.getDay() //0 to 6
        root.hours = date.getHours() //0 to 23
        root.minutes = date.getMinutes()
        root.seconds = date.getUTCSeconds();
    }

    function myFunction(response) {
        //        console.log("teste", JSON.parse(response).current_observation.temp_c);
        tempLbl.text = JSON.parse(response).current_observation.temp_c + "º"
        tempIcon.source = JSON.parse(response).current_observation.icon_url
    }
    StackView {
        id: stackView
        focus: true
        anchors.fill: parent
        initialItem: Item {
            id: topItem
            Column{
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 15
                width: 30
                Label {
                    property var days: ["Domingo","Segunda","Terça","Quarta","Quinta","Sexta","Sábado",""]
                    text: days[root.dayInWeek]+", "+root.date
                    font.pixelSize: 32
                }

                Row {
                    id: clock
                    Label {
                        text: root.hours
                        font.pixelSize: 60
                        font.bold: true
                    }
                    Label {
                        text: ":"
                        font.pixelSize: 60
                        font.bold: true
                        color: (root.seconds & 1) == 0? "transparent" : "white"
                    }
                    Label {
                        text: root.minutes
                        font.pixelSize: 60
                        font.bold: true
                    }
                }
                Label {
                    id: ttLabel
                    text: "goal1"
                    width: 150
                    wrapMode: Label.WordWrap
                    font.bold: true
                    topPadding: 30
                    font.pixelSize: 15
                }

            }
            Column {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.rightMargin: 15
                RowLayout {
                    spacing: 10
                    //                    Layout.alignment: Qt.AlignRight
                    Item {
                        width: 54
                        height: 54
                        AnimatedImage {
                            id: tempIcon
                            source: "http://icons.wxug.com/i/c/k/nt_rain.gif"
                            anchors.fill: parent
                            width: 20
                        }
                    }
                    Label {
                        id: tempLbl
                        text: "15º"
                        font.pixelSize: 38
                        //                        verticalAlignment: parent.verticalCenter
                        //                        bottomPadding: 15
                    }
                }
            }

        }

    }
    Rectangle {
        id: blockScreen
        property bool blackScreen: false
        //        property string device: bluetoothManager.deviceBluetooth
        anchors.fill: parent
        color: "black"
        opacity: 1
        visible: false
        Component {
            id: keypadPage
            ConfirmDigit {
                onCorrectPass: {
                }
                onNoPass: {
                    blockScreen.visible = true
                }
            }
        }


        Image {
            source: "qrc:/keypad.png"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            height: 52
            width: 40
            anchors.margins: 5
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stackView.push(keypadPage)
                    blockScreen.visible = false
                }
            }
        }
        //        function dark(){
        //            if(btModel.savedDeviceFound == true){
        //                welcomeLabel.visible = true
        //                animator.from = 1
        //                animator.to = 0
        //                animator.running = true
        //                blackScreen = false
        //            } else {
        //                animator.from = 0
        //                animator.to = 1
        //                animator.running = true
        //                blackScreen = true
        //            }
        //        }

    }
    OpacityAnimator {
        id: animator
        target: blockScreen;
        running: false
        duration: 2500
        onStopped: welcomeLabel.visible = false
    }
    Label {
        id: welcomeLabel
        Component.onCompleted: console.log(welcomeLabel.text)
        text: {
            if(root.hours < 12) return "Bom dia!"
            else if(root.hours>=12 && root.hours <18) return "Boa tarde!"
            else return "Boa noite!"
        }
        anchors.centerIn: parent
        font.pixelSize: 38
        visible: false
    }
}

