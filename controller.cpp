#include "controller.h"
#include <QDebug>
#include <QTimer>
#include <QProcess>
#include <QDir>
#include "speech.h"

QString pathToProject = "media/smartmirror2";
QTimer *timerGit;

Controller::Controller(QObject *parent) : QObject(parent)
{
    timerGit = new QTimer(this);
    connect(timerGit, SIGNAL(timeout()), this, SLOT(onCheckGitVersion()));
    timerGit->start(10000);

    //    m_settings.clear();
    //    m_settings.setValue("123", "123");
//    m_settings.setValue("gitVersion", 123);
    if(!m_settings.contains("firstTime")){
        m_settings.setValue("firstTime", true);

//        QFile f(QDir::homePath()+"/test.txt");

//        QString command = "cd "+pathToProject+" && git show --name-only >"+QDir::homePath()+"/test.txt";
//        system(command.toLatin1());
//        f.open(QFile::ReadOnly | QFile::Text);
//        QTextStream in(&f);
//        //in.readAll().remove("    ").split("\n").at(4);
//        m_settings.setValue("gitVersion", in.readAll().split("\n").at(0).split(" ").at(1));
//        system("pip install tweepy");
//        QProcess process;
//        process.start("pip install tweepy");
        system("pip install tweepy");
        Speech speech;
        speech.sayWelcome();
    } else {
        m_settings.setValue("firstTime", false);
    }

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
    //returns if it's first time that the app is openned
    return m_settings.value("firstTime").toBool();
}

void Controller::onCheckGitVersion()
{
    QString command = "> "+QDir::tempPath()+"/tempSmartMirror.txt &&"+"cd "+pathToProject+" && git stash && git pull >"+QDir::tempPath()+"/tempSmartMirror.txt";
    system(command.toLatin1());
    QFile f(QDir::tempPath()+"/tempSmartMirror.txt");
    f.open(QFile::ReadOnly | QFile::Text);
    QTextStream in(&f);
    QString version = in.readAll();
    f.close();

    if(version != "Already up-to-date.\n"){
        QString command = "> "+QDir::tempPath()+"/tempSmartMirror.txt &&"+"cd "+pathToProject+" && git log -1 >"+QDir::tempPath()+"/tempSmartMirror.txt";
        system(command.toLatin1());
        QFile f(QDir::tempPath()+"/tempSmartMirror.txt");
        f.open(QFile::ReadOnly | QFile::Text);
        QTextStream in(&f);
        QString lastestCommit = in.readAll().remove("    ").split("\n").at(4);
        f.close();
        emit hasUpdate(lastestCommit);
    } else {
        qDebug() << __func__ << "Already up-to-date.";
    }
}

void Controller::updateApp()
{
    timerGit->stop();

    QString command = "cd "+pathToProject+" && " +
            "cd .. && cp -r smartmirror2 /tmp";
    system(command.toLatin1());

    emit progress("A aplicação será reiniciada... ");
    command = "cd /tmp/smartmirror2 && qmake ";
    system(command.toLatin1());

    emit progress("A aplicação será reiniciada... ");
    command = "cd /tmp/smartmirror2 && make && rm /usr/bin/smartmirror2 && cp smartmirror2 /usr/bin";
    system(command.toLatin1());

    command = "reboot";
    system(command.toLatin1());

//    m_settings.setValue("gitVersion", version.split("\n").at(0).split(" ").at(1));
//    m_settings.sync();
    timerGit->start();
}

void Controller::getTwitter() {
    QString filename1 = QString(pathToProject+"/twitter/twitter_time_line.py");
    QString filename2 = QString("p_pedrinhu");
    QString filename3 = QString(pathToProject+"/twitter/");
    QString cmd_qt = QString("python %1 %2 %3").arg(filename1).arg(filename2).arg(filename3);
    qDebug()<<cmd_qt;
    const char* cmd = cmd_qt.toLocal8Bit().constData();
    system(cmd);

    QFile file(filename3+filename2+".csv");
    if (!file.open(QIODevice::ReadOnly))
    {
        qDebug() << file.errorString();
        //            return 1;
    }

    QStringList wordList;
    while (!file.atEnd())
    {
        QByteArray line = file.readLine();
        wordList.append(line.split(',').first());
    }

    emit answerTwitter(wordList);
}
