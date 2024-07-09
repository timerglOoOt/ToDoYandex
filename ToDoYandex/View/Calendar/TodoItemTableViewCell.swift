import UIKit

final class TodoItemTableViewCell: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    private lazy var itemTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var categoryIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 9
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 3
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

        contentView.addSubview(itemTextLabel)
        contentView.addSubview(categoryIndicator)

        NSLayoutConstraint.activate([
            itemTextLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            itemTextLabel.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,
                constant: 16),
            itemTextLabel.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                constant: -24),

            categoryIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryIndicator.widthAnchor.constraint(equalToConstant: 18),
            categoryIndicator.heightAnchor.constraint(equalToConstant: 18)
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
            itemTextLabel.textColor = UIColor(named: "textColor")
            let attributedText = NSAttributedString(
                string: itemTextLabel.text ?? "",
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single])
            itemTextLabel.attributedText = attributedText
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        itemTextLabel.text = nil
        categoryIndicator.backgroundColor = .clear
    }
}
