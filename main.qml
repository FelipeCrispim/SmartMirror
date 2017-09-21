import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    StackView {
        id: stackView

        focus: true
        anchors.fill: parent

        initialItem: Item {
            id: topItem
            Label {
                text: "Tela principal"
                anchors.centerIn: parent
            }
        }
        Component.onCompleted: stackView.push(Qt.resolvedUrl("Introduction.qml"))
    }

}
