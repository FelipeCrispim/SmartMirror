#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkConfigurationManager>
#include <QStringList>

class NetworkManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList comboList READ comboList WRITE setComboList NOTIFY comboListChanged)

public:
    explicit NetworkManager(QObject *parent = 0);

    void setComboList(const QStringList &a);
    QStringList comboList() const ;
private:
    QNetworkConfigurationManager nwkMgr;
    QStringList m_comboList;

signals:
    void comboListChanged();
public slots:
    void onNetworkUpdateCompleted();
};

#endif // NETWORKMANAGER_H
