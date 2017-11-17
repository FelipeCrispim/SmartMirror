#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include "networkmanager.h"
#include "bluetoothmanager.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    NetworkManager wifi;
    BluetoothManager bluetooth;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("networkManager", &wifi);
    engine.rootContext()->setContextProperty("bluetoothManager", &bluetooth);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    wifi.isOnline();
    return app.exec();
}
