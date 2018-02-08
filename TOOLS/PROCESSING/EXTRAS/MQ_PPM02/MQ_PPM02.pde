
float ATMOCO2 = 407.0; // carbon dioxide
float ATMOCO = 0.05; // carbon monoxide

float RLOAD = 10.0; // resistor value
float val = 102; // incoming analog reading

float co2A = 109.9727;//116.6020682;
float co2B = 2.776167;//2.769034857;

// values for carbon monoxide
float coA = 736.2263;
float coB = 4.510636;

float resistance = ((1023.0/val) * 5.0 - 1.0) * RLOAD;

println("resistance = " + resistance);

// below does work
//float RZERO = resistance * pow((ATMOCO2/PARA), (1./PARB));  

float rO =  resistance * pow((ATMOCO2/co2A),1.0/co2B); 
println("rz = " + rO);

val = 190;
float rS = ((1023.0/val) * 5.0 - 1.0) * RLOAD;

float ppm = co2A * pow((rS/rO), -co2B);
println("co2 ppm = " + ppm);

// carbon monoxide calcs
rO =  resistance * pow((ATMOCO/coA),1.0/coB); 
rS = ((1023.0/val) * 5.0 - 1.0) * RLOAD;
ppm = coA * pow((rS/rO), -coB);
println("co ppm = " + ppm);

