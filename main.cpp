#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include "networkmanager.h"
#include "bluetoothmanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    NetworkManager wifi;
    BluetoothManager bluetooth;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("networkManager", &wifi);
    engine.rootContext()->setContextProperty("bluetoothManager", &bluetooth);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));


    return app.exec();
}
