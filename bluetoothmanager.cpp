#include "bluetoothmanager.h"
#include <qbluetoothaddress.h>
#include <QBluetoothLocalDevice>
#include <QDebug>
#include <QTimer>
#include <QSettings>

bool deviceFound = false;
QString settings;
QTimer *timer;
bool signUp = true;

BluetoothManager::BluetoothManager(QObject *parent) : QObject(parent)
{
    //    QBluetoothLocalDevice localDevice;
    // Turn Bluetooth on
    //    localDevice.powerOn();

    m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);


    connect(m_discoveryAgent, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this, SLOT(deviceDiscovered(QBluetoothDeviceInfo)));
    connect(m_discoveryAgent, SIGNAL(finished()), this, SLOT(discoveryFinished()));
    connect(m_discoveryAgent, SIGNAL(canceled()), this, SLOT(scanCanceled()));

//    startDiscovery();

    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(update()));


    m_devicesList.clear();
}

BluetoothManager::~BluetoothManager()
{
    delete m_discoveryAgent;
}

void BluetoothManager::update()
{
    m_discoveryAgent->stop();
//    if(deviceFound == false && signUp == false) {
//        m_device.clear();
//        m_device = "notFound";
//        emit deviceBluetoothChanged();
//    }
//    deviceFound = false;
    qDebug() << "star/stop";
    m_discoveryAgent->start();

}

void BluetoothManager::startDiscovery()
{
    qDebug() << "scanning";
    m_discoveryAgent->start();
//    timer->start(5000);
}

void BluetoothManager::setDevice(QString address)
{
    deviceFound = true;
    m_device.clear();
    m_device = address;
    emit deviceBluetoothChanged();
    settings = address;

    m_discoveryAgent->stop();
    timer->stop();
}

QString BluetoothManager::getDevice()
{
    return settings;
}

void BluetoothManager::registering(bool flag)
{
    signUp = flag;
}

void BluetoothManager::scanCanceled()
{
    //    qDebug() << "deviceCanceled";


}

void BluetoothManager::deviceDiscovered(const QBluetoothDeviceInfo &deviceInfo)
{

//    if(deviceInfo.address().toString() == settings && signUp == false) {
//        deviceFound = true;
//        m_device.clear();
//        m_device = deviceInfo.address().toString();
//        emit deviceBluetoothChanged();
//    }
    qDebug() << "detected";
//        qDebug() << "Found new device:" << deviceInfo.name() << ", rssi:" << deviceInfo.address().toString();
    if(!m_devicesList.contains(deviceInfo.name()) && signUp == true){
        m_devicesList.append("{\"name\":\""+deviceInfo.name()+"\",\"address\":\""+deviceInfo.address().toString()+"\"}");
        emit devicesListChanged();
    }
}


QString BluetoothManager::deviceBluetooth() const
{
    return m_device;
}

QStringList BluetoothManager::devicesList()
{
    return m_devicesList;
}

void BluetoothManager::discoveryFinished()
{
    qDebug() << __func__;
    startDiscovery();
}

void BluetoothManager::connectDevice(const QBluetoothDeviceInfo device)
{
    qDebug()<<"connecting device";
    m_controller = 0;
    m_controller = new QLowEnergyController(QBluetoothAddress("00:A0:C6:24:16:30"), this);

    //    connect(m_controller, SIGNAL(connected()), this, SLOT(deviceConnected()));
    //    connect(m_controller, SIGNAL(disconnected()), this, SLOT(deviceDisconnected()));
    //    m_controller->connectToDevice();
}

void BluetoothManager::deviceConnected()
{
    qDebug()<<"Dispositivo conectado";
}

void BluetoothManager::deviceDisconnected()
{
    qDebug()<<"Dispositivo desconectado";
}
