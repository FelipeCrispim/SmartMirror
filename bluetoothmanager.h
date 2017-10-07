#ifndef BLUETOOTHMANAGER_H
#define BLUETOOTHMANAGER_H

#include <QObject>
#include <qbluetoothuuid.h>
#include <qbluetoothdeviceinfo.h>
#include <qbluetoothdevicediscoveryagent.h>

class BluetoothManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString deviceBluetooth READ deviceBluetooth NOTIFY deviceBluetoothChanged)

public:
    explicit BluetoothManager(QObject *parent = 0);
    void startDiscovery();
    void stopDiscovery();
    QString deviceBluetooth() const;

private:
    QBluetoothDeviceDiscoveryAgent *m_discoveryAgent;
    QString m_device;
//    QMap<QListWidgetItem *, QBluetoothServiceInfo> m_discoveredServices;

signals:
    void deviceBluetoothChanged();

private slots:
    void deviceDiscovered(const QBluetoothDeviceInfo &serviceInfo);
    void discoveryFinished();
};

#endif // BLUETOOTHMANAGER_H
