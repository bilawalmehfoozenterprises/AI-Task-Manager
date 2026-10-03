# Rive animation preparation checkpoint — 2026-09-30

## Final animation checkpoint — 2026-10-01

Rive authoring is complete. `task-refresh-comparison.riv` is the validated asset for the Home comparison build; [EXPORTS.md](EXPORTS.md) contains its exact contract. It passed progress/reversal, phase, completion/failure/reset, and custom-color checks in the official Rive Web/WASM runtime. Flutter/native verification remains a later implementation check. The archived checkpoint 2 notes below are retained as working history.

## Checkpoint 2 — historical, superseded by final checkpoint

Paused again at the user's explicit request after resuming. No Flutter source was edited. Both animations now pass live state transitions and completion output checks in the official `@rive-app/canvas-advanced` 2.43.1 runtime, using `@napi-rs/canvas` for standalone vector rendering. This is Web/WASM validation, not Flutter/native-device validation.

Saved `refresh-preparation-checkpoint-2.riv` (259,775 bytes), `buddy-working-checkpoint-2.png`, `tornado-working-checkpoint-2.png`, and `runtime-check-checkpoint-2.mjs`. The script is evidence/reference and currently refers to temporary runtime dependencies in `/tmp/rive-validation`; reinstall them there or adapt the paths before re-running. The export has 6 runtime artboards: original Task Tornado, both integration artboards, Watermark, NuRiveBrandmark01, NuRiveWordmark01. Always select the intended integration artboard explicitly. Final per-variant exports have NOT been produced.

Validated phase sequence on each artboard: 0 → 1 → 2 → 0 → 1 → 3 → 0 → 4 → 0, advancing 90 frames per phase. Every expected state was entered; completionProgress returned 1 for Complete and Reduced Complete, 0 for Pull/Refreshing/Failed, including the reset/repeat cycle. The correct low-level test loop is `sm.advance(dt); artboard.advance(dt)`. Using `advanceAndApply(dt)` followed by another artboard advance caused misleading stuck-state results. Flush deferred canvas rendering with `rive.resolveAnimationFrame()` after drawing. Bind the Default view-model instance to both machine and artboard in this low-level harness. Do not copy manual advancement into Flutter widgets, whose runtime owns advancement.

Pull timelines were set to loop (static one-frame poses) to let the editor simulation remain active for late input; the host should stop ticking when hidden/idle. `RefreshControls.defaultinstanceid` now points to Default (`0-21295`). The extra setup layers are confirmed `isDisabled:true` on query; retaining them is harmless. completionFinished remains unused.

Theme binding changes: exact base #8687E7 paints bind accent; success-badge/success-sparkle paints bind success; bright card/eye paints bind surfaceContrast. Default surfaceContrast is #EEEDFF. Deliberately preserve other authored shades. All binding calls succeeded. Color-change rendering is still to be checked.

Visual issue fixed: duplicate Tornado freeform paths rendered jagged. Their child shapes were hidden (not deleted), and 9 clean parametric ellipse strokes were added under the existing animated ribbon groups. New shapes `0-27358`, `0-27362`, `0-27366`, `0-27370`, `0-27374`, `0-27378`, `0-27382`, `0-27386`, `0-27390`; widths40–184, heights10–23.6, stroke1.3. Existing parent transforms/opacity still animate them. Oversized aura shapes were hidden. Working-state renders of Buddy and the cleaned Tornado were inspected; both display on transparency. Full completion, failure and progress contact sheets remain to inspect.

Exported debug node names are now enabled for Pull Reveal (both), Completion Signal (both), and Tornado Scene. Export flags: originals iscomponent=false/includeinexport=false, integrations true/true. Nevertheless export includes the original Task Tornado as default root plus Rive branding artboards. Do not claim a clean single-artboard export. The document default-root selection is not exposed in the current open_file_editor tool. Native UI can display screenshots, but clicks twice failed `noWindowsAvailable`; no UI setting was changed. Investigate normal editor export/default-root controls on resume, or transparently document retained runtime dependencies. Do not strip branding or bypass export restrictions.

