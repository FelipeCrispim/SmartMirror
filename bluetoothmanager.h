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
    Q_PROPERTY(QStringList devicesList READ devicesList NOTIFY devicesListChanged)

public:
    explicit BluetoothManager(QObject *parent = 0);
    ~BluetoothManager();
    Q_INVOKABLE void startDiscovery();
    Q_INVOKABLE void setDevice(QString address);
    Q_INVOKABLE QString getDevice();
    Q_INVOKABLE void registering(bool flag);
    void stopDiscovery();
    QString deviceBluetooth() const;
    QStringList devicesList();
    void connectDevice(const QBluetoothDeviceInfo device);
    QStringList m_devicesList;
private:
    QBluetoothDeviceDiscoveryAgent *m_discoveryAgent;
    QString m_device;
    QBluetoothLocalDevice localDevice;
    QLowEnergyController *m_controller;

signals:
    void deviceBluetoothChanged();
    void devicesListChanged();

public slots:
    void deviceDiscovered(const QBluetoothDeviceInfo &serviceInfo);
    void discoveryFinished();
    void deviceConnected();
    void deviceDisconnected();
    void update();
    void scanCanceled();

};

#endif // BLUETOOTHMANAGER_H
