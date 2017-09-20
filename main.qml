import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    Rectangle {
        anchors.fill: parent
        Component.onCompleted: {
            var component = Qt.createComponent("Introduction.qml");
            component.createObject(root);
        }

    }
}
