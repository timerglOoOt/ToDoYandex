import UIKit

protocol CalendarViewProtocol: AnyObject {
    func showTaskDetailsView()
}

final class CalendarView: UIView {
    weak var delegate: CalendarViewProtocol?

    private lazy var dateCollection: UICollectionView = {
        let collection = UICollectionView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    private lazy var todoItemsTableView: UITableView = {
        let table = UITableView()
//        table.style = .insetGrouped
//        table.register(nil, forCellReuseIdentifier: <#T##String#>)
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
        
//        addSubview(dateCollection)
        addSubview(todoItemsTableView)
        addSubview(addItemButton)

//        setDateCollectionLayout()

        NSLayoutConstraint.activate([
//            dateCollection.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            dateCollection.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
//            dateCollection.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

//            todoItemsTableView.topAnchor.constraint(equalTo: dateCollection.bottomAnchor),
            todoItemsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            todoItemsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            todoItemsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            todoItemsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            addItemButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            addItemButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            addItemButton.heightAnchor.constraint(equalToConstant: 60),
            addItemButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    func setDateCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 20
        dateCollection.setCollectionViewLayout(layout, animated: true)
    }
}
