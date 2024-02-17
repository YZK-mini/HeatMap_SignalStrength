import QtQuick
import QtQuick3D
import MyComponents

// 调用C++程序获取空间信号分布
Item {
    property var signalpos: [Qt.vector3d(0, 0, 0),Qt.vector3d(0, -100, 0)]
    property int calbool: 0
    property int process: 0
    property int signum: 1

    // 调用C++创建的组件
    MyCalculator {
        id: myCalculator
        num: signum
    }

    // 信号源位置选定，开始在C++函数进行计算
    onCalboolChanged: {
        myCalculator.calculateResults(signalpos);
        process = 1;
    }
}
