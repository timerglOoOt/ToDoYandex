import SwiftUI

struct TodoRow: View {
    @Binding var item: TodoItem
    private var priorityText: String {
        switch item.priority {
        case .normal: return ""
        case .high: return "‼️"
        case .low: return "↓"
        }
    }

    var body: some View {
        HStack {
            statusIndicator
            Text(priorityText)
            taskDetails
            Spacer()
            Image(systemName: "chevron.right")
        }
    }

    private var statusIndicator: some View {
        HStack {
            if item.isHighPriority && !item.isDone {
                Circle()
                    .fill(Color.red.opacity(0.2))
                    .frame(width: 18, height: 18)
                    .overlay(
                        Circle()
                            .stroke(Color.red, lineWidth: 1.7)
                    )
            } else {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(item.isDone ? .green : item.priority == .high ? .red : .gray)
            }
        }
        .onTapGesture {
            withAnimation {
                item.isDone.toggle()
            }
        }
    }

    private var taskDetails: some View {
        VStack(alignment: .leading) {
            Text(item.text)
                .strikethrough(item.isDone, color: .gray)
                .foregroundColor(item.isDone ? .gray : Color("textColor"))
                .font(.system(size: 16))


            if let deadline = item.deadline?.toString(with: "dd MMMM") {
                HStack {
                    Image(systemName: "calendar")
                    Text(deadline)
                }
                .foregroundStyle(Color.gray)
                .font(.system(size: 14))
            }
        }
    }
}
