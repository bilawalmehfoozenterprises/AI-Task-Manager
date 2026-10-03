# Home pull-to-refresh integration and animation comparison

Status: Rive preparation is complete as of 2026-10-01. This task has edited the Rive integration artboards and exports, but has not edited Flutter code. Both assets pass standalone official Rive Web/WASM runtime checks for progress/reversal, every state, completion/failure/reset, completion output, and color bindings. Flutter/native runtime validation remains part of integration. See [EXPORTS.md](EXPORTS.md) for the shipped animation contract and [ANIMATION_PREP_CHECKPOINT.md](ANIMATION_PREP_CHECKPOINT.md) for implementation evidence.

The final contract uses `RefreshControls`, numeric `phase` (0 Pull, 1 Refreshing, 2 Complete, 3 Failed, 4 Reduced Complete), and directly bound reversible `pullProgress` rather than a 1D blend. `completionProgress` becomes 1 at the final Complete/Reduced Complete pose and resets to 0 on Pull, Refreshing, and Failed. Do not use the unused `completionFinished` boolean or the earlier proposed event. Accent, success, and surfaceContrast bindings were verified with custom rendered colors. Use [task-refresh-comparison.riv](task-refresh-comparison.riv) and explicitly select `Task Buddy Refresh` or `Task Tornado Refresh`; it is one comparison asset rather than two independently managed files.

## 1. Intended experience and scope

Home keeps its existing My Tasks header, Pending/Completed tabs, task rows, letter effects, AI button, and Add Task button. Pulling down at the top reveals either Task Tornado or Task Buddy between the tabs and the first task. The content makes room for the animation; the graphic does not cover the first task. Releasing past the threshold runs the selected animation and then closes the header smoothly.

Start with Tornado selected. Add a temporary, clearly labeled comparison FAB that opens a small bottom sheet with a Tornado/Buddy segmented selector. The selection applies to both tabs. Both variants use identical gesture thresholds, header space, operation duration, and completion timing so the comparison measures the animation rather than different behavior.

Deliver the comparison experience first. Do not add a permanent user preference, new navigation destination, settings feature, backend sync, or analytics experiment. After choosing a winner, remove the comparison control and the unused runtime asset from the shipped build.

## 2. What exists today

`lib/src/features/task_list/presentation/task_list_screen.dart` provides the repository, task controller, and letter controller at screen scope. Its Scaffold contains a NestedScrollView plus an overlay LetterLayer. The app bar floats/snaps and leaves the tabs pinned. `task_list_view.dart` supplies the TabBarView; each `task_tab.dart` uses a CustomScrollView, SliverOverlapInjector, PageStorageKey, and lazy sliver list. Empty tabs use SliverFillRemaining. The existing FAB column already contains AI and Add Task actions.

`TaskListRepository.watchTasks()` watches local Drift data; `TaskListController.tasks` is a streamSignal. There is no remote task-sync operation, refresh method, or Rive dependency. The current error/loading branches replace the tab body. Existing task completion also drives an independent letter-particle effect. These details are integration constraints, not opportunities for unrelated refactoring.

The legacy `task-buddy.riv` and `task-tornado.riv` exports are motion prototypes. The prepared comparison asset is `design/rive/task-refresh-comparison.riv` (about 260 KB), with two explicit integration artboards and the shared `Refresh` runtime contract. It passed standalone Rive Web/WASM rendering and state validation. Complete Flutter runtime rendering is still an integration check, not an animation-authoring gap.

## 3. Refresh meaning: an explicit comparison build

For this first stage, use a dedicated comparison build with `--dart-define=ENABLE_REFRESH_COMPARISON=true`, default false. In this mode the pull runs an explicitly identified animation preview against the real, unchanged task list. An injected preview operation completes after 900 ms; it does not query an AI model, write tasks, invalidate Drift, or pretend to synchronize a server. The bottom sheet states that this is an animation preview. Keep the mock duration in a preview-only implementation and use a controllable operation in tests.

