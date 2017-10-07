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
//    if(m_device.contains("00:A0:C6:A1:7B:C9")) {
//        qDebug() << "stopped";
//        m_discoveryAgent->stop();
//        startDiscovery();
//    }
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