Completed after this checkpoint: inspected progress0/.25/.5/.75/1 and reversal, loop-to-complete and loop-to-failure handoffs, reduced-motion success, custom theme colors, and bounds through standalone renders. Saved `task-refresh-comparison.riv`, validation contact sheets, and `runtime-visual-check.mjs`. The only remaining validation is Flutter/native rendering during app integration. The numbered instructions and original checkpoint details below are historical.

Paused deliberately at the user's request. Do not continue until asked. Both assets are WORK IN PROGRESS, not integration-ready. No Flutter code was edited in this task. The workspace now contains unrelated/concurrent Flutter integration modifications; inspect them on resume and preserve them.

## Saved location

- Rive document: https://editor.rive.app/file/untitled/2618576 (Untitled).
- Original showcase artboards are intact: Buddy `0-2`, Tornado `0-969`.
- Integration copies: `Task Buddy Refresh` (`0-14123`) and `Task Tornado Refresh` (`0-14252`).
- `refresh-preparation-checkpoint.riv`: runtime snapshot, 244,554 bytes, RIVE header verified. This is not an editable .rev backup and not a validated single-artboard export. The Rive editor document holds editable work.
- `animation-prep-checkpoint.json`: object mappings and original timeline keys, useful for continuing without re-deriving mappings. Not a Rive import format.

## Work completed

Both copies are 400 × 240. Buddy artwork is shifted down 20px to preserve proportions. Copied preview backdrops have opacity 0 and artboard fills are transparent. Original exports are unchanged.

Created Pull, Refreshing, Complete, Failed, and Reduced Complete timelines. Buddy loop is 2 seconds; Tornado loop is 2.5 seconds. Complete is 36 frames at 60fps (600ms), holds its success pose, and no longer includes the original final exit. Failed currently holds a neutral non-success pose; the eventual Flutter adapter must reverse pullProgress to retreat. Reduced Complete is a static success pose.

Each integration artboard has a default `Refresh` machine. Any-State transitions select phases with 120ms blends into working/complete/failed and immediate pull/reduced-complete selection. Idle/pulling/reduced working all use phase 0, differentiated by progress and host semantics.

Pull Reveal groups bind scale X/Y and opacity to clamped pullProgress (0–1). Y binds to a 50px approach offset: Buddy baseline132.5; Tornado baseline115. These bindings are authored but their rendered behavior and reversal have not been verified. This is whole-composition reveal, not the originally proposed five-pose 1D blend or individual-card gathering.

## Current identifiers and contract

Shared ViewModel `RefreshControls`: `0-21284`; explicit instance `Default`: `0-21295`.

| Property | Definition ID | Default instance value ID | Status |
|---|---|---|---|
| pullProgress, number | 0-21286 | 0-21296 | Bound reveal, render verification pending |
| phase, number | 0-21288 | 0-21297 | 0 Pull, 1 Refreshing, 2 Complete, 3 Failed, 4 Reduced Complete |
| accent, color | 0-21290 | 0-21298 | Default #8687E7; artwork bindings unfinished |
| success, color | 0-21292 | 0-21299 | Default #9CE6B2; artwork bindings unfinished |
| surfaceContrast, color | 0-21315 | 0-21316 | Unconfigured/unbound |
| completionProgress, number | 0-21318 | 0-21319 | Output binding authored, unverified |
| completionFinished, boolean | 0-21312 | 0-21313 | Unused experiment; do not consume |

Completion Signal empty nodes: Buddy `0-21321`, Tornado `0-21680`. Their x property is bound **toSource** into completionProgress and keyed 0 during pull/working/failure, 1 at the final completion frame; Reduced Complete sets 1 immediately. Verify that animation changes propagate out through this binding before using it. There is no completion event yet.

Buddy machine `0-21271`, active layer `0-21276`, Any `0-21277`, Entry `0-21279`. States: Pull `0-21280`, Refreshing `0-21669`, Complete `0-21670`, Failed `0-21294`, Reduced Complete `0-27269`. Timelines respectively `0-21281`, `0-21282`, `0-21283`, `0-21671`, `0-21672`. Reveal group `0-21311`.

