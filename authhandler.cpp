#include "authhandler.h"
#include <QDebug>
#include <QVariantMap>
#include <QNetworkRequest>
#include <QJsonObject>
#include <QFile>
#include "sound.h"

QString emgData="Emg|" ,  pulseData="Pulse|" , galvonicData="Gal|",whole, identifier ;
QByteArray response;

AuthHandler::AuthHandler(QObject *parent)
    : QObject(parent)
    , m_apiKey( QString() )
{
    m_networkAccessManager = new QNetworkAccessManager( this );
    connect( this, &AuthHandler::userSignedIn, this, &AuthHandler::performAuthenticatedDatabaseCall );


}

AuthHandler::~AuthHandler()
{
    m_networkAccessManager->deleteLater();
}
QString AuthHandler::refreshDatabase()
{
    // Perform a fresh GET request to fetch the updated data from the database
    QString endPoint = URL_TO_DB + m_idToken;
    m_networkReply = m_networkAccessManager->get(QNetworkRequest(QUrl(endPoint)));
    connect(m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead);
    return  AuthHandler::fetchValuesAsString();
}
void AuthHandler::writeFrequencyToFirebase(const QString &deviceId, const QString &frequency) {

QString timestamp = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
    QString endpoint = URL_TO_DB + timestamp + ".json?auth=" + m_idToken;
    QJsonObject frequencyObject;
    frequencyObject[timestamp] = frequency;
    QJsonDocument jsonDocument(frequencyObject);
    QNetworkRequest request(QUrl(URL_TO_DB + timestamp + ".json?auth=" + m_idToken)); request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    m_networkReply = m_networkAccessManager->put(request, jsonDocument.toJson());
    connect(m_networkReply, &QNetworkReply::finished, this, &AuthHandler::writeFrequencyFinished);
}

void AuthHandler::writeFrequencyFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() == QNetworkReply::NoError)
    {
        qDebug() << "Frequency written successfully!";
        // Handle success if needed
    }
    else
    {
        qDebug() << "Error writing frequency: " << reply->errorString();
        // Handle error if needed
    }
    reply->deleteLater();
}

void AuthHandler::refreshDatabaseReplyReadyRead()
{

}
QString AuthHandler::userName(){
    qDebug()<<identifier;
    return identifier ;
}

QString AuthHandler::fetchValuesAsString()
{
//    QString emgData="Emg|" ,  pulseData="Pulse|" , galvonicData="Gal|",whole;
//    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);

//    if (!jsonDocument.isNull())
//    {
//        QJsonObject rootObject = jsonDocument.object();
//        if (rootObject.contains("DID324"))
//        {
//            QJsonObject didObject = rootObject.value("DID324").toObject();


//            QStringList keys = didObject.keys();
//            if (!keys.isEmpty())
//            {
//                QString uname = keys.first();
//                QJsonObject sriObject = didObject.value(uname).toObject();

//                // Fetch values for "EMG," "Pulse," and "Galvonic"
//                QStringList emgValues;
//                QStringList pulseValues;
//                QStringList galvonicValues;

//                for (const QString &axisName : sriObject.keys())
//                {
//                    if (axisName == "EMG" || axisName == "Pulse" || axisName == "Galvonic")
//                    {
//                        QJsonObject axisObject = sriObject.value(axisName).toObject();
//                        QStringList axisValues;

//                        for (const QString &timestamp : axisObject.keys())
//                        {
//                            QString value = axisObject.value(timestamp).toString();
//                            axisValues.append(value);
//                        }

//                        // Join the values with a delimiter (|)
//                        QString axisString = axisValues.join("|");

//                        // Store in the appropriate member variable
//                        if (axisName == "EMG")
//                            emgData.append(axisString);
//                        else if (axisName == "Pulse")
//                            pulseData.append(axisString);
//                        else if (axisName == "Galvonic")
//                            galvonicData.append(axisString);
//                    }
//                }

//                whole = emgData + "|" + pulseData + "|" + galvonicData + "|" + "End";
//                qDebug() << whole;
//                return whole;
//            }
//        }
//    }

//    qDebug() << "Error: Unable to determine identifier.";
    return "";
}

