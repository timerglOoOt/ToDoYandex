import UIKit

protocol CalendarViewProtocol: AnyObject {
    func showTaskDetailsView()
}

final class CalendarView: UIView {
    weak var delegate: CalendarViewProtocol?

    lazy var dateCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: setDateCollectionLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    lazy var todoItemsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.register(TodoItemTableViewCell.self, forCellReuseIdentifier: TodoItemTableViewCell.reuseIdentifier)
        table.rowHeight = 50
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private lazy var addItemButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.layer.cornerRadius = 30
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3

        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.showTaskDetailsView()
        }, for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
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
            dateCollection.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            dateCollection.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            dateCollection.heightAnchor.constraint(equalToConstant: 70),

            todoItemsTableView.topAnchor.constraint(equalTo: dateCollection.bottomAnchor),
            todoItemsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            todoItemsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            todoItemsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setDateCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 20
        return layout
    }
}

extension CalendarView {
//    func setupTodoItemsTableView(vc: UIViewController) {
//        todoItemsTableView.dataSource = vc
//        todoItemsTableView.delegate = vc
//    }
}