This choice is deliberate: the app already receives local task changes automatically. Adding a database read simply to justify a loader creates an unnecessary operation. A later production refresh must have a separately defined useful action, such as an actual sync/reconciliation service. The UI accepts a `Future<RefreshOutcome> Function()` callback so a real operation can replace the preview without changing gesture or Rive behavior. A production build must not silently fall back to the preview timer. Until a meaningful refresh operation is provided, ordinary builds retain today's Home behavior.

RefreshOutcome is a one-off presentation result such as succeeded, failed, or cancelled; it contains no Rive or Drift objects. Failures return to the widget for feedback and are logged with the existing Logger. Do not copy the current task controller's swallowed-error `_run()` pattern for this API. Drift remains the sole source of visible task data throughout.

## 4. Visual layout and comparison control

The refresh region sits below Pending/Completed, inside the active tab's content flow after overlap compensation. It occupies zero height at rest. Start with a 96-logical-pixel arming distance, a 144-pixel settled region, and a 176-pixel maximum reveal; these are tuning proposals, not measured final values. Introduce named size constants in app_sizes.dart. The animation itself fits a centered 240 × 144 region on normal phones and scales down proportionally on narrower windows. Cap its width on tablets using context.windowSizeClass instead of stretching across the screen.

Both assets get a common transparent 400 × 240 integration artboard, preserving their aspect and artwork proportions. Reframe Buddy rather than stretching its existing 400 × 200 artboard. Center the visual mass consistently so one variant does not seem better simply because it is bigger. Paint the surrounding surface using context.color.surface. Remove baked rounded background panels from integration copies; keep the original design exports intact.

Use FloatingActionButton.small with an animation/swap icon above the existing two FABs, separated by Sizes.p16. Give it a unique hero tag and localized tooltip “Compare refresh animations.” The AI and Add Task FABs retain their keys, positions relative to each other, and navigation. On short landscape windows where a third FAB causes crowding, use an app-bar IconButton with the same action instead; this is a layout fallback, not a second simultaneous control.

The bottom sheet contains a localized title, a SegmentedButton for Tornado/Buddy, a brief preview-mode label, a Preview button, and Close. Selection changes the next animation without triggering an operation. Preview closes the sheet, scrolls the active tab and outer header to the top, then initiates the same refresh path as a real pull. Announce the movement for accessibility; do not silently reset list offsets merely on selecting a variant. Keep selection in screen-scoped signals while navigating away/back with Home still mounted; a fresh Home session starts with Tornado. No preference database is needed.

Disable selection and preview actions during an active refresh, completion, or collapse. Keep the selected variant latched for that entire cycle. During a live drag, cancel back to rest before opening the comparison sheet. A distinct localized disabled explanation is available in the sheet. This prevents a partially rendered tornado becoming a half-finished Buddy.

## 5. Gesture and state behavior

| Phase | Trigger and content behavior | Animation behavior |
| --- | --- | --- |
| Idle | Region collapsed, list behaves normally | Hidden and not ticking |
| Dragging | User starts a downward drag at the true top | Reveal/scrub with normalized pull progress |
| Armed | Progress reaches 1; one light haptic per gesture | Hold ready pose; no operation yet |
| Cancelling | Release below threshold, drag back below threshold, or pointer cancellation | Reverse the reveal; no callback |
| Settling | Release while armed; latch variant and operation token | Ease into the working pose |
| Refreshing | Invoke one callback and keep region open | Loop the selected working animation |
| Completing | Callback succeeds | Stack/check sequence once |
| Failed | Callback fails or times out | Neutral retreat, never a success check |
| Collapsing | Completion or failure presentation ends | Close region, reset and stop ticking |

Use one gesture owner per tab and one screen-wide operation coordinator. Track the active tab and outer/inner top positions, not just notification.depth. Accept vertical leading-edge drags only. A drag beginning halfway down the list is scrolling, even if it later reaches the top; the next top-edge pull can refresh. Ignore horizontal tab swipes, bottom overscroll, inactive-tab notifications, mouse-wheel scrolling, and programmatic jumps. Repeated drags while busy never start another callback.

