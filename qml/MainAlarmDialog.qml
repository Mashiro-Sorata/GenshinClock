import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import NERvGear 1.0 as NVG
import NERvGear.Controls 1.0
import NERvGear.Preferences 1.0 as P

NVG.Window {
    id: window
    title: qsTr("Alarm Settings")
    visible: true
    minimumWidth: 450
    minimumHeight: 500
    width: minimumWidth
    height: minimumHeight

    transientParent: widget.NVG.View.window

    property var configuration

    function setTime(date) {
        rootPreference.load({"option2": date});
    }

    Page {
        id: cfg_page
        anchors.fill: parent

        header: TitleBar {
            text: qsTr("Alarm Settings")

            standardButtons: Dialog.Save | Dialog.Reset

            onAccepted: {
                configuration = rootPreference.save();
                widget.settings.alarm = configuration;
                alarmDialog.active = false;
            }

            onReset: {
                rootPreference.load();
                let cfg = rootPreference.save();
                widget.settings.alarm = cfg;
            }
        }

        ColumnLayout {
            id: root
            anchors.fill: parent
            anchors.margins: 16
            anchors.topMargin: 0

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
                            widget.settings.alarm = rootPreference.save();
                        }

                        P.TimePreference {
                            name: "option1"
                            label: "Time 1"
                        }

                        P.TimePreference {
                            name: "option2"
                            label: "Time 2"
                            message: "This is a message."

                            defaultValue: {
                                const date = new Date;
                                date.setHours(0, 0);
                                return date;
                            }
                        }

                        

                        Component.onCompleted: {
                            if(!widget.settings.alarm) {
                                configuration = rootPreference.save();
                                widget.settings.alarm = configuration;
                            }
                            rootPreference.load(widget.settings.alarm);
                            configuration = widget.settings.alarm;
                        }
                    }
                }
            }
        }
    }

    onClosing: {
        widget.settings.alarm = configuration;
        alarmDialog.active = false;
    }
}