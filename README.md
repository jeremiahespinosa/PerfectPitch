[![Build Status](https://travis-ci.org/jeremiahespinosa/PerfectPitch.svg?branch=master)](https://travis-ci.org/jeremiahespinosa/PerfectPitch)
##App Specification: Pitch Perfect

iOS Developer Nanodegree

The Pitch Perfect app allows users to record a sound using the device’s microphone. It then allows users to play the recorded sound back with four different sound modulations: Chipmunk, Darth Vader, Super Slow, and Super Fast.

###The app has two view controller scenes.
1. Record Sounds View: Allows users to record a sound.
2. Play Sounds View: Allows users to play the recorded sound back with effects.

The two scenes are described in detail below.

1. Record Sounds View: The record sounds view is the initial view for the app, and consists of a button with a microphone image. 
A label indicating the user to tap the button to start recording should be added beneath the image (not pictured). Tapping this microphone button will start an audio recording session. 
The app will use code from AVFoundation to record sounds from the microphone. 
Tapping the button will disable the record button, display a “recording” label, and present a stop button. 
For extra credit, present the user the ability to pause and restart recordings in addition to stopping them. When the stop button is clicked, the app should complete its recording and then push.
The play sounds view will have been pushed onto the navigation stack. 
At the top left of the screen, the navigation bar’s left button says “Record”. 
Clicking this button will pop the play sounds view off the stack and return the user to the record sounds view (which is the default behavior of the navigation bar).
At this point, the play sounds view should be in its original state. The microphone button should be enabled and the stop button should be hidden. The second scene (described below under “Play Sounds View”) onto the navigation stack.
The title in the navigation bar should be “Record”.
      
2. Play Sounds View: The play sounds view has four buttons to play the recorded sound file and a button to stop the playback.
The buttons for playing the recorded sounds will have images corresponding to their sound effect:
  1. Chipmunk image → High-pitched sound 
  2. Darth Vader image → Low-pitched sound 
  3. Snail image → Slow sound
  4. Rabbit image → Fast sound

Additional sound effects, such as reverb and echo, can be implemented and added to this view for extra credit.
       
 