Retain existing nested scrolling and lazy lists. Do not convert the task list to a SingleChildScrollView/Column: this is an intentional preservation of the existing sliver architecture, not a new scrolling pattern. Short and empty lists must accept the pull gesture using always-scrollable physics composed with the chosen platform behavior. The existing full-screen initial loading state does not trigger refresh; show normal load feedback until an initial result exists.

First integration spike: use the generic CustomRefreshIndicator around each TaskTab's scroll view, with one header sliver after SliverOverlapInjector and a shared busy guard. Let the package own drag/arming/cancelling mechanics; map its controller to the header extent and presentation coordinator. Preserve the scrollable child instance on animation ticks. Never combine both content translation and an expanding spacer, which would move the list twice. Ensure native bounce/stretch is not also revealing a second gap. Suppress only the leading effect managed by the indicator.

The spike must prove correct notification routing, app-bar expansion, clipping, and offset restoration on Android and iOS before Rive polishing proceeds. Do not blindly accept all nested notifications. Flutter documents limitations around simultaneous outer floating/snapping and stretching; the existing configuration therefore needs real-device verification. If this wrapper cannot pass the stated behavior with the existing coordinator, isolate a sliver-based gesture adapter behind the same interface rather than adding a whole-screen vertical GestureDetector or replacing the entire Home screen.

## 6. Rive preparation and runtime contract

The integration copies are ready in `task-refresh-comparison.riv`. Preserve the Showcase timelines for recording, but do not play Showcase in response to every refresh. Each prepared artboard exposes the default `Refresh` state machine and the `RefreshControls` view model. Use Rive state machines and data binding; direct timeline playback is legacy.

The tested contract is: `pullProgress` number 0–1; numeric `phase` with 0 Pull, 1 Refreshing, 2 Complete, 3 Failed, and 4 Reduced Complete; colors for accent/surfaceContrast/success; and numeric `completionProgress`. Flutter remains the authority for operation success. Rive acknowledges visual completion by writing `completionProgress` to 1 at its final pose. The Flutter binding validates artboard, machine, properties, and types at load. If the runtime does not expose the output write, use the known 600 ms success duration plus a 1.2-second watchdog; never leave Home held open waiting indefinitely.

Pull uses a directly bound group reveal instead of a 1D blend. The group’s scale, opacity, and Y approach are driven from `pullProgress`, which was rendered and verified at 0, .25, .5, .75, 1, and the matching reverse path. This supports the required finger-following cancellation without timing a separate intro animation.

Refreshing must loop seamlessly and allow completion at any point. Normalize the last pull pose, loop entry, and completion entry to avoid jumps; Buddy's existing timelines especially require checking because they were created independently. Use a short state transition/blend to avoid teleporting cards when completion begins mid-orbit. Compare both variants at the same speed and settled size. Build a neutral failure exit without a tick; add reduced-motion static poses. The showcase remains a separate editor-only comparison convenience.

Starting timings: settle 180 ms; cancel 180–220 ms; success flourish 450–600 ms; header collapse 220 ms. Retune integration copies because existing Complete timelines take 1.5 seconds and already contain an exit. Give the header one owner for collapse: either align the authored final exit with Flutter's collapse or remove the duplicate exit from the asset. In the proposed contract Flutter owns closing the space after the Rive completion event. Keep a bounded completion-event watchdog, approximately 1.2 seconds, so a missing event cannot trap the UI.

A real operation should determine working-loop duration; never wait for a full 2.5-second tornado loop. The 900-ms delay belongs only to comparison mode. Use the same callback duration for both variants. Make pending futures race-safe with an operation generation/token, a 10-second preview watchdog, and ignored late results after disposal or cancellation; a timeout does not imply that an underlying future was actually cancelled.

## 7. Dependencies, ownership, and file boundaries

Initial pinned candidates are `rive: 0.14.11` and `custom_refresh_indicator: 4.0.2`, verified on 2026-09-30. Validate their resolved dependencies and platform compatibility before implementation; avoid the 0.15 dev runtime for this initial integration. Use the generic indicator builder, not CustomMaterialIndicator, to avoid an unwanted spinner container. Check the package's internal material usage against material_ui; application source keeps the required material_ui imports. If compatibility fails, the isolated gesture adapter is the fallback, not copying a second Material theme into Home.

