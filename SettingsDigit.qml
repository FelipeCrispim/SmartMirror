import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "Definitions.js" as Def
import QtBluetooth 5.2
import QtQuick.Window 2.2

Item {
    id: login
    signal advanceSwipeView(var user)
    property var password: new Array
    property var confirmPassword: new Array
    property alias text: labelBot.text
    property int labelPixelSize: Screen.pixelDensity*10
//    Component.onCompleted: console.log((login.width*0.15)*0.25)

    SequentialAnimation {
        id: animation
        NumberAnimation { target: login; property: "x"; to: 20; duration: 100 }
        NumberAnimation { target: login; property: "x"; to: -20; duration: 50 }
        NumberAnimation { target: login; property: "x"; to: 0; duration: 100 }
        onStopped: {
            login.confirmPassword[0].highlighted = false
            login.confirmPassword[1].highlighted = false
            login.confirmPassword[2].highlighted = false
            login.password = []
            login.confirmPassword = []
            login.enabled = true
        }
    }
    function analysePassword(){
        login.enabled = false
        if(login.password[0].text === login.confirmPassword[0].text &&
                login.password[1].text === login.confirmPassword[1].text &&
                login.password[2].text === login.confirmPassword[2].text) {
            advanceSwipeView(login.password[0].text+","+login.password[1].text+","+login.password[2].text)

        } else {
            animation.running = true
            labelBot.text = "Senhas não conferem, digite-as novamente"
            gridButton.confirming  =false
        }
    }

    GridView {
        id: gridButton
        property bool confirming: false
        model: ["7", "8", "9", "4", "5", "6", "1", "2", "3", "", "0", ""]
        height: Screen.pixelDensity*128
        width: Screen.pixelDensity*102
        anchors.centerIn: parent
        cellWidth: Screen.pixelDensity*32; cellHeight: Screen.pixelDensity*32
        interactive: false

        delegate:  Button {
            id: digitButton

            width: Screen.pixelDensity*24; height: Screen.pixelDensity*24
            visible: modelData != ""? true : false
            text: modelData
            highlighted: false
            onClicked: {
                if (digitButton.highlighted == false) {
                    digitButton.highlighted = true

                    if(gridButton.confirming == false){
                        login.password.push(digitButton)
                        if(login.password.length == 3) {
                            gridButton.confirming = true
                            labelBot.text = "Por favor, confirme sua senha"
                            login.password[0].highlighted = false
                            login.password[1].highlighted = false
                            login.password[2].highlighted = false
                            login.enabled = true
                        }
                    } else {
                        login.confirmPassword.push(digitButton)
                        if(login.confirmPassword.length == 3) {
                            login.analysePassword()
                        }
                    }
                }
                else {
                    for(var i = login.password.length - 1; i >= 0; i--) {
                        if(login.password[i] === digitButton) {
                            login.password.splice(i, 1);
                        }
                    }
                    digitButton.highlighted = false
                }
            }
            font: Qt.font({ family: "Serif", pointSize: login.labelPixelSize*0.9, weight: Font.Bold })
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
        text: "Digite 3 dígitos"
        font: Qt.font({ pixelSize: login.labelPixelSize-1, family: Def.standardizedFontFamily(), weight: Font.Bold })
    }
    Image {
        source: "qrc:/back.png"
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: Def.standardizedSizeIcon()
        height: Def.standardizedSizeIcon()
        MouseArea {
            anchors.fill: parent
            onClicked: {
                stackView.pop()
            }
        }
    }
}
