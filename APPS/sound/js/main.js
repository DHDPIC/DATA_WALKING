// Copyright (c) 2019 ml5
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/* ===
ml5 Example
Real time Object Detection using objectDetector
=== */

/*const constraints = {
	audio: false,
  video: true
};*/

const constraints = {
  audio: true,
  video: false,
  /*video: {
    facingMode: {
      exact: 'environment'
    }
  }*/
};

let recordData = false;
let objectId = 0;

let objectDetector;
let status;
let objects = [];
let video;
let canvas, ctx;
const width = 480;
const height = 360;

let placer;

let audioCtx; // = new (window.AudioContext || window.webkitAudioContext)();
//const voiceSelect = document.getElementById("voice");
let source;
let stream;

// Grab the mute button to use below
//const mute = document.querySelector(".mute");

// Set up the different audio nodes we will use for the app
let analyser;

// Set up canvas context for visualizer
canvas = document.querySelector(".visualizer");
const canvasCtx = canvas.getContext("2d");

// when the dom is loaded, call make();
//window.addEventListener("DOMContentLoaded", function () {
//make();
//});

//window.addEventListener("DOMContentLoaded", make());

let tapped = false; // check a tap has happened...
document.body.addEventListener("click", make);

async function make() {
  console.log("func make");
  tapped = true;
  document.body.removeEventListener("click", make);
  //
  var s = document.getElementById("shield");
  s.style.visibility = "hidden";
  //
  placer = document.getElementById("audio");
  // get the video
  //video = await getVideo();

  audioCtx = new (window.AudioContext || window.webkitAudioContext)();
  analyser = audioCtx.createAnalyser();
  analyser.minDecibels = -90;
  analyser.maxDecibels = -10;
  analyser.smoothingTimeConstant = 0.85;

  // Main block for doing the audio recording
  if (navigator.mediaDevices.getUserMedia) {
    console.log("getUserMedia supported.");
    const constraints = { audio: true };
    navigator.mediaDevices
      .getUserMedia(constraints)
      .then(function (stream) {
        source = audioCtx.createMediaStreamSource(stream);
        //source.connect(distortion);
        //distortion.connect(biquadFilter);
        //biquadFilter.connect(gainNode);
        //convolver.connect(gainNode);
        //echoDelay.placeBetween(gainNode, analyser);
        source.connect(analyser);
        //analyser.connect(audioCtx.destination);

        visualize();
        //voiceChange();
      })
      .catch(function (err) {
        console.log("The following gUM error occured: " + err);
      });
  } else {
    console.log("getUserMedia not supported on your browser!");
  }
}

