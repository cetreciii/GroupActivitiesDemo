# Collaborative Cube: visionOS SharePlay Demo

A minimal, robust, and educational sample project demonstrating how to implement **Group Activities (SharePlay)** in a visionOS immersive space.

## 🚀 Overview

This project serves as a basic implementation for developers looking to learn how to synchronize 3D entities across multiple users in real-time. It features a shared red cube that participants can collaboratively move, rotate, and scale.

![visionOS](https://img.shields.io/badge/platform-visionOS-blue)
![Swift](https://img.shields.io/badge/language-Swift-orange)
![RealityKit](https://img.shields.io/badge/framework-RealityKit-red)
![SharePlay](https://img.shields.io/badge/framework-GroupActivities-green)

## ✨ Key Features

- **Real-Time Synchronization**: Position, rotation, and scale are synced across all participants using `GroupSessionMessenger`.
- **"No-Jump" Interaction**: Implements offset tracking so the cube doesn't jump to your finger when grabbed.
- **Simultaneous Gestures**: Move, rotate, and scale at the same time for a fluid user experience.
- **Natural Hand Alignment**: Custom quaternion mirroring logic ensures the cube's rotation feels natural and follows your hand movements perfectly.
- **Immersive Space**: Uses `ImmersiveSpace` and `RealityView` for a high-fidelity spatial experience.

## 📂 Project Structure

- **`SessionManager.swift`**: Handles the lifecycle of the SharePlay session and data broadcasting.
- **`ImmersiveView.swift`**: Manages the 3D rendering and the gesture logic.
- **`ContentView.swift`**: The main UI for starting sessions and entering the immersive space.

## 🛠 Requirements

- **Xcode 15.0+**
- **visionOS 1.0+**

## 📖 How to Run

1. Open `GroupActivitiesDemo.xcodeproj`.
2. Ensure you have a unique **Bundle Identifier** and a **Development Team** set in the project settings.
3. Build and run on a visionOS device.
4. To test SharePlay, start a FaceTime call between two devices/simulators and tap "Start SharePlay" in the app. You can also share the app with someone nearby wearing a Vision Pro!

## 📄 License

This project is provided for educational purposes. Feel free to use the code as a foundation for your own spatial apps.
