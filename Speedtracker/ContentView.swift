import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var trip = TripModel()

    var body: some View {
        VStack(spacing: 18) {

            Text("Speed (MPH)")
                .font(.headline)

            Text("\(Int(locationManager.speedMph.rounded()))")
                .font(.system(size: 72, weight: .bold, design: .rounded))

            statusLine

            Divider().padding(.vertical, 8)

            tripPanel

            Spacer()
        }
        .padding()
        .onAppear {
            locationManager.requestPermission()
            locationManager.start()
        }
        .onReceive(locationManager.$speedMph) { newSpeed in
            trip.ingest(location: locationManager.lastLocation, speedMph: newSpeed)
        }
        .onReceive(locationManager.$lastLocation) { _ in
            trip.ingest(location: locationManager.lastLocation, speedMph: locationManager.speedMph)
        }
    }

    private var statusLine: some View {
        let auth = locationManager.authorizationStatus
        let acc = locationManager.accuracyMeters

        return Group {
            if auth == .denied || auth == .restricted {
                Text("Location permission denied. Enable it in Settings.")
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            } else if auth == .notDetermined {
                Text("Requesting location permission…")
                    .foregroundStyle(.secondary)
            } else {
                if let acc {
                    Text("GPS Accuracy: ~\(Int(acc)) m")
                        .foregroundStyle(acc <= 20 ? .green : .secondary)
                } else {
                    Text("Searching for GPS…")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .font(.subheadline)
    }

    private var tripPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Trip Mode")
                    .font(.title3)
                    .bold()
                Spacer()
                Text(trip.isRunning ? "RUNNING" : "STOPPED")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(trip.isRunning ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                    .clipShape(Capsule())
            }

            HStack {
                stat(title: "Time", value: trip.elapsedString)
                stat(title: "Miles", value: String(format: "%.2f", trip.distanceMiles))
            }

            HStack {
                stat(title: "Avg MPH", value: String(format: "%.1f", trip.averageSpeedMph))
                stat(title: "Top MPH", value: String(format: "%.1f", trip.topSpeedMph))
            }

            HStack(spacing: 12) {
                Button(trip.isRunning ? "Stop" : "Start") {
                    trip.isRunning ? trip.stop() : trip.start()
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    trip.reset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func stat(title: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
