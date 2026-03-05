# 🟥 SharedCubeApp

A **visionOS** sample project for learning **Group Activities (SharePlay)**, **RealityKit**, and some useful **Spatial Gestures** — all in one place.

---

## What it does

A red cube floats in your physical space. You can **drag**, **pinch to scale**, and **rotate** it simultaneously with both hands. When you start a SharePlay session over FaceTime, the cube's position, scale, and rotation are **synchronised in real-time across all participants** — anyone in the call can grab it and everyone else sees it move. You can also start a local SharePlay activity.

---

## Concepts covered

| Concept | Where |
|---|---|
| Declaring `WindowGroup` + `ImmersiveSpace` scenes | `SharedCubeApp.swift` |
| `GroupActivity` protocol & `activityIdentifier` | `CubeActivity.swift` |
| Designing a `Codable` network message with SIMD types | `CubeMessage.swift` |
| Full `GroupSession` lifecycle (listen → activate → join → invalidate) | `SharePlayCoordinator.swift` |
| `GroupSessionMessenger` — sending & receiving typed messages | `SharePlayCoordinator.swift` |
| `@Observable` + SwiftUI environment injection | `SharePlayCoordinator.swift` |
| `openImmersiveSpace` / `dismissImmersiveSpace` actions | `LobbyView.swift` |
| `RealityView` make & update closures | `ImmersiveCubeView.swift` |
| `DragGesture`, `MagnificationGesture`, `RotateGesture3D` simultaneously | `ImmersiveCubeView.swift` |
| `CollisionComponent` + `InputTargetComponent` for hit-testing | `ImmersiveCubeView.swift` |
| Quaternion rotation composition (`simd_quatf`) | `ImmersiveCubeView.swift` |

---

## Gesture design

All three gestures run in parallel using `.simultaneously(with:)`. Each one owns exactly one component of the transform so they never conflict:

| Gesture | Modifies | Approach |
|---|---|---|
| `DragGesture` | `position` | `startPosition + translation3D / sensitivity` |
| `MagnificationGesture` | `scale` | `startScale × gestureValue` (clamped) |
| `RotateGesture3D` | `orientation` | `startQuaternion × deltaQuaternion` |

Two RealityKit components are **required** for gestures to hit-test an entity:

```swift
entity.components.set(CollisionComponent(shapes: [.generateBox(size: [1,1,1])]))
entity.components.set(InputTargetComponent())
```

---

## Requirements

- Xcode 15 or later
- visionOS 1.0+ deployment target
- macOS 14 Sonoma or later (to run Xcode 15)

---

## Xcode project setup

1. **New project** → visionOS › App
   Check **"Include Immersive Space"** in the options

2. **Replace** all generated `.swift` files with the files in this repo

3. **Capabilities** → Target › Signing & Capabilities › **+ Group Activities**

4. **Info.plist** — verify these two entries are present:

```xml
<key>UIApplicationSceneManifest</key>
<dict>
    <key>UIApplicationSupportsMultipleScenes</key>
    <true/>
</dict>

<key>NSGroupActivityTypes</key>
<array>
    <string>com.example.SharedCubeApp.CubeActivity</string>
</array>
```

> ⚠️ `UIApplicationSupportsMultipleScenes` must be **nested inside** `UIApplicationSceneManifest` — a top-level key is silently ignored by the system.

5. Update the **bundle identifier** in `CubeActivity.activityIdentifier` to match your own

---

## Testing SharePlay without two headsets

You can test with two visionOS Simulator instances on the same Mac:

1. Launch **Simulator A** → Settings › FaceTime → sign in with Apple ID #1
2. Launch **Simulator B** → Settings › FaceTime → sign in with Apple ID #2
3. Start a FaceTime call from A to B
4. In Simulator A: launch the app → tap **Enter Immersive Space** → tap **Start SharePlay**
5. In Simulator B: accept the SharePlay invitation → enter the immersive space
6. Move the cube in either simulator — it should move in both

...or you can test it with a friend who has a Vision Pro by starting a local SharePlay session!

---

## File reference

| File | Purpose |
|---|---|
| `SharedCubeApp.swift` | App entry point, scene declarations |
| `CubeActivity.swift` | GroupActivity conformance |
| `CubeMessage.swift` | Codable network payload + `simd_quatf` encoding |
| `SharePlayCoordinator.swift` | Session lifecycle, messenger, published state |
| `LobbyView.swift` | 2D window UI, space controls |
| `ImmersiveCubeView.swift` | RealityView, entity, all three gestures |
| `Info.plist` | Required capability keys |

---

## Further reading

- [Group Activities — Apple Developer Documentation](https://developer.apple.com/documentation/groupactivities)
- [WWDC23: Build spatial SharePlay experiences](https://developer.apple.com/videos/play/wwdc2023/10087/)
- [WWDC22: Make a great SharePlay experience](https://developer.apple.com/videos/play/wwdc2022/10139/)
- [RealityKit — Entity](https://developer.apple.com/documentation/realitykit/entity)
- [Adding 3D content to your app](https://developer.apple.com/documentation/visionos/adding-3d-content-to-your-app)

---

## License

MIT — free to use, modify, and learn from.
