import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

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

			Row {
				anchors.top: parent.top
				anchors.topMargin: 8
				anchors.horizontalCenter: parent.horizontalCenter
				spacing: 8

				Button {
					text: vkeys.active?"↧":"↥"
					onClicked: vkeys.active = !vkeys.active
				}
				Button {
					id: toggleOverlay
					text: "overlay"
					checkable: true
				}
			}
		}
	}


	VirtualKeys {
		id: vkeys

		active: true
		target: root
		enablePad: false
		enableGameButtons: false
		color: "#8080a0f0"
		overlay: toggleOverlay.checked
		modifier: shiftKey.checked?Qt.ShiftModifier:Qt.NoModifier

		centerItem: RowKeys {
			spacing: 2
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
		}
	}
}
