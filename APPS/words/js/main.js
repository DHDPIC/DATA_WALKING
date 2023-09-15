// initialise mapbox
mapboxgl.accessToken = 'pk.eyJ1IjoiZGhkcGljIiwiYSI6IkZfUEVoTUUifQ.rNj-tr8788GTdoGnyMEtAQ';
    var map = new mapboxgl.Map({
container: 'map', // container ID
style: 'mapbox://styles/dhdpic/ckny7kaku1c8617pnlfatzqpz', // style URL

center: [-0.12, 51.51], // starting position [lng, lat]
zoom: 9 // starting zoom

});

map.on('load', function () {
  map.addSource('points', {
    'type': 'geojson',
    'data': myJson

});
// Add a symbol layer
  /*map.addLayer({
    'id': 'points',
    'type': 'circle',
    'source': 'points',
    paint: {
      'circle-color': '#C97CF7',
      'circle-radius': 4,
      'circle-stroke-width': 1,
      'circle-stroke-color': '#fff'
    }
  });*/

  // Add a symbol layer
  map.addLayer({
    'id': 'points',
    'type': 'symbol',
    'source': 'points',
    /*paint: {
      'circle-color': '#C97CF7',
      'circle-radius': 4,
      'circle-stroke-width': 1,
      'circle-stroke-color': '#fff'
    }*/
	'layout': {
		'text-field': ["get","text"],
		'text-font': ['Apercu Bold'],
		'text-size': 10,
		'text-allow-overlap': true
	},
	'paint': {
		'text-halo-color': '#C97CF7',
		'text-halo-width': 0.5,
		'text-halo-blur': 0.5
	}
  });

});

var myJson = {
    type: "FeatureCollection",
    features: []
};

function createJson(id, button_id, button_label, count, the_text, latitude, longitude, altitude, timestamp, iso_date, date, time) {
	console.log("blah blah json");
	//
	if(altitude === null) {
	myJson.features.push({
	  "type": "Feature",
	  "properties":{
	  	"id":id,
	  	"button_id":button_id,
	  	"button_label":button_label,
	  	"count": count,
	  	"text": the_text,
	  	"timestamp": timestamp,
	  	"iso-date": iso_date,
		"date": date,
	  	"time": time

	  },
	  "geometry": {
	    "type": "Point",
	    "coordinates": [currPosition.coords.longitude, currPosition.coords.latitude]
	  }
	});

	} else {

	//
	myJson.features.push({
	  "type": "Feature",
	  "properties":{
	  	"id":id,
	  	"button_id":button_id,
	  	"button_label":button_label,
	  	"count": count,
	  	"text": the_text,
	  	"timestamp": timestamp,
	  	"iso-date": iso_date,
		"date": date,
	  	"time": time

	  },
	  "geometry": {
	    "type": "Point",
	    "coordinates": [currPosition.coords.longitude, currPosition.coords.latitude, currPosition.coords.altitude]
	  }
	});
}
//
console.log(myJson);
}

function mapJson() {
	map.getSource('points').setData(myJson);
  	//
  	var bounds = new mapboxgl.LngLatBounds();

  	myJson.features.forEach(function(feature) {
    	bounds.extend(feature.geometry.coordinates);
    	console.log(feature);
	});

	map.fitBounds(bounds);
}

function exportJson() {
  
  console.log("export geojson...");
  console.log(myJson);

  // Convert object to Blob
  const blobData = new Blob(
      [ JSON.stringify(myJson, undefined, 2) ], 
      { type: 'text/json;charset=utf-8' }
  )
  
  // Convert Blob to URL
  const blobUrl = URL.createObjectURL(blobData);
  
  // Create an a element with blobl URL
  const anchor = document.createElement('a');
  anchor.href = blobUrl;
  anchor.target = "_self";
  anchor.download = "datawalking.geojson";
  
  // Auto click on a element, trigger the file download
  anchor.click();
  
  // Don't forget ;)
  URL.revokeObjectURL(blobUrl);

}

function exportJson2() {

	console.log("export geojson new way 2...");
  	console.log(myJson);

  	console.log("save the date...")
  	/*
	let saveDate = new Date();
	let yr = currDate.getFullYear();
	let mo = currDate.getMonth()+1;
	let dt = currDate.getDate();
	let hr = currDate.getHours();
	let mn = currDate.getMinutes();
	let sc = currDate.getSeconds();
	//
	if (mo<10) { mo = '0'+mo;}
	if (dt<10) { dt = '0'+dt;}
	if (mn<10) { mn = '0'+mn;}
	if (sc<10) { sc = '0'+sc;}
	*/
	//
	let dateStr = getSaveDate();//yr+"-"+mo+"-"+dt+"-"+hr+"-"+mn+"-"+sc;

  // Convert object to Blob
  const blobData = new Blob(
      [ JSON.stringify(myJson, undefined, 2) ], 
      { type: 'text/json;charset=utf-8' }
  )

  //
  var reader = new FileReader();
  reader.onload = function() {
    var popup = window.open();
    var link = document.createElement('a');
    link.setAttribute('href', reader.result);
    link.setAttribute('download', 'datawalking-'+dateStr+'.geojson');
    popup.document.body.appendChild(link); 
    link.click();
  }
  reader.readAsDataURL(blobData); 
  /*
  // Convert Blob to URL
  const blobUrl = URL.createObjectURL(blobData);
  
  // Create an a element with blobl URL
  const anchor = document.createElement('a');
  anchor.href = blobUrl;
  anchor.target = "_self";
  anchor.download = "datawalking.geojson";
  
  // Auto click on a element, trigger the file download
  anchor.click();
  
  // Don't forget ;)
  URL.revokeObjectURL(blobUrl);
*/
}

