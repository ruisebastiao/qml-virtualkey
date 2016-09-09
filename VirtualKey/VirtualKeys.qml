import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0

import "."

Item  {
	id: vkeys

	anchors.fill: parent
	visible: controls.opacity>0
	property bool active: ["android", "ios"].indexOf(Qt.platform.os)>=0

	property Item target: root
	property var targetHandler: null
	property var overlayTarget: target

	property bool overlay: true
	property bool enablePad: true
	property bool enableGameButtons: true
	property alias color: controls.color

	property int modifier

	property alias centerItem: controls.centerItem

	DropShadow {
		visible: overlay && vkeys.color.a>0
		anchors.top: controls.top
		anchors.fill: controls
		horizontalOffset: 0
		verticalOffset: 0
		radius: 8 // elevation
		source: controls
	}

	Rectangle {
		id: controls
		height: Units.dp * 16 + Math.max(centerItem.height,
			Math.max(vkeys.enablePad?virtualpad.height:0,
				vkeys.enableGameButtons?gameButtons.height:0)
			)
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.bottomMargin: vkeys.active?0:-height

		property alias target: vkeys.target
		property alias targetHandler: vkeys.targetHandler
		property alias modifier: vkeys.modifier

		opacity: (vkeys.height-y)/height

		color: Material.backgroundColor
		//border.width: 2

		property Item centerItem

		VirtualPad {
			id: virtualpad
			visible: enablePad
			height: Units.dp * 64 * 3
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.margins: Units.dp * 8
			target: vkeys.target
			targetHandler: vkeys.targetHandler
		}

		GamButton {
			id: gameButtons
			visible: enableGameButtons
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			anchors.margins: Units.dp * 8
			target: vkeys.target
			targetHandler: vkeys.targetHandler
		}
	}

	onActiveChanged:
		if (active)
			inAnime.start()
		else
			outAnime.start()

	NumberAnimation {
		id: inAnime
		target: controls
		property: "anchors.bottomMargin"
		duration: 400
		to: 0
	}

	NumberAnimation {
		id: outAnime
		target: controls
		property: "anchors.bottomMargin"
		duration: 400
		to: -controls.height
	}

	function setCenterItemCenter() {
		if (!centerItem) return;
		var r = 0
		if (enablePad)
			r += virtualpad.width
		if (enableGameButtons)
			r -= gameButtons.width
			centerItem.anchors.horizontalCenterOffset = r/2
	}

	onEnableGameButtonsChanged: setCenterItemCenter()
	onEnablePadChanged: setCenterItemCenter()
	onCenterItemChanged: setCenterItemCenter()

	Component.onCompleted: {
		centerItem.parent = controls
		overlayTarget.anchors.bottomMargin = Qt.binding(function(){
			return (overlay||!active)?0:controls.height
		})

		console.log("VirtualKeys.targetHandler:", targetHandler)
	}
}
