import Qt 4.7
import "."
import org.OpenPilot 1.0

Rectangle {
    color: "#666666"

    Image {
        id: background
        source: "image://svg/pfd.svg!background"

        fillMode: Image.PreserveAspectFit
        anchors.fill: parent

        sourceSize.width: width
        sourceSize.height: height

        Item {
            id: sceneItem
            width: parent.paintedWidth
            height: parent.paintedHeight
            anchors.centerIn: parent
            clip: true

            OsgEarth {
                id: earthView

                anchors.fill: parent
                sceneFile: qmlWidget.earthFile
                visible: qmlWidget.terrainEnabled

                fieldOfView: 90

                yaw: AttitudeActual.Yaw
                pitch: AttitudeActual.Pitch
                roll: AttitudeActual.Roll

                latitude: qmlWidget.actualPositionUsed ?
                              GPSPosition.Latitude/10000000.0 : qmlWidget.latitude
                longitude: qmlWidget.actualPositionUsed ?
                               GPSPosition.Longitude/10000000.0 : qmlWidget.longitude
                altitude: qmlWidget.actualPositionUsed ?
                              GPSPosition.Altitude : qmlWidget.altitude
            }

            Image {
                id: world
                source: "image://svg/pfd.svg!world"
                sourceSize: background.sourceSize
                smooth: true
                visible: !qmlWidget.terrainEnabled

                transform: [
                    Translate {
                        id: pitchTranslate
                        x: (world.parent.width - world.width)/2
                        y: (world.parent.height - world.height)/2 + AttitudeActual.Pitch*world.parent.height/94
                    },
                    Rotation {
                        angle: -AttitudeActual.Roll
                        origin.x : world.parent.width/2
                        origin.y : world.parent.height/2
                    }
                ]
            }

            Image {
                id: rollscale
                source: "image://svg/pfd.svg!rollscale"
                sourceSize: background.sourceSize
                smooth: true

                transformOrigin: Item.Center
                rotation: -AttitudeActual.Roll
            }

            Image {
                id: foreground
                source: "image://svg/pfd.svg!foreground"
                sourceSize: background.sourceSize
                anchors.centerIn: parent
            }

            Image {
                id: compass
                source: "image://svg/pfd.svg!compass"
                sourceSize: background.sourceSize
                clip: true

                y: 12
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    id: compass_band
                    source: "image://svg/pfd.svg!compass-band"
                    sourceSize: background.sourceSize

                    anchors.centerIn: parent
                    //the band is 540 degrees wide
                    anchors.horizontalCenterOffset: -1*AttitudeActual.Yaw/540*width
                }
            }

            SpeedScale {
                anchors.fill: parent
                sourceSize: background.sourceSize
            }

            AltitudeScale {
                anchors.fill: parent
                sourceSize: background.sourceSize
            }

            PfdIndicators {
                anchors.fill: parent
                sourceSize: background.sourceSize
            }
        }
    }
}