import SwiftUI
import CoreLocation

struct WelcomeView: View {
    
    @State private var playerName:   String     = ""
    @State private var inputName:    String     = ""
    @State private var showNameField = false

    @State private var userLocation: CLLocation?
    @State private var locationDenied = false

    @StateObject private var locationDelegateWrapper = LocationDelegateWrapper()
    private let locationManager  = CLLocationManager()
    private let dividerLongitude = 34.817549168324334

    /// “East Side” or “West Side” once we have a location
    private var currentSide: String? {
        guard let loc = userLocation else { return nil }
        return loc.coordinate.longitude > dividerLongitude
             ? "East Side"
             : "West Side"
    }

    // Helper to convert side into the Bool your GameView expects
    private var isPlayerOnLeft: Bool {
        // We’ll put the player on the left when they’re on the West side
        currentSide == "West Side"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                // MARK: Name Input / Greeting
                if playerName.isEmpty {
                    Button("Insert name") {
                        showNameField = true
                    }
                    .foregroundColor(.blue)
                }

                if showNameField {
                    TextField("Enter name", text: $inputName, onCommit: savePlayer)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }

                if !playerName.isEmpty {
                    Text("Hi \(playerName)")
                        .font(.title)
                }

                // MARK: Side Picker Inline HStack
                HStack {
                    let isWest = (currentSide == "West Side")
                    VStack {
                        Image("day-left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .opacity(isWest ? 1.0 : 0.3)
                            .scaleEffect(isWest ? 1.0 : 0.9)
                            .animation(.easeInOut(duration: 0.3), value: isWest)

                        Text("West Side")
                            .fontWeight(isWest ? .bold : .regular)
                    }

                    Spacer()

                    let isEast = (currentSide == "East Side")
                    VStack {
                        Image("day-right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .opacity(isEast ? 1.0 : 0.3)
                            .scaleEffect(isEast ? 1.0 : 0.9)
                            .animation(.easeInOut(duration: 0.3), value: isEast)

                        Text("East Side")
                            .fontWeight(isEast ? .bold : .regular)
                    }
                }
                .padding(.horizontal, 40)

                if let side = currentSide, !playerName.isEmpty {
                    Text("Your Side: \(side)")
                        .font(.headline)
                }

                // MARK: START Button → NavigationLink to GameView
                if let _ = userLocation, !playerName.isEmpty {
                    NavigationLink {
                        GameView(
                            playerName: playerName,
                            isPlayerOnLeft: isPlayerOnLeft
                        )
                    } label: {
                        Text("START")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding()
            .onAppear {
                if let saved = PlayerProfileManager.shared.getPlayerName() {
                    playerName = saved
                }
                requestLocation()
            }
            .alert("Location Access Denied", isPresented: $locationDenied) {
                Button("OK", role: .cancel) { }
            }
        }
    }

    private func savePlayer() {
        let name = inputName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        playerName = name
        PlayerProfileManager.shared.savePlayerName(name)
        PlayerProfileManager.shared.saveScore(0, for: name)
        showNameField = false
    }

    private func requestLocation() {
        locationDelegateWrapper.configure(
            onUpdate: { loc in self.userLocation = loc },
            onDenied: { self.locationDenied = true }
        )
        locationManager.delegate = locationDelegateWrapper
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}





////
////  WelcomeView.swift
////  CardsGame
////
////  Created by Islam Saadi on 18/05/2025.
////
//
//import SwiftUI
//import CoreLocation
//
//struct WelcomeView: View {
//    @State private var playerName:   String    = ""
//    @State private var inputName:    String    = ""
//    @State private var showNameField = false
//
//    @State private var userLocation: CLLocation?
//    @State private var locationDenied = false
//
//    @StateObject private var locationDelegateWrapper = LocationDelegateWrapper()
//    private let locationManager  = CLLocationManager()
//    private let dividerLongitude = 34.817549168324334
//
//    /// “East Side” or “West Side” once we have a location
//    private var currentSide: String? {
//        guard let loc = userLocation else { return nil }
//        return loc.coordinate.longitude > dividerLongitude
//            ? "East Side"
//            : "West Side"
//    }
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//
//            // MARK: Name Input / Greeting
//            if playerName.isEmpty {
//                Button("Insert name") {
//                    showNameField = true
//                }
//                .foregroundColor(.blue)
//            }
//
//            if showNameField {
//                TextField("Enter name", text: $inputName, onCommit: savePlayer)
//                    .textFieldStyle(.roundedBorder)
//                    .padding(.horizontal)
//            }
//
//            if !playerName.isEmpty {
//                Text("Hi \(playerName)")
//                    .font(.title)
//            }
//
//            // MARK: Side Picker Inline HStack
//            HStack {
//                // WEST side
//                let isWest = (currentSide == "West Side")
//                VStack {
//                    Image("day-left")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 120, height: 120)
//                        .opacity(isWest ? 1.0 : 0.3)
//                        .scaleEffect(isWest ? 1.0 : 0.9)
//                        .animation(.easeInOut(duration: 0.3), value: isWest)
//
//                    Text("West Side")
//                        .fontWeight(isWest ? .bold : .regular)
//                        .foregroundColor(.primary)
//                }
//
//                Spacer()
//
//                // EAST side
//                let isEast = (currentSide == "East Side")
//                VStack {
//                    Image("day-right")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 120, height: 120)
//                        .opacity(isEast ? 1.0 : 0.3)
//                        .scaleEffect(isEast ? 1.0 : 0.9)
//                        .animation(.easeInOut(duration: 0.3), value: isEast)
//
//                    Text("East Side")
//                        .fontWeight(isEast ? .bold : .regular)
//                        .foregroundColor(.primary)
//                }
//            }
//            .padding(.horizontal, 40)
//
//            if let side = currentSide, !playerName.isEmpty {
//                Text("Your Side: \(side)")
//                    .font(.headline)
//            }
//
//            if !playerName.isEmpty && userLocation != nil {
//                Button {
//                    let existingScore = PlayerProfileManager
//                        .shared
//                        .getScore(for: playerName)
//                    print("Player score:", existingScore)
//                    
//                } label: {
//                    Text("START")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                        .padding(.horizontal)
//                }
//            }
//
//            Spacer()
//        }
//        .padding()
//        .onAppear {
//            // Load name if saved
//            if let saved = PlayerProfileManager.shared.getPlayerName() {
//                playerName = saved
//            }
//            requestLocation()
//        }
//        .alert("Location Access Denied", isPresented: $locationDenied) {
//            Button("OK", role: .cancel) { }
//        }
//    }
//
//    // MARK: Helpers
//
//    private func savePlayer() {
//        let name = inputName.trimmingCharacters(in: .whitespaces)
//        guard !name.isEmpty else { return }
//        playerName = name
//        PlayerProfileManager.shared.savePlayerName(name)
//        PlayerProfileManager.shared.saveScore(0, for: name)
//        showNameField = false
//    }
//
//    private func requestLocation() {
//        locationDelegateWrapper.configure(
//            onUpdate: { loc in self.userLocation = loc },
//            onDenied: {   self.locationDenied = true }
//        )
//        locationManager.delegate = locationDelegateWrapper
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//    }
//}
