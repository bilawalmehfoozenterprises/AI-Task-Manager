# Task Buddy refresh motion preview

Editable source: https://editor.rive.app/file/untitled/2618576

Artboard: `Task Buddy • Refresh` (400 × 200).

`task-buddy-preview.riv` is the exported runtime asset.

## Preview

In Rive's Animate mode, select `Showcase` and press Play.
The default state machine also plays this five-second looping showcase.

Separate motion timelines:

- `Pull`: one second, intended for scrubbing with pull progress.
- `Refreshing`: two-second loop.
- `Complete`: one and a half seconds, including exit.

This is an initial visual prototype. The separate timelines are not yet wired
to interactive state transitions or Flutter's refresh lifecycle. The fixed dark
background is part of the preview. Theme bindings, gesture cancellation,
error handling, and reduced motion are integration work still to do.

Validation: inspected the rendered vector artwork, verified timeline durations,
and simulated the default state machine for 310 frames at 60 fps. It entered
the Showcase animation and remained in the looping state as intended.
