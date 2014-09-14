/* -*- coding: utf-8-unix -*-
 *
 * Copyright (C) 2014 Osmo Salomaa
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "."

Page {
    allowedOrientations: Orientation.All
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.implicitHeight
        contentWidth: parent.width
        Column {
            id: column
            anchors.fill: parent
            PageHeader { title: "Poor Maps" }
            ListItem {
                id: findPlaceItem
                contentHeight: Theme.itemSizeSmall
                Image {
                    id: findPlaceImage
                    fillMode: Image.Pad
                    height: Theme.itemSizeSmall
                    horizontalAlignment: Image.AlignRight
                    source: "image://theme/icon-m-search"
                    width: implicitWidth + Theme.paddingLarge
                }
                ListItemLabel {
                    anchors.left: findPlaceImage.right
                    anchors.leftMargin: Theme.paddingMedium
                    color: findPlaceItem.highlighted ?
                        Theme.highlightColor : Theme.primaryColor
                    height: Theme.itemSizeSmall
                    text: "Find place"
                }
                onClicked: {
                    app.pageStack.push("GeocodePage.qml");
                    app.pageStack.pushAttached("GeocodingResultsPage.qml");
                }
            }
            ListItem {
                id: findRouteItem
                contentHeight: Theme.itemSizeSmall
                Image {
                    id: findRouteImage
                    fillMode: Image.Pad
                    height: Theme.itemSizeSmall
                    horizontalAlignment: Image.AlignRight
                    source: "image://theme/icon-m-car"
                    width: implicitWidth + Theme.paddingLarge
                }
                ListItemLabel {
                    anchors.left: findRouteImage.right
                    anchors.leftMargin: Theme.paddingMedium
                    color: findRouteItem.highlighted ?
                        Theme.highlightColor : Theme.primaryColor
                    height: Theme.itemSizeSmall
                    text: "Find route"
                }
                onClicked: app.pageStack.push("RoutePage.qml");
            }
            ListItem {
                id: findNearbyItem
                contentHeight: Theme.itemSizeSmall
                Image {
                    id: findNearbyImage
                    fillMode: Image.Pad
                    height: Theme.itemSizeSmall
                    horizontalAlignment: Image.AlignRight
                    source: "icons/nearby.png"
                    width: implicitWidth + Theme.paddingLarge
                }
                ListItemLabel {
                    anchors.left: findNearbyImage.right
                    anchors.leftMargin: Theme.paddingMedium
                    color: findNearbyItem.highlighted ?
                        Theme.highlightColor : Theme.primaryColor
                    height: Theme.itemSizeSmall
                    text: "List nearby venues"
                }
                onClicked: {
                    app.pageStack.push("NearbyPage.qml");
                    app.pageStack.pushAttached("NearbyResultsPage.qml");
                }
            }
            ListItem {
                id: findCurrentPositionItem
                contentHeight: Theme.itemSizeSmall
                Image {
                    id: findCurrentPositionImage
                    fillMode: Image.Pad
                    height: Theme.itemSizeSmall
                    horizontalAlignment: Image.AlignRight
                    source: "image://theme/icon-m-gps"
                    width: implicitWidth + Theme.paddingLarge
                }
                ListItemLabel {
                    anchors.left: findCurrentPositionImage.right
                    anchors.leftMargin: Theme.paddingMedium
                    color: findCurrentPositionItem.highlighted ?
                        Theme.highlightColor : Theme.primaryColor
                    height: Theme.itemSizeSmall
                    text: "Center on current position"
                }
                onClicked: {
                    map.centerOnPosition();
                    app.pageStack.pop(mapPage, PageStackAction.Immediate);
                }
            }
            ListItem {
                id: clearMapItem
                contentHeight: Theme.itemSizeSmall
                Image {
                    id: clearMapImage
                    fillMode: Image.Pad
                    height: Theme.itemSizeSmall
                    horizontalAlignment: Image.AlignRight
                    source: "image://theme/icon-m-clear"
                    width: implicitWidth + Theme.paddingLarge
                }
                ListItemLabel {
                    anchors.left: clearMapImage.right
                    anchors.leftMargin: Theme.paddingMedium
                    color: clearMapItem.highlighted ?
                        Theme.highlightColor : Theme.primaryColor
                    height: Theme.itemSizeSmall
                    text: "Clear map"
                }
                onClicked: {
                    map.clear();
                    app.pageStack.pop(mapPage, PageStackAction.Immediate);
                }
            }
            ListTitleLabel { text: "Preferences" }
            ListItem {
                id: mapTilesItem
                contentHeight: Theme.itemSizeSmall
                Image {
                    id: mapTilesImage
                    fillMode: Image.Pad
                    height: Theme.itemSizeSmall
                    horizontalAlignment: Image.AlignRight
                    source: "image://theme/icon-m-levels"
                    width: implicitWidth + Theme.paddingLarge
                }
                ListItemLabel {
                    anchors.left: mapTilesImage.right
                    anchors.leftMargin: Theme.paddingMedium
                    color: mapTilesItem.highlighted ?
                        Theme.highlightColor : Theme.primaryColor
                    height: Theme.itemSizeSmall
                    text: "Map tiles"
                }
                onClicked: app.pageStack.push("TileSourcePage.qml");
            }
            ListItemSwitch {
                id: autoCenterItem
                anchors.leftMargin: Theme.paddingLarge + Theme.paddingSmall
                checked: map.autoCenter
                height: Theme.itemSizeSmall
                text: "Auto-center on position"
                onCheckedChanged: {
                    map.autoCenter = autoCenterItem.checked;
                    py.call_sync("poor.conf.set", ["auto_center", map.autoCenter]);
                    map.autoCenter && map.centerOnPosition();
                }
            }
            ListItemSwitch {
                id: showNarrativeItem
                anchors.leftMargin: Theme.paddingLarge + Theme.paddingSmall
                checked: py.evaluate("poor.conf.show_routing_narrative")
                height: Theme.itemSizeSmall
                text: "Show routing narrative"
                onCheckedChanged: {
                    map.showNarrative = showNarrativeItem.checked;
                    py.call_sync("poor.conf.set",
                                 ["show_routing_narrative",
                                  map.showNarrative]);

                    map.showNarrative || map.setRoutingStatus(null);
                }
            }
            ListItem {
                id: aboutItem
                contentHeight: Theme.itemSizeSmall
                Image {
                    id: aboutImage
                    fillMode: Image.Pad
                    height: Theme.itemSizeSmall
                    horizontalAlignment: Image.AlignRight
                    source: "image://theme/icon-m-about"
                    width: implicitWidth + Theme.paddingLarge
                }
                ListItemLabel {
                    anchors.left: aboutImage.right
                    anchors.leftMargin: Theme.paddingMedium
                    color: aboutItem.highlighted ?
                        Theme.highlightColor : Theme.primaryColor
                    height: Theme.itemSizeSmall
                    text: "About Poor Maps"
                }
                onClicked: app.pageStack.push("AboutPage.qml");
            }
        }
        VerticalScrollDecorator {}
    }
}
