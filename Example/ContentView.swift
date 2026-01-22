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
    @State private var languageCode: Locale.LanguageCode?
    @State private var translatedForm: Typeform.Form?
    @State private var presentedForm: Typeform.Form?
    @State private var conclusion: Conclusion?
    @FocusState private var focus: Bool

    private var settings: TypeformUI.Settings {
        TypeformUI.Settings(
            presentation: TypeformUI.Settings.Presentation(
                skipWelcomeScreen: skipWelcome,
                skipEndingScreen: skipEnding,
            ),
        )
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField(
                            "Form ID",
                            text: $formId,
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

                    Button {
                        downloadSync()
                    } label: {
                        Text("Download")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(alignment: .trailing) {
                                if downloading {
                                    ProgressView()
                                        .controlSize(.regular)
                                }
                            }
                    }
                    .disabled(formId.isEmpty)
                } header: {
                    Text("Retrive")
                } footer: {
                    Text("Preview any form by entering its unique ID.")
                }

                Section("Settings") {
                    Toggle("Skip Welcome", isOn: $skipWelcome)

                    Toggle("Skip Ending", isOn: $skipEnding)

                    HStack {
                        Picker(selection: $languageCode) {
                            Text("Default \(form?.settings.language ?? "N/A")")
                                .tag(Locale.LanguageCode?.none)

                            if let languageCodes = form?.settings.translationLanguageCodes {
                                ForEach(languageCodes, id: \.self) { code in
                                    Text(code.identifier)
                                        .tag(Locale.LanguageCode?.some(code))
                                }
                            }
                        } label: {
                            Text("Language")
                        }
                        .onChange(of: languageCode) { _, _ in
                            translateSync()
                        }
                    }

                    Button {
                        presentedForm = translatedForm ?? form
                    } label: {
                        Text("Present")
                    }
                }
                .disabled(form == nil)

                if let downloadFailure {
                    Section {
                        Text(downloadFailure)
                            .bold()
                            .foregroundStyle(Color.red)
                    }
                }

                Section("Conclusion") {
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
            }
            .disabled(downloading)
            .navigationTitle("Typeform")
        }
        .sheet(item: $presentedForm) { typeformForm in
            FormView(
                form: typeformForm,
                settings: settings,
            ) { typeformConclusion in
                conclusion = typeformConclusion
                presentedForm = nil
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

        downloading = true
        defer {
            downloading = false
        }

        do {
            form = try await Typeform.Form.download(formId)

            if !recent.contains(formId) {
                recent.insert(formId, at: 0)
            }
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
        } catch {
            downloadFailure = "Decoding Failed\n\(error.localizedDescription)"
        }
    }

    func translateSync() {
        downloadFailure = nil

        Task {
            await translate()
        }
    }

    @MainActor func translate() async {
        guard let form else {
            translatedForm = nil
            return
        }

        guard let languageCode else {
            translatedForm = nil
            return
        }

        downloading = true
        defer {
            downloading = false
        }

        do {
            translatedForm = try await form.translatedTo(languageCode)
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
        } catch {
            downloadFailure = "Decoding Failed\n\(error.localizedDescription)"
        }
    }
}

#Preview {
    ContentView()
}
