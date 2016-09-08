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
	property int spacing

	property int modifier
	property var keys:[
//		{text:"X"},
//		{text:"Space", key:Qt.Key_Space},
//		{text:"Shift", key:Qt.Key_Shift, hold:true}
	]


	property Item centerItem: RowKeys {
		parent: vkeys
		keys: parent.keys
		spacing: parent.spacing
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
