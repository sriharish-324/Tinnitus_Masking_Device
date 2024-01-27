// sound.h
#ifndef SOUND_H
#define SOUND_H

#include <QObject>
#include <QAudioOutput>
#include <QBuffer>
#include <QByteArray>
#include <QTimer>
#include <QBluetoothSocket>
#include <QBluetoothDeviceDiscoveryAgent>
//#include<QNetworkAccessManager>
//#include<QNetworkReply>
class Sound : public QObject
{
    Q_OBJECT



public:
    explicit Sound(QObject *parent = nullptr);
    ~Sound();
public slots:
    void startDescendingVolume(double fq);
    void generateSound(double frequency);
    double generateReverseSound(double frequency);
    void stopSound();
    double calculateHearingIntensity(double frequency, double laststopped);
    void volume(qreal);
    float galvonic();
    int serialData();
    int gen();



private slots:
    void handleStateChanged(QAudio::State newState);
    double calculateInterference(QByteArray originalData, QByteArray reversedData,double);

private:
    QByteArray generateData(double frequency);
    QByteArray generateReverseData(double frequency);
    QAudioFormat format;
    QAudioOutput *audioOutput;
    QBuffer buffer;
    QTimer *timer;
    double currentFrequency; // Added to store the current frequency
    QBluetoothSocket* bluetoothSocket;
};

#endif // SOUND_H
