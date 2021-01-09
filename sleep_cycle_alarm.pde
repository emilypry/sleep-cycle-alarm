const long MIN = 60000; // 1 minute = 60,000ms
const long MINS_IN_DAY = 1440; // 60mins * 24hrs = 1440mins/day
const int QS_IN_MIN = 4 * 60; // 4 quarter seconds * 60 seconds = 1 minute


// PLEASE ENTER the number of minutes it should take you to fall asleep
// once you've set the timer
const long MINS_TO_FALL_ASLEEP = 15; 
// PLEASE ENTER the number of minutes you'd like for snoozing
const long SNOOZE_MINS = 7; 

// The length of the short timer
const long SHORT_TIMER_MINS = (6 * 60) + MINS_TO_FALL_ASLEEP; 
// The length of the medium timer
const long MED_TIMER_MINS = (7.5 * 60) + MINS_TO_FALL_ASLEEP; 
// The length of the long timer
const long LONG_TIMER_MINS = (9 * 60) + MINS_TO_FALL_ASLEEP; 

#define flasher 2 // The red LED that begins flashing at MIN_OF_EARLIEST_SLEEP 
#define shortTimer 16 // The LED that indicates the choice of the short timer
#define medTimer 3 // The LED that indicates the choice of the medium timer
#define longTimer 4 // The LED that indicates the choice of the long timer  
#define pickTimer 5 // The button for toggling between the three timers                    
#define startTimer 6 // The button for starting the alarm
#define buzzer 9 // The buzzer for the sounding of the alarm
#define stopAlarm 7 // The button for stopping the sounding of the alarm
#define snooze 8 // The button for snoozing the alarm 
#define snoozing 10 // The LED that's on while snoozing

void setup() {
  pinMode(flasher, OUTPUT);
  pinMode(shortTimer, OUTPUT);
  pinMode(medTimer, OUTPUT);
  pinMode(longTimer, OUTPUT);
  pinMode(pickTimer, INPUT);
  pinMode(startTimer, INPUT);
  pinMode(buzzer, OUTPUT);
  pinMode(stopAlarm, INPUT);
  pinMode(snooze, INPUT);
  pinMode(snoozing, OUTPUT);
}

void loop(){
  // The program begins at the earliest time of sleep
  int timerChoice = waitToStartTimer();
  sleepWithTimer(timerChoice);
  soundAlarm();
  hibernate();
}

// The period between the earliest time of sleep (when the user turns the 
// device on) up until the user presses the startTimer button
int waitToStartTimer(){
  int timerChoice = 1;
  int thisQuarter = 0; 

  // Light the medTimer LED by default
  digitalWrite(medTimer, HIGH);
  
  while(true){
    delay(250);

    // Flash the light every second
    if(thisQuarter == 0 || thisQuarter == 2){
      if(digitalRead(flasher) == LOW){
        digitalWrite(flasher, HIGH);
      }else{
        digitalWrite(flasher, LOW);
      }
    }
    
    // If the startTimer button has been pressed
    if(buttonPressed(startTimer) == true){
      // Turn off the flashing light and whichever alarmChoice light was on
      digitalWrite(flasher, LOW);
      digitalWrite(shortTimer, LOW);
      digitalWrite(medTimer, LOW);
      digitalWrite(longTimer, LOW);

      // Return the alarm choice
      return timerChoice;
    }
    
    // If the pickTimer button has been pressed
    else if(buttonPressed(pickTimer) == true){
      // Toggle between the shortTimer, medTimer, and longTimer LEDs
      if(timerChoice == 0){
        digitalWrite(shortTimer, LOW);
        digitalWrite(medTimer, HIGH);
        digitalWrite(longTimer, LOW);
        timerChoice = 1;
      }else if(timerChoice == 1){
        digitalWrite(shortTimer, LOW);
        digitalWrite(medTimer, LOW);
        digitalWrite(longTimer, HIGH);
        timerChoice = 2;
      }else{
        digitalWrite(shortTimer, HIGH);
        digitalWrite(medTimer, LOW);
        digitalWrite(longTimer, LOW);
        timerChoice = 0;
      }
    }

    if(thisQuarter < 4){
      thisQuarter += 1;
    }else{
      thisQuarter = 0;
    }
  }
}

