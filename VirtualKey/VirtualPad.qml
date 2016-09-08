import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "."

Canvas {
	id: control
	implicitHeight: 200
	width: height

	property Item target: parent.target
	property var targetHandler: parent.targetHandler

	property bool enableBearing: true
	property int repeatInterval: 33
	property int direction
	property alias pressed: mouse.pressed

	property int arrowSize: height/10

	opacity: .7

	onDirectionChanged: requestPaint()

	onPaint: {
		var ctx = getContext("2d")
		ctx.save()
		ctx.clearRect(0, 0, width, height)

		ctx.beginPath()
		ctx.arc(height/2, width/2, height/2, 0, 2 * Math.PI)
		ctx.fillStyle = pressed?control.Material.buttonPressColor:control.Material.buttonColor
		ctx.fill()
		ctx.closePath()


		ctx.beginPath()
		ctx.arc(height/2, width/2, arrowSize*2, 0, 2 * Math.PI)
		ctx.strokeStyle = control.Material.primaryTextColor
		ctx.stroke()
		ctx.closePath()

		ctx.fillStyle = direction&4?
					control.Material.accentColor:
					control.Material.primaryTextColor

		ctx.beginPath()
		ctx.moveTo(arrowSize, height/2)
		ctx.lineTo(arrowSize*2, height/2-arrowSize)
		ctx.lineTo(arrowSize*2, height/2+arrowSize)
		ctx.fill()
		ctx.closePath()

		ctx.fillStyle = direction&1?
					control.Material.accentColor:
					control.Material.primaryTextColor

		ctx.beginPath()
		ctx.moveTo(width-arrowSize, height/2)
		ctx.lineTo(width-arrowSize*2, height/2-arrowSize)
		ctx.lineTo(width-arrowSize*2, height/2+arrowSize)
		ctx.fill()
		ctx.closePath()

		ctx.fillStyle = direction&2?
					control.Material.accentColor:
					control.Material.primaryTextColor

		ctx.beginPath()
		ctx.moveTo(width/2, arrowSize)
		ctx.lineTo(width/2-arrowSize, arrowSize*2)
		ctx.lineTo(width/2+arrowSize, arrowSize*2)
		ctx.fill()
		ctx.closePath()

		ctx.fillStyle = direction&8?
					control.Material.accentColor:
					control.Material.primaryTextColor

		ctx.beginPath()
		ctx.moveTo(width/2, height-arrowSize)
		ctx.lineTo(width/2-arrowSize, height-arrowSize*2)
		ctx.lineTo(width/2+arrowSize, height-arrowSize*2)
		ctx.fill()
		ctx.closePath()

		ctx.restore()
	}

	MouseArea {
		id: mouse
		anchors.fill: parent

		property int posX
		property int posY

		function calcDirection(x, y) {
			if (x === undefined) {
				x = posX
				y = posY
			}

			x -= width/2
			y -= height/2

			var dis = Math.sqrt(x*x+y*y)

			if (dis<arrowSize*2 || dis*2>height) {
				return 0
			}

			if (enableBearing) {
				if (Math.abs(x)>2*Math.abs(y))
					if (x>0)
						return 1 // right
					else
						return 4 // left
				else if (Math.abs(x)*2<Math.abs(y))
					if (y>0)
						return 8 // down
					else
						return 2 // up
				else
					return ((x>0)?1:4)|((y>0)?8:2)
			} else if (Math.abs(x)>Math.abs(y))
				if (x>0)
					return 1 // right
				else
					return 4 // left
			else if (y>0)
				return 8 // down
			else
				return 2 // up
		}

		onPressed: {
			posX = mouseX
			posY = mouseY
			trigger.start()
		}

		onEntered: {
			posX = mouseX
			posY = mouseY
			trigger.start()
		}

		onPositionChanged: {
			posX = mouseX
			posY = mouseY
		}

		onReleased: {
			trigger.stop()
			control.direction = 0
		}

		onExited: {
			trigger.stop()
			control.direction = 0
		}

		Timer {
			id: trigger
			interval: control.repeatInterval
			repeat: true

			onTriggered: {
				control.direction = mouse.calcDirection()
				if (control.direction)
					target.focus = true
				if (control.targetHandler) {
					if (control.direction & 1)
						control.targetHandler.rightPressed(dummy)
					if (control.direction & 2)
						control.targetHandler.upPressed(dummy)
					if (control.direction & 4)
						control.targetHandler.leftPressed(dummy)
					if (control.direction & 8)
						control.targetHandler.downPressed(dummy)
				} else {
					if (control.direction & 1)
						KeyEventSource.keyPress(Qt.Key_Right, Qt.NoModifier, -1)
					if (control.direction & 2)
						KeyEventSource.keyPress(Qt.Key_Up, Qt.NoModifier, -1)
					if (control.direction & 4)
						KeyEventSource.keyPress(Qt.Key_Left, Qt.NoModifier, -1)
					if (control.direction & 8)
						KeyEventSource.keyPress(Qt.Key_Down, Qt.NoModifier, -1)
				}
			}
		}
	}
}
