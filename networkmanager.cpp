#include "networkmanager.h"
#include <QNetworkInterface>
#include <QDebug>

NetworkManager::NetworkManager(QObject *parent) : QObject(parent)
{
    nwkMgr.updateConfigurations();
    connect(&nwkMgr, SIGNAL(updateCompleted()), this, SLOT(onNetworkUpdateCompleted()));


}

void NetworkManager::onNetworkUpdateCompleted()
{
    QList<QNetworkConfiguration> nwkCnfList = nwkMgr.allConfigurations();
    QStringList tempList;
    for(const QNetworkConfiguration &ncnf : nwkCnfList)
    {
        if (ncnf.bearerType() == QNetworkConfiguration::BearerWLAN)
        {
           tempList.append(ncnf.name());
//           qDebug() << "WiFi:" << ncnf.name();
        }
    }
//    qDebug() << __func__ << ": Setando comboBox";
//    nwkMgr = NULL;
    setComboList(tempList);
}

void NetworkManager::setComboList(const QStringList &comboList)
{
    m_comboList.clear();
    m_comboList.append(comboList);
    emit comboListChanged();
}

QStringList NetworkManager::comboList() const
{
    return m_comboList;
}
