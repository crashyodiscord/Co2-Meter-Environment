//Graphing Library
import grafica.*;

//Differt "Menus" (backgrounds)
PImage Menu;
PImage transportselect;
PImage Intro;
PImage GraphBackground;
//Graphing information
public GPlot Dataplot;

//Constants (in grams per Kilometer)
//Source for constants: https://ourworldindata.org/travel-carbon-footprint
//Declaring a variable as 'final' makes it unchangable and subsequently a constant
final float DieselCarEmission = 171;   //g/Km (divided by number of passengers)
final float PetrolCarEmission = 192;  //g/Km (divided by number of passengers)
final float TrainEmission = 41;       //g/Km
final float BusEmission = 105;        //g/Km
final float PlaneEmission = 255;      //g/Km

float[] Emissions;

//Distance of Travel
String DistanceInput = "";
int Distance = 0;

//RGB Values (for graph):
int PCar = 200;
int DCar = 200;
int Bus = 200;
int Plane = 200;
int Train = 200;

//States of Program
//Used to determine which menu should run and which corresponding code should be used
boolean MainMenu = true;
boolean DataEntry = false; //Value to see if program should be on data entry screen
boolean TransportMenu = false; //Allows program to move to transport selection and User will be prompted to chose form of transportation
boolean CalculationMenu = false; //Using selected form of transportation and corresponding constants, emissions will be calculated


void setup() {

  //Initialising graph
  Dataplot = new GPlot(this);
  Dataplot.setPos(50, 110);
  Dataplot.setDim(250, 250);
  Dataplot.setYLim(0, (Distance * 300));
  Dataplot.setXLim(0, 6);
  Dataplot.getTitle().setText("Carbon Emissions of different Transportation forms");
  Dataplot.getTitle().setTextAlignment(LEFT);
  Dataplot.getTitle().setRelativePos(0);
  Dataplot.getYAxis().getAxisLabel().setText("CO2 Emissions (g/Km)");
  Dataplot.getYAxis().getAxisLabel().setTextAlignment(RIGHT);
  Dataplot.getYAxis().getAxisLabel().setRelativePos(1);
  Dataplot.getXAxis().getAxisLabel().setText("Form of Transport");
  Dataplot.getXAxis().getAxisLabel().setRelativePos(1);
  Dataplot.startHistograms(GPlot.VERTICAL);
  Dataplot.getHistogram().setDrawLabels(true);
  Dataplot.getHistogram().setRotateLabels(true);

  //loads backgrounds for the menus
  Menu = loadImage("distanceinput.jpg");
  transportselect = loadImage("transportselect.jpg");
  Intro = loadImage("MainMenu.jpg");
  GraphBackground = loadImage("Emissionsgraph.jpg");
  size(500, 500);
  background(Menu);
}

// Game loop
void draw() {
  //println("x: " + mouseX + "\ny: " + mouseY);

  //if the program is set to main menu itll run the main menu screen
  if (MainMenu) {
    background(Intro);

    //sets all data back to initial values incase user retrys the program
    DistanceInput = "";
    Distance = 0;
    PCar = 200;
    DCar = 200;
    Bus = 200;
    Plane = 200;
    Train = 200;
  }
  
  //checks if program is ready to advance to the data entry menu
  //where the user inputs their desired distance
  if (DataEntry) {
    background(Menu);
    textSize(50);
    text(DistanceInput + "_", 80, 240);
    fill(0, 0, 0, 255);
  }

  //checks if program should move to the transport selection menu
  //user selects form of transport here
  if (TransportMenu) {
    background(transportselect);
  }
  
  //if distance has been entered and transport selected
  //the program will proceed and a graph of their data will 
  //be plotted in this menu
  if (CalculationMenu) {
    background(GraphBackground);
    Dataplot.getHistogram().setBgColors(new color[] {
      color(200, 200, PCar), color(200, 200, DCar), color(200, 200, Bus),
      color(200, 200, Plane), color(200, 200, Train)
      });

    //Drawing the graph of the data
    Dataplot.beginDraw();
    Dataplot.drawYAxis();
    Dataplot.drawTitle();
    Dataplot.drawHistograms();
    Dataplot.endDraw();
  }
}

