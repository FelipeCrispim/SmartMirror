import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

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
//    RowLayout {
//        //                    anchors.fill: parent
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: parent.top
//        //        anchors.bottomMargin: 35
//        spacing: 20
//        Repeater {
//            model: 3
//            Rectangle {
//                height: 10
//                width: 10
//                radius: height/2
//            }
//        }
//    }
    SwipeView {
        id: swipeView
        anchors.fill: parent
        //            currentIndex: tabBar.currentIndex
        //        Timer {
        //            interval: 1500; running: true; repeat: false
        //            onTriggered: swipeView.currentIndex += 1
        //        }
        Item {

            GridView {
                id: gridButton
                model: ["7", "8", "9", "4", "5", "6", "1", "2", "3", "", "0", ""]
                height: 400
                width: 300
                anchors.centerIn: parent
                cellWidth: 100; cellHeight: 100

                delegate:  Button {
                    id: digitButton
                    width: 80; height: 80
                    visible: modelData != ""? true : false
                    text: modelData
                    highlighted: false
                    onClicked: {
                        if (digitButton.highlighted == false) {
                            digitButton.highlighted = true
                            backgroundButton.color = Qt.rgba(0.9,0.9,0.9,0.6)
                        } else {
                            digitButton.highlighted = false
                            backgroundButton.color = Qt.rgba(0.1,0.1,0.1,0.85)
                        }

                    }
                    font: Qt.font({ family: "Serif", pointSize: 24, weight: Font.Bold })
                    background: Rectangle {
                        id: backgroundButton

                        color: Qt.rgba(0.1,0.1,0.1,0.85)
                        radius: height/2
                        border.width: 2
                        border.color: "white"
                    }

                }
            }
        }

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
