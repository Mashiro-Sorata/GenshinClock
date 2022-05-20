import QtQuick 2.12
import QtQuick.Controls 2.12

import NERvGear 1.0 as NVG
import NERvGear.Templates 1.0 as T


T.Widget {
    solid: true
    visible: true

    property string version: ""
    property var defaultValues: {}
    signal completed()
    signal updated() 

    function updateObject(targetObj, sourceObj) {
        for (let prop in sourceObj) {
            if (sourceObj.hasOwnProperty(prop) && sourceObj[prop] !== undefined) {
                if (typeof sourceObj[prop] === 'object') {
                    Object.assign(targetObj[prop], sourceObj[prop]);
                } else {
                    targetObj[prop] = sourceObj[prop];
                }
            }
        }
        return targetObj;
    }

    onUpdated: {
        widget.settings.styles = updateObject(JSON.parse(JSON.stringify(defaultValues)), widget.settings.styles);
    }

    Component.onCompleted: {
        if (!widget.settings.styles) {
             widget.settings.styles = defaultValues;
             widget.settings.version = version;
        } else if (widget.settings.version !== version) {
            updated();
            widget.settings.version = version;
        }
        completed();
    }
}
