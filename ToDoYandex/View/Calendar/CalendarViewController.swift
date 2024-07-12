import UIKit

final class CalendarViewController: UIViewController {
    private let calendarView = CalendarView(frame: .zero)
    private let viewModel: CalendarViewModel

    override func loadView() {
        self.view = calendarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.todoItemsTableView.delegate = self
        calendarView.todoItemsTableView.dataSource = self
        calendarView.dateCollection.delegate = self
        calendarView.dateCollection.dataSource = self

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

extension CalendarViewController {
    func setupBinding() {
        viewModel.setupBinding(
            tableView: calendarView.todoItemsTableView,
            collectionView: calendarView.dateCollection
        )
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

// MARK: Отметка о выполненном/невыполненном задании по соответствуещему свайпу

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        viewModel.tableView(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        viewModel.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }

// MARK: Переход к нужной секции таблицы

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectDate(for: indexPath.section, collectionView: calendarView.dateCollection)
    }

// MARK: Работа со скроллом таблицы

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        findCollectionCell(scrollView: scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        findCollectionCell(scrollView: scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        findCollectionCell(scrollView: scrollView)
    }

    private func findCollectionCell(scrollView: UIScrollView) {
        if scrollView == calendarView.todoItemsTableView {
            if let indexPaths = calendarView.todoItemsTableView.indexPathsForVisibleRows {
                let sortedIndexPaths = indexPaths.sorted()
                if let firstVisibleIndexPath = sortedIndexPaths.first {
                    viewModel.selectDate(
                        for: firstVisibleIndexPath.section,
                        collectionView: calendarView.dateCollection
                    )
                }
            }
        }
    }
}

// MARK: Функции для работы с коллекцией

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.collectionView(collectionView, numberOfItemsInSection: section)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        viewModel.collectionView(collectionView, cellForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.collectionView(collectionView, didSelectItemAt: indexPath, tableView: calendarView.todoItemsTableView)
    }
}
