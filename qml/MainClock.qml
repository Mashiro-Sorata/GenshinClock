import QtQuick 2.12
import QtQuick.Controls 2.12

import QtGraphicalEffects 1.0

import NERvGear 1.0 as NVG
import NERvGear.Controls 1.0
import NERvGear.Templates 1.0 as T


T.Widget {
    id: widget
    visible: true
    solid: true
    title: qsTr("Genshin Clock Widget")

    property real thour: 0
    property real t12hour: 0
    property real tmin: 0
    property real tsec: 0

    readonly property var configs: widget.settings.styles ? widget.settings.styles : {"Performance and Effectiveness":0,"Performance Settings":{"FPS of Gears":10,"Particle Speed":30,"Particle Visible":true},"Genshin Style":true,"Full Clock":false,"Single Clock Hand":true,"Reverse Clock Hand":false,"Background Visible":true,"Background Opacity":100,"Gear Opacity":55}
    readonly property real gear_opacity: configs["Gear Opacity"]/100

    readonly property real mtime: thour*60+tmin
    readonly property real size: Math.min(width, height)
    property real g0_rotation: 1080

    Item {
        anchors.fill: parent
        scale: size*0.95/1200

        Rectangle {
            width: 540
            height: 540
            anchors.centerIn: parent
            color: "transparent"
            layer.enabled: true
            layer.effect: OpacityMask{
                maskSource: Rectangle{
                    width: 540
                    height: 540
                    radius: 270
                }
            }

            Image {
                width: 590
                height: 590
                cache: true
                anchors.centerIn: parent
                source: "../Images/UI_Img_HoroscopeBg.png"
                autoTransform: true
                rotation: gear0.rotation/3
                opacity: configs["Background Opacity"]/100
                visible: configs["Background Visible"]
            }

            Image {
                width: 465
                height: 465
                cache: true
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -125
                anchors.verticalCenterOffset: 360
                source: "../Images/UI_Img_Horoscope04.png"
                autoTransform: true
                opacity: gear_opacity*0.273
                rotation: -gear0.rotation/3
            }

            Image {
                width: 525
                height: 525
                cache: true
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 65
                anchors.verticalCenterOffset: -41
                source: "../Images/UI_Img_Horoscope03.png"
                autoTransform: true
                opacity: gear_opacity
                rotation: gear0.rotation/3
            }

            Image {
                id: gear1
                width: 465
                height: 465
                cache: true
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -84
                anchors.verticalCenterOffset: 48
                source: "../Images/UI_Img_Horoscope04.png"
                autoTransform: true
                opacity: gear_opacity
                rotation: gear0.rotation/3
            }

            Image {
                width: 290
                height: 290
                cache: true
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 262
                anchors.verticalCenterOffset: 150
                source: "../Images/UI_Img_Horoscope05.png"
                autoTransform: true
                opacity: gear_opacity
                rotation: -gear1.rotation*1.5+2
            }

            Image {
                width: 160
                height: 160
                cache: true
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 262
                anchors.verticalCenterOffset: 150
                source: "../Images/UI_Img_Horoscope06.png"
                autoTransform: true
                opacity: gear_opacity/2
                rotation: gear1.rotation*1.5+2
            }

            Image {
                width: 160
                height: 160
                cache: true
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 125
                anchors.verticalCenterOffset: -275
                source: "../Images/UI_Img_Horoscope06.png"
                autoTransform: true
                opacity: gear_opacity
                rotation: gear0.rotation
            }

            Image {
                id: gear0
                width: 150
                height: 150
                cache: true
                anchors.centerIn: parent
                source: "../Images/UI_Img_Horoscope06.png"
                autoTransform: true
                opacity: gear_opacity
                rotation: 0
                RotationAnimation on rotation {
                    from: 1080
                    to: 0
                    duration: 90000
                    running: widget.NVG.View.exposed && !configs["Performance and Effectiveness"]
                    loops: Animation.Infinite
                }
            }

            AnimatedImage {
                width: 540
                height: 540
                cache: true
                source: "../Images/star_particles.gif"
                anchors.centerIn: parent
                rotation: 360*Math.random()
                speed: !configs["Performance and Effectiveness"] ? 1 : configs["Performance Settings"]["Particle Speed"]/100
                visible: configs["Performance Settings"]["Particle Visible"]
                playing: visible
            }
        }

        Image {
            width: 1200
            height: 1200
            cache: true
            anchors.centerIn: parent
            source: "../Images/Clock_BG.png"
            opacity: 0.4
            autoTransform: true
        }

        Image {
            id: clock_anchors
            width: 1024
            height: 1024
            cache: true
            anchors.centerIn: parent
            source: "../Images/UI_Clock_Dial.png"
            opacity: 1
            autoTransform: true
        }

        Image {
            id: morning_icon
            width: 168
            height: 1024
            cache: true
            anchors.left: clock_anchors.left
            anchors.verticalCenter: clock_anchors.verticalCenter
            source: "../Images/UI_ClockIcon_Morning.png"
            opacity: Math.sqrt(Math.max(0, (1-(mtime-360)**2/129600)))
        }

        Image {
            id: noon_icon
            width: 1024
            height: 168
            cache: true
            anchors.top: clock_anchors.top
            anchors.horizontalCenter: clock_anchors.horizontalCenter
            source: "../Images/UI_ClockIcon_Noon.png"
            opacity: Math.sqrt(Math.max(0, 1-(mtime-720)**2/129600))
        }

        Image {
            id: dusk_icon
            width: 168
            height: 1024
            cache: true
            anchors.right: clock_anchors.right
            anchors.verticalCenter: clock_anchors.verticalCenter
            source: "../Images/UI_ClockIcon_Dusk.png"
            opacity: Math.sqrt(Math.max(0, 1-(mtime-1080)**2/129600))
        }

        Image {
            id: night_icon
            width: 1024
            height: 168
            cache: true
            anchors.bottom: clock_anchors.bottom
            anchors.horizontalCenter: clock_anchors.horizontalCenter
            source: "../Images/UI_ClockIcon_Night.png"
            opacity: (mtime>=1080)*Math.sqrt((1-(1440-mtime)**2/129600)) || (mtime<360)*Math.sqrt(1-mtime**2/129600)
        }

        Image {
            id: min_hand
            width: 1024
            height: 1024
            cache: true
            anchors.centerIn: parent
            source: "../Images/UI_Clock_MinuteHand.png"
            visible: !(configs["Genshin Style"] && configs["Single Clock Hand"])
        }

        Image {
            id: hour_hand
            width: 1024
            height: 1024
            cache: true
            anchors.centerIn: parent
            source: "../Images/UI_Clock_HourHand.png"

            Rectangle {
                x: 452
                y: 274
                width: 120
                height: 240
                color: "red"
                opacity: 0.5
                MouseArea {
                    anchors.fill: parent
                    property bool isdragging: false
                    cursorShape: pressed ? Qt.SizeAllCursor : Qt.ArrowCursor
                    onPressed: {
                        console.log("pressed!");
                    }
                    
                    onPositionChanged: {
                        if (!pressed)
                                return;
                        const date = new Date;
                        alarmDialog.item.setTime(date);
                        let point = mapToItem(hour_hand, mouse.x, mouse.y);
                        let diffX = (point.x - hour_hand.width/2); 
                        let diffY = -1 * (point.y - hour_hand.height/2);
                        let rad = Math.atan (diffY/diffX);
                        let deg = (rad * 180/Math.PI);
                        // if (diffX > 0 && diffY > 0) { 
                        //     rect.rotation = 90 - Math.abs (deg); 
                        // } 
                        // else if (diffX > 0 && diffY < 0) { 
                        //     rect.rotation = 90 + Math.abs (deg); 
                        // } 
                        // else if (diffX < 0 && diffY > 0) { 
                        //     rect.rotation = 270 + Math.abs (deg); 
                        // } 
                        // else if (diffX < 0 && diffY < 0) { 
                        //     rect.rotation = 270 - Math.abs (deg); 
                        // } 

                    }
                }
            }
        }
    }

    

    Timer {
        interval: Math.round(1000/configs["Performance Settings"]["FPS of Gears"])
        running: widget.NVG.View.exposed && configs["Performance and Effectiveness"]
        repeat: true
        onTriggered: {
            g0_rotation -= 1080*interval/90000;
            if (g0_rotation < 0)
                g0_rotation = 1080
            gear0.rotation = g0_rotation;
        }

    }

    Timer {
        interval: 500
        running: widget.NVG.View.exposed
        repeat: true
        onTriggered: {
            var now = new Date();
            tsec = now.getSeconds();
            tmin = now.getMinutes();
            thour = now.getHours();

            if (configs["Genshin Style"]) {
                if (configs["Single Clock Hand"]) {
                    hour_hand.rotation = 180+15*thour+tmin*0.25+tsec*0.004167;
                } else {
                    if (!configs["Reverse Clock Hand"]) {
                        hour_hand.rotation = 180+15*thour+tmin*0.25+tsec*0.004167;
                        min_hand.rotation = tmin*6+tsec*0.1;
                    } else {
                        hour_hand.rotation = 180+tmin*6+tsec*0.1;
                        min_hand.rotation = 15*thour+tmin*0.25+tsec*0.004167;
                    }
                }
            } else {
                let full_clock = configs["Full Clock"];
                if (!full_clock)
                    t12hour = thour > 12 ? thour - 12 : thour;
                if (!configs["Reverse Clock Hand"]) {
                    min_hand.rotation = 180+tmin*6+tsec*0.1;
                    hour_hand.rotation = ((!full_clock)*30+full_clock*15)*thour+tmin*(0.5-full_clock*0.25)+tsec*(0.01-0.0058333*full_clock);
                } else {
                    min_hand.rotation = 180+((!full_clock)*30+full_clock*15)*thour+tmin*(0.5-full_clock*0.25)+tsec*(0.01-0.0058333*full_clock);
                    hour_hand.rotation = tmin*6+tsec*0.1;
                }
            }
        }
    }

    menu: Menu {
        Action {
            text: qsTr("Settings") + "..."
            onTriggered: styleDialog.active = true
        }

        Action {
            text: qsTr("Alarm Clock") + "..."
            onTriggered: alarmDialog.active = true
        }
    }

    Loader {
        id: alarmDialog
        active: false
        sourceComponent: MainAlarmDialog {
            
        }
    }

    Loader {
        id: styleDialog
        active: false
        sourceComponent: MainClockDialog {}
    }
}