function visualize() {
  console.log("v i s u a l i s e");
  //
  WIDTH = 256; //canvas.width;
  HEIGHT = 256; //canvas.height;

  /* - - - GET RID
    const visualSetting = visualSelect.value;
    console.log(visualSetting);
    */

  /*if (visualSetting == "frequencybars") {*/
  analyser.fftSize = 256;
  const bufferLengthAlt = analyser.frequencyBinCount;
  console.log(bufferLengthAlt);

  // See comment above for Float32Array()
  const dataArrayAlt = new Uint8Array(bufferLengthAlt);

  //canvasCtx.clearRect(0, 0, WIDTH, HEIGHT);

  const drawAlt = function () {
    let inc = 1;

    let pixels = canvasCtx.getImageData(1, 0, WIDTH - inc, HEIGHT);
    //console.log(pixels);
    canvasCtx.putImageData(pixels, 0, 0);

    /*for(let i=0; i<WIDTH-inc; i+=inc) {
          //let pixels = canvasCtx.getImageData(i+inc,0, inc, HEIGHT);
          //canvasCtx.putImageData(pixels, i, 0);
          //canvasCtx.fillStyle = "rgb("+Math.random()*255+","+Math.random()*255+", 0)";
          /
        }*/

    drawVisual = requestAnimationFrame(drawAlt);

    analyser.getByteFrequencyData(dataArrayAlt);
    //console.log("d arr alt", dataArrayAlt);

    if (recordData) {
      //console.log(objects);
      //inputFieldArr[0].value += "\n" + objects[0].label;

      console.log("d arr alt rec", dataArrayAlt); // works
      // add the audio to the data array
      //realtimeAddArray(dataArrayAlt); // works

      tempAudioData = tempAudioData.map(function (val, indx) {
        return val + dataArrayAlt[indx];
      });
      tempAudioCount++; //increment tracker
      //console.log("tac c",tempAudioCount);
      //console.log("tac d",tempAudioData);
    }

    //canvasCtx.fillStyle = "rgb(0, 0, 0)";
    //canvasCtx.fillRect(0, 0, WIDTH, HEIGHT);

    let barWidth = 0; // (WIDTH / bufferLengthAlt) * 2.5;
    let barHeight = HEIGHT / bufferLengthAlt; // * 2.5;
    let x = WIDTH;
    let y = 0;

    //console.log(dataArrayAlt);
    for (let i = 0; i < bufferLengthAlt; i++) {
      barWidth = dataArrayAlt[i];
      //console.log(barWidth);

      /*
          //canvasCtx.fillStyle = "rgb(" + (barHeight + 100) + ",50,50)";
          canvasCtx.fillStyle = "rgb(" + (barWidth) + ",0,0)";
          canvasCtx.fillRect(
            x-barWidth,
            y,//HEIGHT - barHeight / 2,
            barWidth,//WIDTH,
            barHeight//barHeight / 2
          );

          //x += barWidth -1;
          y += barHeight -1;
          */
         if(recordData) {
      canvasCtx.fillStyle =
      //"rgba(" + barWidth * 2 + "," + barWidth * 2 + "," + barWidth * 2 + ")"; // white
      //"rgba(" + 255 + "," + 255 + "," + 255 + "," + (barWidth * 2)/255 +  ")"; // white using alpha
      "rgb(" + 201/255 * (barWidth * 2) + "," + 124/255 * (barWidth * 2) + "," + 247/255 * (barWidth * 2) + ")";
         } else {
          canvasCtx.fillStyle = "rgb(" + (barWidth * 2) + "," + (barWidth * 2) + "," + (barWidth * 2) + ")";
         }
      canvasCtx.fillRect(
        WIDTH - inc,
        y, //HEIGHT - barHeight / 2,
        inc, //WIDTH,
        barHeight //barHeight / 2
      );
         

      //x += barWidth -1;
      y += barHeight; //-1;
    }
  };

  drawAlt();
  /*--- } */
}

// array to store data and then average before saving to file
let tempAudioData = new Array(128);
let tempAudioCount = 0;

//add a timer for averaging data
//let recordTimer = setInterval(timerAverageData,1000);
let recordTimer; // = setInterval(timerAverageData,1000);

function timerAverageData() {
  console.log("timer hit");
  // average data
  tempAudioData = tempAudioData.map(function (val, indx) {
    return Math.round((val = val / tempAudioCount));
  });
  tempAudioCount = 0;
  realtimeAddArray(tempAudioData); // works
  console.log("tac averaged", tempAudioData);
  // write data and save

  // increment timer display
  elapsedRecordingTime++;
  let mins = Math.floor(elapsedRecordingTime/60);
  let secs = elapsedRecordingTime%60;
  if(mins>=1) {
    countTracker1.innerHTML = mins+"m"+secs+"s";
  } else {
    countTracker1.innerHTML = secs+"s";
  }
}

/*
// initialise mapbox
mapboxgl.accessToken = 'pk.eyJ1IjoiZGhkcGljIiwiYSI6IkZfUEVoTUUifQ.rNj-tr8788GTdoGnyMEtAQ';
    var map = new mapboxgl.Map({
container: 'map', // container ID
style: 'mapbox://styles/dhdpic/ckny7kaku1c8617pnlfatzqpz', // style URL

center: [-0.12, 51.51], // starting position [lng, lat]
zoom: 9 // starting zoom

});
*/

