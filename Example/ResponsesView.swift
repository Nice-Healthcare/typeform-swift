import SwiftUI
import Typeform
import TypeformUI

struct ResponsesView: View {

    var responses: Responses

    var body: some View {
        Grid(alignment: .leading) {
            ForEach(Array(responses.keys), id: \.self) { key in
                GridRow(alignment: .top) {
                    ReferenceView(reference: key)
                    ResponseValueView(value: responses[key])
                }
            }
        }
    }
}

struct ReferenceView: View {
    var reference: Reference
    var body: some View {
        switch reference {
        case .string(let string):
            Text(string)
        case .uuid(let uuid):
            Text(uuid.uuidString)
        }
    }
}

struct ResponseValueView: View {
    var value: ResponseValue?
    var body: some View {
        if let value {
            switch value {
            case .bool(let bool):
                Text("\(bool)")
            case .choice(let choice):
                ChoiceView(choice: choice)
            case .choices(let array):
                ForEach(array) { choice in
                    ChoiceView(choice: choice)
                }
            case .date(let date):
                Text(date, style: .date)
            case .int(let int):
                Text(int.formatted())
            case .string(let string):
                Text(string)
            }
        } else {
            EmptyView()
        }
    }
}

struct ChoiceView: View {
    let choice: Choice
    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                Text("ID")
                Text(choice.id)
            }
            GridRow {
                Text("Ref")
                Text(choice.ref.rawValue)
            }
            GridRow {
                Text("Label")
                Text(choice.label)
            }
        }
    }
}

#Preview {
    ResponsesView(
        responses: [
            .string("example-field"): .string("String Value"),
        ]
    )
}
