import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Item {
    id: rect
    signal finishedSignup()
    Timer {
        id: timer
        interval: 1000; running: false; repeat: false;
        onTriggered: {
            stackView.pop();
        }
    }

    Component {
        id: settingsBluettoth
        SettingsBluettoth {
            onAdvanceSwipeView: {
                bluetoothManager.registering(false);
                swipeView.currentIndex += 1
                finishedSignup()
                timer.start()
            }
        }
    }

    Component {
        id: settingsDigit
        SettingsDigit {
            onAdvanceSwipeView: {
                swipeView.currentIndex += 1
            }
        }
    }

    Label {
        bottomPadding: 5
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font: Qt.font({ pixelSize: 30, family: "Serif", weight: Font.Bold })
        text: {
            if(swipeView.currentIndex == 0)
                "Defina um tipo de desbloqueio"
            else if(swipeView.currentIndex == 1)
                "Conecnte-nos ao seu wifi"
            else
                "Forneça seu usuário do twitter"
        }
    }
    Image {
        id: logo
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
            Row {
                anchors.centerIn: parent
                spacing: 10
                Button {
                    text: "Bluetooth"
                    font: Qt.font({ pixelSize: 30, family: "Serif", weight: Font.Bold })
                    height: 100
                    width: 200
                    onClicked: {
                        bluetoothManager.registering(true);
                        stackView.push(settingsBluettoth)
                    }
                }
                Button {
                    text: "3 dígitos"
                    font: Qt.font({ pixelSize: 30, family: "Serif", weight: Font.Bold })
                    height: 100
                    width: 200
                    onClicked: {
                        stackView.push(settingsDigit)
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
                    onAccepted: {
                        Qt.inputMethod.show();

                    }
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
//            anchors.fill: parent
                Rectangle {
                    anchors.centerIn: parent
                    color: "transparent"
                    border.color: "white"
                    radius: 2
                    height: 100
                    width: root.width/2
                    TextInput {
                        anchors.fill: parent
                        verticalAlignment: TextInput.AlignVCenter
                        leftPadding: 5
                        color: "white"
                        font: Qt.font({pixelSize: 30, family: "Serif"})
                    }
                }

        }
    }
}
