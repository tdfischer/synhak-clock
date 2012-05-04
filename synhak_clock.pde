struct led {
  int pin;
  int value;
};

led lights[5];

#define lightCount (sizeof(lights)/sizeof(led))

void writePins() {
  for(int i = 0;i<lightCount;i++) {
    analogWrite(lights[i].pin, lights[i].value);
  }
}

void setup() {
  lights[0].pin = 3;
  lights[1].pin = 5;
  lights[2].pin = 6;
  lights[3].pin = 9;
  lights[4].pin = 10;
  for(int i = 0;i<lightCount;i++) {
    lights[i].value = ((float)i/lightCount)*255;
    pinMode(lights[i].pin, OUTPUT);
  }
  writePins();
}

int direction[5] = {2, 4, 6, 8, 12};

typedef boolean(*pattern_cb)();

pattern_cb patterns[] = {allBlink,};
int currentPattern = 0;
int currentIter = 0;

void loop() {
  currentIter++;
  pattern_cb func = patterns[currentPattern];
  if (!func()) {
    currentPattern++;
    currentIter = 0;
    if (currentPattern >= sizeof(patterns)/sizeof(pattern_cb))
      currentPattern = 0;
  }
}

boolean allBlink() {
  for(int i = 0;i<lightCount;i++) {
    if (currentIter % 128 == 0) {
      lights[i].value = 0;
    } else {
      lights[i].value = 255;
    }
  }
  delay(100);
  return currentIter < 10;
  digitalWrite(11, HIGH);
}

boolean geometricBlink() {
  for(int i = 0;i<lightCount;i++) {
    lights[i].value+=direction[i];
    if (lights[i].value >= 255) {
       lights[i].value = 255;
       direction[i] *= -1;
    } else if (lights[i].value <= 0) {
       lights[i].value = 255;
       direction[i] *= -1;
    }
  }
  writePins();
  delay(10);
  return true;
}
