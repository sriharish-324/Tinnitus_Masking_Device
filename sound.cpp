// sound.cpp
#include "sound.h"
#include <QtCore/qmath.h>
#include<QDebug>
#include <QSerialPort>
#include<QRandomGenerator>

#define PULSE_SENSOR_GPIO_PIN 18
QSerialPort serial;

Sound::Sound(QObject *parent) : QObject(parent){
    format.setSampleRate(44100);
    format.setChannelCount(1);
    format.setSampleSize(16);
    format.setCodec("audio/pcm");
    format.setByteOrder(QAudioFormat::LittleEndian);
    format.setSampleType(QAudioFormat::SignedInt);
    // Open serial port
      serial.setPortName("/dev/ttyACM0"); // Change this to the actual port your Arduino is connected to

      if (serial.open(QIODevice::ReadWrite)) {
          serial.setBaudRate(QSerialPort::Baud9600); // Match with the baud rate in your Arduino code
          serial.setDataBits(QSerialPort::Data8);
          serial.setParity(QSerialPort::NoParity);
          serial.setStopBits(QSerialPort::OneStop);

          QObject::connect(&serial, &QSerialPort::readyRead, this, &Sound::serialData);

          qDebug() << "Serial port opened successfully";
      } else {
          qDebug() << "Failed to open serial port";
      }

    audioOutput = new QAudioOutput(format, this);
    audioOutput->setBufferSize(32768);
    // Connect to Bluetooth
    //connectToBluetooth("00:18:91:D6:A7:EF");   // connect(m_networkReply, &QNetworkReply::readyRead ,this, &Sound::networkReplys);
    connect(audioOutput, &QAudioOutput::stateChanged, this, &Sound::handleStateChanged);
}


int Sound::serialData()
{
   QByteArray data = serial.readAll();
        int sens = data.toInt();
        if (sens <= 75) {
            return 77;
        } else {
            return sens;
        }

        //qDebug() << "Received data:" << data;
}

void Sound::volume(qreal volu){
    audioOutput->setVolume(volu / 100.0);

}

int Sound::gen()
{
     return QRandomGenerator::global()->bounded(75,90);
}
float Sound::galvonic()
{
 return static_cast<float>(QRandomGenerator::global()->bounded(0.5, 3));
}
void Sound::generateSound(double frequency)
{
    buffer.close();
    buffer.setData(generateData(frequency));
    buffer.open(QIODevice::ReadOnly);
    buffer.seek(0);

    audioOutput->start(&buffer);
}

double Sound::generateReverseSound(double frequency)
{

    buffer.close();
    QByteArray originalData = generateData(frequency);
    double reversedFrequency = -frequency;
    buffer.setData(generateReverseData(reversedFrequency));
    buffer.open(QIODevice::ReadOnly);
    buffer.seek(0);

    audioOutput->start(&buffer);

    return calculateInterference(originalData, buffer.data(),frequency);
}

QByteArray Sound::generateData(double frequency)
{
    QByteArray audioData;
    const int sampleRate = format.sampleRate();
    const double durationSeconds = 30.0; // Set the duration of each block (seconds)

    for (int i = 0; i < durationSeconds * sampleRate; ++i)
    {
        qreal value = qSin(2 * M_PI * frequency * i / sampleRate);
        qint16 sample = static_cast<qint16>(value * 32767);

        audioData.append(reinterpret_cast<const char *>(&sample), sizeof(sample));
    }

    return audioData;
}

QByteArray Sound::generateReverseData(double frequency)
{
    QByteArray audioData;
    const int sampleRate = format.sampleRate();
    const double durationSeconds = 30.0; // Set the duration of each block (seconds)

    for (int i = 0; i < durationSeconds * sampleRate; ++i)
    {
        qreal value = qSin(2 * M_PI * -frequency * i / sampleRate); // Reverse frequency by changing the sign
        qint16 sample = static_cast<qint16>(value * 32767);

        audioData.append(reinterpret_cast<const char *>(&sample), sizeof(sample));
    }

    return audioData;
}

double Sound::calculateInterference(QByteArray originalData, QByteArray reversedData, double frequency)
{
    // Calculate the interference ratio
    double sumSquaredOriginal = 0.0;
    double sumSquaredReversed = 0.0;
    double sumSquaredInterference = 0.0;
    const double scale = 32767.0;  // Maximum sample value for a 16-bit signed integer

    for (int i = 0; i < originalData.size(); i += sizeof(qint16))
    {
        qint16 originalSample = *reinterpret_cast<const qint16*>(originalData.constData() + i);
        qint16 reversedSample = *reinterpret_cast<const qint16*>(reversedData.constData() + i);

        double scaledOriginal = static_cast<double>(originalSample) / scale;
        double scaledReversed = static_cast<double>(reversedSample) / scale;

        sumSquaredOriginal += scaledOriginal * scaledOriginal;
        sumSquaredReversed += scaledReversed * scaledReversed;
        sumSquaredInterference += (scaledOriginal - scaledReversed) * (scaledOriginal - scaledReversed);
    }

    double interferenceRatio = sumSquaredInterference / (sumSquaredOriginal + sumSquaredReversed);

    qDebug() << sumSquaredReversed<< sumSquaredOriginal<<sumSquaredInterference << "Interference Ratio:" << interferenceRatio;

    return interferenceRatio;
}
void Sound::startDescendingVolume(double fq)
{
    generateSound(fq);
}

double calculatePressureAmplitude(double frequency, double volume) {
       // Implement your logic for calculating pressure amplitude based on frequency and volume
       // This is a placeholder, you may need a more complex model based on your requirements
    const double frequencySensitivity = 0.01;  // Adjust based on your requirements
            const double volumeSensitivity = 0.005;   // Adjust based on your requirements

            double pressureAmplitude = frequencySensitivity * frequency + volumeSensitivity * volume;

            return pressureAmplitude;
   }

double Sound::calculateHearingIntensity(double frequency, double volume) {
    const double density = 1.21;  // Density of air in kg/m^3 (example value, you may adjust this)
           const double speedOfSound = 343.0;  // Speed of sound in air in m/s (example value, you may adjust this)
           const double thresholdIntensity = 1e-12;  // Threshold intensity of hearing in W/m^2

           // Calculate sound intensity (I)
           double pressureAmplitude = calculatePressureAmplitude(frequency, volume);
           double intensity = (std::pow(pressureAmplitude, 2.0) * density * std::pow(speedOfSound, 2.0)) / 2.0;

           // Calculate sound intensity level (in dB)
           double intensityLevel = 10.0 * std::log10(intensity / thresholdIntensity);

           return intensityLevel;
    }


void Sound::handleStateChanged(QAudio::State newState)
{
    if (newState == QAudio::IdleState) {
        buffer.seek(0); // Reset buffer position to the beginning
        audioOutput->start(&buffer);
    }
}

void Sound::stopSound()
{
    audioOutput->stop();
}
Sound::~Sound()
{

}
//void Sound::networkReplys()
//{
//   qDebug()<< m_networkReply->readAll();
//}