Rive loading/rendering is presentation infrastructure, scoped to Home. Use FileLoader/RiveWidgetController/RiveWidget with explicit artboard and state-machine selection. Prefer Factory.rive initially and verify supported platforms/native initialization. Do not introduce a new app-wide provider. Initialize/load lazily when Home's comparison mode starts, preload both small assets once, and instantiate only the active player. Keep controller lifetimes explicit: detach event/effect listeners, dispose the player/view-model resources according to the pinned API, then dispose loaders/files after their consumers are gone.

| Proposed location | Responsibility |
| --- | --- |
| `assets/animations/task_refresh_comparison.riv` | Prepared comparison export; select `Task Buddy Refresh` or `Task Tornado Refresh` by name and explicitly register the nested asset directory in pubspec |
| `task_list/presentation/controller/refresh_preview_controller.dart` | Selected variant, busy state, operation token, one-off outcomes; plain class with signals/dispose |
| `task_list/presentation/controller/refresh_variant.dart` | Presentation enum and asset/artboard descriptor; no domain pollution |
| `task_list/presentation/controller/refresh_outcome.dart` | Typed operation result |
| `task_list/presentation/widgets/refresh/task_refresh_container.dart` | Generic indicator, active-scroll filtering, region extent and lifecycle |
| `task_list/presentation/widgets/refresh/task_refresh_header.dart` | Layout, semantics, reduced-motion and fallback presentation |
| `task_list/presentation/widgets/refresh/rive_refresh_player.dart` | Rive widget ownership and resource disposal |
| `task_list/presentation/widgets/refresh/rive_refresh_binding.dart` | Contract validation, property updates, event handling |
| `task_list/presentation/widgets/refresh/refresh_comparison_sheet.dart` | Segmented selection and Preview action |
| `task_list/presentation/widgets/refresh/refresh_comparison_fab.dart` | Temporary labeled comparison entry point |
| `task_list/presentation/refresh_preview_options.dart` | Feature flag, motion durations and preview-only operation configuration |

Paths above are under `lib/src/features/` unless otherwise specified. Register the new controller in TaskListScreen's existing MultiProvider. Update TaskTab, the FAB column, and the compact app-bar fallback only as necessary. Keep classes focused, aim under 100 lines, never over 150. Do not create domain/data/application layers without a role. No feature imports another feature; no schema changes or build_runner invocation are required for animation comparison.

Use signals for semantic UI state and SignalWidget/SignalBuilder for readers. Keep high-frequency renderer updates in the small visual subtree using the indicator's animation/listenable rather than broadcasting frame ticks to the task list. Avoid mirrored progress sources. Stateful widgets may own render/ticker resources, as the existing LetterLayer does; screen decisions stay in the controller. Dispose every effect. Use primary constructors, dot shorthands, Object? rather than dynamic, context.color, named size constants, and localization keys.

## 8. Failures, accessibility, and performance

Asset loading or contract failure must not block scrolling, task actions, or the comparison sheet. Log the specific variant/error and use a small theme-native static status fallback; explain that the animation is unavailable. Refresh-operation failure preserves current tasks and offers localized retry feedback, with no success flourish. Keep separate diagnostics for asset failure and operation failure.

Respect reduced-motion settings: no vortex orbit, sparkle burst, or spring overshoot; show a small static task/check treatment and a short fade. Announce pull-ready, working, completion, and failure once per transition, not every progress update. Label the FAB and selector, preserve native keyboard focus, meet minimum touch targets, and test enlarged text and landscape bottom-sheet fit. Do not put status text inside Rive; Flutter owns localization and screen-reader semantics.

On tab change, cancel a pre-release drag. For an already-started cycle, collapse/pause its visual, allow the callback to settle silently, and retain the shared busy guard until it does; do not replay completion on the new tab. On navigation away or backgrounding, stop visible rendering and ignore stale UI callbacks. Do not pause/resume the database stream or clear letter particles. Keep LetterLayer above list content and beneath FABs; active refresh can temporarily ignore row actions while visibly moving the list, but normal list interaction resumes immediately after collapse.

