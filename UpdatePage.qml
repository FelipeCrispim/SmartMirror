import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "Definitions.js" as Def
//import Controller 1.0
import QtQuick.Window 2.2

Item {
    id: login
    property string commit: ""
    property int labelPixelSize: Screen.pixelDensity*10
    onCommitChanged: {
        var commits = login.commit.split(",")
        for(var i = 0; i<login.commit.split(",").length; i++){
            labelCommit.text += "\n" + commits[i].trim()
        }
    }

    signal correctPass()
    signal noPass()
    property var confirmPassword: new Array
    property alias text: labelBot.text

//    Controller{
//        id: controller
//    }

    Button {
        id: updateButton
        text: "Atualizar"
        anchors.centerIn: parent
        font: Qt.font({ pixelSize: 30, family: Def.standardizedFontFamily(), weight: Font.Bold })
        height: Screen.pixelDensity*41
        width: Screen.pixelDensity*68
        onClicked: {
            timer.start()
            updateButton.visible = false
            labelBot.visible = false
            labelCommit.visible = false
            back.visible = false
            rowCenter.visible = true
        }
    }
    Timer {
        id: timer
        interval: 1000; running: false; repeat: false;
        onTriggered: {controller.updateApp(); console.log("Atualizando")}
    }

    Row {
        id: rowCenter
        visible: false
        anchors.centerIn: parent
        spacing: 10
        Label {
            text: "Atualizando... "
            font: Qt.font({ pixelSize: login.labelPixelSize-1, family: Def.standardizedFontFamily(), weight: Font.Bold })
        }
        BusyIndicator {
            anchors.verticalCenter: parent.verticalCenter
            height: login.labelPixelSize-1
            width: login.labelPixelSize-1
        }
    }

    Label {
        id: labelBot
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: labelCommit.top
        bottomPadding: -22
        text: root.progressUpdate//"Essa atualização inclui:"
        font: Qt.font({ pixelSize: login.labelPixelSize-1, family: Def.standardizedFontFamily(), weight: Font.Bold })
    }
    Label {
        id: labelCommit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        bottomPadding: 5
        text: ""
        font: Qt.font({ pixelSize: login.labelPixelSize-1, family: Def.standardizedFontFamily(), weight: Font.Bold })
    }
    Image {
        id: back
        source: "qrc:/back.png"
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: Def.standardizedSizeIcon()
        height: Def.standardizedSizeIcon()
        MouseArea {
            anchors.fill: parent
            onClicked: {
                blockScreen.visible = true
                stackView.pop()
            }
        }
    }
}
