# Lantmäteriets Fjällkarta
Lantmäteriets Fjällkarta (Swedish mountain map) reprojected to WGS84 as a "Tiled web map" for Guru Maps-app, OpenStreetMap and Google Maps.

[![Lantmäteriets Fjällkarta](https://git.beroni.us/Lantmateriets-Fjallkarta/fjallkartan.jpg)](https://git.beroni.us/Lantmateriets-Fjallkarta/fjallkartan.html)

## Guru Maps
[Guru Maps](https://gurumaps.app/) makes in easy to zoom and pan seamlessly in tiled web maps. It also saves all downloaded tiles for offline use.

#### Install the app
The app can be found [for iOS here](https://itunes.apple.com/us/app/galileo-offline-maps-osm-based/id321745474)
and [for Android here](https://play.google.com/store/apps/details?id=com.bodunov.galileo).

#### Add map source
To add a custom map source, open the map source [Lantmäteriets Fjällkarta for Guru Maps](https://custom-map-source.appspot.com/galileo-lantmateriets-fjallkarta.ms) in the browser on the device and select "Open in Guru Maps". Many other map sources can also be found here: https://custom-map-source.appspot.com/.

#### Offline
The complete map is available as one 400 MB file for offline use. Open the file [Lantmäteriets Fjällkarta for Guru Maps](https://drive.google.com/open?id=1pWaaIDBzilVCYp3gXEdLgCF8TNQ8DQnK) in the browser on the device and select "Open in Guru Maps".

## Google Maps
A map overlay for Google Maps for desktop or mobile browsers can be found here: [Lantmäteriets Fjällkarta for Google Maps](https://git.beroni.us/Lantmateriets-Fjallkarta/fjallkartan.html)

## Google Earth
The map can also be found as a "Super Overlay" for Google Earth here: [Lantmäteriets Fjällkarta for Google Earth](https://git.beroni.us/Lantmateriets-Fjallkarta/Google-Earth.kml)

## About tiled web maps
Read about [tiled web maps on Wikipedia](https://en.wikipedia.org/wiki/Tiled_web_map).

## Code
The Perl-script is a one-time batch job that reprojects coordinates, downloads map images, transforms perspective and composits them.
ImageMagick is used for image processing. The output from the script can be found using the links above, no need to run the code to view the map.

## Map source
Original web map can be found here: [Kartsök och ortnamn](https://kso.etjanster.lantmateriet.se/),
and information about the mountain map product here: [Fjällkartan](http://www.lantmateriet.se/sv/Kartor-och-geografisk-information/Kartor/Fjallkartan/)
