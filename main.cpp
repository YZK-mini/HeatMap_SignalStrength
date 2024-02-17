#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QtGui>
#include <QtQuick3D/qquick3d.h>
#include <QIcon>

#include "mycalculator.h"
#include "heatmapprovider.h"
#include "img.h"

extern QObject *pRootObject;
extern ShowImage *CodeImage;

ImageProvider::ImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{
}

QImage ImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    return this->img;
}

QPixmap ImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    return QPixmap::fromImage(this->img);
}

ShowImage::ShowImage(QObject *parent) :
    QObject(parent)
{
    m_pImgProvider = new ImageProvider();
}

void  ShowImage::sendimage(QImage sendimage)
{
    m_pImgProvider->img =sendimage ;

    // 发出图像传输信号
    emit callQmlRefeshImg();
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/maps/icon.png"));
    QSurfaceFormat::setDefaultFormat(QQuick3D::idealSurfaceFormat());

    qmlRegisterType<MyCalculator>("MyComponents", 1, 0, "MyCalculator");
    qmlRegisterType<HeatmapProvider>("HeatMap",1,0,"HeatmapProvider");

    QQmlApplicationEngine engine;

    CodeImage=new ShowImage();
    engine.rootContext()->setContextProperty("CodeImage",CodeImage);
    engine.addImageProvider(QLatin1String("CodeImg"),CodeImage->m_pImgProvider);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    auto list =  engine.rootObjects();
    pRootObject = list.first()->findChild<QObject *>("3dmodel");
    if (!pRootObject)
        return -1;

    return app.exec();
}
