#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QSettings>

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = nullptr);
    Q_INVOKABLE bool setNewUser(QString info);
    Q_INVOKABLE bool isThereUser(QString user);
    Q_INVOKABLE bool firstTimeApp();
private:
    QSettings m_settings;

signals:

public slots:
};

#endif // CONTROLLER_H
