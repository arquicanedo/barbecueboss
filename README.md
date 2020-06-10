# Barbecue Boss ConnectIQ App for Garmin Watches.
Barbecue like a boss. An opensource app (https://github.com/arquicanedo/barbecueboss) for barbecue enthusiasts. In the initial version, it provides a searing timer (user-configurable for 1, 2, ..., 5 minutes) and flip confirmation to keep track of your steaks and veggies on the grill. It creates a "barbecue" activity and associates the GPS location to it whenever available. 

This project is licensed under the Apache 2.0 License. See LICENSE and AUTHORS for more information.

This version only supports circular watches. Future release includes:
- "smoking" timer in addition to the "searing" timer
- multiple timers to track various steaks simultaneously

Other:
- Icon made by Pixel perfect from www.flaticon.com
- Meat type icons by:

Burger - Freepik https://www.flaticon.com/free-icon/burger_2933054?term=hamburger&page=1&position=8
Fish - surang https://www.flaticon.com/free-icon/fish_2916600?term=fish&page=1&position=31
Steak (meat) - Good Ware https://www.flaticon.com/free-icon/meat_2853141?term=steak&page=1&position=21
Drumstick - Good Ware https://www.flaticon.com/free-icon/chicken-leg_2836503?term=chicken&page=1&position=41
Cow - Freepik https://www.flaticon.com/free-icon/cow_676208?term=cow&page=1&position=43
Pig - Smashicons https://www.flaticon.com/free-icon/pig_2826014?term=pork&page=1&position=56
Sheep - Freepik https://www.flaticon.com/free-icon/sheep_2591084?term=lamb&page=1&position=16
Corn - Good Ware https://www.flaticon.com/free-icon/corn_2619427?term=veggies&page=1&position=2
Cake - Freepik https://www.flaticon.com/free-icon/cake_3014523?term=cake&page=1&position=1


## What's New
This update (0.1.0) is brought to you by @nilsbenson (https://github.com/nilsbenson):
- adds vibration and sound when flip timer ends
- adds a "custom" timer duration
- activity recording is prompted when application ends rather than between runs of the flip (to make it easier to manage multi-step cooking processes in the future)
- general UI spacing adjustments


## Download
Download from the Garmin app store: https://apps.garmin.com/en-US/apps/bfbcb162-f215-49cb-8185-dad7e6dc4595

## Screenshots
![welcome screen](./img/BBQIQ1.png)

![searing](./img/BBQIQ2.png)

![searing timer](./img/BBQIQ3.png)

![barbecue activity](./img/BBQIQ4.png) ![flips as laps](./img/BBQIQ5.png)

## Useful Documentation
- https://developer.garmin.com/connect-iq/programmers-guide/
- https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox.html
- https://forums.garmin.com/developer/connect-iq/f/discussion
- https://github.com/garmin/connectiq-apps


## State Machine
![state machine](./img/statemachine.png)
