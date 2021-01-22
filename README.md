# sleep-cycle-alarm
A sleep cycle alarm for Arduino

This is the program for an Arduino device that may be used instead of a typical alarm clock. 
It has three fixed-time timers, one for 6 hours, one for 7.5 hours, and the other for 9, each 
of which accord with the ending of a sleep cycle (which iterates in 1.5-hour increments). 
The user should set the timer just as they're about to fall asleep. The device will remind the 
user to set the timer by flashing an LED until the user sets the timer. 

The user is encouraged to declare the values of two variables in the program, MINS_TO_SLEEP and 
SNOOZE_MINS. The former is the number of minutes the user expects it'll take them to fall asleep
once they've set the timer. (This number is added to the number of hours in the timer, so the user 
is woken up at the right point in their sleep cycle.) The latter is the number of minutes they'd
like the snooze to last.

It's best for the user to turn the device on initially at the earliest time they might get to sleep.
Once on, the device will begin flashing an LED, and by pressing a button, the user can toggle between
the 6-, 7.5-, and 9-hour timers (indicated by three separate LEDs). When the user is about to fall asleep,
they should start the timer, by pressing a different button. This stage of the program will begin at 
the same time each day, which is why it's best to turn the device on at the earliest time of sleep
to begin with. 

Once the timer has begun (since the user expects to fall asleep shortly), all of the LEDs will be
turned off so the user may sleep. In Version 1, the user has the option of resetting the timer by
pressing the button for starting the timer (if, e.g., something came up and they couldn't fall 
asleep as quickly as expected). An LED will turn on for a few seconds to confirm that the timer has 
been reset. In Version 2, if the user presses the button for starting the timer, they will return to 
the point at which they can pick between the 6-, 7.5-, and 9-hour timers, instead of merely resetting 
the timer that they'd already chosen (if, e.g., the user could afford to sleep for 9 hours when first 
setting the timer, then was kept up for an hour, and now can afford to sleep for only 7.5 hours). 

After the sleep time has elapsed, a buzzer will beep pleasantly to wake the user up. (Only in Version 2, 
the user may press the button for stopping the alarm before the sleep time has elapsed. This will prevent 
the alarm from going off. Also only in Version 2, an LED will flash as the buzzer beeps.) The user may press
one button to turn off the alarm, or press another to snooze. Snoozing will last for the number of minutes
that SNOOZE_MINS is set to in the program. An LED will be on during the snoozing period, to confirm 
that snoozing is happening and to gently encourage the user to wake up. The user may end the snooze early
by pressing the button that stops the alarm. Otherwise, the alarm will go off again once the snooze time has 
elapsed. The user may snooze as many times as they like. 

Once the alarm has been turned off, the device will remain idle until the time of the day at which the device
had initially been turned on, at which point it will begin the flashing of the LED again. 
