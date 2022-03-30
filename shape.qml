import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtGraphicalEffects 1.0

import NERvGear 1.0 as NVG
import NERvGear.Templates 1.0 as T
import NERvGear.Preferences 1.0 as P

//import QtQuick.Shapes 1.11

T.Widget {
    id: widget
    visible: true
    solid: true
    title: qsTr("Genshin Clock")

    property real thour: 0
    property real t12hour: 0
    property real tmin: 0
    property real tsec: 0
    property real tmsec: 0

//    readonly property bool full_clock: widget.settings.styles? widget.settings.styles["Full Clock"] : true
//    readonly property bool hand_reversed: widget.settings.styles? widget.settings.styles["Reverse Clock Hand"] : false

    readonly property var configs: widget.settings.styles ? widget.settings.styles : {"Full Clock": true, "Reverse Clock Hand": false, "Background Visible": true, "Background Opacity": 100, "Gear Opacity": 55, "Particle Visible": true}
    readonly property real gear_opacity: configs["Gear Opacity"]/100

    Item {
        anchors.centerIn: parent
        width: widget.width
        height: widget.height
        scale: Math.min(widget.height, widget.width)*0.95/1200

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
                anchors.centerIn: parent
                source: "images/UI_Img_HoroscopeBg.png"
                autoTransform: true
                rotation: gear0.rotation/3
                opacity: configs["Background Opacity"]/100
                visible: configs["Background Visible"]
            }

            Image {
                width: 465
                height: 465
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -125
                anchors.verticalCenterOffset: 360
                source: "images/UI_Img_Horoscope04.png"
                autoTransform: true
                opacity: gear_opacity*0.273
                rotation: -gear0.rotation/3
            }

            Image {
                width: 525
                height: 525
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 65
                anchors.verticalCenterOffset: -41
                source: "images/UI_Img_Horoscope03.png"
                autoTransform: true
                opacity: gear_opacity
                rotation: gear0.rotation/3
            }

            Image {
                id: gear1
                width: 465
                height: 465
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -84
                anchors.verticalCenterOffset: 48
                source: "images/UI_Img_Horoscope04.png"
                autoTransform: true
                opacity: gear_opacity
                rotation: gear0.rotation/3
            }

            Image {
                width: 290
                height: 290
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 262
                anchors.verticalCenterOffset: 150
                source: "images/UI_Img_Horoscope05.png"
                autoTransform: true
                opacity: gear_opacity
                rotation: -gear1.rotation*1.5+2
            }

            Image {
                width: 160
                height: 160
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 262
                anchors.verticalCenterOffset: 150
                source: "images/UI_Img_Horoscope06.png"
                autoTransform: true
                opacity: gear_opacity/2
                rotation: gear1.rotation*1.5+2
            }

            Image {
                width: 160
                height: 160
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 125
                anchors.verticalCenterOffset: -275
                source: "images/UI_Img_Horoscope06.png"
                autoTransform: true
                opacity: gear_opacity
                rotation: gear0.rotation
            }

            Image {
                id: gear0
                width: 150
                height: 150
                anchors.centerIn: parent
                source: "images/UI_Img_Horoscope06.png"
                autoTransform: true
                opacity: gear_opacity
                RotationAnimation on rotation {
                    from: 1080
                    to: 0
                    duration: 90000
                    running: widget.NVG.View.exposed
                    loops: Animation.Infinite
                }
            }

            AnimatedImage {
                width: 540
                height: 540
                source: "images/star_particles.gif"
                anchors.centerIn: parent
                rotation: 360*Math.random()
                speed: 1
                visible: configs["Particle Visible"]
            }
        }

        Image {
            width: 1200
            height: 1200
            anchors.centerIn: parent
            source: "images/UI_Img_Horoscope01.png"
            opacity: 0.4
            autoTransform: true
        }

        Image {
            id: clock_anchors
            width: 1024
            height: 1024
            anchors.centerIn: parent
            source: "images/UI_Img_Horoscope02.png"
            opacity: 0.4
            autoTransform: true
        }

        Image {
            width: 1024
            height: 1024
            anchors.centerIn: parent
            source: "images/UI_Clock_Dial.png"
            opacity: 1
            autoTransform: true
        }

        Image {
            id: morning_icon
            width: 168
            height: 1024
            anchors.left: clock_anchors.left
            anchors.verticalCenter: clock_anchors.verticalCenter
            source: "images/UI_ClockIcon_Morning.png"
            opacity: Math.max(0, 1-Math.abs(thour-6)/6)//(thour<12)*(1-Math.abs(thour-6)/6)
        }

        Image {
            id: noon_icon
            width: 1024
            height: 168
            anchors.top: clock_anchors.top
            anchors.horizontalCenter: clock_anchors.horizontalCenter
            source: "images/UI_ClockIcon_Noon.png"
            opacity: Math.max(0, 1-Math.abs(thour-12)/6)//(thour>=6 && thour <18)*(1-Math.abs(thour-12)/6)
        }

        Image {
            id: dusk_icon
            width: 168
            height: 1024
            anchors.right: clock_anchors.right
            anchors.verticalCenter: clock_anchors.verticalCenter
            source: "images/UI_ClockIcon_Dusk.png"
            opacity: Math.max(0, 1-Math.abs(thour-18)/6)//(thour>=12 && thour <24)*(1-Math.abs(thour-18)/6)
        }

        Image {
            id: night_icon
            width: 1024
            height: 168
            anchors.bottom: clock_anchors.bottom
            anchors.horizontalCenter: clock_anchors.horizontalCenter
            source: "images/UI_ClockIcon_Night.png"
            opacity: (thour>=18)*(1-(24-thour)/6) || (thour<6)*(1-(6-thour)/6)
        }

        Image {
            id: min_hand
            width: 1024
            height: 1024
            anchors.centerIn: parent
            source: "images/UI_Clock_MinuteHand.png"
        }

        Image {
            id: hour_hand
            width: 1024
            height: 1024
            anchors.centerIn: parent
            source: "images/UI_Clock_HourHand.png"
        }
    }

    

    

    Timer {
        interval: 250
        running: widget.NVG.View.exposed
        repeat: true
        onTriggered: {
            var now = new Date();
            tmsec = now.getMilliseconds();
            tsec = now.getSeconds();
            tmin = now.getMinutes();
            thour = now.getHours();
            let full_clock = configs["Full Clock"];
            if (full_clock)
                t12hour = thour > 12 ? thour - 12 : thour;
            tsec += tmsec/1000;
            if (!configs["Reverse Clock Hand"]) {
                min_hand.rotation = 180+tmin*6+tsec*0.1;
                hour_hand.rotation = ((!full_clock)*30+full_clock*15)*thour+tmin*0.5+tsec*0.01;
            } else {
                min_hand.rotation = 180+((!full_clock)*30+full_clock*15)*thour+tmin*0.5+tsec*0.01;
                hour_hand.rotation = tmin*6+tsec*0.1;
            }
        }
    }

    menu: Menu {
        Action {
            text: qsTr("Settings") + "..."
            onTriggered: styleDialog.active = true
        }
    }

    Loader {
        id: styleDialog
        active: false
        sourceComponent: NVG.Window {
            id: window
            title: qsTr("Clock Settings")
            visible: true
            minimumWidth: 380
            minimumHeight: 480
            maximumWidth: minimumWidth
            maximumHeight: minimumHeight
            width: minimumWidth
            height: minimumHeight

            transientParent: widget.NVG.View.window

            property var configuration

            ColumnLayout {
                id: root
                anchors.fill: parent
                anchors.margins: 16
                anchors.topMargin: 0

                Row {
                    spacing: 234

                    ToolButton {
                        text: qsTr("Save")
                        onClicked: {
                            configuration = rootPreference.save();
                            widget.settings.styles = configuration;
                            styleDialog.active = false;
                        }
                    }

                    ToolButton {
                        text: qsTr("Reset")
                        onClicked: {
                            rootPreference.load();
                            let cfg = rootPreference.save();
                            widget.settings.styles = cfg;
                        }
                    }
                }

                Label {
                    Layout.alignment: Qt.AlignCenter
                    text: qsTr("Settings")
                    font.pixelSize: 24
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    clip: true
                    contentWidth: preferenceLayout.implicitWidth
                    contentHeight: preferenceLayout.implicitHeight

                    ColumnLayout {
                        id: preferenceLayout
                        width: root.width

                        P.PreferenceGroup {
                            id: rootPreference
                            Layout.fillWidth: true

                            label: qsTr("Configuration")

                            onPreferenceEdited: {
                                widget.settings.styles = rootPreference.save();
                            }

                            P.SwitchPreference {
                                name: "Full Clock"
                                label: qsTr("24 Hour Clock")
                                defaultValue: true
                            }

                            P.SwitchPreference {
                                name: "Reverse Clock Hand"
                                label: qsTr("Reverse Clock Hand")
                                defaultValue: false
                            }

                            P.Separator {}

                            P.SwitchPreference {
                                id: _cfg_bg_visible
                                name: "Background Visible"
                                label: qsTr("Background Visible")
                                defaultValue: true
                            }

                            P.SliderPreference {
                                name: "Background Opacity"
                                label: qsTr("Background Opacity")
                                enabled: _cfg_bg_visible.value
                                from: 1
                                to: 100
                                stepSize: 1
                                defaultValue: 100
                                displayValue: value + "%"
                            }

                            P.SliderPreference {
                                name: "Gear Opacity"
                                label: qsTr("Gear Opacity")
                                from: 1
                                to: 100
                                stepSize: 1
                                defaultValue: 55
                                displayValue: value + "%"
                            }

                            P.SwitchPreference {
                                name: "Particle Visible"
                                label: qsTr("Particle Visible")
                                defaultValue: true
                            }


                            Component.onCompleted: {
                                if(!widget.settings.styles) {
                                    configuration = rootPreference.save();
                                    widget.settings.styles = configuration;
                                }
                                rootPreference.load(widget.settings.styles);
                                configuration = widget.settings.styles;
                            }
                        }
                    }
                }
            }

            onClosing: {
                widget.settings.styles = configuration;
                styleDialog.active = false;
            }
        }
    }
}
