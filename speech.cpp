#include "speech.h"
#include <QLocale>
#include <QDebug>
#include <QTime>
#include <QProcess>

Speech::Speech(QObject *parent) : QObject(parent)
{
//    m_speech = new QTextToSpeech(this);
//    m_speech->setVolume(70);
//    m_speech->setRate(0);
//    m_speech->setPitch(0);
//    m_speech->setLocale(QLocale::Portuguese);
}

void Speech::sayWelcome()
{
//    m_speech->say("Seja bem vindo, ao aisseuf");
}

void Speech::say(int hour, QString weather)
{
    QString message;

    if(hour < 12){
        //bom dia
        message += "Olá bom dia! ";
    } else if(hour >= 12 && hour < 18) {
        //boa tarde
        message += "Olá boa tarde! ";
    } else {
        //boa noite
        message += "Olá boa noite! ";
    }

    // https://www.wunderground.com/weather/api/d/docs?d=resources/phrase-glossary&MR=1&_ga=2.183219110.1875570343.1511699835-1348404951.1511699835
    if(hour < 17) {
        if(weather == "mostlycloudy" || weather == "mostlysunny" ||
                weather == "partlycloudy" || weather == "partlysunny") {
            message += "Parece que hoje, será um dia com algumas nuvens.";
        } else if(weather == "sunny" || weather == "clear") {
            message += "Parece que hoje, será um ótimo dia ensolarado.";
        } else {
            message += "A expectativa para hoje, é de risco de chuva.";
        }
    }

    #if __APPLE__
//        m_speech->say(message);
    #else
    QString program = "/home/felipecrispim/Qt-Workspace/smartmirror2";
    QStringList arguments, arg2;
    arguments << program;

    QProcess *myProcess = new QProcess(this);
    myProcess->start("cd", arguments);
    myProcess->waitForReadyRead();
    arg2 << "speech.sh" << message;
    myProcess->start("./", arg2);
//    myProcess->waitForReadyRead();
//        QString tempMsg = "cd /home/felipecrispim/Qt-Workspace/smartmirror2 && ./speech.sh "+message;
//        system(tempMsg.toLatin1());
    #endif

}

void Speech::sayGoodBye()
{
    // returns a random number randomValue with 0 <= randomValue < number
    qsrand(QTime::currentTime().msec());
    int randomValue = rand() % 20;
//    if(randomValue <= 10)
//        m_speech->say("Até mais");
//    else
//        m_speech->say("Até a próxima");
}

void Speech::infoAboutWeather(int wind, float levelSea, QString time)
{
    QString message = "Nesse momento em Maceió, a velocidade do vento é de "+QString::number(wind)+" km/h,"
                        " e o nível da maré, é de "+QString::number(levelSea)+"m até às "+time;
//    m_speech->say(message);
    system(message.toLatin1());

}
