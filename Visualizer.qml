import QtQuick 2.0
import QtQuick.Controls 1.2
import codeviz 1.0

import codeviz 1.0

Item {
    id: root

    function getChildFromName(name){
        for(var i = 0; i < repeater.count; ++i){
            if (repeater.itemAt(i).title === name)
                return repeater.itemAt(i);
        }
    }

    function refreshInheritance()
    {
        canvas.lineList = [];
        for(var i = 0; i < repeater.model.count; ++i){
            var childAt = repeater.itemAt(i)
            var motherList = childAt.inheritsListModel;
            if(motherList.count > 0)
            {
                var motherClass = getChildFromName(motherList.get(0).classTo)
                console.log("from : " + childAt.x + ";" + childAt.y)
                console.log("to : " + motherClass.x + ";" + motherClass.y)
                canvas.lineList.push({

                    "fromX": childAt.x,
                    "fromY": childAt.y,
                    "toX": motherClass.x,
                    "toY": motherClass.y
                });
            }
        }

        canvas.requestPaint()
    }

    property real zoom: 1.0
    readonly property real maximumZoom: 4.0
    readonly property real minimumZoom: 1.0
    readonly property real zoomOffset: 0.4

    property real distanceFromCenter: 350 * zoom

    Component.onCompleted: {
        console.debug("Data = " + JSON.stringify(DataModel.queryClasses()))
        classListModel.append(DataModel.queryClasses());

        refreshInheritance();

    }



    ListModel {
        id: classListModel
    }

    ListModel {
        id: listInheritance
    }



    Component {
        id: cListElement

        ListElement {
            property string className;
            property var attributes;
            property var methods;
            property var inheritsFrom;
        }
    }

    Flickable {
        id: flickable
        focus: true
        anchors.fill: parent
        contentWidth: parent.width * zoom
        contentHeight: parent.height * zoom

        MouseArea {
            width: flickable.contentWidth
            height: flickable.contentHeight
            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    console.debug("Click right on blank")
                } else if (mouse.button === Qt.LeftButton) {
                    console.debug("Click left on blank")
                }
            }

            onDoubleClicked: {
                var mousePoint = Qt.point(mouse.x, mouse.y);
                console.debug("MAP " + mapToItem(flickable.contentItem, mouse.x, mouse.y))
                console.debug("double click " + mouse.x + " ; " + mouse.y);
                ++zoom;
            }

            onWheel: {
                if(wheel.angleDelta.y > 0) {
                    zoom = Math.min(root.maximumZoom, zoom + zoomOffset);
                } else {
                    zoom = Math.max(root.minimumZoom, zoom - zoomOffset);
                }
            }
        }


        Timer{
            interval: 5000
            running: true
            onTriggered: {

                console.debug("test")
                canvas.requestPaint();

            }
        }



        Canvas {
            id: canvas
            height: flickable.contentHeight;
            width: flickable.contentWidth;
            anchors.fill: parent;

            property var context: getContext("2d");
            property var lineList;

            onPaint: {

                // Draw a line
                context.reset()
                context.beginPath();
                context.lineWidth = 2;
                context.strokeStyle = "red"
                for(var i = 0 ; i < lineList.length ; ++i)
                {
                    var line = lineList[i];
                    console.log("line from " + line.fromX + ";" + line.fromY)
                    console.log("line to " + line.toX + ";" + line.toY)
                    context.moveTo(line.fromX, line.fromY);
                    context.lineTo(line.toX, line.toY);
                }
                context.stroke();
            }

        }


        Repeater {
            id: repeater
            model: classListModel
            anchors.fill: parent

            delegate: ClassBox {
                    zoom: root.zoom
                    scale: zoom
                    id: classBox

                    Behavior on scale {
                        NumberAnimation {

                        }
                    }

                    Behavior on x {
                        NumberAnimation { }
                    }

                    Behavior on y {
                        NumberAnimation { }
                    }

                    width: 150
                    height: 250
                    x: (flickable.contentWidth - width) / 2.0 -
                       + Math.cos((2 * index + 0.5) * Math.PI / repeater.count) * distanceFromCenter
                    y: (flickable.contentHeight - height) / 2.0
                        + Math.sin((2 * index + 0.5) * Math.PI / repeater.count) * distanceFromCenter
                    title: name

                    onXChanged: {
                        refreshInheritance()
                    }

                    onYChanged: {
                        refreshInheritance()
                    }



            }


        }
    }

    Button {
        anchors.centerIn: parent
        width: 50
        height: 50

        onClicked: {
            console.debug("clicked")
            var newAttributes = {"test": "real",
                    "aaa":"string"};
            var newMethods = {
                "foo": "bar"
            };
            var newElement = cListElement.createObject(root, {
                className: "firstClass",
                attributes: newAttributes,
                methods: newMethods
            });
            listModel.append(newElement);


            console.debug(JSON.stringify(newElement))
        }
    }
}
