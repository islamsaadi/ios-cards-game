//
//  LocationDelegate.swift
//  CardsGame
//
//  Created by Islam Saadi on 18/05/2025.
//
import Foundation
import CoreLocation

class LocationDelegateWrapper: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var onUpdate: ((CLLocation) -> Void)?
    private var onDenied: (() -> Void)?

    func configure(onUpdate: @escaping (CLLocation) -> Void, onDenied: @escaping () -> Void) {
        self.onUpdate = onUpdate
        self.onDenied = onDenied
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            onUpdate?(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            onDenied?()
        }
    }
}
