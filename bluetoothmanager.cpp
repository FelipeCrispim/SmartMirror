#include "bluetoothmanager.h"
#include <qbluetoothaddress.h>
#include <QBluetoothLocalDevice>
#include <QDebug>
#include <QTimer>

bool deviceFound = false;
BluetoothManager::BluetoothManager(QObject *parent) : QObject(parent)
{
    //    QBluetoothLocalDevice localDevice;
    // Turn Bluetooth on
    //    localDevice.powerOn();

//    m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);


//    connect(m_discoveryAgent, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
//            this, SLOT(deviceDiscovered(QBluetoothDeviceInfo)));
//    connect(m_discoveryAgent, SIGNAL(finished()), this, SLOT(discoveryFinished()));
//    connect(m_discoveryAgent, SIGNAL(canceled()), this, SLOT(scanCanceled()));

//    startDiscovery();

//    QTimer *timer = new QTimer(this);
//    connect(timer, SIGNAL(timeout()), this, SLOT(update()));
//    timer->start(5000);
}

BluetoothManager::~BluetoothManager()
{
    delete m_discoveryAgent;
}

void BluetoothManager::update()
{

    m_discoveryAgent->stop();
    if(deviceFound == false) {
        m_device.clear();
        m_device = "notFound";
        emit deviceBluetoothChanged();
    }
    deviceFound = false;
    m_discoveryAgent->start();

}

void BluetoothManager::startDiscovery()
{
    qDebug() << "scanning";
    m_discoveryAgent->start();
}

void BluetoothManager::scanCanceled()
{
    //    qDebug() << "deviceCanceled";


}

void BluetoothManager::deviceDiscovered(const QBluetoothDeviceInfo &deviceInfo)
{

    if(deviceInfo.address().toString().contains("00:A0:C6:24:16:30")) {
        qDebug() << "foi";
        deviceFound = true;
        m_device.clear();
        m_device = deviceInfo.address().toString();
        emit deviceBluetoothChanged();
    }

        qDebug() << "Found new device:" << deviceInfo.name() << ", rssi:" << deviceInfo.address().toString();
}


QString BluetoothManager::deviceBluetooth() const
{
    return m_device;
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