void AuthHandler::setAPIKey(const QString &apiKey)
{
    m_apiKey = apiKey;
}
void AuthHandler::writeResponseToJsonFile(const QByteArray &response, const QString &fileName)
{
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);

    if (!jsonDocument.isNull())
    {
        QFile file(fileName);
        if (file.open(QIODevice::WriteOnly))
        {
            QJsonObject rootObject = jsonDocument.object();

            if (rootObject.contains("DID324"))
            {
                QJsonObject didObject = rootObject.value("DID324").toObject();

                // Include the identifier as a key
                QJsonObject outputObject;
                QStringList keys = didObject.keys();

                if (!keys.isEmpty())
                {
                    identifier = keys.first();
                    userName();
                    outputObject.insert(identifier, didObject.value(identifier));
                }

                QTextStream stream(&file);
                stream << QJsonDocument(outputObject).toJson();

                file.close();
                qDebug() << "Values under DID324 written to file: " << fileName;
            }
            else
            {
                qDebug() << "No data found under DID324.";
            }
        }
        else
        {
            qDebug() << "Error opening file for writing: " << fileName;
        }
    }
    else
    {
        qDebug() << "Error parsing JSON response: " << response;
    }
}

void AuthHandler::signUserUp(const QString &emailAddress, const QString &password)
{
    QString signUpEndpoint = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + m_apiKey;

    QVariantMap variantPayload;
    variantPayload["email"] = emailAddress;
    variantPayload["password"] = password;
    variantPayload["returnSecureToken"] = true;

    QJsonDocument jsonPayload = QJsonDocument::fromVariant( variantPayload );
    performPOST( signUpEndpoint, jsonPayload );
}

void AuthHandler::signUserIn(const QString &emailAddress, const QString &password)
{
    QString signInEndpoint = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + m_apiKey;

    QVariantMap variantPayload;
    variantPayload["email"] = emailAddress;
    variantPayload["password"] = password;
    variantPayload["returnSecureToken"] = true;

    QJsonDocument jsonPayload = QJsonDocument::fromVariant( variantPayload );

    performPOST( signInEndpoint, jsonPayload );
}

void AuthHandler::networkReplyReadyRead()
{
    response = m_networkReply->readAll();
    qDebug() << "response from the db is "<<response;
    m_networkReply->deleteLater();
    writeResponseToJsonFile(response, "/home/ai/Downloads/icons8-reload-100/images/output.json");
    parseResponse( response );
}

void AuthHandler::performAuthenticatedDatabaseCall()
{
    QString endPoint = "https://faceattendancerealtime-8dce7-default-rtdb.firebaseio.com/Students.json?auth=" + m_idToken;
    m_networkReply = m_networkAccessManager->get( QNetworkRequest(QUrl(endPoint)));
    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead );
}

void AuthHandler::performPOST(const QString &url, const QJsonDocument &payload)
{
    QNetworkRequest newRequest( (QUrl( url )) );
    newRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString( "application/json"));
    m_networkReply = m_networkAccessManager->post( newRequest, payload.toJson());
    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead );
}

void AuthHandler::parseResponse(const QByteArray &response)
{
    QJsonDocument jsonDocument = QJsonDocument::fromJson( response );
    if ( jsonDocument.object().contains("error") )
    {
        qDebug() << "Error occured!" << response;
    }
    else if ( jsonDocument.object().contains("kind"))
    {
        QString idToken = jsonDocument.object().value("idToken").toString();
        qDebug() << "Obtained user ID Token: " << idToken;
        qDebug() << "User signed in successfully!";
        m_idToken = idToken;
        emit userSignedIn();
    }
    else
        qDebug() << "The response was: " << response;

}


QString AuthHandler::getCurrentTinnitusStage()
{
    QString val ="Normal";
    QFile file("/home/ai/Downloads/icons8-reload-100/images/output.json");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qDebug() << "Error opening file: " << file.errorString();
        return "";
    }
    QByteArray jsonData = file.readAll();
    file.close();
    QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonData);
    if (!jsonDocument.isNull())
    {
        QJsonObject rootObject = jsonDocument.object();
        if (rootObject.contains("sri"))
        {
            QJsonObject sriObject = rootObject.value("sri").toObject();
            if (sriObject.contains("Current_tinnnitus_stage"))
            {
                QJsonObject tinnitusObject = sriObject.value("Current_tinnnitus_stage").toObject();
                if (tinnitusObject.contains("category"))
                {
                    qDebug()<<tinnitusObject.value("category").toString();
                    if(tinnitusObject.value("category").toString()!="Neutral"){


                    }
                    return tinnitusObject.value("category").toString();
                }
            }
        }
    }
    return val; // Return empty string if data is not found
}


QString AuthHandler::getLatestFutureTinnitusStage()

