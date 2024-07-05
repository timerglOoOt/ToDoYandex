import UIKit

final class CalendarViewController: UIViewController {
    private let calendarView = CalendarView(frame: .zero)
    private let viewModel: CalendarViewModel

    override func loadView() {
        self.view = calendarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
        calendarView.todoItemsTableView.delegate = self
        calendarView.todoItemsTableView.dataSource = self
        setupBinding()
    }

    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarViewController: CalendarViewProtocol {
    func showTaskDetailsView() {
        viewModel.showDetailsView()
    }

    func setupBinding() {
        viewModel.setupBinding(tableView: calendarView.todoItemsTableView)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableView(tableView, numberOfRowsInSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.configureCell(tableView, cellForRowAt: indexPath)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections(in: tableView)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.tableView(tableView, titleForHeaderInSection: section)
    }
}