/*
map.on('load', function () {
  map.addSource('points', {
    'type': 'geojson',
    'data': myJson

});
// Add a symbol layer
  map.addLayer({
    'id': 'points',
    'type': 'circle',
    'source': 'points',
    paint: {
      'circle-color': '#C97CF7',
      'circle-radius': 4,
      'circle-stroke-width': 1,
      'circle-stroke-color': '#fff'
    }
  });

});
*/

var myJson = {
  type: "FeatureCollection",
  features: [],
};

function createJson(
  id,
  button_id,
  button_label,
  count,
  the_text,
  latitude,
  longitude,
  altitude,
  timestamp,
  iso_date,
  date,
  time
) {
  //console.log("blah blah json");
  //
  if (altitude === null) {
    myJson.features.push({
      "type": "Feature",
      "properties": {
        "id": id,
        "button_id": button_id,
        "button_label": button_label,
        "count": count,
        "audio": the_text,
        "timestamp": timestamp,
        "iso-date": iso_date,
        "date": date,
        "time": time,
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          currPosition.coords.longitude,
          currPosition.coords.latitude,
        ],
      },
    });
  } else {
    //
    myJson.features.push({
      "type": "Feature",
      "properties": {
        "id": id,
        "button_id": button_id,
        "button_label": button_label,
        "count": count,
        "audio": the_text,
        "timestamp": timestamp,
        "iso-date": iso_date,
        "date": date,
        "time": time,
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          currPosition.coords.longitude,
          currPosition.coords.latitude,
          currPosition.coords.altitude,
        ],
      },
    });
  }
  //
  console.log(myJson);
}

function createSmallJson(
  id,
  the_text,
  latitude,
  longitude,
  altitude,
  timestamp,
  iso_date,
  date,
  time
) {
  //console.log("blah blah json");
  //
  if (altitude === null) {
    myJson.features.push({
      "type": "Feature",
      "properties": {
        "id": id,
        "audio": the_text,
        "timestamp": timestamp,
        "iso-date": iso_date,
        "time": time,
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          currPosition.coords.longitude,
          currPosition.coords.latitude,
        ],
      },
    });
  } else {
    //
    myJson.features.push({
      "type": "Feature",
      "properties": {
        "id": id,
        "audio": the_text,
        "timestamp": timestamp,
        "iso-date": iso_date,
        "time": time,
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          currPosition.coords.longitude,
          currPosition.coords.latitude,
          currPosition.coords.altitude,
        ],
      },
    });
  }
  //
  console.log(myJson);
}

/*
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
*/

function exportJson() {
  console.log("export geojson...");
  console.log(myJson);

  // Convert object to Blob
  const blobData = new Blob([JSON.stringify(myJson, undefined, 2)], {
    type: "text/json;charset=utf-8",
  });

  // Convert Blob to URL
  const blobUrl = URL.createObjectURL(blobData);

  // Create an a element with blobl URL
  const anchor = document.createElement("a");
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

  console.log("save the date...");
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
  let dateStr = getSaveDate(); //yr+"-"+mo+"-"+dt+"-"+hr+"-"+mn+"-"+sc;

  // Convert object to Blob
  const blobData = new Blob([JSON.stringify(myJson, undefined, 2)], {
    type: "text/json;charset=utf-8",
  });

  //
  var reader = new FileReader();
  reader.onload = function () {
    var popup = window.open();
    var link = document.createElement("a");
    link.setAttribute("href", reader.result);
    link.setAttribute("download", "datawalking-" + dateStr + ".geojson");
    popup.document.body.appendChild(link);
    link.click();
  };
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
  let mo = currDate.getMonth() + 1;
  let dt = currDate.getDate();
  let hr = currDate.getHours();
  let mn = currDate.getMinutes();
  let sc = currDate.getSeconds();
  //
  if (mo < 10) {
    mo = "0" + mo;
  }
  if (dt < 10) {
    dt = "0" + dt;
  }
  if (hr < 10) {
    hr = "0" + hr;
  }
  if (mn < 10) {
    mn = "0" + mn;
  }
  if (sc < 10) {
    sc = "0" + sc;
  }
  //
  return yr + "-" + mo + "-" + dt + "-" + hr + "-" + mn + "-" + sc;
}

