# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

NetLab is a cross-platform Flutter app for teaching computer networking. It has three pillars: an interactive **Network Simulator** (build topologies, run ARP/packet-routing simulations), a 5-chapter **Study** curriculum with quizzes, and reference **Tools** (IP converter, subnet calculator, network analyzer). Backend is Firebase (Auth + Firestore) for optional cloud backup of study progress.

## Commands

```sh
flutter pub get                    # install dependencies
flutter run                        # run app (desktop/mobile; landscape-only)
flutter build web --release        # web build (see CI for required --dart-define flags)

flutter analyze                    # static analysis
dart fix --apply                   # auto-fix analyzer issues
dart format .                      # format
dart run custom_lint               # Riverpod-specific lints (riverpod_lint) — NOT covered by `flutter analyze`

flutter test                                                  # all tests
flutter test test/simulation/core/mac_address_manager_test.dart   # single test file
```

Toolchain: Dart SDK `^3.8.1`; developed on Flutter 3.41 / Dart 3.11; CI builds with Flutter 3.38.7.

## Architecture

`lib/` is organized feature-first: `core/` (shared routing, theme, utils, providers), `home/` (landing + `simulation/`), `dashboard/` (+ `study/`), `settings/`, `tools/`, `tutorial/`.

### Routing — `lib/core/routing/go_router.dart`
`go_router` with one `ShellRoute` wrapping every screen in `AppLayout`. Paths are centralized in the `Routes` class. The simulation screen sets `parentNavigatorKey: _rootNavigatorKey` so it opens fullscreen *over* the shell. `routeObserver` (a `RouteObserver`) is exported for screens that need route-lifecycle callbacks.

### State management — Riverpod 3, no codegen
All state uses hand-written `Notifier` / `NotifierProvider` classes (there is no `build_runner`/`riverpod_generator`). `ProviderScope` lives in `main.dart` and overrides `asyncSharedPrefsProvider` with a real `SharedPreferencesAsync`. Run `dart run custom_lint` to catch Riverpod misuse.

### The Simulation Engine — `lib/home/simulation/`
This is the most complex subsystem. Subfolders: `core/` (enums, address managers, validator), `model/` (data classes), `provider/` (notifiers), `widgets/` (canvas rendering).

- **Model hierarchy** (`model/sim_objects/sim_object.dart`): abstract `SimObject` → abstract `Device` (adds `posX`/`posY`) → concrete `Host`, `Router`, `Switch`, `AccessPoint`, `WirelessHost`; `Connection`, `WirelessCon`, `Message` extend `SimObject` directly. Every concrete type is a Dart `part` of `sim_object.dart`. Each has `toMap()`/`fromMap()`; `SimObject.fromMap()` dispatches on the `type` field.

- **Three providers per object type.** For each type there is a trio: `xProvider` (a `.family` `SimObjectNotifier` keyed by id — the per-instance behavior), `xMapProvider` (the canonical `Map<id, SimObject>` store), and `xWidgetsProvider` (`Map<id, SimObjectWidget>` for rendering). A per-instance notifier reads its initial value from the map. Notifier base classes (`SimObjectNotifier`/`SimObjectMapNotifier`/`SimObjectWidgetsNotifier`, then `DeviceNotifier` etc.) are themselves `part`s of `sim_object_notifier.dart`.

- **ID convention is load-bearing.** IDs are `'${type.label}_${Ulid()}'`. Code routes behavior by `id.startsWith(SimObjectType.host.label)` etc. throughout the engine — IDs are not opaque.

- **Orchestrator:** `SimScreenNotifier` (`provider/sim_screen_notifier.dart`) creates devices/connections/messages and drives play/stop. The `SimObjectCreation` extension on `SimObjectType` holds the `createSimObject` / `createSimObjectWidget` factories.

- **Play/stop lifecycle:** `playSimulation()` snapshots state to `_tempMap`, starts `simClockProvider` (10 ms ticks), and begins host message processing. `stopSimulation()` resets the clock, `ref.invalidate`s every object/map/widget provider, then re-imports `_tempMap` — so the canvas reverts to its pre-run layout. `clearAll()` wipes everything.

- **Message passing simulates the OSI stack.** A `Message` carries a `layerStack` (`List<Map<String,String>>`). Devices push encapsulation layers (Network, Data Link, ARP) before sending; receivers `popLayer()`. A `Connection` animates a message across (duration = distance ÷ `messageSpeed`) then delivers to the peer's `receiveMessage()`. Hosts keep an `arpTable`, broadcast ARP requests when a MAC is unknown, and track pending requests with `arpReqTimeout`. `Ipv4AddressManager` / `MacAddressManager` (`core/`) are static allocators with import/export/clear.

- Provider mutations are frequently deferred via `WidgetsBinding.instance.addPostFrameCallback` to avoid mutating providers mid-build — preserve this when editing the engine.

- **Adding a new SimObject type** means: extend the `SimObjectType` enum + its `label` extension (`core/enums.dart`); add `part` files under `model/sim_objects/`, `provider/sim_object_notifiers/`, and `widgets/sim_object_widgets/` (registered in each parent's `part` directives); and update every `switch (type)` — `SimObject.fromMap`, `SimObjectWidget.fromType`, `createSimObject`, `createSimObjectWidget`.

### Learning content & progress
Curriculum is **data-driven**: `assets/learning_material/material_details.json` defines chapters → lessons → questions; lesson bodies are Markdown under `assets/learning_material/material_content/chapter_N/`. `main.dart`'s `_loadData()` loads all of it at startup into `materialDetailProvider` / `materialContentProvider`. New asset folders must be added to the `assets:` list in `pubspec.yaml`.

Study progress lives in five notifiers under `dashboard/study/provider/` (`question_status`, `lesson_status`, `chapter_quiz`, `study_time`, `lesson_history`). Each persists to `SharedPreferences` under a key prefix and exposes `exportData()` / `restoreFromBackup()`.

### Firebase & auth
`FirebaseBackupService` (`settings/providers/`) signs in with Google (`google_sign_in_all_platforms`) and mirrors the five progress notifiers to Firestore at `user_backups/{uid}`. Firebase plugins are **not supported on Linux** (a Linux build target still exists but will throw on Firebase init).

### Configuration & secrets
`lib/firebase_options.dart` and `lib/google_auth_keys.dart` hold platform credentials. The **committed** versions read secrets from `String.fromEnvironment` (`--dart-define`) with a `flutter_dotenv` `.env` fallback (loaded only in `kDebugMode`). CI injects real values via `--dart-define` and strips `.env` from `pubspec.yaml` before a web build. Note: these two files currently have **uncommitted local edits that hardcode the secrets** — restore the env-based pattern before committing changes to them.

CI: `.github/workflows/firebase-hosting-merge.yml` deploys web to Firebase Hosting (project `netlab-8c22e`) on push to the `web-deployment` branch.

### Platform constraints
- App forces **landscape orientation** and immersive fullscreen (`main.dart`).
- **Mobile web is blocked** — `isMobileWeb()` (`core/utils/platform_helper.dart`) routes to a `MobileWebBlocker` overlay.
- `FileService` (`core/utils/file_service.dart`) saves/loads network `.json` files with per-platform code paths (web blob, Windows/Android `file_picker`); iOS/macOS save is not implemented.

## Conventions

- **Commits:** `Type: Purpose` (e.g. `feat: add subnet tool`). Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, `ci`, `perf`, `revert`.
- **Git:** fork-based workflow; keep history linear — `git pull --rebase` before pushing.
- Lints extend `flutter_lints` with `prefer_const_*` rules plus the `custom_lint` plugin (see `analysis_options.yaml`).
