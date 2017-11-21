#ifndef PROCESS_H
#define PROCESS_H
#include <QProcess>
#include <QVariant>
#include <QFile>
#include <QDebug>

class Process : public QProcess {
    Q_OBJECT

public:
    Process(QObject *parent = 0) : QProcess(parent) { }

    Q_INVOKABLE void start(const QString &program, const QVariantList &arguments) {
        QString filename1 = QString("/media/smart_mirror/twitter/twitter_time_line.py");
        QString filename2 = QString("p_pedrinhu");
        QString filename3 = QString("/media/smart_mirror/twitter/");
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

        emit answer(wordList.at(1));
    }

    Q_INVOKABLE QString readAll() {
//        QFile file("/Users/felipecrispim/Downloads/twitter/p_pedrinhu.csv");
//        if (!file.open(QIODevice::ReadOnly))
//        {
//            qDebug() << file.errorString();
////            return 1;
//        }

//        QStringList wordList;
//        while (!file.atEnd())
//        {
//            QByteArray line = file.readLine();
//            wordList.append(line.split(',').first());
//        }
//        return wordList.at(1);
    }
signals:
    void answer(QString ans);


};
#endif // PROCESS_H
