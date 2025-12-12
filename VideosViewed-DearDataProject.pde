String[] data_values;                                // The inputted data
int values_size;                                     // Amount of inputted data
Building[] city;                                     // Array of buildings

HashMap<String, Float> building_heights = new HashMap<String, Float>();      // Stores building height stacking
HashMap<String, Integer> building_indexes = new HashMap<String, Integer>();  // Stores building indexes
HashMap<String, Float> days = new HashMap<String, Float>();                  // Stores day grid

float camX = width/2;                              // Variables for manipulating the camera
float camY = height/2;
float camZ = (height/2.0) / tan(PI*30.0 / 180.0);
float centerX = width/2;
float centerY = height/2;
float centerZ = 0;

void setup() {
  size(1000, 800, P3D);                          // Window Size
  windowTitle("Dear Data Project");              // Dear Data Project - Video City

  days.put("Mon", 0.0);                            // days grid values
  days.put("Tue", 0.0);
  days.put("Wed", 0.0);
  days.put("Thu", 0.0);
  days.put("Fri", 0.0);
  days.put("Sat", 0.0);
  days.put("Sun", 0.0);

  data_values = loadStrings("MyData.csv");         // Load stored data
  values_size = data_values.length;
  city = new Building[values_size];              // Array of buildings
  int next_index = 0;
  for (int i = 0; i < values_size; i++) {
    String[] items = split(data_values[i], ',');
    if (!building_heights.containsKey(items[4])) {    // Ensures no duplicate dates aka buildings on the same date will stack
      building_heights.put(items[4], 0.0);
      building_indexes.put(items[4], next_index);
      next_index++;
    }
  }

  for (int i = 0; i < values_size; i++) {
    String[] date = split( data_values[i], ",");
    int date_index = building_indexes.get(date[4]);
    float previous_height = building_heights.get(date[4]);
    float day_grid = days.get(date[3]);
    city[i] = new Building(data_values[i], values_size, date_index, previous_height, day_grid);    // Creates a building object
    float height_increase = city[i].varying();
    building_heights.put(date[4], previous_height + height_increase);
    days.put(date[3], ++day_grid);
  }

  camX = width/2.0;                                  // Variables to manipulate camera
  camY = height/2.0 - 100;
  camZ = (height/2.0) / tan(PI*45.0 / 180.0) + 400;
  centerX = width/2.0;
  centerY = height/2.0;
  centerZ = 0;
}

void draw() {

  background(0);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  lights();                  // Adds 3D lighting


  camera(camX, camY, camZ, centerX, centerY, centerZ, 0, 1, 0);      // Initiates manual camera control

  for (int i = 0; i < values_size; i++) {
    city[i].draw_building();                       // Call's each building's draw function
  }
  
  for (Building b : city) {
    b.check_title();
  }

  if (keyPressed) {
    if (key == 'w' || keyCode == UP) {              // move camera forward
      camY -= 20;
      centerY -= 20;
    }
    if (key == 's' || keyCode == DOWN) {              // move camera back
      camY += 20;
      centerY += 20;
    }
    if (key == 'a' || keyCode == LEFT) {              // move camera left
      camX -= 20;
      centerX -= 20;
    }
    if (key == 'd' || keyCode == RIGHT) {              // move camera right
      camX += 20;
      centerX += 20;
    }
    
    if (keyPressed) { 
      if (key == '+') {                                  // Zoom Camera in
        camZ -= 20;
        centerZ -= 20;
      }
      if (key == '-') {                                  // Zoom Camera out
        camZ += 20;
        centerZ += 20;
      }
    }

    camX = constrain(camX, -250, 700);                  // Clamps Camera Movement
    camY = constrain(camY, -250, 700);
    centerX = constrain(centerX, -250, 700);
    centerY = constrain(centerY, -250, 700);
    camZ = constrain(camZ, 500, 2000);
    centerZ = constrain(centerZ, 0, 900);
  }
}