// variables for geo, time, buttons, data
var geoEnabled = document.getElementById("geo-enabled");
//var dataReadOut = document.getElementById("read-out");

var currPosition;

var currDate = new Date();

var elapsedRecordingTime = 0;

var resetDataBtn = document.getElementById("resetData");
var exportCSVBtn = document.getElementById("exportCSV");
var exportGeoJsonBtn = document.getElementById("exportGeoJson");

var id = 0;
var dataHead = [
  "id",
  "button_id",
  "label",
  "count",
  "audio",
  "latitude",
  "longitude",
  "altitude",
  "timestamp",
  "iso-date",
  "date",
  "time"
];
var dataArr = [dataHead];

var addButton = document.getElementById("adder");

var countTracker1 = document.getElementById("countNumberTracker1");
countTracker1.innerHTML = "0s";

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
  if (error.code == error.PERMISSION_DENIED) {
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
  if(tapped) {
    var s = document.getElementById("shield");
    s.style.visibility = "hidden";
  }
}

function trackPosition(position) {
  currPosition = position;
}

function countPress() {
  //
  recordData = !recordData;

  //
  if (recordData) {
    addButton.innerHTML = "Stop";
    addButton.classList.toggle('recording');
    tempAudioData = tempAudioData.fill(0);
    recordTimer = setInterval(timerAverageData, 1000);
  } else {
    addButton.innerHTML = "Start";
    addButton.classList.toggle('recording');
    clearInterval(recordTimer);
    recordTimer = null; //setInterval(timerAverageData,1000);
    // clean up and record any leftover data
    console.log("stop hit");
    // average data
    tempAudioData = tempAudioData.map(function (val, indx) {
      return Math.round((val = val / tempAudioCount));
    });
    tempAudioCount = 0;
    console.log("tac averaged stopped", tempAudioData);
    // write data and save
  }
}

