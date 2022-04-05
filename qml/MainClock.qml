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
    property real tmin: 0
    property real tsec: 0

    readonly property var configs: widget.settings.styles ? widget.settings.styles : {"Performance and Effectiveness":0,"Performance Settings":{"FPS of Gears":10,"Particle Speed":30,"Particle Visible":true},"Genshin Style":true,"Full Clock":false,"Single Clock Hand":true,"Swap Clock Hand":false,"Background Visible":true,"Background Opacity":100,"Gear Opacity":55}
    readonly property var alarms: widget.settings.alarm ? widget.settings.alarm : {}
    readonly property real gear_opacity: configs["Gear Opacity"]/100

    readonly property real mtime: thour*60+tmin
    readonly property real size: Math.min(width, height)
    property real g0_rotation: 1080

    property bool alarm_modify: false
    property real hourhand_anime_rotation: 0
    property real minhand_anime_rotation: 0
    property real alarm_initial_angle: 0
    property bool alarm_dialog_completed: false
    property bool alarm_close_anime_start: false
    property bool initial_visible: false

    FontLoader {
        id: genshinFont;
        source: "../Fonts/hk4e_zh-cn.ttf"
    }

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
                    running: widget.NVG.View.exposed && configs["Performance and Effectiveness"]
                    loops: Animation.Infinite
                }
            }

           Rectangle {
               width: 536
               height: 536
               anchors.centerIn: parent
               color: "transparent"
               visible: alarm_dialog_completed
               layer.enabled: true
               layer.effect: OpacityMask{
                    maskSource: rainbow_mask
               }

               Canvas {
                    id: rainbow_mask
                    contextType: "2d"
                    anchors.fill: parent
                    visible: false
                    onPaint: {
                        context.reset();
                        const cX = width/2;
                        const cY = height/2;
                        context.beginPath();
                        context.fillStyle = "white";
                        context.moveTo(cX, cY);
                        if (alarm_close_anime_start) {
                            context.arc(cX, cY, width, (90+min_hand.rotation)%360/180*Math.PI, (hour_hand.rotation+270)%360/180*Math.PI, false);
                        } else {
                            context.arc(cX, cY, width, (270+alarm_initial_angle)%360/180*Math.PI, (hour_hand.rotation+270)%360/180*Math.PI, false);
                        }
                        context.lineTo(cX, cY);
                        context.fill();
                    }
                }

               Rectangle {
                   width: 536
                   height: 536
                   anchors.centerIn: parent
                   color: "transparent"
                   layer.enabled: true
                   layer.effect: OpacityMask{
                       maskSource: Image{
                           width: 536
                           height: 536
                           source: "../Images/UI_Clock_TimeZone.png"
                       }
                   }

                   Image {
                       width: 1200
                       height: 1200
                       cache: true
                       anchors.centerIn: parent
                       source: "../Images/UI_Clock_TimeZoneColor.png"
                       autoTransform: true
                   }
               }
           }

            AnimatedImage {
                width: 540
                height: 540
                cache: true
                source: "../Images/star_particles.gif"
                anchors.centerIn: parent
                rotation: 360*Math.random()
                speed: configs["Performance and Effectiveness"] ? 1 : configs["Performance Settings"]["Particle Speed"]/100
                visible: !configs["Performance and Effectiveness"] ? configs["Performance Settings"]["Particle Visible"] : true
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
            visible: initial_visible && !(configs["Genshin Style"] && configs["Single Clock Hand"]) || alarm_dialog_completed

            onRotationChanged: {
                if (alarm_dialog_completed)
                    rainbow_mask.requestPaint();
            }
        }

        Image {
            id: hour_hand
            width: 1024
            height: 1024
            cache: true
            anchors.centerIn: parent
            source: "../Images/UI_Clock_HourHand.png"
            visible: initial_visible
            onRotationChanged: {
                if (alarm_dialog_completed)
                    rainbow_mask.requestPaint();
            }

            Rectangle {
                x: 452-15
                y: 274-40
                width: 150
                height: 200
                color: "transparent"//"red"
                opacity: 0.5
                MouseArea {
                    anchors.fill: parent
                    cursorShape: (alarm_dialog_completed && pressed) ? Qt.SizeAllCursor : Qt.ArrowCursor
                    enabled: alarm_dialog_completed && !hourhand_anime.running
                    onPositionChanged: {
                        if (!alarm_dialog_completed)
                            return;
                        if (!pressed)
                            return;
                        const point = mapToItem(hour_hand, mouse.x, mouse.y);
                        const diffX = (point.x - hour_hand.width/2);
                        const diffY = -1 * (point.y - hour_hand.height/2);
                        const deg = (Math.atan (diffY/diffX) * 180/Math.PI);
                        let delta_deg = 0;
                        if (diffX > 0) {
                            delta_deg = 90 - Math.abs (deg);
                        } else if (diffX < 0) {
                            delta_deg = -90 + Math.abs (deg);
                        }
                        let temp_hour_rotation = hour_hand.rotation + delta_deg;
                        if ((temp_hour_rotation - alarm_initial_angle) > 0 && (temp_hour_rotation - alarm_initial_angle) <= 360) {
                            hour_hand.rotation = temp_hour_rotation;
                            let date = new Date();
                            date.setHours(0, 4*(hour_hand.rotation-180));
                            alarmDialog.item.setTime(date);
                        }
                    }
                }
            }
        }
    }

    

    Timer {
        interval: Math.round(1000/configs["Performance Settings"]["FPS of Gears"])
        running: widget.NVG.View.exposed && !configs["Performance and Effectiveness"]
        repeat: true
        onTriggered: {
            g0_rotation -= 1080*interval/90000;
            if (g0_rotation < 0)
                g0_rotation = 1080
            gear0.rotation = g0_rotation;
        }

    }

    function wait_for_alarm_cfg_done() {
        if (alarm_modify) {
            if (!alarm_dialog_completed) {
                alarm_dialog_completed = true;
            }
        }
    }

    RotationAnimation{
        id: hourhand_anime
        target: hour_hand
        to: hourhand_anime_rotation
        easing.type: Easing.InOutQuad
        duration: 600
        running: false
        onRunningChanged: {
            if (!running) {
                wait_for_alarm_cfg_done();
            }
        }
    }

    RotationAnimation{
        id: minhand_anime
        target: min_hand
        to: minhand_anime_rotation
        easing.type: Easing.InOutQuad
        duration: 600
        running: false
        direction: RotationAnimation.Clockwise
        onRunningChanged: {
            if (!running) {
                wait_for_alarm_cfg_done();
                if (alarm_close_anime_start) {
                    handAnimeRotation();
                    alarm_modify = false;
                    alarm_dialog_completed = false;
                    alarm_close_anime_start = false;
                }
            }
        }
    }

    function handAnimeRotation() {
        if (configs["Genshin Style"]) {
            if (configs["Single Clock Hand"]) {
                hourhand_anime_rotation = 180+15*thour+tmin*0.25+tsec*0.004167;
            } else {
                hourhand_anime_rotation = 180+15*thour+tmin*0.25+tsec*0.004167;
                minhand_anime_rotation = tmin*6+tsec*0.1;
            }
        } else {
            const full_clock = configs["Full Clock"];
            if (!configs["Swap Clock Hand"]) {
                minhand_anime_rotation = (180+tmin*6+tsec*0.1) % 360;
                hourhand_anime_rotation = ((!full_clock)*30+full_clock*15)*thour+tmin*(0.5-full_clock*0.25)+tsec*(0.01-0.0058333*full_clock);
            } else {
                minhand_anime_rotation = 180+((!full_clock)*30+full_clock*15)*thour+tmin*(0.5-full_clock*0.25)+tsec*(0.01-0.0058333*full_clock);
                hourhand_anime_rotation = tmin*6+tsec*0.1;
            }
        }
        hourhand_anime.direction = RotationAnimation.Shortest;
        hourhand_anime.start();
        minhand_anime.start();
    }

    onConfigsChanged: {
        handAnimeRotation();
    }

    Timer {
        interval: 500
        running: widget.NVG.View.exposed && !hourhand_anime.running && !minhand_anime.running
        repeat: true
        readonly property real alarm_hour: {
            const date = new Date(alarms["Alarm Time"]);
            return date.getHours()
        }
        readonly property real alarm_minute: {
            const date = new Date(alarms["Alarm Time"]);
            return date.getMinutes()
        }
        property bool next_task: true
        onTriggered: {
            var now = new Date();
            tsec = now.getSeconds();
            tmin = now.getMinutes();
            thour = now.getHours();
            if (tmin==alarm_minute && thour==alarm_hour && next_task) {
                if (alarms["Enable Task"] && action.status) {
                    action.trigger(widget);
                    next_task = false;
                }
            } else if (!next_task && tmin!=alarm_minute) {
                next_task = true;
            }
            if (!alarm_modify) {
                if (configs["Genshin Style"]) {
                    if (configs["Single Clock Hand"]) {
                        hour_hand.rotation = 180+15*thour+tmin*0.25+tsec*0.004167;
                    } else {
                        hour_hand.rotation = 180+15*thour+tmin*0.25+tsec*0.004167;
                        min_hand.rotation = tmin*6+tsec*0.1;
                    }
                } else {
                    const full_clock = configs["Full Clock"];
                    if (!configs["Swap Clock Hand"]) {
                        min_hand.rotation = 180+tmin*6+tsec*0.1;
                        hour_hand.rotation = ((!full_clock)*30+full_clock*15)*thour+tmin*(0.5-full_clock*0.25)+tsec*(0.01-0.0058333*full_clock);
                    } else {
                        min_hand.rotation = 180+((!full_clock)*30+full_clock*15)*thour+tmin*(0.5-full_clock*0.25)+tsec*(0.01-0.0058333*full_clock);
                        hour_hand.rotation = tmin*6+tsec*0.1;
                    }
                }
            }
            if (!initial_visible)
                initial_visible = true;
        }
    }

    menu: Menu {
        Action {
            text: qsTr("Settings") + "..."
            enabled: !alarmDialog.active
            onTriggered: {
                styleDialog.active = true;
            }
        }

        Action {
            text: qsTr("Alarm Clock") + "..."
            enabled: !styleDialog.active
            onTriggered: {
                alarmDialog.active = true;
                const date = new Date(alarms["Alarm Time"]);
                minhand_anime_rotation = (15*date.getHours()+date.getMinutes()*0.25+date.getSeconds()*0.004167) % 360;
                minhand_anime.start();
                hourhand_anime_rotation = (180+minhand_anime_rotation) % 360;
                hourhand_anime.direction = RotationAnimation.Shortest;
                hourhand_anime.start();
                alarm_initial_angle = (hourhand_anime_rotation);
            }
        }
    }

    Loader {
        id: alarmDialog
        active: false
        sourceComponent: MainClockAlarmDialog {}
    }

    Loader {
        id: styleDialog
        active: false
        sourceComponent: MainClockStyleDialog {}
    }

    NVG.ActionSource {
        id: action
        configuration: alarms["action"]
    }
}
