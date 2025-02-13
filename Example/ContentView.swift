import SwiftUI
import Typeform
import TypeformUI

struct ContentView: View {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    @AppStorage("recent-forms") private var recentForms: Data?

    @State private var formId: String = ""
    @State private var recent: [String] = []
    @State private var skipWelcome: Bool = false
    @State private var skipEnding: Bool = false
    @State private var downloading: Bool = false
    @State private var downloadFailure: String?
    @State private var form: Typeform.Form?
    @State private var conclusion: Conclusion?
    @FocusState private var focus: Bool

    private var settings: TypeformUI.Settings {
        TypeformUI.Settings(
            presentation: TypeformUI.Settings.Presentation(
                skipWelcomeScreen: skipWelcome,
                skipEndingScreen: skipEnding
            )
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Preview any form by entering its unique ID.")
                        .font(.headline)

                    HStack {
                        TextField(
                            "Form ID",
                            text: $formId
                        )
                        .autocorrectionDisabled(true)
                        #if canImport(UIKit)
                        .textInputAutocapitalization(.none)
                        #endif
                        .focused($focus)

                        Menu("Recent") {
                            ForEach(recent, id: \.self) { item in
                                Button(item) {
                                    formId = item
                                    downloadSync()
                                }
                            }

                            Button("Clear", role: .destructive) {
                                recent.removeAll()
                            }
                        }
                    }

                    HStack {
                        Toggle("Skip Welcome", isOn: $skipWelcome)
                        Toggle("Skip Ending", isOn: $skipEnding)
                    }

                    HStack {
                        Button("Download") {
                            downloadSync()
                        }
                        .disabled(formId.isEmpty)

                        if downloading {
                            ProgressView()
                                .controlSize(.regular)
                        }
                    }

                    if let downloadFailure {
                        Text(downloadFailure)
                            .bold()
                            .foregroundStyle(Color.red)
                    }

                    Text("Last form conclusion")
                        .font(.headline)

                    if let conclusion {
                        switch conclusion {
                        case .completed(let responses, _):
                            Text("Completed")

                            ResponsesView(responses: responses)
                        case .abandoned(let responses):
                            Text("Abandoned")

                            ResponsesView(responses: responses)
                        case .rejected(let responses):
                            Text("Rejected")

                            ResponsesView(responses: responses)
                        case .canceled:
                            Text("Canceled")
                        }
                    }
                }
                .padding()
                .disabled(downloading)
            }
            .navigationTitle("Typeform")
        }
        .sheet(item: $form) { typeformForm in
            FormView(
                form: typeformForm,
                settings: settings
            ) { typeformConclusion in
                conclusion = typeformConclusion
                form = nil
            }
        }
        .onAppear {
            loadRecents()
        }
        .onChange(of: recent) { _, newValue in
            saveRecents(newValue)
        }
    }

    func loadRecents() {
        guard let recentForms else {
            return
        }

        do {
            recent = try decoder.decode([String].self, from: recentForms)
        } catch {}
    }

    func saveRecents(_ recents: [String]) {
        do {
            recentForms = try encoder.encode(recents)
        } catch {}
    }

    func downloadSync() {
        focus = false
        downloadFailure = nil
        conclusion = nil

        Task {
            await download()
        }
    }

    @MainActor func download() async {
        guard !formId.isEmpty else {
            return
        }

        guard let url = URL(string: "https://api.typeform.com/forms/\(formId)") else {
            downloadFailure = "Invalid URL"
            return
        }

        downloading = true
        defer {
            downloading = false
        }

        let data: Data
        do {
            let request = URLRequest(url: url)
            let response = try await URLSession.shared.data(for: request)
            data = response.0
        } catch {
            downloadFailure = "Download Failed"
            return
        }

        do {
            form = try decoder.decode(Typeform.Form.self, from: data)
        } catch let decodingError as DecodingError {
            switch decodingError {
            case .typeMismatch(_, let context),
                 .valueNotFound(_, let context),
                 .keyNotFound(_, let context),
                 .dataCorrupted(let context):
                downloadFailure = "Decoding Failed\n\(context)"
            default:
                downloadFailure = "Decoding Failed\n\(decodingError.localizedDescription)"
            }
            return
        } catch {
            downloadFailure = "Decoding Failed\n\(error.localizedDescription)"
            return
        }

        if !recent.contains(formId) {
            recent.insert(formId, at: 0)
        }
    }
}

#Preview {
    ContentView()
}
