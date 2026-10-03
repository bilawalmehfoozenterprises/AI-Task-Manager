# Runtime exports

- `task-buddy.riv`: Task Buddy • Refresh artboard; Pull, Refreshing, Complete,
  and Showcase timelines. 6,750 bytes.
- `task-tornado.riv`: Task Tornado artboard; Tornado Pull, Tornado Refreshing,
  Tornado Complete, and Tornado Showcase timelines. 128,289 bytes.

Each file contains only its respective artboard. Both RIVE signatures,
artboard names, and four timeline names were verified. The earlier
`*-preview.riv` files are retained as previous exports.

These are visual runtime assets. No Flutter dependency, asset registration,
gesture handling, or refresh lifecycle integration has been added.

## Validated comparison asset

`task-refresh-comparison.riv` is the current integration asset for comparing
both animations in Home. It contains the two prepared artboards:

- `Task Buddy Refresh`
- `Task Tornado Refresh`

Use the `Refresh` state machine and `RefreshControls` view model on the
explicitly selected artboard. Both artboards use the same contract:

| Property | Type | Meaning |
| --- | --- | --- |
| `pullProgress` | number, 0–1 | Reversible reveal amount. |
| `phase` | number | 0 Pull, 1 Refreshing, 2 Complete, 3 Failed, 4 Reduced Complete. |
| `accent` | color | Main indigo/accent artwork. |
| `success` | color | Completion artwork. |
| `surfaceContrast` | color | Bright card and eye details. |
| `completionProgress` | number | 1 after Complete or Reduced Complete reaches its final pose; 0 otherwise. |

The asset has passed a standalone official Rive Web/WASM runtime check for
progress 0/.25/.5/.75/1 and reversal, every phase, a completion/failure/reset
cycle, and custom color bindings. The `buddy-validation.png`,
`tornado-validation.png`, and theme validation PNGs show those states.

This export retains non-selected document artboards, including the legacy
Tornado and Rive branding artboards. That does not affect use in Flutter when
the two integration artboards above are selected by name. A Flutter/native
runtime check still belongs to the app integration task.
