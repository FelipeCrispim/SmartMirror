#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
//#include "networkmanager.h"
#include "controller.h"
#include "bluetoothmanager.h"
#include "speech.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

//    NetworkManager wifi;
    BluetoothManager bluetooth;
//    Process myProcess;
    Speech speech;


    QQmlApplicationEngine engine;
//    engine.rootContext()->setContextProperty("networkManager", &wifi);
//    engine.rootContext()->setContextProperty("bluetoothManager", &bluetooth);
    engine.rootContext()->setContextProperty("speech", &speech);
    qmlRegisterType<Controller>("Controller", 1, 0, "Controller");
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
//    wifi.isOnline();
    return app.exec();
}
