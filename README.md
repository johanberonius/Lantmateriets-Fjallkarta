# Lantmäteriets Fjällkarta
Lantmäteriets Fjällkarta (Swedish mountain map) reprojected to WGS84 as a "Tiled web map" for Galileo-app, OpenStreetMap and Google Maps.

## Galileo-app
Galileo https://galileo-app.com/ makes in easy to zoom and pan seamlessly in tiled web maps. It also saves all downloaded tiles for offline use.
The app can be found for iOS here https://itunes.apple.com/us/app/galileo-offline-maps-osm-based/id321745474 or Android here https://play.google.com/store/apps/details?id=com.bodunov.galileo
To add a custom map source, open https://db.tt/vikFZZaW in the browser on the device and select "Open in Galileo".

## Google Maps
A map overlay for Google Maps for desktop or mobile browsers can be found here https://db.tt/1tYS2RGQ

## Google Earth
The map can also be found as a "Super Overlay" for Google Earth here https://db.tt/6NIZL0tq

## About tiled web maps
https://en.wikipedia.org/wiki/Tiled_web_map

## Code
The Perl-script is a one-time batch job that reprojects coordinates, downloads map images, transforms perspective and composits them.
ImageMagick is used for image processing. The output from the script can be found using the links above, no need to run the code to view the map.

## Map source
Original web map can be found here https://kso.etjanster.lantmateriet.se/
