import UIKit

final class CalendarView: UIView {
    lazy var dateCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: setDateCollectionLayout())
        collection.register(
            ItemDateCollectionViewCell.self,
            forCellWithReuseIdentifier: ItemDateCollectionViewCell.reuseIdentifier
        )
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    lazy var todoItemsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.register(
            TodoItemTableViewCell.self,
            forCellReuseIdentifier: TodoItemTableViewCell.reuseIdentifier
        )
        table.rowHeight = 50
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CalendarView {
    func setupLayout() {
        backgroundColor = UIColor(named: "backgroundColor")

        addSubview(dateCollection)
        addSubview(todoItemsTableView)

        NSLayoutConstraint.activate([
            dateCollection.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dateCollection.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            dateCollection.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            dateCollection.heightAnchor.constraint(equalToConstant: 70),

            todoItemsTableView.topAnchor.constraint(equalTo: dateCollection.bottomAnchor),
            todoItemsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            todoItemsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            todoItemsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setDateCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 66, height: 60)
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        return layout
    }
}
