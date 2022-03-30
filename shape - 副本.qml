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

    readonly property real size: Math.max(widget.height, widget.width) * 0.95
    readonly property real maxr: 512

    property real thour: 0
    property real tmin: 0
    property real tsec: 0
    property real tmsec: 0

    

    Image {
        width: size
        height: size
        anchors.centerIn: parent
        source: "images/UI_Img_Horoscope01.png"
        autoTransform: true
    }

    Image {
        width: size*426/maxr
        height: size*426/maxr
        anchors.centerIn: parent
        source: "images/UI_Img_Horoscope02.png"
        autoTransform: true
    }

    Image {
        width: size*574/maxr
        height: size*574/maxr
        anchors.centerIn: parent
        source: "images/UI_Clock_Dial.png"
        autoTransform: true
    }

    Image {
        id: hour_hand
        width: size*50/maxr
        height: size*125/maxr
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: size*0.15/maxr
        anchors.verticalCenterOffset: -size*38.5/maxr
        source: "images/UI_Clock_HourHand.png"
        transform: Rotation {
            //设置图像原点
            origin.x: size*25.15/maxr
            origin.y: hour_hand.height*0.8
            angle: tsec*24
        }
    }

    Timer {
        interval: 50
        running: widget.NVG.View.exposed
        repeat: true
        onTriggered: {
            var now = new Date();
            tmsec = now.getMilliseconds();
            tsec = now.getSeconds();
            tmin = now.getMinutes();
            thour = now.getHours();
            thour = thour > 12 ? thour - 12 : thour;
            tsec += tmsec/1000;
        }
    }
}