Tornado machine `0-21681`, active layer `0-21686`, Any `0-21687`, Entry `0-21689`. States: Pull `0-21690`, Refreshing `0-21691`, Complete `0-21692`, Failed `0-21693`, Reduced Complete `0-21694`. Timelines respectively `0-21674`, `0-21675`, `0-21676`, `0-21677`, `0-21678`. Reveal group `0-21679`; inner scene `0-17597`.

Converters: clamped raw progress `0-21300`; Buddy Y `0-21645`; Tornado Y `0-27168`. Data binds use underlying unit scale/opacity (0–1), while property/keyframe tools use editor percentages (0–100).

## Validation performed and unresolved issue

Read-back confirms timeline keys, state animation assignments, numeric phase conditions and bindings were authored. A frame-zero phase=1 simulation reaches Buddy Refreshing and remains looping for 60 frames. A frame-zero phase=2 simulation reaches Tornado Complete and settles at frame37.

**A multi-step simulation did not transition when phase changed at later frames.** It stayed in Pull despite scheduled phase=1 and phase=2 writes. This may be a simulation wake-up/instance issue or actual state wiring problem. It is unresolved and is a readiness blocker. Test a live runtime instance with updates after advancing, ensure the correct Default instance is attached, then fix and repeat cancellation/working/completion/failure/reduced/restart cycles.

No rendered capture of the modified copies was inspected. No native Flutter runtime verification or performance measurements were run. One native editor screenshot showed a loading overlay; MCP continued accepting calls. Check editor health before resuming.

## Remaining work, in order

1. Confirm current editor state and read back both machines and view-model bindings. Check that unrelated work has not changed the integration contract.
2. Resolve dynamic phase updates and prove working → success/failure → reset with live runtime data binding. Verify Any-State transitions do not repeatedly restart their own state.
3. Verify completionProgress output and repeat-cycle reset. Replace with a supported completion signal if necessary; never present the unused completionFinished boolean as working.
4. Bind theme colors to appropriate fills; configure default surfaceContrast and the default-instance selection. Avoid recoloring all shades identically.
5. Visually inspect both at progress 0/.25/.5/.75/1 and reverse. Check transparent background, bounds, proportions, loop seam, mid-loop blends, success hold, neutral failure, and reduced-motion presentation. Refine the whole-composition reveal if it is too plain.
6. Confirm 600ms complete timing and a single host-owned collapse. Reduced working uses phase0/progress1; reduced success phase4.
7. Export each integration artboard separately with intentional export/component flags. Keep originals and checkpoint separate. Validate actual rendered exports, not binary names alone.
8. Update HOME_REFRESH_PLAN.md and write the final integration contract with tested names/types/timings and honest runtime verification status.

## Tooling notes and preserved setup objects

The visible tool signatures collapse nested schemas into unknown. Full schemas were retrieved via MCP tools/list and saved at `/tmp/rive-tools.json` (temporary; may disappear). Server is http://127.0.0.1:9791/mcp; initialize, then notifications/initialized, then tools/list or tools/call. Shell network access requires escalation. Native export is denied by the editor sandbox, so use its documented inline-base64 export fallback and decode directly to disk without printing bytes.

Correct nested forms: createStates uses linearAnimationName; updateStates accepts id+animationId. createStateMachine did NOT resolve existing timeline names in this run, so explicit updateStates was necessary. createTransitions uses states:[{id,transitions:[{to}]}]. createConditions uses leftComparator.viewModelPropertyId, operation, rightComparator:{valueType:'constantValueType',value}. createLinearAnimations duration is in SECONDS; property57 is FRAMES. addProperties uses viewModels:[{viewModelId,viewModelProperties:[{name,propertyType}]}]. createConverters uses converterType:'formula', with {Input} in its expression.

Automatic approval review rejected deletion of temporary setup objects and a copied backdrop, classifying it as irreversible without exact authorization. No deletion was performed. Backdrops were hidden instead. Extra empty layers `0-21272` and `0-21682` were named Disabled setup layer and flags set to1, but simulation still lists them; verify the actual disable flag before claiming they are disabled. The empty initial ViewModel `RefreshViewModel` (`0-21269`) remains unused. These objects do not require deletion to proceed. Do not retry deletion without resolving the review's concern.
