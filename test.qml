import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import NERvGear 1.0 as NVG
import NERvGear.Templates 1.0 as T
import NERvGear.Preferences 1.0 as P

import QtQuick.Shapes 1.11

T.Widget {
    id: widget
    visible: true

 Rectangle {
        id: root
        anchors.fill: parent
        color: "#1f1f1f"

        ParticleSystem {
            id: myParticleSystem
        }

        Emitter {
            id: myEmitter
            system: myParticleSystem

            //发射器区域宽和高
            width: 240
            height: parent.height

            //发射频率每秒500个元素
            emitRate: 500
            //每个元素的生命周期是1000毫秒
            lifeSpan: 1000
            //每个元素的大小是16*16像素
            size: 16
        }

        ImageParticle {
            system: myParticleSystem
            //Qt自带粒子图，可以换成自定义图片
            source: "images/UI_ClockIcon_Noon.png"
            //粒子图使用白色
            color: "white"
        }

    }
}
