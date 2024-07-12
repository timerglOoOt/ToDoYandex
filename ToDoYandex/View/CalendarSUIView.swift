import SwiftUI

struct CalendarSUIView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ContentViewModel

    func makeUIViewController(context: Context) -> CalendarViewController {
        let viewModel = CalendarViewModel(contentViewModel: viewModel)
        let viewController = CalendarViewController(viewModel: viewModel)
        return viewController
    }

    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {}
}
