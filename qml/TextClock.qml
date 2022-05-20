import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtGraphicalEffects 1.0

import NERvGear 1.0 as NVG
import NERvGear.Controls 1.0
import NERvGear.Templates 1.0 as T
import NERvGear.Preferences 1.0 as P


WidgetTemplate {
    id: widget
    title: qsTr("Genshin Text Clock Widget")
    editing: styleDialog.active

    version: "1.0.0"
    defaultValues:{
        "Full Clock": true,
        "Font Name": fonts.length - 1,
        "Font Weight": 1,
        "Font Color": "#000000"
    }

    readonly property var configs: widget.settings.styles

    readonly property var fonts: Qt.fontFamilies().sort()
    readonly property var fontweight: [Font.Light, Font.Normal, Font.Bold]
    readonly property var sfontweight: [qsTr("Light"), qsTr("Normal"), qsTr("Bold")]


    property real thour: 0
    property real t12hour: 0
    property real tmin: 0
    property real tsec: 0
    property real tmsec: 0

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

        Text {
            anchors.centerIn: parent
            color: configs["Font Color"]
            text: configs["Full Clock"] ? ("0"+thour).slice(-2) + ":" + ("0"+tmin).slice(-2) : ("0"+t12hour).slice(-2) + ":" + ("0"+tmin).slice(-2)
            font.pointSize: 40
            font.family: fonts[configs["Font Name"]]
            font.weight: fontweight[configs["Font Weight"]]
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

                                onPreferenceEdited: {
                                    widget.settings.styles = rootPreference.save();
                                }

                                P.SwitchPreference {
                                    name: "Full Clock"
                                    label: qsTr("24 Hour Clock")
                                    defaultValue: defaultValues["Full Clock"]
                                }

                                P.SelectPreference {
                                    name: "Font Name"
                                    label: qsTr("Font Style")
                                    defaultValue: defaultValues["Font Name"]
                                    model: fonts
                                }

                                P.SelectPreference {
                                    name: "Font Weight"
                                    label: qsTr("Font Weight")
                                    defaultValue: defaultValues["Font Weight"]
                                    model: sfontweight
                                }

                                P.ColorPreference {
                                    name: "Font Color"
                                    label: qsTr("Font Color")
                                    defaultValue: defaultValues["Font Color"]
                                }

                                Component.onCompleted: {
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
