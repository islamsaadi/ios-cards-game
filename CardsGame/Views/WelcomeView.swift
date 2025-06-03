import SwiftUI
import CoreLocation

struct WelcomeView: View {

    var onStart: (_ playerName: String, _ isPlayerOnLeft: Bool) -> Void
    @Environment(\.colorScheme) var colorScheme

    @State private var playerName:   String     = ""
    @State private var inputName:    String     = ""
    @State private var showNameField = false

    @State private var userLocation: CLLocation?
    @State private var locationDenied = false

    @StateObject private var locationDelegateWrapper = LocationDelegateWrapper()
    private let locationManager  = CLLocationManager()
    private let dividerLongitude = 34.817549168324334

    /// "East Side" or "West Side" once we have a location
    private var currentSide: String? {
        guard let loc = userLocation else { return nil }
        return loc.coordinate.longitude > dividerLongitude
             ? "East Side"
             : "West Side"
    }

    private var isPlayerOnLeft: Bool {
        // We'll put the player on the left when they're on the West side
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
                        .foregroundStyle(.primary)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                        )
                }

                if !playerName.isEmpty {
                    Text("Hi \(playerName)")
                        .font(.title)
                        .foregroundColor(.primary)
                }

                
                HStack {
                    let isWest = (currentSide == "West Side")
                    VStack {
                        Image(colorScheme == .dark ? "night-left" : "day-left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .opacity(isWest ? 1.0 : 0.3)
                            .scaleEffect(isWest ? 1.0 : 0.9)
                            .animation(.easeInOut(duration: 0.3), value: isWest)

                        Text("West Side")
                            .fontWeight(isWest ? .bold : .regular)
                            .foregroundColor(.primary)
                    }

                    Spacer()

                    let isEast = (currentSide == "East Side")
                    VStack {
                        Image(colorScheme == .dark ? "night-right" : "day-right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .opacity(isEast ? 1.0 : 0.3)
                            .scaleEffect(isEast ? 1.0 : 0.9)
                            .animation(.easeInOut(duration: 0.3), value: isEast)

                        Text("East Side")
                            .fontWeight(isEast ? .bold : .regular)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 40)

                if let side = currentSide, !playerName.isEmpty {
                    Text("Your Side: \(side)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }

                if let _ = userLocation, !playerName.isEmpty {
                    Button("START") {
                        onStart(playerName, isPlayerOnLeft)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .onAppear {
                loadSavedPlayerName()
                requestLocation()
            }
            .alert("Location Access Denied", isPresented: $locationDenied) {
                Button("OK", role: .cancel) { }
            }
        }
    }

    private func loadSavedPlayerName() {
        if let savedName = PlayerProfileManager.shared.getPlayerName(), !savedName.isEmpty {
            playerName = savedName
            inputName = savedName
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
            onUpdate: { loc in
                self.userLocation = loc
                // Stop location updates after getting the first location
                self.locationManager.stopUpdatingLocation()
            },
            onDenied: { self.locationDenied = true }
        )
        locationManager.delegate = locationDelegateWrapper
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}
