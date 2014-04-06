var warning_icon = L.divIcon({html: '<i class="fa fa-warning"></i>'});
var police_icon = L.divIcon({html: '<i class="fa fa-tachometer"></i>'});


// create a map in the "map" div, set the view to a given place and zoom
var map = L.map('map').setView(points[5], 12);

// add an OpenStreetMap tile layer
L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors | Waze GeoRSS'
}).addTo(map);

var stdMarkerLayer = L.layerGroup();
var iconMarkerLayer = L.layerGroup();

// add a marker in the given location, attach some popup content to it and open the popup
var marker_icon;
for (var i = points.length - 1; i >= 0; i--) {
  switch (causes[i]) {
    case "WEATHERHAZARD":
    marker_icon = warning_icon;
    break;

    case "POLICEMAN":
    marker_icon = police_icon;
    break;

    default:
    marker_icon = new L.Icon.Default();
  }
  stdMarkerLayer.addLayer(L.marker(points[i]).bindPopup(causes[i]));
  iconMarkerLayer.addLayer(L.marker(points[i], {icon: marker_icon}).bindPopup(causes[i]));
}
stdMarkerLayer.addTo(map);

// .openPopup();

// var circle = L.circle([51.508, -0.11], 2000, {
//     color: 'red',
//     fillColor: '#f03',
//     fillOpacity: 0.5
// }).addTo(map);

$("#stdMarkers").on("click", function(event) {
  map.removeLayer(iconMarkerLayer);
  map.addLayer(stdMarkerLayer);
});

$("#iconMarkers").on("click", function(event) {
  map.removeLayer(stdMarkerLayer);
  map.addLayer(iconMarkerLayer);
});
