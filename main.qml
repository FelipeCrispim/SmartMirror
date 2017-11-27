import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtPositioning 5.2
import QtBluetooth 5.0
import Controller 1.0
import QtQuick.Window 2.2
import "Definitions.js" as Def

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 480
    visibility: "Maximized"
    title: qsTr("Smart Mirror")
    property int dayInWeek: 7
    property int date: 0
    property int hours: 0
    property int minutes: 0
    property int seconds: 0
    property string kindOfWeather: "mostlycloudy"
    property int velocityOfWind: 0
    Component.onCompleted: {
        root.timeChanged()
        if(controller.firstTimeApp() === true)
            stackView.push(introduction)
        else {
            blockScreen.visible = true
            btTimer.start()
        }
        //        console.log(location.position.coordinate.latitude)
    }
    PositionSource {
        id: position
        active: true
        property string latitude
        property string longitude
        onPositionChanged: {
            var coord = position.position.coordinate;
            position.latitude = coord.latitude
            position.longitude = coord.longitude
            root.getWeather()
        }
    }

    Controller {
        id: controller
        property string commit: ""
        Component.onCompleted: {
            controller.getTwitter()
        }
        onHasUpdate: {
            controller.commit = commit
            update.visible = true
        }
        onAnswerTwitter: ttLabel.text = ans;
    }

    Timer {
        id: btTimer
        interval: 7000; running: false; repeat: true;
        onTriggered: {
            btModel.running = false
            btModel.running = true
            if(btModel.savedUserFound == true){
                blockScreen.visible = false
            } else {
                blockScreen.visible = true
            }
            btModel.savedUserFound = false
        }
    }

    BluetoothDiscoveryModel {
        id: btModel
        property bool savedUserFound: false
        running: false
        discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
        onDeviceDiscovered: {
            console.log(device)
            if(controller.isThereUser(device)){
                savedUserFound = true
            }

        }
    }

    Component {
        id: introduction
        Introduction {
            onFinishedSignupBluttoth: {
                btTimer.running = true
                iconGetOut.visible = false
                //                animator.start()
                //root.getWeather()
            }
            onFinishedSignupDigit: {
                iconGetOut.visible = true
                //                animator.start()
                //root.getWeather()
            }
        }
    }

    PositionSource {
        id: coord
    }
    //http://api.wunderground.com/api/a43e3da295483298/conditions/q/-9,-35.7224.json
    function getWeather() {
        var xmlhttp = new XMLHttpRequest();
        var url = "http://api.wunderground.com/api/a43e3da295483298/conditions/q/"+position.latitude+","+position.longitude+".json";

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
        root.hours = date.getHours()-1 //0 to 23
        root.minutes = date.getMinutes()
        root.seconds = date.getUTCSeconds();
    }

    function myFunction(response) {
        //        console.log("teste", JSON.parse(response).current_observation.temp_c);
        tempLbl.text = JSON.parse(response).current_observation.temp_c + "°"
        tempIcon.source = JSON.parse(response).current_observation.icon_url
        root.kindOfWeather = JSON.parse(response).current_observation.icon
        root.velocityOfWind = JSON.parse(response).current_observation.wind_kph
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
                    font: Qt.font({ pixelSize: 32, family: Def.standardizedFontFamily()})
                }

                Row {
                    id: clock
                    Label {
                        text: root.hours
                        font: Qt.font({ pixelSize: 60, family: Def.standardizedFontFamily(), weight: Font.Bold })
                    }
                    Label {
                        text: ":"
                        font: Qt.font({ pixelSize: 60, family: Def.standardizedFontFamily(), weight: Font.Bold })
                        color: (root.seconds & 1) == 0? "transparent" : "white"
                    }
                    Label {
                        text: {
                            if(root.minutes < 10){
                                return "0"+root.minutes
                            } else {
                                return root.minutes
                            }


                        }
                        font: Qt.font({ pixelSize: 60, family: Def.standardizedFontFamily(), weight: Font.Bold })
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
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(root.hours < 12)
                                    speech.infoAboutWeather(root.velocityOfWind, 1.7, "11:32")
                                else
                                    speech.infoAboutWeather(root.velocityOfWind, 0.7, "17:43")
                            }
                        }
                    }
                    Label {
                        id: tempLbl
                        text: "00°"
                        font: Qt.font({ pixelSize: 38, family: Def.standardizedFontFamily(), weight: Font.Bold })
                        //                        verticalAlignment: parent.verticalCenter
                        //                        bottomPadding: 15
                    }
                }
            }
            Image {
                id: iconGetOut
                source: "qrc:/door.png"
                visible: false
                anchors.margins: 15
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                width: Screen.pixelDensity*14
                height: Screen.pixelDensity*14
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        btModel.running = true
                        btTimer.start();
                        iconGetOut.visible = false
                        blockScreen.visible = true
                        speech.sayGoodBye()
                    }
                }
            }
            //            Label {
            //                id: welcomeLabel
            //                text: {
            //                    if(root.hours < 12) return "Bom dia, bem vindo!"
            //                    else if(root.hours>=12 && root.hours <18) return "Boa tarde, bem vindo!"
            //                    else return "Boa noite, bem vindo!"
            //                }
            //                OpacityAnimator {
            //                    id: animator
            //                    target: welcomeLabel;
            //                    from: 1
            //                    to: 0
            //                    running: false
            //                    duration: 2000
            //                }
            //                anchors.centerIn: parent
            //                font: Qt.font({ pixelSize: 38, family: Def.standardizedFontFamily()})
            //            }
        }

    }
    Rectangle {
        id: blockScreen
        property bool blackScreen: false
        anchors.fill: parent
        color: "black"
        opacity: 1
        visible: false
        Component {
            id: keypadPage
            ConfirmDigit {
                onCorrectPass: {
                    iconGetOut.visible = true
                    //                    animator.start()
                    stackView.pop();
                    //root.getWeather()
                    speech.say(root.hours, root.kindOfWeather)
                }
                onNoPass: {
                    btTimer.start();
                    blockScreen.visible = true
                }
            }
        }

        Row {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 5
            spacing: 10
            Image {
                source: "qrc:/keypad.png"
                height: Screen.pixelDensity*14
                width: Screen.pixelDensity*13
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        btModel.running = false;
                        btTimer.stop();

                        stackView.push(keypadPage)
                        blockScreen.visible = false
                    }
                }
            }
            Image {
                source: "qrc:/addUser.png"
                height: Def.standardizedSizeIcon()
                width: Def.standardizedSizeIcon()
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        btModel.running = false;
                        btTimer.stop();

                        stackView.push(introduction)
                        blockScreen.visible = false
                    }
                }
            }
            Image {
                id: update
                height: Def.standardizedSizeIcon()
                width: Def.standardizedSizeIcon()
                source: "qrc:/update.png"
                visible: false

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        btModel.running = false;
                        btTimer.stop();
                        stackView.push(Qt.resolvedUrl("UpdatePage.qml"),{commit:controller.commit})
                        //                        updatePage.commit = "cor,tamanho,fonte"//controller.commit
                        blockScreen.visible = false
                    }
                }
            }
            //            Button {
            //                id: update
            //                text: "test"
            //                onClicked: {
            //                    btModel.running = false;
            //                    btTimer.stop();
            //                    stackView.push(Qt.resolvedUrl("UpdatePage.qml"),{commit:controller.commit})
            ////                        updatePage.commit = "cor,tamanho,fonte"//controller.commit
            //                    blockScreen.visible = false
            //                }
            //            }
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

}