void keyPressed() {
  //only runs during the data entry section of the project
  //(when user enters a distance)
  if (DataEntry) {
    //0 - 9 Key
    if (((int) key >= 47) && ((int) key <= 58)) {
      DistanceInput += key;
      print(DistanceInput);
    }

    //Backspace Key -> Removes end character
    if (((int) key == 8) && (DistanceInput.length() > 0)) {
      DistanceInput = DistanceInput.substring(0, DistanceInput.length() - 1);
    }

    //Prevents user entering a value greater than 8 digits (8 digits chosen due to earths circumference being 7 digits)
    if (DistanceInput.length() - 1 > 8) {
      DistanceInput = DistanceInput.substring(0, DistanceInput.length() - 1);
    }

    //Enter Key -> Continues if valid value has been inputted
    if (((int) key == 10) && (DistanceInput.length() > 0)) {
      DataEntry = false;
      Distance = Integer.valueOf(DistanceInput);

      //Calculating Emissions and storing in a Float array
      Emissions = new float[5];
      Emissions[0] = DieselCarEmission * Distance;
      Emissions[1] = PetrolCarEmission * Distance;
      Emissions[2] = BusEmission * Distance;
      Emissions[3] = PlaneEmission * Distance;
      Emissions[4] = TrainEmission * Distance;

      //Looping through forms of transportation and associated emissions
      //Creating points to be plotted
      String[] Arr = {"Car(Petrol)", "Car(Diesel)", "Bus", "Plane", "Train"};
      GPointsArray DataPoints = new GPointsArray(5);
      for (int i = 0; i < 5; i++) {
        DataPoints.add(i + 1, Emissions[i], Arr[i]);
      }
      //Plots points
      Dataplot.setPoints(DataPoints);

      TransportMenu = true;
    }
  }
}

void mousePressed() {

  //only runs when the program is in the main menu section
  if (MainMenu) {
    if ((mouseX > 160 && mouseX < 360) && (mouseY > 310 && mouseY < 375)) {
      MainMenu = false;
      DataEntry = true;
    }
    //only runs when the program is at the transport select menu
  } else if (TransportMenu) {

    //PCar Coords
    if ((mouseX > 50 && mouseX < 185) && (mouseY > 90 && mouseY < 225)) {
      PCar = 255;
      TransportMenu = false;
      CalculationMenu = true;
    }

    //DCard Coords
    if ((mouseX > 300 && mouseX < 430) && (mouseY > 90 && mouseY < 225)) {
      DCar = 255;
      TransportMenu = false;
      CalculationMenu = true;
    }

    //Bus Coords
    if ((mouseX > 50 && mouseX < 185) && (mouseY > 240 && mouseY < 375)) {
      Bus = 255;
      TransportMenu = false;
      CalculationMenu = true;
    }

    //Plane Coords
    if ((mouseX > 300 && mouseX < 430) && (mouseY > 240 && mouseY < 375)) {
      Plane = 255;
      TransportMenu = false;
      CalculationMenu = true;
    }

    //Train Coords
    if ((mouseX > 45 && mouseX < 430) && (mouseY > 405 && mouseY < 475)) {
      Train = 255;
      TransportMenu = false;
      CalculationMenu = true;
    }
    //only runs when the program is at the calculation menu
    //when the graph is being plotted
  } else if (CalculationMenu) {
    //TRY AGAIN BUTTON
    if ((mouseX > 15 && mouseX < 225) && (mouseY > 60 && mouseY < 105)) {
      CalculationMenu = false;
      MainMenu = true;

      DistanceInput = "";
    }
    //QUIT BUTTON
    if ((mouseX > 275 && mouseX < 485) && (mouseY > 60 && mouseY < 105)) {
      exit();
    }
  }
}
