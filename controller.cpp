#include "controller.h"
#include <QDebug>
#include <QTimer>
#include <QProcess>
#include <QDir>

Controller::Controller(QObject *parent) : QObject(parent)
{
    QTimer *timerGit = new QTimer(this);
    connect(timerGit, SIGNAL(timeout()), this, SLOT(onCheckGitVersion()));
    timerGit->start(5000);

    m_settings.clear();
    if(!m_settings.contains("firstTime")){
        m_settings.setValue("firstTime", true);

        QString command = "cd /Users/felipecrispim/dev/Qt-workspace/smart_mirror && git show --name-only >"+QDir::homePath()+"/test.txt";
        system(command.toLatin1());
        QFile f(QDir::homePath()+"/test.txt");
        f.open(QFile::ReadOnly | QFile::Text);
        QTextStream in(&f);
        //in.readAll().remove("    ").split("\n").at(4);
        m_settings.setValue("gitVersion", in.readAll().split("\n").at(0).split(" ").at(1));
    }
}

bool Controller::setNewUser(QString info)
{
    //    if(!m_settings.contains(info)){
    m_settings.setValue(info, info);
    return true;
    //    } else {
    //        return false;
    //    }
}

bool Controller::isThereUser(QString user)
{
    return m_settings.contains(user);
}

bool Controller::firstTimeApp()
{
    //returns if it's first time that the app is open
    //    m_settings.
    return true;//!m_settings.contains("firstTime");
}

void Controller::onCheckGitVersion()
{
    QString command = "cd /Users/felipecrispim/dev/Qt-workspace/smart_mirror && git show --name-only >"+QDir::tempPath()+"/test.txt";
    system(command.toLatin1());
    QFile f(QDir::tempPath()+"/test.txt");
    f.open(QFile::ReadOnly | QFile::Text);
    QTextStream in(&f);

    if(in.readAll().split("\n").at(0).split(" ").at(1) != m_settings.value("gitVersion").toString()){
        emit hasUpdate();
    } else {
        qDebug() << "same version git";
    }
}

void Controller::updateApp()
{
    QString command = "cd /Users/felipecrispim/dev/Qt-workspace/smart_mirror && git pull && qmake && make";
    system(command.toLatin1());
    qDebug() << "terminou";
}
