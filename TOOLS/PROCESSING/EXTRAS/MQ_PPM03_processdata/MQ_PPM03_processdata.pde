
float ATMOCO2 = 407.0; // carbon dioxide
float ATMOCO = 0.05; // carbon monoxide

float RLOAD = 10.0; // resistor value
float cleanVal = 140; // incoming analog reading

// values for CO2
float co2A = 109.9727;//116.6020682;
float co2B = 2.776167;//2.769034857;

// values for carbon monoxide
float coA = 736.2263;
float coB = 4.510636;

float resistance;// = ((1023.0/cleanVal) * 5.0 - 1.0) * RLOAD;

float rOCO2;// =  resistance * pow((ATMOCO2/co2A),1.0/co2B);
float rOCO;// =  resistance * pow((ATMOCO/coA),1.0/coB);

float inputVal = 190;
float rSCO2;// = ((1023.0/inputVal) * 5.0 - 1.0) * RLOAD;
float rSCO;// = ((1023.0/inputVal) * 5.0 - 1.0) * RLOAD;
float ppm;// = co2A * pow((rS/rO), -co2B);

//
//
//
Table data;

void setup() {
  size(400, 400);
  // calculate normal air values
  calibrateCO2();
  calibrateCO();
  // load data
  data = loadTable("merged-air-quality.csv", "header");
  println(data.getRowCount());
  // add new columns to store ppm data
  data.addColumn("CO2 ppm", Table.INT);
  data.addColumn("CO ppm", Table.FLOAT);
  // get datapoint, calculate ppm, put in table
  for (int i=0; i<data.getRowCount (); i++) {
    float v = data.getFloat(i, "MQ135 average");
    float p = getPPMCO2(v);
    float p2 = getPPMCO(v);
    data.setInt(i,"CO2 ppm", int(p));
    data.setFloat(i,"CO ppm", p2);
    if (p >= 400) {
      print(int(p) + " ");
    } else {
      print("- ");
    }
  }
  // save data
  saveTable(data, "data/new.csv");
  // do nothing
  noLoop();
}

void draw() {
}

void calibrateCO2() {
  resistance = ((1023.0/cleanVal) * 5.0 - 1.0) * RLOAD;
  rOCO2 = resistance * pow((ATMOCO2/co2A), 1.0/co2B);
}


float getPPMCO2(float inputVal) {
  //float ppm;
  rSCO2 = ((1023.0/inputVal) * 5.0 - 1.0) * RLOAD;
  ppm = co2A * pow((rSCO2/rOCO2), -co2B);
  return ppm;
}

void calibrateCO() {
  resistance = ((1023.0/cleanVal) * 5.0 - 1.0) * RLOAD;
  rOCO = resistance * pow((ATMOCO/coA), 1.0/coB);
}


float getPPMCO(float inputVal) {
  //float ppm;
  rSCO = ((1023.0/inputVal) * 5.0 - 1.0) * RLOAD;
  ppm = coA * pow((rSCO/rOCO), -coB);
  return ppm;
}

