import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle {
    id: rect
    width: 100; height: 100
    anchors.fill: parent

    SwipeView {
        id: swipeView
        anchors.fill: parent
        //            currentIndex: tabBar.currentIndex
        //        Timer {
        //            interval: 1500; running: true; repeat: false
        //            onTriggered: swipeView.currentIndex += 1
        //        }

        Page {
            BackgroundSwirls { }
            Column {
                anchors.centerIn: parent
                spacing: 15
                Label {
                    text: "Selecione sua rede"
                    font.weight: Font.Bold
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ComboBox {
                    id: wifiComboBox
                    objectName: "wifiComboBox"
                    model: networkManager.comboList
                    width: root.width/2
                }
                TextField {
                    id: textField1
                    placeholderText: qsTr("Senha da rede")
                    width: root.width/2
                }
                Button {
                    text: "Conectar"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: rect.destroy();//swipeView.currentIndex += 1
                }
            }
        }
        Page {
            Image {
                id: logo
                source: "qrc:/logo.png"
                anchors.centerIn: parent
                height: 250
                width: 250
                //                Component.onCompleted: bouncebehavior.start()

                //                NumberAnimation on x { to: 50; duration: 1000 }
            }
        }
    }
}
