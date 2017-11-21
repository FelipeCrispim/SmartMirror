import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "Definitions.js" as Def
import QtBluetooth 5.2
import Controller 1.0

Item {
    id: item
    signal advanceSwipeView(var user)
//    Component.onCompleted: bluetoothManager.startDiscovery()
    //    property var model: bluetoothManager.devicesList
    //    onModelChanged: {
    //        if (model[0] === "undefined")
    //            console.log("Chegoou")
    //    }
    BluetoothDiscoveryModel {
        id: btModelSettings
        property bool savedDeviceFound: true
        running: true
        discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
    }

    Controller {
        id: controller
    }

    ListView {

        width: item.width; height: 400
        anchors.horizontalCenter: parent.horizontalCenter

        model: btModelSettings
        delegate: Column{
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 10
            leftPadding: 10
            spacing: 10
            Button {
                text: deviceName
                font: Qt.font({ pixelSize: 30, family: Def.standardizedFontFamily(), weight: Font.Bold })
                height: 100
                width: 400
                onClicked: {
//                    var JsonObject = JSON.parse(modelData);
//                    bluetoothManager.setDevice(JsonObject.address)

                    advanceSwipeView(remoteAddress)
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
