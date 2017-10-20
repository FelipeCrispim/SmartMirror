#include "bluetoothmanager.h"
#include <qbluetoothaddress.h>
#include <QBluetoothLocalDevice>
#include <QDebug>

BluetoothManager::BluetoothManager(QObject *parent) : QObject(parent)
{
//    QBluetoothLocalDevice localDevice;
    // Turn Bluetooth on
//    localDevice.powerOn();

    m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);


    connect(m_discoveryAgent, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this, SLOT(deviceDiscovered(QBluetoothDeviceInfo)));
    connect(m_discoveryAgent, SIGNAL(finished()), this, SLOT(discoveryFinished()));

    startDiscovery();
}

BluetoothManager::~BluetoothManager()
{
    delete m_discoveryAgent;
}

void BluetoothManager::startDiscovery()
{
    qDebug() << "scanning";
    m_discoveryAgent->start();
}

void BluetoothManager::deviceDiscovered(const QBluetoothDeviceInfo &deviceInfo)
{
    m_device.clear();
    m_device = deviceInfo.address().toString();
    emit deviceBluetoothChanged();
    if(m_device.contains("00:A0:C6:24:16:30")) {
        connectDevice(deviceInfo);
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
