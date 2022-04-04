import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import NERvGear 1.0 as NVG
import NERvGear.Controls 1.0
import NERvGear.Preferences 1.0 as P

NVG.Window {
    id: window
    title: qsTr("Clock Settings")
    visible: true
    x: widget.NVG.View.x + widget.width
    y: widget.NVG.View.y
    minimumWidth: 500
    minimumHeight: 500
    width: minimumWidth
    height: minimumHeight

    transientParent: widget.NVG.View.window

    property var configuration

    Page {
        id: cfg_page
        anchors.fill: parent

        header: TitleBar {
            text: qsTr("Clock Settings")
            font.family: genshinFont.name

            standardButtons: Dialog.Save | Dialog.Reset

            onAccepted: {
                configuration = rootPreference.save();
                widget.settings.styles = configuration;
                styleDialog.active = false;
            }

            onReset: {
                rootPreference.load();
                let cfg = rootPreference.save();
                widget.settings.styles = cfg;
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
                        font.family: genshinFont.name

                        onPreferenceEdited: {
                            widget.settings.styles = rootPreference.save();
                        }

                        P.SelectPreference {
                            id: _cfg_priority_mode
                            name: "Performance and Effectiveness"
                            label: qsTr("Performance and Effectiveness")
                            defaultValue: 0
                             model: [qsTr("Effectiveness First"), qsTr("Performance First")]
                        }

                        P.DialogPreference {
                            name: "Performance Settings"
                            label: qsTr("Performance Settings")
                            live: true
                            icon.name: "regular:\uf1de"
                            enabled: _cfg_priority_mode.value == 1

                            P.SliderPreference {
                                name: "FPS of Gears"
                                label: qsTr("FPS of Gears")
                                from: 1
                                to: 60
                                stepSize: 1
                                defaultValue: 10
                                displayValue: value + " fps"
                            }

                            P.SliderPreference {
                                name: "Particle Speed"
                                label: qsTr("Particle Speed")
                                from: 1
                                to: 100
                                stepSize: 1
                                defaultValue: 30
                                displayValue: value + "%"
                                enabled: _cfg_particle_visible.value
                            }

                            P.SwitchPreference {
                                id: _cfg_particle_visible
                                name: "Particle Visible"
                                label: qsTr("Particle Visible")
                                defaultValue: true
                            }
                        }

                        P.Separator {}

                        P.SwitchPreference {
                            id: _cfg_genshin_style
                            name: "Genshin Style"
                            label: qsTr("Genshin Style")
                            defaultValue: true
                        }

                        P.SwitchPreference {
                            name: "Full Clock"
                            label: qsTr("24 Hour Clock")
                            visible: !_cfg_genshin_style.value
                            enabled: visible
                            defaultValue: false
                        }

                        P.SwitchPreference {
                            id: _cfg_single_clock_hand
                            name: "Single Clock Hand"
                            label: qsTr("Single Clock Hand")
                            visible: _cfg_genshin_style.value
                            enabled: visible
                            defaultValue: true
                        }

                        P.SwitchPreference {
                            name: "Reverse Clock Hand"
                            label: qsTr("Reverse Clock Hand")
                            visible: !_cfg_genshin_style.value
                            enabled: visible
                            defaultValue: false
                        }

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
    }

    onClosing: {
        widget.settings.styles = configuration;
        styleDialog.active = false;
    }
}
