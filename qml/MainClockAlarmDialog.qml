import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import NERvGear 1.0 as NVG
import NERvGear.Controls 1.0
import NERvGear.Preferences 1.0 as P

NVG.Window {
    id: window
    title: qsTr("Alarm Clock Settings")
    visible: true
    x: widget.NVG.View.x + widget.width
    y: widget.NVG.View.y
    minimumWidth: 450
    minimumHeight: 380
    width: minimumWidth
    height: minimumHeight

    transientParent: widget.NVG.View.window

    property var configuration

    property real last_time: 0
    property real initial_time: 0

    function setTime(date) {
        rootPreference.load({"Alarm Time": date});
        last_time = date.getHours()*60+date.getMinutes();
    }

    Page {
        id: cfg_page
        anchors.fill: parent

        header: TitleBar {
            text: qsTr("Alarm Clock Settings")

            standardButtons: Dialog.Save

            onAccepted: {
                configuration = rootPreference.save();
                widget.settings.alarm = configuration;
                alarm_close_anime_start = true;
                alarmDialog.active = false;
                hourhand_anime.direction = RotationAnimation.Clockwise;
                minhand_anime_rotation = (hour_hand.rotation + 180) % 360;
                minhand_anime.start();
            }
        }

        ColumnLayout {
            id: root
            anchors.fill: parent
            anchors.margins: 16
            anchors.topMargin: 0

            Label {
                Layout.alignment: Qt.AlignCenter
                anchors.topMargin: 10
                text: qsTr("Last Time")
                font.pixelSize: 24
            }

            Label {
                Layout.alignment: Qt.AlignCenter
                anchors.topMargin: 10
                text: {
                    const date = new Date(configuration["Alarm Time"]);
                    return ("0"+date.getHours()).slice(-2) + ":" + ("0"+date.getMinutes()).slice(-2);
                }
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

                        function setHanime(time, direction) {
                            const date = new Date(time);
                            const _thour = date.getHours();
                            let _thour_rotation = (15*_thour+date.getMinutes()*0.25+date.getSeconds()*0.004167);
                            if (_thour >= 18) {
                                _thour_rotation -= 180;
                                if (_thour_rotation < alarm_initial_angle) {
                                    hourhand_anime_rotation = _thour_rotation + 360;
                                } else {
                                    hourhand_anime_rotation = _thour_rotation;
                                }    
                            } else if (_thour >= 12)  {
                                _thour_rotation += 180;
                                if (_thour_rotation%360 < alarm_initial_angle)  {
                                    hourhand_anime_rotation = _thour_rotation;
                                } else {
                                    hourhand_anime_rotation = _thour_rotation - 360;
                                }
                            } else {
                                _thour_rotation += 180;
                                if ((_thour_rotation) < alarm_initial_angle) {
                                    hourhand_anime_rotation = _thour_rotation + 360;
                                } else {
                                    hourhand_anime_rotation = _thour_rotation;
                                }
                            }
                            hourhand_anime.direction = direction ? RotationAnimation.Clockwise : RotationAnimation.Counterclockwise;
                            hourhand_anime.start();
                        }

                        onPreferenceEdited: {
                            widget.settings.alarm = rootPreference.save();
                            const date = new Date(widget.settings.alarm["Alarm Time"]);
                            const cfg_alarm = date.getHours()*60+date.getMinutes();
                            if (last_time != cfg_alarm) {
                                let direction = true;
                                if (cfg_alarm == initial_time) {
                                    direction = false;
                                } else if (last_time >= initial_time && initial_time > cfg_alarm) {
                                    direction = true;
                                } else if(last_time < initial_time && initial_time <= cfg_alarm) {
                                    direction = false;
                                } else if (cfg_alarm > last_time && last_time >= initial_time) {
                                    direction = true;
                                } else if (last_time > cfg_alarm && cfg_alarm >= initial_time) {
                                    direction = false;
                                } else if (initial_time >= cfg_alarm, cfg_alarm > last_time) {
                                    direction = true;
                                } else if (initial_time >= last_time, last_time > cfg_alarm) {
                                    direction = false;
                                } else if (initial_time >= cfg_alarm && cfg_alarm > last_time) {
                                    direction = true;
                                } else if (initial_time >= last_time && last_time > cfg_alarm) {
                                    direction = false;
                                } else if (last_time > cfg_alarm && cfg_alarm >= initial_time) {
                                    direction = false;
                                } else if (cfg_alarm > last_time && last_time >= initial_time) {
                                    direction = true;
                                }
                                setHanime(widget.settings.alarm["Alarm Time"], direction);
                            }
                            last_time = cfg_alarm;
                        }

                        P.TimePreference {
                            name: "Alarm Time"
                            label: qsTr("Alarm Time")
                            message: qsTr("Tips: Drag the hour hand to set alarm time.")
                        }

                        P.Separator {}

                        P.SwitchPreference {
                            id: _cfg_enable_task
                            name: "Enable Task"
                            label: qsTr("Enable Task")
                            defaultValue: false
                        }

                        P.ActionPreference {
                            name: "action"
                            label: qsTr("Action")
                            enabled: _cfg_enable_task.value
                        }

                        Component.onCompleted: {
                            if(!widget.settings.alarm) {
                                configuration = rootPreference.save();
                                widget.settings.alarm = configuration;
                            }
                            rootPreference.load(widget.settings.alarm);
                            configuration = widget.settings.alarm;
                            const date = new Date(configuration["Alarm Time"]);
                            last_time = date.getHours()*60+date.getMinutes();
                            initial_time = last_time;
                        }
                    }
                }
            }
        }
    }

    onClosing: {
        widget.settings.alarm = configuration;
        alarmDialog.active = false;
        handAnimeRotation();
        alarm_modify = false;
        alarm_dialog_completed = false;
    }

    Component.onCompleted: {
        widget.alarm_modify = true;
    }
}
