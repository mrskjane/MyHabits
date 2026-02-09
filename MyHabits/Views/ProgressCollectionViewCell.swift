
import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    static let id = "ProgressCollectionViewCell"
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Все получится!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        progress.trackTintColor = .systemGray5
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
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
    
    private func setupLayout() {
        contentView.layer.cornerRadius = 8
        contentView.addSubviews([textLabel, percentLabel, progressView])
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            percentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            progressView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressView.heightAnchor.constraint(equalToConstant: 7),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    func updatePercent() {
        let progress = HabitsStore.shared.todayProgress
        progressView.setProgress(progress, animated: true)
        percentLabel.text = "\(Int(progress * 100))%"
    }
}
