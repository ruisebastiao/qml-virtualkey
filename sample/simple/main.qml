import QtQuick 2.7
import QtQuick.Window 2.2

import VirtualKey 1.0

Window {
	visible: true
	width: 800
	height: 600
	title: qsTr("Login")

	FocusScope {
		id: root
		anchors.fill: parent
		Root {
			anchors.fill: parent
		}
	}


	VirtualKeys {
		visible: true
		target: root
		enablePad: false
		enableGameButton: false
		spacing: 2
		modifier: shiftKey.checked?Qt.ShiftModifier:Qt.NoModifier
		keys:  {
			var t = []
			t.push({text:"Tab", key:Qt.Key_Tab, modifier:Qt.NoModifier})
			for (var c='a'.charCodeAt(0);c<='z'.charCodeAt(0);c++) {
				t.push({
				   text:String.fromCharCode(modifier===Qt.ShiftModifier?
												c-32:c)
				})
			}
			return t
		}

		VirtualKey {
			id: shiftKey
			text: "Shift"
			checkable: true
			key: Qt.Key_Shift
			target: root
		}

		Component.onCompleted: {
			shiftKey.parent = centerItem
		}
	}
}
