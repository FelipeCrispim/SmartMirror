#ifndef SPEECH_H
#define SPEECH_H

#include <QObject>
#include <QTextToSpeech>

class Speech : public QObject
{
    Q_OBJECT
public:
    explicit Speech(QObject *parent = nullptr);
    Q_INVOKABLE void sayWelcome();
    Q_INVOKABLE void say(int hour, QString weather);
    Q_INVOKABLE void sayGoodBye();
    Q_INVOKABLE void infoAboutWeather(int wind, float levelSea, QString time);

private:
    QTextToSpeech *m_speech;

public slots:
};

#endif // SPEECH_H