function getSaveDate() {

	let saveDate = new Date();
	let yr = currDate.getFullYear();
	let mo = currDate.getMonth()+1;
	let dt = currDate.getDate();
	let hr = currDate.getHours();
	let mn = currDate.getMinutes();
	let sc = currDate.getSeconds();
	//
	if (mo<10) { mo = '0'+mo;}
	if (dt<10) { dt = '0'+dt;}
	if (hr<10) { hr = '0'+hr;}
	if (mn<10) { mn = '0'+mn;}
	if (sc<10) { sc = '0'+sc;}
	//
	return yr+"-"+mo+"-"+dt+"-"+hr+"-"+mn+"-"+sc;

}


// variables for geo, time, buttons, data
var geoEnabled = document.getElementById("geo-enabled");
var dataReadOut = document.getElementById("read-out");

var currPosition;

var currDate = new Date();

var resetDataBtn = document.getElementById("resetData");
var exportCSVBtn = document.getElementById("exportCSV");
var exportGeoJsonBtn = document.getElementById("exportGeoJson");

var id = 0;
var dataHead = ["id","button_id","label","count","text","latitude","longitude","altitude", "timestamp", "iso-date", "date", "time"];
var dataArr = [dataHead];

var addButton = document.getElementById("adder");

var countTracker1 = document.getElementById("countNumberTracker1");
countTracker1.innerHTML = 0;

var inputField1 = document.getElementById("inputField1");

// variables for editing
//var currEdit = false;
//var editBtn = document.getElementById("edit");


// array to store counts
var countArr = [0];

// storing button id values
addButton.value = 0;

var buttonArr = [addButton];
var countTrackerArr = [countTracker1];
var inputFieldArr = [inputField1];

//trigger location
function getLocation() {
	console.log("trying to get geolocation enabled");
  	if (navigator.geolocation) {
    	navigator.geolocation.getCurrentPosition(showPosition, failPosition);
    	navigator.geolocation.watchPosition(trackPosition);
    	console.log("geo location enabled");
  	} else {
  		console.log("geo location failed");
    	geoEnabled.innerHTML = "Geolocation is not supported by this browser.";
    
  	}
}

function failPosition(error) {
	if(error.code == error.PERMISSION_DENIED) {
	console.log("geolocation access denied");
	// you could hide elements, but currently covered by the shield
	} else {
		console.log("other error");
	}
}

function showPosition(position) {
  /*geoEnabled.innerHTML = "Geolocation enabled! At " + position.coords.timestamp + " time:" +
  "<br>Latitude: " + position.coords.latitude +
  "<br>Longitude: " + position.coords.longitude +
  "<br>Altitude: " + position.coords.altitude;*/
  geoEnabled.innerHTML = "geolocation enabled";
  geoEnabled.style.visibility = "hidden";

  //
  var s = document.getElementById("shield");
  s.style.visibility = "hidden";
}

function trackPosition(position) {
	currPosition = position;
}


function countPress() {
	//
	/* geoEnabled.innerHTML = "Geolocation enabled! At " + currPosition.coords.timestamp + " time:" +
  "<br>Latitude: " + currPosition.coords.latitude +
  "<br>Longitude: " + currPosition.coords.longitude +
  "<br>Altitude: " + currPosition.coords.altitude; */
	//
	currDate = new Date();
	let yr = currDate.getFullYear();
	let mo = currDate.getMonth()+1;
	let dt = currDate.getDate();
	let hr = currDate.getHours();
	let mn = currDate.getMinutes();
	let sc = currDate.getSeconds();
	//
	if (mo<10) { mo = '0'+mo;}
	if (dt<10) { dt = '0'+dt;}
	if (hr<10) { hr = '0'+hr;}
	if (mn<10) { mn = '0'+mn;}
	if (sc<10) { sc = '0'+sc;}
	//
	id++;
	//this.value++;
	//countTrack1.innerHTML = this.value;
	countArr[this.value]++;
	var v = countArr[this.value];
	var t = inputFieldArr[this.value].value;
	var currArr = [id, Number(this.value), this.innerHTML, v, "\""+t+"\"", currPosition.coords.latitude, currPosition.coords.longitude, currPosition.coords.altitude, currPosition.coords.timestamp, yr+"-"+mo+"-"+dt+"T"+hr+":"+mn+":"+sc, yr+"-"+mo+"-"+dt, hr+":"+mn+":"+sc ];
	dataArr.push(currArr);
	//
	console.log(dataArr);
	//
	countTrackerArr[this.value].innerHTML = v;
	inputFieldArr[this.value].value = ""
	inputFieldArr[this.value].focus();
	//
	dataReadOut.innerHTML = currArr;

	createJson(id, Number(this.value), this.innerHTML, v, t, currPosition.coords.latitude, currPosition.coords.longitude, currPosition.coords.altitude, currPosition.coords.timestamp, yr+"-"+mo+"-"+dt+"T"+hr+":"+mn+":"+sc, yr+"-"+mo+"-"+dt, hr+":"+mn+":"+sc);
	mapJson();
}

