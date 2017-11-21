#include "controller.h"
#include <QDebug>
#include <QTimer>
#include <QProcess>
#include <QDir>

QString pathToProject = "/Users/felipecrispim/dev/Qt-workspace/smart_mirror";
QString lastVersionInGit; //Versao no repositorio

Controller::Controller(QObject *parent) : QObject(parent)
{
    QTimer *timerGit = new QTimer(this);
    connect(timerGit, SIGNAL(timeout()), this, SLOT(onCheckGitVersion()));
    timerGit->start(10000);

    if(!m_settings.contains("firstTime")){
        m_settings.setValue("firstTime", true);

        QString command = "cd "+pathToProject+" && git show --name-only >"+QDir::homePath()+"/test.txt";
        system(command.toLatin1());
        QFile f(QDir::homePath()+"/test.txt");
        f.open(QFile::ReadOnly | QFile::Text);
        QTextStream in(&f);
        //in.readAll().remove("    ").split("\n").at(4);
        m_settings.setValue("gitVersion", in.readAll().split("\n").at(0).split(" ").at(1));
    }
    lastVersionInGit = m_settings.value("gitVersion").toString();
    qDebug() << QDir::tempPath();
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
    return !m_settings.contains("firstTime");
}

void Controller::onCheckGitVersion()
{
    QString command = "cd "+pathToProject+" && git show --name-only >"+QDir::tempPath()+"/tempSmartMirror.txt";
    system(command.toLatin1());
    QFile f(QDir::tempPath()+"/tempSmartMirror.txt");
    f.open(QFile::ReadOnly | QFile::Text);
    QTextStream in(&f);

    if(in.readAll().split("\n").at(0).split(" ").at(1) != m_settings.value("gitVersion").toString()){
        emit hasUpdate(in.readAll().remove("    ").split("\n").at(4));
        lastVersionInGit = in.readAll().split("\n").at(0).split(" ").at(1);
    } else {
        qDebug() << __func__ << "same version git";
    }
}

void Controller::updateApp()
{
    QString command = "cd "+pathToProject+" && git pull && " +
            "cd .. && cp -r smart_mirror "+QDir::tempPath()+" && "
            "cd "+QDir::tempPath()+"/smart_mirror && qmake && make";
    system(command.toLatin1());
    qDebug() << "Terminou a atualização";
    m_settings.setValue("gitVersion", lastVersionInGit);
}
