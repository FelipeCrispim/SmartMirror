#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include "networkmanager.h"
#include "process.h"
#include "controller.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    NetworkManager wifi;
//    BluetoothManager bluetooth;
    Process myProcess;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("networkManager", &wifi);
//    engine.rootContext()->setContextProperty("bluetoothManager", &bluetooth);
    qmlRegisterType<Process>("Process", 1, 0, "Process");
    qmlRegisterType<Controller>("Controller", 1, 0, "Controller");
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    wifi.isOnline();
    return app.exec();
}
