public class Building {

  private String title;
  private String genre;
  private int video_length;
  private String day;
  private String date;
  private int values_size;
  private int index;
  private float offset;
  private float boxHeight;
  private float day_grid;
  private float week;
  private PVector pos;


  public Building(String input, int values_size, int index, float height_offset, float day_grid) {
    String[] items = split(input, ',');
    this.title = items[0];
    this.genre = items[1];
    this.video_length = int(items[2]);
    this.day = items[3];
    this.date = items[4];
    this.values_size = values_size;
    this.index = index;
    this.offset = height_offset;
    this.boxHeight = 3.5 * (float(this.video_length));
    this.day_grid = day_grid;

    this.week = this.getWeek(this.date);
  }

  public void draw_building() {
    pushMatrix();
    rotateX(radians(30));
    float gridset = floor(this.index / 7);
    this.pos = new PVector(((width)/this.values_size)+((this.index%7)*120), ((height)/this.values_size)+(gridset*180), (-50)+(this.boxHeight/2)+this.offset);
    translate(this.pos.x, this.pos.y, this.pos.z);
    if (this.genre.equals("Anime")) {
      fill(128, 255, 0); // Light Green
    } else if (this.genre.equals("Technology")) {
      fill(0, 188, 255); // Light Blue
    } else if (this.genre.equals("Music")) {
      fill(255, 0, 0); // Red
    } else if (this.genre.equals("Educational")) {
      fill(255, 255, 0); // Yellow
    } else if (this.genre.equals("Gaming")) {
      fill(255, 128, 0); // Orange
    } else if (this.genre.equals("Political")) {
      fill(255, 0, 127); // Pink
    } else if (this.genre.equals("Horror")) {
      fill(0, 0, 153); // Dark Blue
    } else {
      fill(0, 0, 0); // Black
    }
    box(35, 35, this.boxHeight);

    popMatrix();
  }

  public float varying() {
    return this.boxHeight;
  }

  int getWeek(String date) {
    String[] parts = split(date, '/');
    int day = int(parts[0]);
    return (day - 1) / 7; // zero-based week index
  }


  void check_title() {            // Mouse Hover Title

    pushMatrix();
    rotateX(radians(30));

    float xs =screenX(this.pos.x, this.pos.y, this.pos.z);
    float ys =screenY(this.pos.x, this.pos.y, this.pos.z);

    PVector camPos = new PVector(camX, camY, camZ);
    float distance = PVector.dist(camPos, pos);

    if (dist(mouseX, mouseY, xs, ys) < 30 && distance < 800) {

      hint(DISABLE_DEPTH_TEST);
      camera();
      noLights();
      fill(255);
      textSize(35);
      String details = this.title + "\n" + this.genre + "\n" + this.video_length + " min";
      text(details, xs+22, ys);
      hint(ENABLE_DEPTH_TEST);
      lights();
    }
    popMatrix();
  }
}
