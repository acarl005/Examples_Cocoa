Example of weird hotkey bug.

This is the code for an app that does nothing except show itself when a global hotkey is pressed.
The hotkey is **ctrl-g**.
This code works perfectly well for showing itself, except when iTerm is the active app.
If any other app is active, and ctrl-g is pressed, the HelloWorld app becomes active.
However, if iTerm is active, and ctrl-g is pressed, the HelloWorld app will **not become active**.
This is with iTerm's hotkey window disabled.
What gives?