{
    QString val = "Abnormal";
    QFile file("/home/ai/Downloads/icons8-reload-100/images/output.json");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qDebug() << "Error opening file: " << file.errorString();
        return "";
    }
    QByteArray jsonData = file.readAll();
    file.close();
    QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonData);
    if (!jsonDocument.isNull())
    {
        QJsonObject rootObject = jsonDocument.object();
        if (rootObject.contains("sri"))
        {
            QJsonObject sriObject = rootObject.value("sri").toObject();
            if (sriObject.contains("Future_tinnnitus_stage"))
            {
                QJsonObject tinnitusObject = sriObject.value("Future_tinnnitus_stage").toObject();
                QStringList timestamps = tinnitusObject.keys();
                if (!timestamps.isEmpty())
                {
                    QString latestTimestamp = *std::max_element(timestamps.begin(), timestamps.end());
                    qDebug()<<tinnitusObject.value(latestTimestamp).toString();
                    return tinnitusObject.value(latestTimestamp).toString();
                }
            }
        }
    }
    return val; // Return empty string if data is not found
}


QString AuthHandler::getRecommendedFrequency()
{
    QString val ="330";
    QFile file("/home/ai/Downloads/icons8-reload-100/images/output.json");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qDebug() << "Error opening file: " << file.errorString();
        return "";
    }
    QByteArray jsonData = file.readAll();
    file.close();
    QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonData);
    if (!jsonDocument.isNull())
    {
        QJsonObject rootObject = jsonDocument.object();
        if (rootObject.contains("sri"))
        {
            QJsonObject sriObject = rootObject.value("sri").toObject();
            if (sriObject.contains("Recommended_Frequency_"))
            {
                QJsonObject frequencyObject = sriObject.value("Recommended_Frequency_").toObject();
                QStringList timestamps = frequencyObject.keys();
                if (!timestamps.isEmpty())
                {
                    QString latestTimestamp = *std::max_element(timestamps.begin(), timestamps.end());
                    qDebug()<<frequencyObject.value(latestTimestamp).toString();
                    return frequencyObject.value(latestTimestamp).toString();
                }
            }
        }
    }
    return val; // Return empty string if data is not found
}


//#include "authhandler.h"

//#include <QDebug>

//#include <QVariantMap>

//#include <QNetworkRequest>

//#include <QJsonObject>

//#include <QFile>


//QString emgData = "Emg|", pulseData = "Pulse|", galvonicData = "Gal|", whole, identifier;

//QByteArray response;


//AuthHandler::AuthHandler(QObject *parent)

//    : QObject(parent)

//{

//    m_networkAccessManager = new QNetworkAccessManager(this);


//    // Connect signals and slots

//    connect(m_networkAccessManager, &QNetworkAccessManager::finished, this, &AuthHandler::networkReplyFinished);

//}


//AuthHandler::~AuthHandler()

//{

//    m_networkAccessManager->deleteLater();

//}



//QString AuthHandler::refreshDatabase()

//{

//    // Perform a fresh GET request to fetch the updated data from the database

//    QString endPoint = "https://faceattendancerealtime-8dce7-default-rtdb.firebaseio.com/Students.json?auth=" + m_idToken;

//    m_networkReply = m_networkAccessManager->get(QNetworkRequest(QUrl(endPoint)));

//    connect(m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead);

//   return  AuthHandler::fetchValuesAsString();

//}


//void AuthHandler::refreshDatabaseReplyReadyRead()

//{


//}


//QString AuthHandler::fetchValuesAsString()

//{   QString emgData="Emg|" ,  pulseData="Pulse|" , galvonicData="Gal|",whole;

//    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);

//    if (!jsonDocument.isNull())

//    {

//        QJsonObject rootObject = jsonDocument.object();

//        if (rootObject.contains("sri"))

//        {

//            QJsonObject sriObject = rootObject.value("sri").toObject();


//            // Fetch values for "EMG," "Pulse," and "Galvonic"

//            QStringList emgValues;

//            QStringList pulseValues;

//            QStringList galvonicValues;


//            for (const QString &axisName : sriObject.keys())

//            {

//                if (axisName == "EMG" || axisName == "Pulse" || axisName == "Galvonic")

//                {

//                    QJsonObject axisObject = sriObject.value(axisName).toObject();

//                    QStringList axisValues;


//                    for (const QString &timestamp : axisObject.keys())

//                    {

//                        QString value = axisObject.value(timestamp).toString();

//                        axisValues.append(value);

//                    }


