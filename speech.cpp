#include "speech.h"
#include <QLocale>
#include <QDebug>
#include <QTime>
#include <QProcess>

QString pathToAudioProject = "/media/smartmirror2/translate.py";

Speech::Speech(QObject *parent) : QObject(parent)
{
//    m_speech = new QTextToSpeech(this);
//    m_speech->setVolume(70);
//    m_speech->setRate(0);
//    m_speech->setPitch(0);
//    m_speech->setLocale(QLocale::Portuguese);

    m_process = new QProcess(this);
}

void Speech::sayWelcome()
{
//    QString message = "omxplayer -o hdmi "+pathToAudioProject+"/welcome.mp3";
    QString message = "python "+pathToAudioProject+" \"Seja%20bem%20vindo%20ao%20aisselfi\"";
//    QProcess process;
    m_process->start(message);
}

void Speech::say(int hour, QString weather)
{
    QString message;

    if(hour < 12){
        //bom dia
        message += " \"Olá, bom dia! ";
    } else if(hour >= 12 && hour < 18) {
        //boa tarde
        message += " \"Olá, boa tarde! ";
    } else {
        //boa noite
        message += " \"Olá, boa noite! ";
    }

    // https://www.wunderground.com/weather/api/d/docs?d=resources/phrase-glossary&MR=1&_ga=2.183219110.1875570343.1511699835-1348404951.1511699835
    if(hour < 17) {
        if(weather == "mostlycloudy" || weather == "mostlysunny" ||
                weather == "partlycloudy" || weather == "partlysunny") {
            message += "Parece que hoje, será um dia com algumas nuvens.\"";
        } else if(weather == "sunny" || weather == "clear") {
            message += "Parece que hoje, será um ótimo dia ensolarado.\"";
        } else {
            message += "A expectativa para hoje, é de risco de chuva.\"";
        }
    }


//        QString tempMsg = "./media/smartmirror2/speech.sh "+message;
        QString tempMsg = "python "+pathToAudioProject+message.replace(" ", "%20");
//        QProcess process;
//        QString messages = "omxplayer -o hdmi "+pathToAudioProject+"/weather.mp3";
        m_process->start(tempMsg);

}

void Speech::sayGoodBye()
{
    // returns a random number randomValue with 0 <= randomValue < number
    qsrand(QTime::currentTime().msec());
    int randomValue = rand() % 20;
    if(randomValue <= 10) {
        QString message = "python "+pathToAudioProject+" \"Até%20mais\"";
//        QProcess process;
        m_process->start(message);
    } else {
        QString message = "python "+pathToAudioProject+" \"Até%20a%20próxima\"";
//        QProcess process;
        m_process->start(message);
    }
}

void Speech::infoAboutWeather(int wind, float levelSea, QString time)
{
    QString message = " \"Agora em Maceió, a velocidade do vento é de "+QString::number(wind)+" km/h,"
                        " e o nível da maré, é de "+QString::number(levelSea)+"m até às "+time+"\"";
//    QProcess process;
//    QString message = "omxplayer -o hdmi "+pathToAudioProject+"/weather.mp3";
    QString tempMsg = "python "+pathToAudioProject+message.replace(" ", "%20");
//    QProcess process;
    qDebug() << tempMsg;
    m_process->start(tempMsg);
//    system(tempMsg.toLatin1());

}
