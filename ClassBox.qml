import QtQuick 2.0
import Material 0.1

Item {
    id: root
    property alias title: titleText.text
    property var methods
    property var attributes

    Column {
        anchors.fill: parent
        Rectangle {
            id: titleContainer
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            color: "purple"
            Text {
                id: titleText
            }
        }

        Row {
            Rectangle {
                height: 100
                width: titleContainer.width / 2
                id: attributesContainer
                color: "green"
            }
            Rectangle {
                height: 100
                width: titleContainer.width / 2
                id: methodsContainer
                color: "red"
            }
        }

        Rectangle {
            id: instancesContainer
            height: 150
            width: titleContainer.width
            color: "yellow"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.debug("Click on box " + title)
        }
    }
}

