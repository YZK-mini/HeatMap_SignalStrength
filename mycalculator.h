#ifndef MYCALCULATOR_H
#define MYCALCULATOR_H

#include <QObject>
#include <QtQml>
#include <QVector3D>
#include <QList>

class MyCalculator : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QList<QList<QList<qreal>>> result READ result NOTIFY resultChanged)
    Q_PROPERTY(int num READ getNum WRITE setNum NOTIFY numChanged FINAL)

public:
    MyCalculator(QObject *parent = nullptr);

    QList<QList<QList<qreal>>> result() const;

    int getNum() const;
    void setNum(int newNum);

public slots:
    void calculateResults(const QList<QVector3D> &signalPos);

signals:
    void resultChanged();
    void numChanged();

private:
    QList<QList<QList<qreal>>> m_result;
    int num;

};

#endif // MYCALCULATOR_H
