import UIKit

final class CalendarViewController: UIViewController, CalendarViewProtocol {
    private let calendarView = CalendarView(frame: .zero)
    private let viewModel: CalendarViewModel

    override func loadView() {
        self.view = calendarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
    }

    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarViewController {
    func showTaskDetailsView() {
        viewModel.showDetailsView()
    }
}
