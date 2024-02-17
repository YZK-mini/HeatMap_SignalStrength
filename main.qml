import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Helpers
import HeatMap

Window{
    // 基础属性
    id: window
    width: 1470
    height: 720
    visible: true
    title: "3D热力图"

    property real fontSize: 12
    property bool whichsig: true
    property bool set: false

    // 左侧显示静态模型及切面位置
    View3D{
        id: s3dshow
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.height
        height: parent.height
        camera: showCamera
        environment: sceneEnvironment

        // 视角摄像机
        PerspectiveCamera{
            id: showCamera
            clipNear: 1
            clipFar: 100000
            position: Qt.vector3d(2050,2500,2050)
            eulerRotation: Qt.vector3d(-45,45,0)

            onPositionChanged: {
                showCamera.lookAt(zftip.position)
            }
        }

        WasdController{
            id: cameramove
            controlledObject: showCamera
            // 摄像头移动速度
            speed: 3
            // 禁用视角拖动
            mouseEnabled: false
            // 按住shift加速的速度
            shiftSpeed: 4
            // 限制摄像头高度
            downSpeed: (showCamera.position.y > 1250) ? 3 : 0
        }

        // 实际模型
        RootModel{
            id: rootmodel
            trans: colormapcheck.checked
        }

        // 切片帧位置标示
        Model {
            id: zftip
            pickable: false
            source: "#Cube"
            position: Qt.vector3d(0,0,0)
            scale: Qt.vector3d(25.2, 25.2, 0.0001)
            eulerRotation: Qt.vector3d(-90,0,0)
            materials: colormapcheck.checked ? colorshow : unshow

            // 不显示热力图时的切片帧材质
            DefaultMaterial {
               id: unshow
               emissiveFactor: Qt.vector3d(0.0,0.0,0.0)
               opacity: 0.3
            }
            // 显示热力图时的切片帧材质
            DefaultMaterial {
                id: colorshow
                emissiveMap:Texture{
                    sourceItem: heatmapchange
                }
                emissiveFactor: Qt.vector3d(1.0,1.0,1.0)
            }
        }

        // 移动备注
        Text {
            id: movementtips
            font.pointSize: fontSize
            anchors.top: parent.top
            anchors.right: parent.right
            text: qsTr("通过W、A、S、D、F、R等键转动视角")
            color: "black"
        }

        // 切片帧备注
        Text {
            id: frametips
            font.pointSize: fontSize
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            text: qsTr("z方向截面为灰色\n截面高度为:%1m").arg(zframectl.value/10)
            color: "black"
        }

        // 信号源位置标示
        Model{
            id: signalsource
            visible: sourcecheck.checked
            source: "#Sphere"
            position: Qt.vector3d(0,-100,0)
            scale: Qt.vector3d(0.3,0.3,0.3)
            pickable: false

            // 信号源材质设置
            materials: [
                smaterial1
            ]
        }

        // 信号源位置标示
        Model{
            id: signalsource2
            visible: (sourcecheck.checked & secondsig.checked)
            source: "#Sphere"
            position: Qt.vector3d(0,-100,0)
            scale: Qt.vector3d(0.3,0.3,0.3)
            pickable: false

            // 信号源材质设置
            materials: [
                smaterial2
            ]
        }

        // 信号源位置备注
        Text {
            id: signalsourcePostip1
            font.pointSize: fontSize
            anchors.top: parent.top
            anchors.left: parent.left
            text: qsTr("第一信号源位置为:未设置")
            color: "black"
        }

        // 信号源2位置备注
        Text {
            id: signalsourcePostip2
            font.pointSize: fontSize
            anchors.top: signalsourcePostip1.bottom
            anchors.left: parent.left
            visible: secondsig.checked
            text: qsTr("第二信号源位置为:未设置")
            color: "black"
        }
    }

    // 暂无显示的备注
    Text {
        id: noheatmaptip
        text: qsTr("暂无结果")
        font.pointSize: fontSize * 2
        x: 1100
        y: 280
    }

    // 当前切片帧热力图
    Image {
        id: heatmapchange
        width: 600
        height: 600
        anchors.top: parent.top
        anchors.right: parent.right
        source: ""
        cache: false
    }

    // 热力图标尺
    Image {
        id: rulermap
        width: 600
        height: 100
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        source: "heatmaps/ruler.png"
    }

    // 右侧控制面板及切面和热力图
    Rectangle {
        id: showlayout
        anchors.top: parent.top
        anchors.left: s3dshow.right
        width: 120
        height: parent.height
        color: "gray"
        ColumnLayout{
            anchors.fill: parent
            Label {
                font.pointSize: fontSize
                font.bold: true
                text: "调整z轴截面"
            }

            // 用于调整切片帧高度的Slider组件
            Slider {
                id: zframectl
                value: 0
                from: 0
                to: 1240
                stepSize: 10
                rotation: -90

                background: Rectangle {
                    x: zframectl.leftPadding
                    y: zframectl.topPadding + zframectl.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: zframectl.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#bdbebf"

                    Rectangle {
                        width: zframectl.visualPosition * parent.width
                        height: parent.height
                        color: "#21be2b"
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: zframectl.leftPadding + zframectl.visualPosition * (zframectl.availableWidth - width)
                    y: zframectl.topPadding + zframectl.availableHeight / 2 - height / 2
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: 13
                    color: zframectl.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                }

                onValueChanged: {
                    // 修改切片帧位置
                    zftip.position.y = value
                    showCamera.lookAt(zftip.position)
                    cameramove.focus = true
                }

                onPressedChanged: {
                    // 传递切片帧高度
                    heatmap.qmlValue = Math.round(value/10)
                    // 绘制对应高度的热力图
                    heatmap.generateHeatmapImage()
                }
            }

            // 用于进入选择信号源模式的按钮
            Button{
                id: enter3dmode1
                text: "选择信号源位置"
                height: 40
                width: 100
                onClicked: {
                    firstView.checked = true
                    window3d.visible = true
                    whichsig = true
                }
            }

            // 用于选择是否有第二信号源的CheckBox
            CheckBox{
                id: secondsig
                text: qsTr("第二信号源")
                checkState: Qt.Unchecked
                onCheckedChanged: {
                    cameramove.focus = true
                }
            }

            // 用于进入选择信号源模式的按钮
            Button {
                id: enter3dmode2
                text: "选择第二信号源位置"
                visible: secondsig.checked
                height: 40
                width: 100
                onClicked: {
                    firstView.checked = true
                    window3d.visible = true
                    whichsig = false
                }
            }

            // 用于进入选择信号源模式的按钮
            Button {
                id: startcal
                text: "启动仿真"
                height: 40
                width: 100
                onClicked: {
                    protip.title = "仿真计算中......"
                    protip.visible = true
                    calculation.calbool = calculation.calbool + 1;
                }
            }

            // 用于选择是否显示热力图的CheckBox
            CheckBox{
                id: colormapcheck
                text: qsTr("显示热力图")
                checkState: Qt.Unchecked
                onCheckedChanged: {
                    cameramove.focus = true
                }
            }

            // 用于选择是否显示信号源的CheckBox
            CheckBox{
                id: sourcecheck
                text: qsTr("显示信号源")
                checkState: Qt.Checked
                onCheckedChanged: {
                    cameramove.focus = true
                }
            }
        }
    }

    // 切换至全屏3D选择基站位置 mode1
    Window{
        id: window3d
        visible: false
        width: 800
        height: 800
        title: "选择信号源位置"

        // 3D可移动窗口
        View3D{
            id:showmodel
            objectName: "3dmodel"
            width: parent.width
            height: parent.height
            anchors.fill: parent
            // 绑定摄像头
            camera: {
                if (firstView.checked){
                    if(whichsig){
                        firstViewCamera1
                    }
                    else{
                        firstViewCamera2
                    }
                }
                else{
                    godViewCamera
                }
            }
            // 绑定环境
            environment: sceneEnvironment

            // 基础模型
            RootModel{
                id: showrootmodel
                trans: godView.checked
            }

            // 环境
            SceneEnvironment {
                id: sceneEnvironment
                antialiasingMode: SceneEnvironment.MSAA
                antialiasingQuality: SceneEnvironment.VeryHigh
                backgroundMode: SceneEnvironment.Transparent
            }

            // 第一人称视角摄像头 mode1
            PerspectiveCamera{
                id: firstViewCamera1
                position: Qt.vector3d(2050,2500,2050)
                eulerRotation: Qt.vector3d(-45,45,0)
                clipNear: 1
                clipFar: 100000
                fieldOfView: 60
                onPositionChanged: {
                    camera_position.text =
                            qsTr("当前坐标: (%1, %2, %3)").arg(firstViewCamera1.position.x/10).arg(firstViewCamera1.position.y/10).arg(firstViewCamera1.position.z/10)
                }
            }

            // 第一人称视角摄像头 mode2
            PerspectiveCamera{
                id: firstViewCamera2
                position: Qt.vector3d(2050,2500,2050)
                eulerRotation: Qt.vector3d(-45,45,0)
                clipNear: 1
                clipFar: 100000
                fieldOfView: 60
                onPositionChanged: {
                    camera_position.text =
                            qsTr("当前坐标: (%1, %2, %3)").arg(firstViewCamera2.position.x/10).arg(firstViewCamera2.position.y/10).arg(firstViewCamera2.position.z/10)
                }
            }

            // 上帝视角摄像头
            PerspectiveCamera{
                id: godViewCamera
                position: Qt.vector3d(2000,2450,2000)
                eulerRotation: Qt.vector3d(-45,45,0)
                clipNear: 1
                clipFar: 100000
                fieldOfView: 60
            }

            // 信号源位置标示
            Model{
                id: signalmodel1
                source: "#Sphere"
                position: firstViewCamera1.position
                scale: Qt.vector3d(0.3,0.3,0.3)
                pickable: false
                visible: {
                    if (whichsig){
                        firstView.checked ? false : true
                    }
                    else{
                        true
                    }
                }

                // 信号源材质设置
                DefaultMaterial{
                    id: smaterial1
                    emissiveFactor: Qt.vector3d(1.0,0.0,0.0)
                }
                materials: [
                    smaterial1
                ]
            }

            // 信号源位置标示
            Model{
                id: signalmodel2
                source: "#Sphere"
                position: firstViewCamera2.position
                scale: Qt.vector3d(0.3,0.3,0.3)
                pickable: false
                visible: {
                    if (whichsig){
                        if (secondsig){
                            true
                        }
                        else{
                            false
                        }
                    }
                    else{
                        firstView.checked ? false : true
                    }
                }

                // 信号源材质设置
                DefaultMaterial{
                    id: smaterial2
                    emissiveFactor: Qt.vector3d(1.0,1.0,0.0)
                }
                materials: [
                    smaterial2
                ]
            }

            // 左下角提示
            Text{
                id: movetips
                text: qsTr("W前进\nS向后\nA向左\nD向右\nR向上\nF向下\n按住shift加速")
                color: "black"
                anchors.left: showmodel.left
                anchors.bottom: showmodel.bottom
            }

            // 左上角摄像头坐标
            Text{
                id: camera_position
                text: qsTr("")
                color: "black"
                anchors.left: showmodel.left
                anchors.top: showmodel.top
                width: showmodel.width/8
                height: showmodel.height/8
            }

            // 摄像头移动控制
            WasdController{
                id: firstViewMove
                controlledObject: whichsig ? firstViewCamera1:firstViewCamera2
                // 摄像头移动速度
                speed: 3
                // 视角转动速度
                xSpeed: 2
                ySpeed: 2
                // 按住shift加速的速度
                shiftSpeed: 5
            }

            // 供C++计算时调用，判断是否遮挡
            function raycheck1(pos){
                // 计算信号源指向当前位置的方向
                var direction = pos.minus(signalsource.position)
                // 获取两点连线与模型的相交信息
                var temp = showmodel.rayPick(signalsource.position, direction.normalized())
                // 判断信号源与当前位置之中是否有模型阻挡
                var check = ((temp.distance >= direction.length()) || (!temp.objectHit))

                // 遮挡为false，无遮挡为true
                return check
            }
            function raycheck2(pos){
                // 计算信号源指向当前位置的方向
                var direction = pos.minus(signalsource2.position)
                // 获取两点连线与模型的相交信息
                var temp = showmodel.rayPick(signalsource2.position, direction.normalized())
                // 判断信号源与当前位置之中是否有模型阻挡
                var check = ((temp.distance >= direction.length()) || (!temp.objectHit))

                // 遮挡为false，无遮挡为true
                return check
            }
        }

        // 切换视角
        Column{
            id:col1
            anchors.top: parent.top
            anchors.right: parent.right
            RadioButton {
                id: firstView
                checked: true
                text: qsTr("第一人称视角")
                onCheckedChanged: {
                    firstViewMove.focus = true
                }
            }
            RadioButton{
                id:godView
                checked: false
                text: qsTr("上帝视角")
                onCheckedChanged: {
                    firstViewMove.focus = true
                }
            }
        }

        // 选定按钮
        Button{
            id: decision
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width/8
            height: parent.height/16
            text: "选定当前位置"

            // 选定位置后修改相关参数，触发信号强度计算
            onClicked: {
                window3d.visible = false
                if (whichsig){
                    signalsource.position = firstViewCamera1.position
                    calculation.signalpos[0] = signalsource.position
                    signalsourcePostip1.text =
                            qsTr("第一信号源位置为:(%1,%2,%3)").arg(signalsource.position.x/10).arg(signalsource.position.y/10).arg(signalsource.position.z/10)
                }
                else{
                    signalsource2.position = firstViewCamera2.position
                    calculation.signalpos[1] = signalsource2.position
                    signalsourcePostip2.text =
                            qsTr("第二信号源位置为:(%1,%2,%3)").arg(signalsource2.position.x/10).arg(signalsource2.position.y/10).arg(signalsource2.position.z/10)
                    set = true
                }
            }
        }
    }

    // 此组件用于计算三维空间各处信号强度
    SignalCal{
        id: calculation
        signum: (secondsig.checked & set) ? 2:1

        // 当计算完成后，会触发提示窗口的修改
        onProcessChanged: {
            if (process === 1){
                protip.title = "仿真计算完成"
                process = 0
            }
        }
    }

    // 仿真状态提示窗口
    Window{
        id: protip
        width: 250
        height: 1
        visible: false
        title: "仿真计算中......"
    }

    // 此组件用于生成QImage
    HeatmapProvider{
        id: heatmap
    }

    // 当热力图绘制完成后，会重新加载图片
    // 此组件与C++中的showImage类型变量链接
    Connections{
        target: CodeImage;
        function onCallQmlRefeshImg()
        {
            heatmapchange.source =""
            heatmapchange.source = "image://CodeImg"
        }
    }

}
