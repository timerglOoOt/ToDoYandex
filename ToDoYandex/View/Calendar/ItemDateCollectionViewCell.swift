import UIKit

final class ItemDateCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16.5, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemDateCollectionViewCell {
    private func setupLayout() {
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -4)
        ])

        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = UIColor(named: "selectedCollectionViewCell")
                contentView.layer.borderColor = UIColor.gray.cgColor
            } else {
                contentView.backgroundColor = .clear
                contentView.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }

    func configure(with date: String) {
        dateLabel.text = date
    }

    override func prepareForReuse() {
        dateLabel.text = nil
    }
}
