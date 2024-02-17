#include <QVector3D>
#include <QList>

#include "mycalculator.h"

QObject *pRootObject;
extern QList<QList<QList<qreal>>> recentResult;
extern int width; // 图片像素横纵值，也即计算精度

MyCalculator::MyCalculator(QObject *parent)
    : QObject{parent}
{
    width = 255;

    recentResult.resize(125);
    // 将每个元素初始化为 0.0
    for (int k = 0; k < 125; k++) {
        recentResult[k].resize(width);

        for (int i = 0; i < recentResult[k].size(); i++) {
            recentResult[k][i].resize(width, 0.0);
        }
    }
}

QList<QList<QList<qreal>>> MyCalculator::result() const
{
    return m_result;
}

void MyCalculator::calculateResults(const QList<QVector3D> &signalPos)
{
    m_result.clear();

    auto view = pRootObject;

    for (int sig_num = 0; sig_num < num; sig_num++){
        // 三重循环，遍历三维空间内固定步长间隔的各点
        for (int k = 0; k < 125; k++) {
            QList<QList<qreal>> kList;
            for (int i = 0; i < width; i++) {
                QList<qreal> iList;
                for (int j = 0; j < width; j++) {
                    int jScaled = (j-(width-1)/2) * (2550 / width);
                    int iScaled = (i-(width-1)/2) * (2550 / width);
                    int kScaled = k * 10;

                    // 调用qml中的函数raycheck进行遮挡判断
                    QVariant pos = QVariant::fromValue(QVector3D(iScaled,kScaled,jScaled));
                    QVariant check = true;
                    if (sig_num==0){
                        QMetaObject::invokeMethod(view, "raycheck1", Qt::DirectConnection, Q_RETURN_ARG(QVariant, check), Q_ARG(QVariant, pos));
                    }
                    else{
                        QMetaObject::invokeMethod(view, "raycheck2", Qt::DirectConnection, Q_RETURN_ARG(QVariant, check), Q_ARG(QVariant, pos));
                    }

                    QVector3D p(iScaled, kScaled, jScaled);
                    float distance = (p - signalPos[sig_num]).length()/10;

                    // 进行该点强度计算,并些微修正信号源位置
                    if (check.toBool()) {
                        if(distance == 0){
                            iList.append(100);
                        }
                        else{
                            double temp = 1000 / (4 * 3.1415926 * qPow(distance, 2));
                            iList.append(temp);
                        }
                    } else {
                        iList.append(0);
                    }
                }
                kList.append(iList);
            }
            if (sig_num==0)
                m_result.append(kList);
            else
                m_result[k]=kList;
        }

        if (sig_num==1){
            for (int k = 0; k < 125; k++) {
                for (int i = 0; i < width; i++) {
                    for (int j = 0; j < width; j++) {
                        recentResult[k][i][j] = recentResult[k][i][j] + m_result[k][i][j];
                    }
                }
            }
            qDebug()<<"Calculation2 End.";
        }
        else{
            recentResult = m_result;
            qDebug()<<"Calculation1 End.";
        }
    }

    // 发出计算结束信号
    emit resultChanged();
}

int MyCalculator::getNum() const
{
    return num;
}

void MyCalculator::setNum(int newNum)
{
    if (num == newNum)
        return;
    num = newNum;
    emit numChanged();
}
