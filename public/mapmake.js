// create a map in the "map" div, set the view to a given place and zoom
var map = L.map('map').setView([56.951848,24.098697], 12);

// add an OpenStreetMap tile layer
L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors | Waze GeoRSS'
}).addTo(map);

function initRegularMap() {
  var accident_icon = L.divIcon({html: '<i class="fa fa-ambulance"></i>'});
  var hazard_icon = L.divIcon({html: '<i class="fa fa-cloud"></i>'});
  var jam_icon = L.divIcon({html: '<i class="fa fa-warning"></i>'});
  var police_icon = L.divIcon({html: '<i class="fa fa-tachometer"></i>'});

  var stdMarkerLayer = L.layerGroup();
  var clusterMarkerLayer = new L.MarkerClusterGroup();
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
    clusterMarkerLayer.addLayer(L.marker(points[i]).bindPopup(causes[i]));
    iconMarkerLayer.addLayer(L.marker(points[i], {icon: marker_icon}).bindPopup(causes[i]));
  }
  stdMarkerLayer.addTo(map);

  // Add add a few circles to zones layer
  var circle = L.circle([56.942661, 24.065871], 2000, {
    color: 'red',
    fillColor: '#f03',
    fillOpacity: 0.5
  });
  annotationLayer.addLayer(circle);
  circle = L.circle([56.958192, 24.100122], 2000, {
    color: 'yellow',
    fillColor: '#cece00',
    fillOpacity: 0.5
  });
  annotationLayer.addLayer(circle);

  // Enable layer controls for the map
  var baselayers = {
    "Markers": stdMarkerLayer,
    "Icons": iconMarkerLayer,
    "Cluster": clusterMarkerLayer
  };
  var overlays = {
    "Zones": annotationLayer
  };
  L.control.layers(baselayers, overlays).addTo(map);
}


function initTimelapseMap(timeline) {
  var timelapseLayers = [];
  var points;

  for (var i = timeline.length - 1; i >= 0; i--) {
    points = timeline[i].points;
    var stdMarkerLayer = L.layerGroup();
    for (var p = points.length - 1; p >= 0; p--) {
      stdMarkerLayer.addLayer(L.marker(points[p].location));
    }
    timelapseLayers.unshift({
      layer: stdMarkerLayer,
      timestamp: timeline[i].timestamp
    });
  }
  i = 0;

  setInterval(function() {
    if (i === 0) {
      map.removeLayer(timelapseLayers[timelapseLayers.length-1].layer);
    } else {
      map.removeLayer(timelapseLayers[i-1].layer);
    }
    map.addLayer(timelapseLayers[i].layer);
    $("#timestamp").html("Riga - " + timelapseLayers[i].timestamp);
    i++;
    if (i === timelapseLayers.length) {
      i = 0;
    }
  }, 750);
  
}
