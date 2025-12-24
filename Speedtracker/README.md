# SpeedTracker (CS50 Final Project)

Project Overview
SpeedTracker is an iOS application built with Swift and SwiftUI that displays a user’s real-time speed in miles per hour (MPH) using GPS data. The app also includes a Trip Mode that allows users to track distance traveled, trip duration, average speed, and top speed during a session.

This project was created as the final project for **CS50**, demonstrating mobile development concepts, real-time data handling, and user interface design using Apple’s native frameworks.



Features
- Live speed display in **MPH**
- GPS accuracy indicator
- Trip Mode with:
  - Start / Stop functionality
  - Elapsed time tracking
  - Distance traveled (miles)
  - Average speed
  - Top speed
  - Reset option
- Clean and simple SwiftUI interface
- Real-time updates using Core Location



How It Works
- The app uses **Core Location** to access GPS data.
- Speed is obtained from `CLLocation.speed`, which provides meters per second.
- Speed is converted to miles per hour using the formula:
Distance is calculated by summing the distance between consecutive GPS location updates.
- Trip statistics are updated in real time while Trip Mode is active.



Technologies Used
- Swift
- SwiftUI
- Core Location
- Combine
- Xcode

No backend server or database is required; all calculations are handled locally on the device.



How to Run the App
1. Open the project in **Xcode** on macOS.
2. Ensure location permissions are enabled:
   The app requests *When In Use* location access.
3. Select an iPhone device or simulator.
4. Click **Run** to build and launch the app.
5. For accurate speed readings, testing on a **real iPhone** is recommended.



Notes & Limitations
- GPS speed may take a few seconds to initialize.
- Indoor use or poor signal may reduce accuracy.
- This app is intended for **informational purposes only** and should not be used while driving.



Design Decisions
- SwiftUI was chosen for its modern, declarative UI approach.
- Trip Mode was implemented to add meaningful functionality beyond a basic speed display.
- The interface was intentionally kept simple to prioritize readability and ease of use.
- GPS distance spikes are filtered to reduce errors from sudden location jumps.



Future Improvements
- Unit toggle between MPH and KM/H
- Trip history saving
- Map view showing the traveled route
- Speed alerts when exceeding a user-defined limit



Author
Created by Dustin Addison as the final project for CS50.



Demo Video
https://youtube.com/shorts/2s0lJQ6Z3HY
