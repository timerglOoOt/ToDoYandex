import Foundation
import UIKit
import Combine

@MainActor
final class CalendarViewModel {
    private let infinity = Date.distantFuture
    private let contentViewModel: ContentViewModel
    private var cancellable = Set<AnyCancellable>()
    private var dates = [String]()
    private var itemsByDate = [String: [TodoItem]]()

    init(contentViewModel: ContentViewModel) {
        self.contentViewModel = contentViewModel
    }

    func setupBinding(tableView: UITableView, collectionView: UICollectionView) {
        contentViewModel.$items.sink { [weak self] items in

            self?.updateItemsByDateAndDates(items: items)
            tableView.reloadData()
            collectionView.reloadData()
        }.store(in: &cancellable)
    }
}

// MARK: Реализация функций для таблиц

extension CalendarViewModel {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = dates[section]
        return itemsByDate[date]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = dates[section]
        return date
    }

    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoItemTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? TodoItemTableViewCell
        guard let cell else { return UITableViewCell() }
        let date = dates[indexPath.section]
        if let item = itemsByDate[date]?[indexPath.row] {
            cell.configure(with: item)
        }
        cell.selectionStyle = .none

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let doneItemAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in

            if let date = self?.dates[indexPath.section],
               let item = self?.itemsByDate[date]?[indexPath.row] {
                if !item.isDone {
                    self?.contentViewModel.updateItemStatus(id: item.id)
                }
            }
            completion(true)
        }
        doneItemAction.backgroundColor = .systemGreen
        doneItemAction.image = UIImage(systemName: "checkmark.circle")

        let config = UISwipeActionsConfiguration(actions: [doneItemAction])
        return config
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let cancelDoneItemAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in

            if let date = self?.dates[indexPath.section],
               let item = self?.itemsByDate[date]?[indexPath.row] {
                if item.isDone {
                    self?.contentViewModel.updateItemStatus(id: item.id)
                }
            }
            completion(true)
        }
        cancelDoneItemAction.backgroundColor = .systemGray3
        cancelDoneItemAction.image = UIImage(systemName: "xmark.circle")

        let config = UISwipeActionsConfiguration(actions: [cancelDoneItemAction])
        return config
    }
}

// MARK: Реализация функций для коллекций

extension CalendarViewModel {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dates.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemDateCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ItemDateCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        cell.configure(with: dates[indexPath.row])

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath, tableView: UITableView
    ) {
        scrollToSection(for: dates[indexPath.row], tableView: tableView)
    }

    func selectDate(for section: Int, collectionView: UICollectionView) {
        let indexPath = IndexPath(item: section, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: Вспомогательные функции

private extension CalendarViewModel {
    func updateItemsByDateAndDates(items: [TodoItem]) {
        self.dates = []
        let dates = items.map { $0.deadline ?? infinity }.sorted { $0 < $1 }
        let stringDates = dates.map { $0 != infinity
            ? $0.toString(with: Constant.DateFormate.dayWithFullMonth.rawValue)
            : "Другое"
        }

        for date in stringDates where !self.dates.contains(date) {
            self.dates.append(date)
        }

        itemsByDate = items.reduce(into: [String: [TodoItem]]()) { partialResult, item in
            partialResult[item.deadline?.toString(
                with: Constant.DateFormate.dayWithFullMonth.rawValue
            ) ?? "Другое", default: []].append(item)
        }
    }

    func scrollToSection(for date: String, tableView: UITableView) {
        if let section = dates.firstIndex(of: date) {
            let indexPath = IndexPath(row: 0, section: section)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
