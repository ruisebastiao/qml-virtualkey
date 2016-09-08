import QtQuick 2.7
import QtQuick.Controls 2.0

Item  {
	id: vkeys

	anchors.fill: parent
	visible: ["android", "ios"].indexOf(Qt.platform.os)>=0

	property Item target: root
	property var targetHandler: null

	property bool enablePad: true
	property bool enableGameButton: true
	property Item centerItem: row
	property alias spacing: row.spacing

	property int modifier
	property var keys:[
//		{text:"X"},
//		{text:"Space", key:Qt.Key_Space},
//		{text:"Shift", key:Qt.Key_Shift, hold:true}
	]

	Row {
		id: row

		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.horizontalCenterOffset: {
			var r = 0
			if (vkeys.enablePad)
				r += virtualpad.width
			if (vkeys.enableGameButton)
				r -= virtualGameButton.width
			return r/2
		}
		anchors.margins: 8
		spacing: 8

		Repeater {
			model: keys
			delegate: VirtualKey {
				target: vkeys.target
				targetHandler: vkeys.targetHandler
				text: modelData.text
				key: (modelData["key"]===undefined)?
						 0:modelData.key
				modifier: (modelData["modifier"]===undefined)?
							  vkeys.modifier:modelData.modifier
			}
		}
	}

	VirtualPad {
		id: virtualpad
		visible: enablePad
		height: 200
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.margins: 8
		target: parent.target
		targetHandler: parent.targetHandler
	}

	Item {
		id: virtualGameButton
		visible: enableGameButton
	}

	Component.onCompleted: {
		console.log("VirtualKeys.targetHandler:", targetHandler)
	}
}
