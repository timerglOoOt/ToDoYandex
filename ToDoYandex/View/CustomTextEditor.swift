import SwiftUI

struct CustomTextEditor: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("detailColor")
                .cornerRadius(16)
            TextEditor(text: $text)
                .padding(8)
                .background(Color.clear)
                .frame(minHeight: 120, maxHeight: .infinity, alignment: .leading)

            if text.isEmpty {
                Text(placeholder)
                    .foregroundStyle(Color("placeholderLight"))
                    .padding(.leading, 16)
                    .padding(.top, 16)
            }
        }
    }
}
