import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selfieImage: UIImage?
    @State private var selectedCardType: CardType = .christmas
    @State private var isGenerating = false
    @State private var generatedImage: UIImage?
    @State private var errorMessage: String?
    @State private var showErrorAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let selfie = selfieImage {
                        Image(uiImage: selfie)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images
                        ) {
                            Label("Change photo", systemImage: "photo.on.rectangle.angled")
                        }
                        .onChange(of: selectedItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let img = UIImage(data: data) {
                                    selfieImage = img
                                }
                            }
                        }
                    } else {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images
                        ) {
                            VStack(spacing: 12) {
                                Image(systemName: "person.crop.rectangle.badge.plus")
                                    .font(.system(size: 48))
                                Text("Choose a selfie")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .background(Color(.secondarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .onChange(of: selectedItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let img = UIImage(data: data) {
                                    selfieImage = img
                                }
                            }
                        }
                    }

                    if selfieImage != nil {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Card type")
                                .font(.headline)
                            HStack(spacing: 12) {
                                ForEach(CardType.allCases) { type in
                                    Button {
                                        selectedCardType = type
                                    } label: {
                                        Text(type.displayName)
                                            .font(.subheadline)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(selectedCardType == type ? Color.accentColor : Color(.secondarySystemFill))
                                            .foregroundColor(selectedCardType == type ? .white : .primary)
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        if isGenerating {
                            VStack(spacing: 12) {
                                ProgressView()
                                    .scaleEffect(1.2)
                                Text("Generating your card…")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("This may take 10–30 seconds")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                        } else if let generated = generatedImage {
                            Image(uiImage: generated)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 320)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            HStack(spacing: 16) {
                                Button {
                                    saveToPhotos(generated)
                                } label: {
                                    Label("Save to Photos", systemImage: "square.and.arrow.down")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)

                                Button {
                                    generatedImage = nil
                                } label: {
                                    Label("Try another", systemImage: "arrow.clockwise")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                        } else {
                            Button {
                                generateCard()
                            } label: {
                                Label("Create my card", systemImage: "wand.and.stars")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(isGenerating)
                        }

                        if let err = errorMessage {
                            Text(err)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Selfie Cards")
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {
                    errorMessage = nil
                    showErrorAlert = false
                }
            } message: {
                if let err = errorMessage {
                    Text(err)
                }
            }
        }
    }

    private func generateCard() {
        guard let image = selfieImage else { return }
        errorMessage = nil
        isGenerating = true

        Task {
            do {
                let result = try await ApiClient.generateCard(image: image, cardType: selectedCardType)
                await MainActor.run {
                    generatedImage = result
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = (error as? ApiClientError).map { err in
                        switch err {
                        case .invalidURL: return "Invalid server URL"
                        case .noData: return "Could not prepare image"
                        case .serverError(let msg): return msg
                        }
                    } ?? error.localizedDescription
                    showErrorAlert = true
                    isGenerating = false
                }
            }
        }
    }

    private func saveToPhotos(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

#Preview {
    ContentView()
}