function realtimeAdd(objectArr) {
  //

  //
  /* geoEnabled.innerHTML = "Geolocation enabled! At " + currPosition.coords.timestamp + " time:" +
  "<br>Latitude: " + currPosition.coords.latitude +
  "<br>Longitude: " + currPosition.coords.longitude +
  "<br>Altitude: " + currPosition.coords.altitude; */
  //
  currDate = new Date();
  let yr = currDate.getFullYear();
  let mo = currDate.getMonth() + 1;
  let dt = currDate.getDate();
  let hr = currDate.getHours();
  let mn = currDate.getMinutes();
  let sc = currDate.getSeconds();
  //
  if (mo < 10) {
    mo = "0" + mo;
  }
  if (dt < 10) {
    dt = "0" + dt;
  }
  if (hr < 10) {
    hr = "0" + hr;
  }
  if (mn < 10) {
    mn = "0" + mn;
  }
  if (sc < 10) {
    sc = "0" + sc;
  }
  //
  id++;
  //this.value++;
  //countTrack1.innerHTML = this.value;

  //? countArr[this.value]++;

  // ? not sure i need this
  var v = 0; //countArr[this.value];
  // definitely don't need this - to be replaced by objectArr
  //var t = inputFieldArr[this.value].value;
  //
  //var currArr = [id, Number(this.value), this.innerHTML, v, "\""+objectArr+"\"", currPosition.coords.latitude, currPosition.coords.longitude, currPosition.coords.altitude, currPosition.coords.timestamp, yr+"-"+mo+"-"+dt, hr+":"+mn+":"+sc ];
  //dataArr.push(currArr);

  //var stringedObjects = objectArr.toString();//.replace(/"/g, '\\"');//objectArr.replaceAll("\"", "\\\"");
  //stringedObjects = stringedObjects.replaceAll("\"", "\'"); // this works but breaks the json!

  // new method just make an array of the labels, don't try to make a json array for CSV
  var objectList = [];
  for (let i = 0; i < objectArr.length; i++) {
    objectList[i] = objectArr[i].label;
  }

  //
  var currArr = [
    id,
    Number(this.value),
    this.innerHTML,
    v,
    '"' + objectList + '"',
    currPosition.coords.latitude,
    currPosition.coords.longitude,
    currPosition.coords.altitude,
    currPosition.coords.timestamp,
    yr + "-" + mo + "-" + dt + "T" +  hr + ":" + mn + ":" + sc,
    yr + "-" + mo + "-" + dt,
    hr + ":" + mn + ":" + sc,
  ];
  dataArr.push(currArr);
  //
  //? console.log(dataArr);
  //
  //? countTrackerArr[this.value].innerHTML = v;
  //inputFieldArr[this.value].value = "";
  //? inputFieldArr[this.value].focus();
  //
  //? dataReadOut.innerHTML = currArr;

  // this works well
  //createJson(id, Number(this.value), this.innerHTML, v, JSON.parse(objectArr), currPosition.coords.latitude, currPosition.coords.longitude, currPosition.coords.altitude, currPosition.coords.timestamp, yr+"-"+mo+"-"+dt, hr+":"+mn+":"+sc);

  //***** use whole json object, works well
  //createJson(id, Number(this.value), this.innerHTML, v, objectArr, currPosition.coords.latitude, currPosition.coords.longitude, currPosition.coords.altitude, currPosition.coords.timestamp, yr+"-"+mo+"-"+dt, hr+":"+mn+":"+sc);

  // use  only parts of json object and rewrap as json
  var reducedJSON = [];
  for (let i = 0; i < objectArr.length; i++) {
    reducedJSON[i] = {
      label: objectArr[i].label,
      confidence: objectArr[i].confidence.toFixed(3),
    };
  }
  createSmallJson(
    id,
    reducedJSON,
    currPosition.coords.latitude,
    currPosition.coords.longitude,
    currPosition.coords.altitude,
    currPosition.coords.timestamp,
    yr + "-" + mo + "-" + dt + "T" +  hr + ":" + mn + ":" + sc,
    yr + "-" + mo + "-" + dt,
    hr + ":" + mn + ":" + sc
  );

  // no longer adding map
  //mapJson();
}

