import QtQuick
import QtQuick3D

// 建模载入
Node {
    property bool trans: false
    scale: Qt.vector3d(0.25,0.25,0.25)

    // 山的模型
    Model {
        id: _
        x: 2030.42
        z: -1420.69

        rotation: Qt.quaternion(0.707107, -0.707107, 0, 0)
        scale: Qt.vector3d(-1948.84,-1948.84,-1948.84)
        source: "meshes/_.mesh"
        pickable: true

        DefaultMaterial {
            id: ___006_material
            diffuseColor: "#ff02cc00"
            emissiveMap: Texture{
                source: "maps/Mont.png"
                scaleU: 1.0
                scaleV: 1.0
            }
            emissiveFactor: Qt.vector3d(1.0, 1.0, 1.0)
        }

        DefaultMaterial {
            id: ___006_material_t
            diffuseColor: "#ff02cc00"
            emissiveMap: Texture{
                source: "maps/Mont.png"
                scaleU: 1.0
                scaleV: 1.0
            }
            emissiveFactor: Qt.vector3d(1.0, 1.0, 1.0)
            opacity: 0.5
        }
        materials: trans ? ___006_material_t : ___006_material
    }

    // 海洋的模型
    Model {
        id: __1
        rotation: Qt.quaternion(0.707107, -0.707107, 0, 0)
        scale: Qt.vector3d(-5057.21,-5057.21,-5057.21)
        source: "meshes/__1.mesh"
        pickable: true

        DefaultMaterial {
            id: ___material
            diffuseColor: "#ff0610cc"
            emissiveMap: Texture{
                source: "maps/Ocean.png"
                scaleU: 8.0
                scaleV: 8.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.4, 0.4)
        }

        DefaultMaterial {
            id: ___material_t
            diffuseColor: "#ff0610cc"
            emissiveMap: Texture{
                source: "maps/Ocean.png"
                scaleU: 8.0
                scaleV: 8.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.4, 0.4)
            opacity: 0.5
        }

        materials: trans ? ___material_t : ___material
    }

    // 船的模型
    Model {
        id: __004
        x: -1543.37
        y: 363.112
        z: -1013.59
        rotation: Qt.quaternion(0.124711, -0.124711, 0.696023, 0.696022)
        scale: Qt.vector3d(933.253,933.253,933.253)
        source: "meshes/__004.mesh"
        pickable: true

        DefaultMaterial {
            id: ___001_material
            diffuseColor: "#ffcc5b01"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.35686, 0.003922)
        }

        DefaultMaterial {
            id: ___001_material_t
            diffuseColor: "#ffcc5b01"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.35686, 0.003922)
            opacity: 0.5
        }

        materials: trans ? ___001_material_t : ___001_material
    }

    // 船的模型
    Model {
        id: __005
        x: 5997.47
        y: 293.022
        z: 1228.09
        rotation: Qt.quaternion(0.124711, -0.124711, 0.696023, 0.696022)
        scale: Qt.vector3d(1866.5,1866.5,1866.5)
        source: "meshes/__005.mesh"
        pickable: true

        DefaultMaterial {
            id: ___004_material
            diffuseColor: "#ffcc6501"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.3961, 0.003922)
        }

        DefaultMaterial {
            id: ___004_material_t
            diffuseColor: "#ffcc6501"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.3961, 0.003922)
            opacity: 0.5
        }

        materials: trans ? ___004_material_t : ___004_material
    }

    // 船的模型
    Model {
        id: __006
        x: -490.131
        y: 279.782
        z: 1641.24
        rotation: Qt.quaternion(-0.139903, 0.139903, 0.693129, 0.693128)
        scale: Qt.vector3d(933.253,933.253,933.253)
        source: "meshes/__006.mesh"
        pickable: true

        DefaultMaterial {
            id: ___003_material
            diffuseColor: "#ffccb502"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.7098, 0.007843)
        }

        DefaultMaterial {
            id: ___003_material_t
            diffuseColor: "#ffccb502"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.7098, 0.007843)
            opacity: 0.5
        }

        materials: trans ? ___003_material_t : ___003_material
    }

    // 船的模型
    Model {
        id: __007
        x: -886.988
        y: 364.862
        z: -5182.49
        rotation: Qt.quaternion(-0.139903, 0.139903, 0.693129, 0.693128)
        scale: Qt.vector3d(1300,1300,1300)
        source: "meshes/__007.mesh"
        pickable: true

        DefaultMaterial {
            id: ___005_material
            diffuseColor: "#ff835c18"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.513725, 0.3607843, 0.0941)
        }

        DefaultMaterial {
            id: ___005_material_t
            diffuseColor: "#ff835c18"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.513725, 0.3607843, 0.0941)
            opacity: 0.5
        }

        materials: trans ? ___005_material_t : ___005_material
    }

    // 船的模型
    Model {
        id: __008
        x: -4309.59
        y: 279.689
        z: 3749.48
        rotation: Qt.quaternion(0.705384, -0.705384, 0.0493252, 0.0493252)
        scale: Qt.vector3d(933.253,933.253,933.253)
        source: "meshes/__008.mesh"
        pickable: true

        DefaultMaterial {
            id: ___002_material
            diffuseColor: "#ffcc7702"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.4667, 0.007843)
        }

        DefaultMaterial {
            id: ___002_material_t
            diffuseColor: "#ffcc7702"
            emissiveMap: Texture{
                source: "maps/Mental.png"
                scaleU: 2.0
                scaleV: 2.0
            }
            emissiveFactor: Qt.vector3d(0.8, 0.4667, 0.007843)
            opacity: 0.5
        }

        materials: trans ? ___002_material_t : ___002_material
    }
}
