#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include "sound.h"
#include "authhandler.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    AuthHandler authHandler;

    //Set your API Key here
    authHandler.setAPIKey("AIzaSyAx-fgaHPWsSLZmYQAVOGjtAuVGaZWu-bU");

    //This is the call to sign a user up using Email/Password
   // authHandler.signUserUp("email", "password");

    //This is the call to sign an existing user in
   authHandler.signUserIn("sriharish.cs21@bitsathy.ac.in", "Janusri@324");
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    Sound sound;
    QQmlContext *ctx =engine.rootContext();
    ctx->setContextProperty("demo",&sound);
    ctx->setContextProperty("db",&authHandler);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
