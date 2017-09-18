#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include "networkmanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    NetworkManager wifi;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("networkManager", &wifi);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));


    return app.exec();
}
