import Foundation
import UIKit
import Combine

final class CalendarViewModel {
    private let infinity = Date.distantFuture
    private let contentViewModel: ContentViewModel
    private var cancellable = Set<AnyCancellable>()
    private var dates = [String]()
    private var itemsByDate = [String: [TodoItem]]()
    
    init(contentViewModel: ContentViewModel) {
        self.contentViewModel = contentViewModel
    }
    
    func showDetailsView() {
        // TODO: реализовать переход на экран редактирования/добавления
    }

    func setupBinding(tableView: UITableView) {
        contentViewModel.$items.sink { [weak self] items in

            self?.updateItemsByDateAndDates(items: items)
            tableView.reloadData()
        }.store(in: &cancellable)
    }
}

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
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemTableViewCell.reuseIdentifier, for: indexPath) as? TodoItemTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        let date = dates[indexPath.section]
        if let item = itemsByDate[date]?[indexPath.row] {
            cell.configure(with: item)
        }
        cell.selectionStyle = .none

        return cell
    }
}

private extension CalendarViewModel {
    func updateItemsByDateAndDates(items: [TodoItem]) {
        //        let sortedItems = self.contentViewModel.items.sorted { first, second in
        //            if let date1 = first.deadline,
        //               let date2 = second.deadline {
        //                return date1 < date2
        //            }
        //            if !(first.deadline != nil || second.deadline != nil) {
        //                return first.createdDate < second.createdDate
        //            }
        //
        //            return first.deadline != nil
        //        }
        let dates = Array(Set(items.map { $0.deadline ?? infinity })).sorted { $0 < $1 }
        self.dates = dates.map { $0 != infinity ? $0.toString(with: "dd MMMM") : "Другое" }

        itemsByDate = items.reduce(into: [String: [TodoItem]]()) { partialResult, item in
            partialResult[item.deadline?.toString(with: "dd MMMM") ?? "Другое", default: []].append(item)
        }
    }
}