//                    // Join the values with a delimiter (|)

//                    QString axisString = axisValues.join("|");


//                    // Store in the appropriate member variable

//                    if (axisName == "EMG")

//                        emgData.append( axisString);

//                    else if (axisName == "Pulse")

//                        pulseData.append( axisString);

//                    else if (axisName == "Galvonic")

//                        galvonicData.append( axisString);

//                }

//            }

//        }

//    }

//    whole ="";

//    whole=emgData+"|"+pulseData+"|"+galvonicData+"|"+"End";

//    qDebug()<<whole;

//    return whole;

//}

//QString AuthHandler::userName()
//{

//}


//void AuthHandler::setAPIKey(const QString &apiKey)

//{

//    m_apiKey = apiKey;

//}

//void AuthHandler::writeResponseToJsonFile(const QByteArray &response, const QString &fileName)

//{

//    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);


//    if (!jsonDocument.isNull())

//    {

//        QFile file(fileName);

//        if (file.open(QIODevice::WriteOnly))

//        {

//            QTextStream stream(&file);

//            stream << jsonDocument.toJson();

//            file.close();

//            qDebug() << "Response written to file: " << fileName;

//        }

//        else

//        {

//            qDebug() << "Error opening file for writing: " << fileName;

//        }

//    }

//    else

//    {

//        qDebug() << "Error parsing JSON response: " << response;

//    }

//}

//void AuthHandler::signUserUp(const QString &emailAddress, const QString &password)

//{

////    QString signUpEndpoint = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + m_apiKey;


////    QVariantMap variantPayload;

////    variantPayload["email"] = emailAddress;

////    variantPayload["password"] = password;

////    variantPayload["returnSecureToken"] = true;


////    QJsonDocument jsonPayload = QJsonDocument::fromVariant( variantPayload );

////    performPOST( signUpEndpoint, jsonPayload );

//}


//void AuthHandler::signUserIn(const QString &emailAddress, const QString &password)

//{

////    QString signInEndpoint = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + m_apiKey;


////    QVariantMap variantPayload;

////    variantPayload["email"] = emailAddress;

////    variantPayload["password"] = password;

////    variantPayload["returnSecureToken"] = true;


////    QJsonDocument jsonPayload = QJsonDocument::fromVariant( variantPayload );


////    performPOST( signInEndpoint, jsonPayload );

//}


//void AuthHandler::networkReplyReadyRead()

//{

////    response = m_networkReply->readAll();

////    qDebug() << "response from the db is "<<response;

////    m_networkReply->deleteLater();

////    writeResponseToJsonFile(response, "/home/ai/Downloads/icons8-reload-100/images/output.json");

////    parseResponse( response );

//}


//void AuthHandler::performAuthenticatedDatabaseCall()

//{

//    QString endPoint = "https://faceattendancerealtime-8dce7-default-rtdb.firebaseio.com/Students.json?auth=" + m_idToken;

//    m_networkReply = m_networkAccessManager->get( QNetworkRequest(QUrl(endPoint)));

//    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead );

//}


//void AuthHandler::performPOST(const QString &url, const QJsonDocument &payload)

//{

//    QNetworkRequest newRequest( (QUrl( url )) );

//    newRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString( "application/json"));

//    m_networkReply = m_networkAccessManager->post( newRequest, payload.toJson());

//    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead );

//}


//void AuthHandler::parseResponse(const QByteArray &response)

//{

//    QJsonDocument jsonDocument = QJsonDocument::fromJson( response );

//    if ( jsonDocument.object().contains("error") )

//    {

//        qDebug() << "Error occured!" << response;

//    }

//    else if ( jsonDocument.object().contains("kind"))

//    {

//        QString idToken = jsonDocument.object().value("idToken").toString();

//        qDebug() << "Obtained user ID Token: " << idToken;

//        qDebug() << "User signed in successfully!";

//        m_idToken = idToken;

//        emit userSignedIn();

//    }

//    else

//        qDebug() << "The response was: " << response;


//}

//void AuthHandler::networkReplyFinished(QNetworkReply *reply)

//{

//    if (reply->error() == QNetworkReply::NoError)

//    {

//        response = reply->readAll();

//        qDebug() << "response from the db is " << response;

//        writeResponseToJsonFile(response, "/home/ai/Downloads/icons8-reload-100/images/output.json");

//        parseResponse(response);

//    }

//    else

//    {

//        qDebug() << "Error occurred: " << reply->errorString();

//    }


//    reply->deleteLater();

//}