function resetData() {
	//
	id = 0;
	dataArr = [dataHead];
	countArr = [0];
countTracker1.innerHTML = 0;
	//
// reset json
	myJson = {
    type: "FeatureCollection",
    features: []
	};
	//
	console.log(dataArr);
}

function exportCSV() {
	let csvContent = "data:text/csv;charset=utf-8,";

	dataArr.forEach(function(rowArr) {
		let row = rowArr.join(",");
		csvContent += row + "\r\n";
	});

	var encodedUri = encodeURI(csvContent);
	window.open(encodedUri);
}

function exportCSV2() {
	let csvContent;// = "data:text/csv;charset=utf-8,";

	dataArr.forEach(function(rowArr) {
		let row = rowArr.join(",");
		csvContent += row + "\r\n";
	});
/*
	var encodedUri = encodeURI(csvContent);
	var link = document.createElement("a");
	link.setAttribute("href", encodedUri);
	link.setAttribute("download", "my_data.csv");
	document.body.appendChild(link); // Required for FF

	link.click(); // This will download the data file named "my_data.csv".
*/
	//
	let dateStr = getSaveDate();
	// Convert object to Blob
  	const blobData = new Blob(
      [ csvContent ], 
      { type: 'text/csv;charset=utf-8' }
  	)

  //
  var reader = new FileReader();
  reader.onload = function() {
    var popup = window.open();
    var link = document.createElement('a');
    link.setAttribute('href', reader.result);
    link.setAttribute('download', 'datawalking-'+dateStr+'.csv');
    popup.document.body.appendChild(link); 
    link.click();
  }
  reader.readAsDataURL(blobData);
}

function editPress() {
	currEdit = !currEdit;
	if(currEdit) {

		editBtn.innerHTML = "Save";

		buttonLabel1.style.visibility = "visible";
		buttonLabel2.style.visibility = "visible";
		buttonLabel3.style.visibility = "visible";
		buttonLabel4.style.visibility = "visible";
		buttonLabel5.style.visibility = "visible";
		buttonLabel6.style.visibility = "visible";
		buttonLabel7.style.visibility = "visible";
		buttonLabel8.style.visibility = "visible";
		buttonLabel9.style.visibility = "visible";

		countBtn1.classList.toggle("inactive-button");
		countBtn2.classList.toggle("inactive-button");
		countBtn3.classList.toggle("inactive-button");
		countBtn4.classList.toggle("inactive-button");
		countBtn5.classList.toggle("inactive-button");
		countBtn6.classList.toggle("inactive-button");
		countBtn7.classList.toggle("inactive-button");
		countBtn8.classList.toggle("inactive-button");
		countBtn9.classList.toggle("inactive-button");
	} else {
		editBtn.innerHTML = "Edit";

		buttonLabel1.style.visibility = "hidden";
		countBtn1.innerHTML = buttonLabel1.value;
		buttonLabel2.style.visibility = "hidden";
		countBtn2.innerHTML = buttonLabel2.value;
		buttonLabel3.style.visibility = "hidden";
		countBtn3.innerHTML = buttonLabel3.value;
		
		buttonLabel4.style.visibility = "hidden";
		countBtn4.innerHTML = buttonLabel4.value;
		buttonLabel5.style.visibility = "hidden";
		countBtn5.innerHTML = buttonLabel5.value;
		buttonLabel6.style.visibility = "hidden";
		countBtn6.innerHTML = buttonLabel6.value;
		
		buttonLabel7.style.visibility = "hidden";
		countBtn7.innerHTML = buttonLabel7.value;
		buttonLabel8.style.visibility = "hidden";
		countBtn8.innerHTML = buttonLabel8.value;
		buttonLabel9.style.visibility = "hidden";
		countBtn9.innerHTML = buttonLabel9.value;

		countBtn1.classList.toggle("inactive-button");
		countBtn2.classList.toggle("inactive-button");
		countBtn3.classList.toggle("inactive-button");
		countBtn4.classList.toggle("inactive-button");
		countBtn5.classList.toggle("inactive-button");
		countBtn6.classList.toggle("inactive-button");
		countBtn7.classList.toggle("inactive-button");
		countBtn8.classList.toggle("inactive-button");
		countBtn9.classList.toggle("inactive-button");
	}
}

//
//
//

getLocation();

resetDataBtn.addEventListener("click", resetData);
exportCSVBtn.addEventListener("click", exportCSV2);
exportGeoJsonBtn.addEventListener("click", exportJson2);

addButton.addEventListener("click", countPress);


//editBtn.addEventListener("click", editPress);
