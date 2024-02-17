#ifndef HEATMAPPROVIDER_H
#define HEATMAPPROVIDER_H

#include <QObject>
#include <QImage>
#include <QQmlEngine>
#include <QList>

class HeatmapProvider : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double qmlValue READ getQmlValue WRITE setQmlValue NOTIFY qmlValueChanged)

public:
    HeatmapProvider(QObject *parent = nullptr);

    Q_INVOKABLE QImage generateHeatmapImage();

    int getQmlValue() const;
    void setQmlValue(int value);

signals:
    void qmlValueChanged();
    void imageSavedSuccessfully();

private:
    int qmlValue;
    QColor mapValueToColor(qreal value);
};

#endif // HEATMAPPROVIDER_H
