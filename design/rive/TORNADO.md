# Task Tornado

Editable source: https://editor.rive.app/file/untitled/2618576

New artboard: `Task Tornado` (400 × 240). The previous Task Buddy artboard
is preserved. The tornado is marked as a component and included in export.

Export: `task-tornado-preview.riv`. The document export includes the original
artboard as well; select `Task Tornado` explicitly when loading it in a runtime.

## Preview

Select Task Tornado, then Animate → Tornado Showcase → Play.
Its default state machine plays the 5.2-second looping showcase.

- Tornado Pull: 1 second, scrub with pull progress.
- Tornado Refreshing: 2.5 seconds, seamless two-revolution loop.
- Tornado Complete: 1.5 seconds, stack, completion ticks, sparkles, and exit.

Five cards orbit with changing position, scale, and rotation. Nine tapered
lavender trails collapse as the cards form a stack. The dark rounded backdrop
is for preview and should be removed or theme-bound during app integration.

Validation: inspected orbit and completed-stack renders; simulated the default
state machine for 320 frames at 60 fps; checked exported RIVE signature,
artboard name, and all four animation names.

Flutter gestures and refresh lifecycle are not connected yet. The three
individual timelines are available, but interactive state transitions,
cancellation, failure feedback, and reduced motion remain integration work.
