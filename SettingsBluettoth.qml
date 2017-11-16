import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "Definitions.js" as Def
import QtBluetooth 5.2

Item {
    id: item
    signal advanceSwipeView()
    Component.onCompleted: bluetoothManager.startDiscovery()
//    property var model: bluetoothManager.devicesList
//    onModelChanged: {
//        if (model[0] === "undefined")
//            console.log("Chegoou")
//    }
    BluetoothDiscoveryModel {
           id: btModel
           running: true
    }
    ListView {

        width: item.width; height: 400
        anchors.horizontalCenter: parent.horizontalCenter

        model: bluetoothManager.devicesList
        delegate: Column{
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 10
            leftPadding: 10
            spacing: 10
            Button {
                text: {
                    var JsonObject = JSON.parse(modelData);
                    return JsonObject.name
                }
                font: Qt.font({ pixelSize: 30, family: Def.standardizedFontFamily(), weight: Font.Bold })
                height: 100
                width: 400
                onClicked: {
                    var JsonObject = JSON.parse(modelData);
                    bluetoothManager.setDevice(JsonObject.address)
                    advanceSwipeView()
                    stackView.pop()
                }
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        bottomPadding: 5
        spacing: 10
        Label {
            text: "Procurando dispositivos"
            font: Qt.font({ pixelSize: 30, family: Def.standardizedFontFamily(), weight: Font.Bold })
        }
        BusyIndicator {
            anchors.verticalCenter: parent.verticalCenter
            height: 30
            width: 30
        }
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
                stackView.pop()
            }
        }
    }
}
