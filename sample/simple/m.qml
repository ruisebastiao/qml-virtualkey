import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0

import VirtualKey 1.0

Window {
	id: window

	visible: true
	width: 800
	height: 600

	MouseArea {
		anchors.fill: parent

		onClicked: {
			console.log(mouseX, mouseY)
		}

		onPressed: {
			console.log(mouseX, mouseY)
		}
	}


	Button {
		text: "GG"
		onClicked: {
			InputEventSource.mousePress(window, 100, 100,
										Qt.LeftButton, Qt.NoModifier, -1)
		}
	}

//	Button {
//		text: "OO"
//		checkable: true
//		onClicked: console.log("OO")
//	}
}
