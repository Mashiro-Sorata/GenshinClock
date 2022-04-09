import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtGraphicalEffects 1.0

import NERvGear 1.0 as NVG
import NERvGear.Controls 1.0
import NERvGear.Templates 1.0 as T
import NERvGear.Preferences 1.0 as P


T.Widget {
    id: widget
    visible: true
    solid: true
    title: qsTr("Genshin Text Clock Widget")

    property real thour: 0
    property real t12hour: 0
    property real tmin: 0
    property real tsec: 0
    property real tmsec: 0
    editing: styleDialog.active

    readonly property var configs: widget.settings.styles ? widget.settings.styles : {"Full Clock":true, "Font Color": "#000000"}


    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 250
        height: 200
        scale: widget.height*0.95/200
        opacity: 0.75

        Image {
            width: 162
            height: 57
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../Images/UI_Clock_TimeArrow.png"
            autoTransform: true
        }

        Image {
            width: 162
            height: 57
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../Images/UI_Clock_TimeArrow.png"
            autoTransform: true
            rotation: 180
        }

        FontLoader {
            id: genshinFont;
            source: "../Fonts/hk4e_zh-cn.ttf"
        }

        Text {
            anchors.centerIn: parent
            color: configs["Font Color"]
            text: configs["Full Clock"] ? ("0"+thour).slice(-2) + ":" + ("0"+tmin).slice(-2) : ("0"+t12hour).slice(-2) + ":" + ("0"+tmin).slice(-2)
            font.pointSize: 40
            font.family: genshinFont.name
        }
    }


    Timer {
        interval: 250
        running: widget.NVG.View.exposed
        repeat: true
        onTriggered: {
            var now = new Date();
            tsec = now.getSeconds();
            tmin = now.getMinutes();
            thour = now.getHours();
            if (!configs["Full Clock"])
                t12hour = thour > 12 ? thour - 12 : thour;
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
            title: qsTr("Text Clock Settings")
            visible: true
            minimumWidth: 380
            minimumHeight: 500
            width: minimumWidth
            height: minimumHeight

            transientParent: widget.NVG.View.window

            property var configuration

            Page {
                id: cfg_page
                anchors.fill: parent

                header: TitleBar {
                    text: qsTr("Text Clock Settings")
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

                                P.SwitchPreference {
                                    name: "Full Clock"
                                    label: qsTr("24 Hour Clock")
                                    defaultValue: true
                                }

                                P.ColorPreference {
                                    name: "Font Color"
                                    label: qsTr("Font Color")
                                    defaultValue: "#000000"
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
    }
}