// The period between the user's having pressed the startTimer button and
// just until the alarm should go off
void sleepWithTimer(int timerChoice){  
  long minsToSleep;
  
  if(timerChoice == 0){
    minsToSleep = SHORT_TIMER_MINS;
  }else if(timerChoice == 1){
    minsToSleep = MED_TIMER_MINS;
  }else{
    minsToSleep = LONG_TIMER_MINS;
  }

  // Start a new sleeping period
  while(true){
    long startSleepingMin = onFor(); // The minute at which the sleeping period begins
    boolean sleptEnough = false;
    int thisQuarter = 0; // Tracks quarter seconds
    long thisSleepingMin; // How long the sleeping period has gone on for

    while(true){
      delay(250);

      // If the startTimer button is pressed
      if(buttonPressed(startTimer) == true){
        // Turn on the flasher LED for 3 seconds as verification
        digitalWrite(flasher, HIGH);
        delay(3000);
        digitalWrite(flasher, LOW);

        // Break to start a new sleeping period
        break;
      }

      // Otherwise, if startTimer hasn't been pressed
      else{
        // Each minute, update thisSleepingMin
        if(thisQuarter == QS_IN_MIN){
          thisQuarter = 0;
          thisSleepingMin = onFor() - startSleepingMin;

          // If this sleeping period has lasted for minsToSleep, stop
          if(thisSleepingMin == minsToSleep){
            sleptEnough = true;
            break;
          }  
        }else{
          thisQuarter += 1;
        }
      }
    }

    // If it was determined the user had slept enough in the inner loop, stop
    if(sleptEnough == true){
      break;
    }
  }
}

// Sounds the alarm when it's time to wake up, until the user presses the 
// stopAlarm button (may hit the snooze button in the meantime)
void soundAlarm(){
  int thisQuarter = 0;
  boolean quit = false;
  while(true){
    // Sound the buzzer once a second
    if(thisQuarter == 0){
      tone(buzzer, 10, 100);
    }

    delay(250);

    // If the stopAlarm button has been pressed
    if(buttonPressed(stopAlarm) == true){
      // Stop
      break;
    }

    // If the snooze button has been pressed
    if(buttonPressed(snooze) == true){
      // Get the minute at which snooze begins
      long snoozeStartMin = onFor();
      
      // Turn on the snoozing LED
      digitalWrite(snoozing, HIGH);

      // Snooze for the desired time
      int aQuarter = 0;
      while(true){
        delay(250);

        // If stopAlarm has been pressed, stop the snooze
        if(buttonPressed(stopAlarm) == true){
          quit = true;
          break;
        }

        // If the user has snoozed for enough time, stop
        if(aQuarter == QS_IN_MIN){
          aQuarter = 0;
          if(onFor() - snoozeStartMin == SNOOZE_MINS){
            break;
          }
        }else{
          aQuarter += 1;
        }
        
      }
    }

    if(quit == true){
      // Turn off the snoozing LED
      digitalWrite(snoozing, LOW);

      // Stop
      break;
    }

    if(thisQuarter < 4){
      thisQuarter += 1;
    }else{
      thisQuarter = 0;
    }   
  }
}

// The period between the alarm's being turned off after sounding and up until
// the earliest time of sleep
void hibernate(){
  while(true){
    delay(MIN);

    // If the device has been on for another full day
    if(onFor() % MINS_IN_DAY == 0){
      // Stop
      break;
    }
  }
}

// Returns how many minutes the device has been on for (to the nearest full minute)
long onFor(){
  // ms / 1000 = s
  // s / 60 = m
  return millis() / 1000 / 60;
}

boolean buttonPressed(int buttonPin){
  if(digitalRead(buttonPin)==LOW){
    delay(40);
    return true;
  }
  return false;
}
