import SwiftUI

struct CalendarSUIView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ContentViewModel

    func makeUIViewController(context: Context) -> CalendarViewController {
        let viewModel = CalendarViewModel(contentViewModel: viewModel)
        let vc = CalendarViewController(viewModel: viewModel)
        return vc
    }

    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {}
}
