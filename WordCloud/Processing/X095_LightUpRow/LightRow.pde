class LightRow {
   ArrayList<Light> lights;
   
   int lit_index = 0;
   float last_change_time = 0;
   float current_time = 0;
   float CHANGE = 100;
   
   public LightRow() {
     lights = new ArrayList<Light>();
   }
   
   public void update() {
     if (lights.size() > 0) {
       current_time = millis();
       if (current_time - last_change_time > CHANGE) {
         lights.get(lit_index).isOn = false;
         lit_index ++;
         lit_index %= lights.size();
         lights.get(lit_index).isOn = true;
         
         last_change_time = current_time;
       }
     }
   }
   
   public void draw() {
     for (Light l : lights) {
       l.draw();
     }
   }
}