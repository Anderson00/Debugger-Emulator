import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.0

import "../components"
import Qaterial 1.0 as Qaterial

Rectangle {
    id: root
    property var tt: ""
    property var count: 0
    property int minWgrid: 20
    property int minZoom: 1
    property int maxZoom: 6
    anchors.fill: parent
    clip: true

    color: '#27191c'

    onWidthChanged: {
        viewSubWindowsWidthHeightArea()
    }

    onHeightChanged: {
        viewSubWindowsWidthHeightArea()
    }

    function viewSubWindowsWidthHeightArea(){
        // TODO:
        if(view3.x + view3.width > root.width){
            view3.x = root.width - view3.width
        }
        if(view3.y + view3.height > root.height){
            view3.y = root.height - view3.height
        }
    }

    MouseArea {
        anchors.fill: parent

        onWheel: {
            if (wheel.angleDelta.y > 0)
                sliderZoom.value += 0.1;
            else
               sliderZoom.value -= 0.1;
        }
    }

    Connections{
        target: viewPort

        function fullScreenToogle(){
           // console.log(val);
        }
    }
    Column {
        id: fullscreenFab
        anchors.top: root.top
        anchors.left: root.left
        anchors.margins: 8
        spacing: 2
        z: 100

        Qaterial.MiniFabButton {

            icon.source: Qaterial.Icons.fullscreen
            icon.color: Material.accentColor
            flat: false


            onClicked: {
                if(icon.source == Qaterial.Icons.fullscreen)
                    icon.source = Qaterial.Icons.fullscreenExit
                else
                    icon.source = Qaterial.Icons.fullscreen

                viewPort.setFullScreen(true);
            }
        }

        Qaterial.MiniFabButton {
            icon.source: Qaterial.Icons.setCenter
            icon.color: Material.accentColor
            flat: false
            opacity: (mycanvas.x == 0 && mycanvas.y == 0 && sliderZoom.value == 1)? 0.3 : 1

            onClicked: {
                if(opacity == 1){
                    mycanvas.x = 0;
                    mycanvas.y = 0;
                    sliderZoom.value = 1;
                }
            }
        }
    }

    CustomSlider {
        id: sliderZoom
        from: minZoom
        to: maxZoom
        value: minZoom
        z: 100
        color: Material.accentColor
        anchors.left: fullscreenFab.right
        anchors.top: parent.top
        anchors.topMargin: 8
        prefix: "x"

        onValueChanged: {
            mycanvas.wgrid = sliderZoom.value * minWgrid
            mycanvas.requestPaint()
        }
    }

    CustomSliderVertical {
        id: slider2
        visible: false
        from: 1
        to: 100
        value: 1
        z: 100
        anchors.top: fullscreenFab.bottom
        anchors.topMargin: -8
        anchors.left: fullscreenFab.left
        state: "left"

        onValueChanged: {

        }
    }

    Canvas {
        id: mycanvas
        width: parent.width
        height: parent.height
        property int wgrid: sliderZoom.value * root.minWgrid;

        Component.onCompleted: {
            console.log(sliderZoom.value)
            mycanvas.requestPaint()
        }

        transform: Scale {
            origin.x: 0
            origin.y: 0
            xScale: sliderZoom.value
            yScale: sliderZoom.value
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent

            drag.smoothed: true
            drag.target: mycanvas

        }

        Rectangle{
            id: mycanvasBody
            anchors.fill: parent
            border.width: 1
            border.color: "#96a0cd"
            color: "transparent"

            ViewComponentRectV2 {
                id: view3
                width: 250
                height: 250
                borderColor: Material.accentColor

                connectionsInput: [
                    {name: "fileOpen"},
                    {name: "fileClosed"},
                    {name: "fileSize"}
                ]

                connectionsOutput: [
                    {name: "Out(D)"},
                ]
            }

        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0,0, width, height)
            ctx.lineWidth = 0.3
            ctx.strokeStyle = "#114d4d"
            ctx.beginPath()
            var nrows = height / wgrid;
            for(var i = 0; i < nrows+1; i++){
                ctx.moveTo(0, wgrid*i);
                ctx.lineTo(width, wgrid*i);
            }

            var ncols = width / wgrid
            for(var j = 0; j < ncols+1; j++){
                ctx.moveTo(wgrid*j, 0);
                ctx.lineTo(wgrid*j, height);
            }
            ctx.closePath()
            ctx.stroke()
        }
    }

    ProgressBar {
        id: progressX
        width: viewRect.width
        height: 3

        value: 10
        from: 0
        to: 100

        anchors.bottom: viewRect.top
        anchors.left: viewRect.left
    }

    ProgressBar {
        id: progressY
        width: viewRect.height + 4
        height: 3

        value: 10
        from: 0
        to: 100

        rotation: -90

        anchors.left: viewRect.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: width/2 + (8-2)
        anchors.leftMargin: - width/2 - 3
    }

    CustomToolbar {
        id: toolbar
        anchors.bottom: parent.bottom

        width: 350
        height: 50
        actions : [
            {text: "OK", icon: "play", onClicked: ()=>{console.log(3232)} },
            {text: "OK", icon: "stop", onClicked: ()=>{console.log(3232)} },
            {text: "OK", onClicked: ()=>{console.log(3232)} },
            {text: "OK", onClicked: ()=>{console.log(3232)} }
        ]

    }

    Rectangle {
        id: viewRect
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 8
        anchors.rightMargin: 8
        color: "transparent"
        border.width: 2
        border.color: "#96a0cd"
        radius: 4

        width: parent.width / 10
        height: parent.height / 10

        Rectangle {
            color: "transparent"
            border.width: 1
            border.color: "#ccc"
            radius: 4

            width: viewRect.width / sliderZoom.value
            height: viewRect.height / sliderZoom.value

            x: -(mycanvas.x / (viewRect.width * 0.3));
            y: -(mycanvas.y / (viewRect.height * 0.3));

            onXChanged: {
                progressX.value = (x+viewRect.width)%mycanvas.width;

            }

            onYChanged: {
                progressY.value = (y+viewRect.height)%mycanvas.height;
            }
        }
    }
}