Render only one Rive player; hidden/offstage tabs must not tick a second copy. Put the header in a RepaintBoundary. No per-frame file decode, native controller creation, full-list rebuild, or texture allocation. Profile sustained pulls and repeated switching on a physical Android and iOS device; target the device's frame budget, inspect build/raster timings, and check memory returns to a stable plateau after repeated cycles. Asset file size alone is not a performance guarantee, especially with the tornado's many sampled keys.

## 9. Implementation sequence and validation

1. **Contract and asset spike:** back up originals, prepare transparent integration copies, normalize poses, wire the shared Rive contract, prove scrubbing/reversal and completion/failure in the pinned Flutter runtime, and verify each exported artboard through actual runtime rendering. Do not rely only on searching binary names.
2. **Scroll spike:** add the comparison-gated header with a static placeholder; validate top-only triggering, cancellation, one callback, short/empty lists, both tabs, nested header behavior, and exact offset restoration. Record baseline behavior before changing physics. Resolve this before layering complex animation onto it.
3. **Player integration:** connect pull progress and operation results to Rive; add fallback/reduced motion, disposal, timeout protection, and theme color bindings. Keep task data untouched.
4. **Comparison UI:** add the small FAB, bottom sheet, shared selection, and same-path programmatic preview. Confirm switching does not reset list state or create multiple players; keep AI/Add navigation working.
5. **Polish and review:** tune the proposed distances/timings together for both variants, profile native devices, capture comparable full/partial pulls, and let the user choose the winner before simplifying the final build.

Controller tests mirror source paths under test/src/features/task_list/. Cover cancelled pulls (zero callbacks), armed release (one callback), duplicate requests, typed failures/timeouts, stale results, variant latching, disposal, and selection retention. Use fake time and a controllable future rather than real sleeps. A fake renderer tests coordinator contracts without native rendering.

Widget tests cover both tabs, empty/short/long lists, mid-list downward scrolling, horizontal swipes, partial pull/reversal, max pull, app-bar collapsed/expanded, FAB/sheet semantics, programmatic Preview, busy switching, failed asset load, and no data/scroll-position reset. Test initial loading/error screens explicitly; comparison controls may preview a visual, but must not present that as a successful retry of a failed data stream. Preserve existing letter-effect tests.

Run native integration checks for actual Rive rendering and each property/event binding; ordinary widget fakes cannot prove these. Verify cycle boundaries and failure exits with screenshots/video. Test navigation mid-refresh, background/foreground, rotation, repeated refreshes and at least 20 variant switches. For later code implementation run flutter gen-l10n, flutter analyze (0 issues), and flutter test; run the app using flutter run --print-dtd and hot reload/restart via Dart MCP. No tests or builds are required to claim this planning document was written, and none are claimed here.

## 10. Completion criteria and follow-up decision

The comparison stage is complete when both animations can be selected on Home, pull follows the finger, cancellation works without callbacks, one released pull runs exactly one preview operation, each success/failure finishes correctly, empty tabs work, both tab offsets survive switching, existing actions/letters still work, reduced motion is usable, and no hidden animation or disposed callback remains active. The user can compare both on identical terms and record a clean sequence.

After selection: keep the chosen asset and common lifecycle, remove the comparison-only control/timer and unused asset from shipping builds, and decide the meaningful production refresh operation. Production must not ship an unexplained simulated synchronization. This is a product decision separate from choosing the best animation.

## References checked

- [Rive Flutter integration](https://rive.app/docs/runtimes/flutter/flutter): current widget/controller loading and runtime setup.
- [Rive package](https://pub.dev/packages/rive): stable version candidate.
- [Rive animation playback guidance](https://rive.app/docs/runtimes/flutter/animation-playback): new integrations should use state machines.
- [Custom Refresh Indicator](https://pub.dev/packages/custom_refresh_indicator): gesture states, builder, durations, and notification filtering.
- [Flutter NestedScrollView](https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html): coordinated inner/outer scrolling and header limitations.
