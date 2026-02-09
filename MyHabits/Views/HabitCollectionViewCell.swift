
import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    static let id = "HabitCollectionViewCell"
    
    var onTrackTap: (() -> Void)?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var statusButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(trackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var habit: Habit!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with habit: Habit) {
        self.habit = habit
        
        nameLabel.text = habit.name
        nameLabel.textColor = habit.color
        timeLabel.text = habit.dateString
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        
        
        statusButton.layer.borderColor = habit.color.cgColor 
        statusButton.layer.borderWidth = 2
        statusButton.layer.cornerRadius = 19
        statusButton.clipsToBounds = true
        
        if habit.isAlreadyTakenToday {
            statusButton.backgroundColor = habit.color
            statusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            statusButton.tintColor = .white
        } else {
            statusButton.backgroundColor = .white
            statusButton.setImage(nil, for: .normal)
        }
    }
    
    @objc private func trackButtonTapped() {
        guard !habit.isAlreadyTakenToday else { return }
        HabitsStore.shared.track(habit)
        onTrackTap?()
    }
    
    private func setupLayout() {
        contentView.addSubviews([nameLabel, timeLabel, counterLabel, statusButton])
        contentView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: statusButton.leadingAnchor, constant: -20),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            statusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            statusButton.widthAnchor.constraint(equalToConstant: 38),
            statusButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
}

