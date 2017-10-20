#ifndef BLUETOOTHMANAGER_H
#define BLUETOOTHMANAGER_H

#include <QObject>
#include <qbluetoothuuid.h>
#include <qbluetoothdeviceinfo.h>
#include <qbluetoothdevicediscoveryagent.h>
#include <qbluetoothlocaldevice.h>
#include <QLowEnergyController>

class BluetoothManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString deviceBluetooth READ deviceBluetooth NOTIFY deviceBluetoothChanged)

public:
    explicit BluetoothManager(QObject *parent = 0);
    ~BluetoothManager();
    void startDiscovery();
    void stopDiscovery();
    QString deviceBluetooth() const;

    void connectDevice(const QBluetoothDeviceInfo device);
private:
    QBluetoothDeviceDiscoveryAgent *m_discoveryAgent;
    QString m_device;
    QBluetoothLocalDevice localDevice;
    QLowEnergyController *m_controller;

signals:
    void deviceBluetoothChanged();

public slots:
    void deviceDiscovered(const QBluetoothDeviceInfo &serviceInfo);
    void discoveryFinished();
    void deviceConnected();
    void deviceDisconnected();
    void update();
    void scanCanceled();

};

#endif // BLUETOOTHMANAGER_H
