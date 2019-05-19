//Copyright (C) 2018 Ultimaker B.V.
//Copyright (C) 2019 Ghostkeeper
//This plug-in is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//This plug-in is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for details.
//You should have received a copy of the GNU Affero General Public License along with this plug-in. If not, see <https://gnu.org/licenses/>.

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import UM 1.3 as UM
import Cura 1.0 as Cura

Item {
	id: general_template

	property var setting_data: loaderData

	// Check for undefined, because after switching loader object the qml still tries to read this data
	property var setting_description: {
		return setting_data["details"]["data"] != undefined ? setting_data["details"]["data"]["description"]: "";
	}
	property var setting_img_description: {
		return setting_data["details"]["data"] != undefined ? setting_data["details"]["data"]["img_description"]: "";
	}
	property var setting_hints: {
		return setting_data["details"]["data"] != undefined ? setting_data["details"]["data"]["hints"]: "";
	}
	property var setting_notes: {
		return setting_data["details"]["data"] != undefined ? setting_data["details"]["data"]["notes"] != undefined ? setting_data["details"]["data"]["notes"] : "" : "";
	}	
	property var setting_images: {
		return setting_data["images"] != undefined ? setting_data["images"] : "";
	}

	ScrollView {
		id: page_scroll_view
		anchors.fill: parent

		Column {
			spacing: UM.Theme.getSize("default_margin").height
			padding: UM.Theme.getSize("wide_margin").width
			property bool is_grid_images_visible: setting_images.length > 0
			id: rect_scroll

			width: general_template.width

			Label {
				id: title

				text: selectedSettingName.properties.label
				font: UM.Theme.getFont("large")
				color: UM.Theme.getColor("text")
				renderType: Text.NativeRendering
			}

			Label {
				id: description

				text: general_template.setting_description
				width: parent.width - parent.padding * 2
				wrapMode: Text.WordWrap
				font: UM.Theme.getFont("default")
				color: UM.Theme.getColor("text")
				renderType: Text.NativeRendering
			}

			GridLayout {
				property var selectedMouseArea: undefined
				function enableHoverForBorder() {
					if (selectedMouseArea != undefined) {
						selectedMouseArea.hoverEnabled = true;
					}
				}

				id: images_grid
				columns: 3
				rows: 2
				columnSpacing: 20 * screenScaleFactor
				rowSpacing: 20 * screenScaleFactor

				x: (rect_scroll.width - width) / 2 // set center position

				visible: rect_scroll.is_grid_images_visible

				Repeater {
					id: animationRepeater
					model: setting_images.length
					AnimatedImage {
						id: gridImage
						source: setting_images[index]

						// Some gif animations have a black first frame, for this reason start from 1
						currentFrame: setting_images[index].split('.').pop() == "gif" ? 1 : 0
						playing: false

						property var is_gif_image: setting_images[index].split('.').pop() == "gif"

						property var updateBorder: function() {
							if (gridImage.is_gif_image) {
								border_rectangle.border.width = 1;
							} else {
								border_rectangle.border.width = 0;
							}
						}

						Rectangle {
							id: border_rectangle
							anchors.fill: parent
							border.width: {
								// Show border only for gif images, because they have animation
								return gridImage.is_gif_image ? 1 : 0;
							}
							border.color: UM.Theme.getColor("setting_control_border")
							color: "transparent"
							anchors.margins: -5

							MouseArea {
								id: border_rectangle_mouse_area
								hoverEnabled: true
								anchors.fill: parent
								cursorShape: Qt.PointingHandCursor
								onHoveredChanged: {
									if (containsMouse) {
										border_rectangle.border.color = UM.Theme.getColor("setting_control_border_highlight");
										border_rectangle.border.width = 2;
									} else {
										border_rectangle.border.color = UM.Theme.getColor("setting_control_border");
										gridImage.updateBorder();
									}
								}

								onClicked: {
									zoom_image.source = setting_images[index];
									border_rectangle_mouse_area.hoverEnabled = false;
									border_rectangle.border.color = UM.Theme.getColor("setting_control_border");
									gridImage.updateBorder();

									// After zooming don't change the border color of an image on hover
									images_grid.selectedMouseArea = border_rectangle_mouse_area;
								}
							}
						}

						Layout.preferredWidth: {
							var ratio = Math.max( sourceSize.width / 350, sourceSize.height / 200);
							var new_value = sourceSize.width;
							if (ratio > 1) {
								new_value = sourceSize.width / ratio;
							}

							return new_value * screenScaleFactor;
						}
						Layout.preferredHeight: {
							var ratio = Math.max( sourceSize.width / 350, sourceSize.height / 200);
							var new_value = sourceSize.height;
							if (ratio > 1) {
								new_value = sourceSize.height / ratio;
							}

							return new_value * screenScaleFactor;
						}

						// Only gif files can have animation
						Image {
							id: play_icon
							source: Qt.resolvedUrl("../../icons/play.svg")
							anchors.horizontalCenter: parent.horizontalCenter
							anchors.verticalCenter: parent.verticalCenter
							opacity: 0.7
							width: 50 * screenScaleFactor
							height: 50 * screenScaleFactor
							// Do not show play button for rest image extensions
							visible: setting_images[index].split('.').pop() == "gif"
						}
					}
				}
			}

			Label {
				id: img_description

				width: parent.width - parent.padding * 2
				text: general_template.setting_img_description
				font: UM.Theme.getFont("default_italic")
				color: UM.Theme.getColor("text")
				renderType: Text.NativeRendering
				wrapMode: Text.WordWrap
			}

			Label {
				id: hints

				text: manager.parseStylingList(general_template.setting_hints)
				width: parent.width - parent.padding * 2
				font: UM.Theme.getFont("default")
				color: UM.Theme.getColor("text")
				renderType: Text.NativeRendering
				wrapMode: Text.WordWrap
				textFormat: Text.RichText
			}

			Label {
				id: notes

				text: general_template.setting_notes
				width: parent.width - parent.padding * 2
				font: UM.Theme.getFont("default_bold")
				color: UM.Theme.getColor("text")
				renderType: Text.NativeRendering
				wrapMode: Text.WordWrap
			}
		}
	}
	// Image zoom has own background and Animation Image
	Rectangle {
		id: zoom_image_background
		width: general_template.width
		height: general_template.height
		visible: zoom_image.source != "" //Use single "=" because we want to allow comparison with undefined.

		anchors {
			left: general_template.left
			right: general_template.right
		}

		z: 1
		color: UM.Theme.getColor("viewport_background")
		opacity: 0.9

		MouseArea {
			anchors.fill: parent

			cursorShape: Qt.ArrowCursor

			onClicked: {
				zoom_image.source = "";
				images_grid.enableHoverForBorder();
			}
		}
	}

	AnimatedImage {
		id: zoom_image
		z: 1 //Display on top of other content.
		anchors.centerIn: parent
		width: parent.width * 2 / 3
		height: parent.height * 2 / 3
		fillMode: Image.PreserveAspectFit
	}

	UM.SettingPropertyProvider {
		id: selectedSettingName
		containerStack: Cura.MachineManager.activeMachine
		key: manager.selectedSettingId
		watchedProperties: [ "label" ]
	}

	//When switching settings, unzoom the image.
	Connections {
		target: manager
		onSettingItemChanged: {
			zoom_image.source = "";
		}
	}
}