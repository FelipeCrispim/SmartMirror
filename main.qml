import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtPositioning 5.3

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 480
    title: qsTr("Hello World")

    PositionSource {
        id: coord
    }
    Component.onCompleted: getData()
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
                width: root.width/2
                Label {
                    text: "Sexta, 28"
                    font.pixelSize: 32
                }

                Label {
                    id: clock
                    property int hours
                    property int minutes
                    property int seconds
                    function timeChanged() {
                        var date = new Date;
                        hours = date.getHours()
                        minutes = date.getMinutes()
                        seconds = date.getUTCSeconds();
                    }
                    Timer {
                        interval: 1000; running: true; repeat: true;
                        onTriggered: clock.timeChanged()
                    }
                    text: {
                        if ((clock.seconds & 1) == 0)
                            hours+":"+minutes
                        else
                            hours+" "+minutes
                    }
                    font.pixelSize: 60
                    font.bold: true
                }
                Label {
                    property string goal1: "Caminhar para o trabalho"
                    text: goal1
                    font.bold: true
                    topPadding: 30
                    font.pixelSize: 15
                }
                Label {
                    text: "07:00 - 07:30"
                    font.pixelSize: 14
                }
                Label {
                    property string goal1: "Tomar remédio"
                    text: goal1
                    font.bold: true
                    topPadding: 10
                    font.pixelSize: 15
                }
                Label {
                    text: "09:00"
                    font.pixelSize: 14
                }
                Label {
                    property string goal1: "Reunião via Skype"
                    text: goal1
                    font.bold: true
                    topPadding: 10
                    font.pixelSize: 15
                }
                Label {
                    text: "11:00 - 12:00"
                    font.pixelSize: 14
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
                Component.onCompleted: stackView.push(Qt.resolvedUrl("Introduction.qml"))
    }

}
