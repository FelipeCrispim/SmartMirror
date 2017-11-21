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
    Q_INVOKABLE void updateApp();

private:
    QSettings m_settings;

signals:
    void hasUpdate(QString commit);

public slots:
    void onCheckGitVersion();
};

#endif // CONTROLLER_H
