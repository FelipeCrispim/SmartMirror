import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 480
    title: qsTr("Hello World")
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
                    text: "Sexta, 21"
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
                        if ((clock.seconds % 2) == 0)
                            hours+":"+minutes
                        else
                            hours+" "+minutes
                    }
                    font.pixelSize: 60
                    font.bold: true
                    Component.onCompleted: {
                        if ((clock.seconds % 2) == 0)
                            clock.text[2] = ' ';
                    }
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
                        width: 75
                        height: 54
                        AnimatedImage {
                            source: "qrc:/giphy.gif"
                            anchors.fill: parent
                            width: 20
                        }
                    }
                    Label {
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
