import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "Definitions.js" as Def
import Controller 1.0

Item {
    id: login
    signal correctPass()
    signal noPass()
    property var confirmPassword: new Array
    property alias text: labelBot.text

    Controller{
        id: controller
    }

    SequentialAnimation {
        id: animation
        NumberAnimation { target: login; property: "x"; to: 20; duration: 100 }
        NumberAnimation { target: login; property: "x"; to: -20; duration: 50 }
        NumberAnimation { target: login; property: "x"; to: 0; duration: 100 }
        onStopped: {
            login.confirmPassword[0].highlighted = false
            login.confirmPassword[1].highlighted = false
            login.confirmPassword[2].highlighted = false
            login.confirmPassword = []
            login.enabled = true
        }
    }
    function analysePassword(){
        login.enabled = false
        if(controller.isThereUser(login.confirmPassword[0].text+","+
                                  login.confirmPassword[1].text+","+
                                  login.confirmPassword[2].text)){
            correctPass();
        } else {
            animation.running = true
            labelBot.text = "Senha errada, digite-a novamente"
        }
    }

    GridView {
        id: gridButton
        model: ["7", "8", "9", "4", "5", "6", "1", "2", "3", "", "0", ""]
        height: 400
        width: 300
        anchors.centerIn: parent
        cellWidth: 100; cellHeight: 100
        interactive: false

        delegate:  Button {
            id: digitButton

            width: 80; height: 80
            visible: modelData != ""? true : false
            text: modelData
            highlighted: false
            onClicked: {
                if (digitButton.highlighted == false) {
                    digitButton.highlighted = true
                    login.confirmPassword.push(digitButton)
                    if(login.confirmPassword.length == 3) {
                        login.analysePassword()
                    }

                }
                else {
                    for(var i = login.confirmPassword.length - 1; i >= 0; i--) {
                        if(login.confirmPassword[i] === digitButton) {
                            login.confirmPassword.splice(i, 1);
                        }
                    }
                    digitButton.highlighted = false
                }
            }
            font: Qt.font({ family: "Serif", pointSize: 24, weight: Font.Bold })
            background: Rectangle {
                id: backgroundButton

                color: digitButton.highlighted? Qt.rgba(0.9,0.9,0.9,0.6) : Qt.rgba(0.1,0.1,0.1,0.85)
                radius: height/2
                border.width: 2
                border.color: "white"
            }

        }
    }
    Label {
        id: labelBot
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        bottomPadding: 5
        text: "Digite sua senha"
        font: Qt.font({ pixelSize: 30, family: Def.standardizedFontFamily(), weight: Font.Bold })
    }
    Image {
        source: "qrc:/back.png"
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 50
        height: 50
        MouseArea {
            anchors.fill: parent
            onClicked: {
                noPass()
                stackView.pop()
            }
        }
    }
}
