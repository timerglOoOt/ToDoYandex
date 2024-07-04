import UIKit

final class TodoItemTableViewCell: UITableViewCell {
    private lazy var itemTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var categoryIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TodoItemTableViewCell {
    private func setupLayout() {
        contentView.backgroundColor = UIColor(named: "detailColor")
//        contentView.layer.cornerRadius = 16

        contentView.addSubview(itemTextLabel)
        contentView.addSubview(categoryIndicator)

        NSLayoutConstraint.activate([
            itemTextLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            itemTextLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            itemTextLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            categoryIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            categoryIndicator.widthAnchor.constraint(equalToConstant: 20),
            categoryIndicator.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with item: TodoItem) {
        itemTextLabel.text = item.text
        categoryIndicator.backgroundColor = item.category.color
        updateTaskAppearance(isDone: item.isDone)
    }

    func updateTaskAppearance(isDone: Bool) {
        if isDone {
            itemTextLabel.textColor = .gray
            let attributedText = NSAttributedString(
                string: itemTextLabel.text ?? "",
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            itemTextLabel.attributedText = attributedText
        } else {
            itemTextLabel.textColor = .black
            let attributedText = NSAttributedString(string: itemTextLabel.text ?? "")
            itemTextLabel.attributedText = attributedText
        }
    }

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        itemTextLabel.text = nil
        categoryIndicator.backgroundColor = .clear
    }
}
