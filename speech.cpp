#include "speech.h"
#include <QLocale>
#include <QDebug>
#include <QTime>
#include <QProcess>

QString pathToAudioProject = "/media/smartmirror2/audios";

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
    QString message = "omxplayer -o hdmi "+pathToAudioProject+"/welcome.mp3";
//    QProcess process;
    m_process->start(message);
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
//    QString program = "/home/felipecrispim/Qt-Workspace/smartmirror2";
//    QStringList arguments, arg2;
//    arguments << program;

//    QProcess *myProcess = new QProcess(this);
//    myProcess->start("cd", arguments);
//    myProcess->waitForReadyRead();
//    arg2 << "speech.sh" << message;
//    myProcess->start("./", arg2);
//    myProcess->waitForReadyRead();
#endif

//        QString tempMsg = "./media/smartmirror2/speech.sh "+message;
//        QString tempMsg = "omxplayer -o hdmi http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=Alo%20Alo&tl=Pt-br";
//        QProcess process;
        QString messages = "omxplayer -o hdmi "+pathToAudioProject+"/welcome.mp3";
        m_process->start(messages);

}

void Speech::sayGoodBye()
{
    // returns a random number randomValue with 0 <= randomValue < number
    qsrand(QTime::currentTime().msec());
    int randomValue = rand() % 20;
    if(randomValue <= 10) {
        QString message = "omxplayer -o hdmi "+pathToAudioProject+"/seeYou.mp3";
//        QProcess process;
        m_process->start(message);
    } else {
        QString message = "omxplayer -o hdmi "+pathToAudioProject+"/seeYouNextTime.mp3";
//        QProcess process;
        m_process->start(message);
    }
}

void Speech::infoAboutWeather(int wind, float levelSea, QString time)
{
    QString message = "\"Nesse momento em Maceió, a velocidade do vento é de "+QString::number(wind)+" km/h,"
                        " e o nível da maré, é de "+QString::number(levelSea)+"m até às "+time+"\"";
//    QProcess process;
    QString tempMsg = "omxplayer -o hdmi http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q="+message+"&tl=Pt-br";
    system(tempMsg.toLatin1());

}
