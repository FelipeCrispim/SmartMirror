#include "controller.h"
#include <QDebug>
#include <QTimer>
#include <QProcess>
#include <QDir>
#include "speech.h"

QString pathToProject = "/Users/felipecrispim/smartmirror2";
QString lastVersionInGit; //Versao no repositorio
QTimer *timerGit;

Controller::Controller(QObject *parent) : QObject(parent)
{
    timerGit = new QTimer(this);
    connect(timerGit, SIGNAL(timeout()), this, SLOT(onCheckGitVersion()));
    timerGit->start(10000);

//    m_settings.clear();
//    m_settings.setValue("123", "123");
    if(!m_settings.contains("firstTime")){
        m_settings.setValue("firstTime", true);

        QFile f(QDir::homePath()+"/test.txt");

        QString command = "cd "+pathToProject+" && git show --name-only >"+QDir::homePath()+"/test.txt";
        system(command.toLatin1());
        f.open(QFile::ReadOnly | QFile::Text);
        QTextStream in(&f);
        //in.readAll().remove("    ").split("\n").at(4);
        m_settings.setValue("gitVersion", in.readAll().split("\n").at(0).split(" ").at(1));
        Speech speech;
        speech.sayWelcome();
        qDebug() << "welcome";
    } else {
        m_settings.setValue("firstTime", false);
    }
    lastVersionInGit = m_settings.value("gitVersion").toString();
}

bool Controller::setNewUser(QString info)
{
    m_settings.setValue(info, info);
    return true;
}

bool Controller::isThereUser(QString user)
{
    return m_settings.contains(user);
}

bool Controller::firstTimeApp()
{
    //returns if it's first time that the app is open
    return m_settings.value("firstTime").toBool();
}

void Controller::onCheckGitVersion()
{
    QString command = "cd "+pathToProject+" && git show --name-only >"+QDir::tempPath()+"/tempSmartMirror.txt";
    system(command.toLatin1());
    QFile f(QDir::tempPath()+"/tempSmartMirror.txt");
    f.open(QFile::ReadOnly | QFile::Text);
    QTextStream in(&f);
    QString version = in.readAll();

//    qDebug() << version.split("\n").at(0).split(" ").at(1);
    f.close();
    if(version.split("\n").at(0).split(" ").at(1) != m_settings.value("gitVersion").toString()){
        emit hasUpdate(version.remove("    ").split("\n").at(4));
//        lastVersionInGit.clear();
//        lastVersionInGit = version.split("\n").at(0).split(" ").at(1);
        qDebug() << "different version git";
        timerGit->stop();
    } else {
        qDebug() << __func__ << "same version git";
    }
}

void Controller::updateApp()
{
    QString command = "cd "+pathToProject+" && git pull && " +
            "cd .. && cp -r smartmirror2 "+QDir::tempPath()+" && "
            "cd "+QDir::tempPath()+"/smartmirror2 && qmake && make && cp smartmirror2 /usr/bin && reboot";
    system(command.toLatin1());

    command = "cd "+pathToProject+" && git show --name-only >"+QDir::tempPath()+"/tempSmartMirror.txt";
    system(command.toLatin1());
    QFile f(QDir::tempPath()+"/tempSmartMirror.txt");
    f.open(QFile::ReadOnly | QFile::Text);
    QTextStream in(&f);
    QString version = in.readAll();

    m_settings.setValue("gitVersion", version.split("\n").at(0).split(" ").at(1));
    m_settings.sync();
    timerGit->start();
}
