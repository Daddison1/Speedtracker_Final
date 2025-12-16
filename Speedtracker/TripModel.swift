import Foundation
import CoreLocation
import Combine

final class TripModel: ObservableObject {
    @Published var isRunning = false
    @Published var elapsedSeconds: Int = 0
    @Published var distanceMeters: Double = 0
    @Published var topSpeedMph: Double = 0

    private var timer: Timer?
    private var lastTripLocation: CLLocation?

    func start() {
        isRunning = true
        lastTripLocation = nil
        startTimer()
    }

    func stop() {
        isRunning = false
        stopTimer()
        lastTripLocation = nil
    }

    func reset() {
        stop()
        elapsedSeconds = 0
        distanceMeters = 0
        topSpeedMph = 0
    }

    func ingest(location: CLLocation?, speedMph: Double) {
        guard isRunning else { return }
        guard let location else { return }

        if speedMph > topSpeedMph {
            topSpeedMph = speedMph
        }

        if let last = lastTripLocation {
            let delta = location.distance(from: last)
            // Ignore GPS jumps
            if delta < 50 {
                distanceMeters += delta
            }
        }
        lastTripLocation = location
    }

    var distanceMiles: Double {
        distanceMeters / 1609.344
    }

    var averageSpeedMph: Double {
        guard elapsedSeconds > 0 else { return 0 }
        let hours = Double(elapsedSeconds) / 3600.0
        return distanceMiles / hours
    }

    var elapsedString: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
