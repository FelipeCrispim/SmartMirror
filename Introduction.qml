import QtQuick 2.7
import QtQuick.Controls 2.0

BackgroundSwirls {
    id: rect
    //    width: 100; height: 100
    //    anchors.fill: parent
    Image {
        source: "qrc:/logo.png"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 50
        width: 50
    }
    SwipeView {
        id: swipeView
        anchors.fill: parent
        //            currentIndex: tabBar.currentIndex
        //        Timer {
        //            interval: 1500; running: true; repeat: false
        //            onTriggered: swipeView.currentIndex += 1
        //        }

        Item {
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
                    onClicked: {
                        stackView.pop();
                        //swipeView.currentIndex += 1
                    }
                }
            }
        }
        Item {
            Column {
                anchors.centerIn: parent
                spacing: 15
                Label {
                    text: "Configure sua rede social"
                    font.weight: Font.Bold
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextField {
                    placeholderText: qsTr("Rede")
                    width: root.width/2
                }
                TextField {
                    placeholderText: qsTr("Senha da rede")
                    width: root.width/2
                }
                Button {
                    text: "Entrar"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        stackView.pop();
                        //swipeView.currentIndex += 1
                    }
                }
            }
        }
    }
}