function realtimeAddArray(audioArr) {
  //

  //
  /* geoEnabled.innerHTML = "Geolocation enabled! At " + currPosition.coords.timestamp + " time:" +
	"<br>Latitude: " + currPosition.coords.latitude +
	"<br>Longitude: " + currPosition.coords.longitude +
	"<br>Altitude: " + currPosition.coords.altitude; */
  //
  currDate = new Date();
  let yr = currDate.getFullYear();
  let mo = currDate.getMonth() + 1;
  let dt = currDate.getDate();
  let hr = currDate.getHours();
  let mn = currDate.getMinutes();
  let sc = currDate.getSeconds();
  //
  if (mo < 10) {
    mo = "0" + mo;
  }
  if (dt < 10) {
    dt = "0" + dt;
  }
  if (hr < 10) {
    hr = "0" + hr;
  }
  if (mn < 10) {
    mn = "0" + mn;
  }
  if (sc < 10) {
    sc = "0" + sc;
  }
  //
  id++;
  //this.value++;
  //countTrack1.innerHTML = this.value;

  //? countArr[this.value]++;

  // ? not sure i need this
  var v = 0; //countArr[this.value];
  // definitely don't need this - to be replaced by objectArr
  //var t = inputFieldArr[this.value].value;
  //
  //var currArr = [id, Number(this.value), this.innerHTML, v, "\""+objectArr+"\"", currPosition.coords.latitude, currPosition.coords.longitude, currPosition.coords.altitude, currPosition.coords.timestamp, yr+"-"+mo+"-"+dt, hr+":"+mn+":"+sc ];
  //dataArr.push(currArr);

  //var stringedObjects = objectArr.toString();//.replace(/"/g, '\\"');//objectArr.replaceAll("\"", "\\\"");
  //stringedObjects = stringedObjects.replaceAll("\"", "\'"); // this works but breaks the json!

  // new method just make an array of the labels, don't try to make a json array for CSV
  /* >>> var objectList = [];
	for (let i = 0; i < objectArr.length; i++) {
	  objectList[i] = objectArr[i].label;
	}*/

  //
  var currArr = [
    id,
    Number(this.value),
    this.innerHTML,
    v,
    '"' + audioArr + '"',
    currPosition.coords.latitude,
    currPosition.coords.longitude,
    currPosition.coords.altitude,
    currPosition.coords.timestamp,
    yr + "-" + mo + "-" + dt + "T" +  hr + ":" + mn + ":" + sc,
    yr + "-" + mo + "-" + dt,
    hr + ":" + mn + ":" + sc,
  ];
  dataArr.push(currArr);
  //
  //? console.log(dataArr);
  //
  //? countTrackerArr[this.value].innerHTML = v;
  //inputFieldArr[this.value].value = "";
  //? inputFieldArr[this.value].focus();
  //
  //? dataReadOut.innerHTML = currArr;

  // this works well
  //createJson(id, Number(this.value), this.innerHTML, v, JSON.parse(objectArr), currPosition.coords.latitude, currPosition.coords.longitude, currPosition.coords.altitude, currPosition.coords.timestamp, yr+"-"+mo+"-"+dt, hr+":"+mn+":"+sc);

  //***** use whole json object, works well
  //createJson(id, Number(this.value), this.innerHTML, v, objectArr, currPosition.coords.latitude, currPosition.coords.longitude, currPosition.coords.altitude, currPosition.coords.timestamp, yr+"-"+mo+"-"+dt, hr+":"+mn+":"+sc);

  // use  only parts of json object and rewrap as json
  /* >>> var reducedJSON = [];
	for (let i = 0; i < objectArr.length; i++) {
	  reducedJSON[i] = {
		label: objectArr[i].label,
		confidence: objectArr[i].confidence.toFixed(3),
	  };
	}*/
  createSmallJson(
    id,
    audioArr,
    currPosition.coords.latitude,
    currPosition.coords.longitude,
    currPosition.coords.altitude,
    currPosition.coords.timestamp,
    yr + "-" + mo + "-" + dt + "T" +  hr + ":" + mn + ":" + sc,
    yr + "-" + mo + "-" + dt,
    hr + ":" + mn + ":" + sc
  );

  // no longer adding map
  //mapJson();
}

function resetData() {
  //
  id = 0;
  dataArr = [dataHead];
  countArr = [0];
  countTracker1.innerHTML = "0s";
  elapsedRecordingTime = 0;
  //
  inputFieldArr[0].value = "Objects recorded...";
  // reset json
  myJson = {
    type: "FeatureCollection",
    features: [],
  };
  //
  console.log(dataArr);
}

function exportCSV() {
  let csvContent = "data:text/csv;charset=utf-8,";

  dataArr.forEach(function (rowArr) {
    let row = rowArr.join(",");
    csvContent += row + "\r\n";
  });

  var encodedUri = encodeURI(csvContent);
  window.open(encodedUri);
}

function exportCSV2() {
  let csvContent; // = "data:text/csv;charset=utf-8,";

  dataArr.forEach(function (rowArr) {
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
  const blobData = new Blob([csvContent], { type: "text/csv;charset=utf-8" });

  //
  var reader = new FileReader();
  reader.onload = function () {
    var popup = window.open();
    var link = document.createElement("a");
    link.setAttribute("href", reader.result);
    link.setAttribute("download", "datawalking-" + dateStr + ".csv");
    popup.document.body.appendChild(link);
    link.click();
  };
  reader.readAsDataURL(blobData);
}

function editPress() {
  currEdit = !currEdit;
  if (currEdit) {
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
