#include <QList>
#include <QImage>
#include <QColor>

#include "heatmapprovider.h"
#include "img.h"

QList<QList<QList<qreal>>> recentResult;
ShowImage *CodeImage;
int width;

HeatmapProvider::HeatmapProvider(QObject *parent)
    : QObject(parent),qmlValue(0)
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

QImage HeatmapProvider::generateHeatmapImage() {

    QImage heatmapImage(width, width, QImage::Format_RGB32);

    // 根据每个元素数值给予对应点颜色
    for (int y = 0; y < width; y++) {
        for (int x = 0; x < width; x++) {
            qreal value = recentResult[qmlValue][x][y];
            QColor color = mapValueToColor(value);
            heatmapImage.setPixelColor(x, y, color);
        }
    }

    // 发送图片
    CodeImage->sendimage(heatmapImage);

    // 保存图片
    heatmapImage.save("D:/Personal/Software Design/heatmapproject/heatmaps/heatmap.png","PNG",100);

    return heatmapImage;
}

QColor HeatmapProvider::mapValueToColor(qreal value) {
    const double mvalue = qLn(value/100); // 先做对数处理
    const double max = -1;
    const double min = -10;
    const double range = max - min + 1;

    // 计算数据在整个范围中的相对位置
    double r = static_cast<double>(mvalue - min) / range;

    // 根据范围分为五个阶段
    double step = range / 5;
    int d = static_cast<int>(r * 5);
    double t = (d + 1) * step + min;
    double l = d * step + min;
    double local_r = static_cast<double>(mvalue - l) / (t - l);

    if (mvalue > max) {
        return QColor::fromRgb(qRgb(255, 0, 255));
    }

    if (mvalue <= min){
        return QColor::fromRgb(qRgb(0, 0, 255));
    }

    // 根据阶段的不同，采用不同的颜色映射方式
    if (d == 0) {
        return QColor::fromRgb(qRgb(0, static_cast<int>(local_r * 255), 255)); //蓝变青
    } else if (d == 1) {
        return QColor::fromRgb(qRgb(0, 255, static_cast<int>((1 - local_r) * 255))); //青变绿
    } else if (d == 2) {
        return QColor::fromRgb(qRgb(static_cast<int>(local_r * 255), 255, 0)); // 绿变黄
    } else if (d == 3) {
        return QColor::fromRgb(qRgb(255, static_cast<int>((1 - local_r) * 255), 0)); // 黄变红
    } else if (d == 4) {
        return QColor::fromRgb(qRgb(255, 0, static_cast<int>(local_r * 255))); // 红变紫
    }

    return QColor::fromRgb(qRgb(255, 0, 0));
}

int HeatmapProvider::getQmlValue() const {
    return qmlValue;
}

void HeatmapProvider::setQmlValue(int value) {
    if (qmlValue != value) {
        qmlValue = value;
        emit qmlValueChanged();
    }
}
