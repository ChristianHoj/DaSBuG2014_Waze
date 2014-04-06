var accident_icon = L.divIcon({html: '<i class="fa fa-ambulance"></i>'});
var hazard_icon = L.divIcon({html: '<i class="fa fa-cloud"></i>'});
var jam_icon = L.divIcon({html: '<i class="fa fa-warning"></i>'});
var police_icon = L.divIcon({html: '<i class="fa fa-tachometer"></i>'});


// create a map in the "map" div, set the view to a given place and zoom
var map = L.map('map').setView(points[5], 12);

// add an OpenStreetMap tile layer
L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors | Waze GeoRSS'
}).addTo(map);

var stdMarkerLayer = L.layerGroup();
var iconMarkerLayer = L.layerGroup();
var annotationLayer = L.layerGroup();

// add a marker in the given location, attach some popup content to it and open the popup
var marker_icon;
for (var i = points.length - 1; i >= 0; i--) {
  switch (causes[i]) {
    case "ACCIDENT":
    marker_icon = accident_icon;
    break;

    case "JAM":
    marker_icon = jam_icon;
    break;

    case "POLICEMAN":
    marker_icon = police_icon;
    break;

    case "WEATHERHAZARD":
    marker_icon = hazard_icon;
    break;

    default:
    marker_icon = new L.Icon.Default();
  }
  stdMarkerLayer.addLayer(L.marker(points[i]).bindPopup(causes[i]));
  iconMarkerLayer.addLayer(L.marker(points[i], {icon: marker_icon}).bindPopup(causes[i]));
}
stdMarkerLayer.addTo(map);

var circle = L.circle([56.942661, 24.065871], 2000, {
    color: 'red',
    fillColor: '#f03',
    fillOpacity: 0.5
});
annotationLayer.addLayer(circle);

var baselayers = {
  "Markers": stdMarkerLayer,
  "Icons": iconMarkerLayer
};
var overlays = {
  "Heatmap": annotationLayer
}
L.control.layers(baselayers, overlays).addTo(map);
