#include "speech.h"
#include <QLocale>
#include <QDebug>
#include <QTime>

Speech::Speech(QObject *parent) : QObject(parent)
{
    m_speech = new QTextToSpeech(this);
    m_speech->setVolume(70);
    m_speech->setRate(0);
    m_speech->setPitch(0);
//    QLocale local(QLocale::Brazil);
    m_speech->setLocale(QLocale::Portuguese);
}

void Speech::sayWelcome()
{
    m_speech->say("Seja bem vindo, ao aisseuf");
}

void Speech::say(int hour, QString weather)
{
    QString message = "Olá, ";

    if(hour < 12){
        //bom dia
        message += "bom dia!\n";
    } else if(hour >= 12 && hour < 18) {
        //boa tarde
        message += "boa tarde!\n";
    } else {
        //boa noite
        message += "boa noite!\n";
    }

    // https://www.wunderground.com/weather/api/d/docs?d=resources/phrase-glossary&MR=1&_ga=2.183219110.1875570343.1511699835-1348404951.1511699835
//    if(hour <= 13) {
        if(weather == "mostlycloudy" || weather == "mostlysunny" ||
                weather == "partlycloudy" || weather == "partlysunny") {
            message += "Parece que hoje, será um dia com algumas nuvens.";
        } else if(weather == "sunny" || weather == "clear") {
            message += "Parece que hoje, será um ótimo dia ensolarado.";
        } else {
            message += "A expectativa para hoje, é de risco de chuva.";
        }
//    }

    m_speech->say(message);
}

void Speech::sayGoodBye()
{
    // returns a random number randomValue with 0 <= randomValue < number
    qsrand(QTime::currentTime().msec());
    int randomValue = rand() % 20;
    if(randomValue <= 10)
        m_speech->say("Até mais");
    else
        m_speech->say("Até a próxima");
}
