import SwiftUI

struct CalendarSUIView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CalendarViewController

    func makeUIViewController(context: Context) -> CalendarViewController {
        let viewModel = CalendarViewModel()
        let vc = CalendarViewController(viewModel: viewModel)
        return vc
    }

    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
//        <#code#>
    }
}
