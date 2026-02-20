
import UIKit

final class HabitDetailsViewController: UIViewController {
    
    var habit: Habit!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: HabitDetailsHeaderViewCell.id)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DateCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubviews([tableView])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        navigationItem.title = habit?.name
        navigationItem.largeTitleDisplayMode = .never
        
        let accentColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        let backButton = UIButton(type: .system)
        let arrowImage = UIImage(systemName: "chevron.left")?.withTintColor(accentColor, renderingMode: .alwaysOriginal)
        var config = UIButton.Configuration.plain()
        config.title = "Сегодня"
        config.image = arrowImage
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 6, leading: 10, bottom: 6, trailing: 14
        )
        config.baseForegroundColor = accentColor
        backButton.configuration = config
        backButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        backButton.layer.cornerRadius = 18
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let editButton = UIBarButtonItem(
            title: "Править",
            style: .plain,
            target: self,
            action: #selector(editHabit))
        editButton.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        editButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        editButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17)], for: .highlighted)
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editHabit() {
        guard let habit = habit else { return }
        let vc = HabitViewController(mode: .edit(habit: habit))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HabitDetailsHeaderViewCell.id)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)
        let reversedIndex = HabitsStore.shared.dates.count - 1 - indexPath.row
        let date = HabitsStore.shared.dates[reversedIndex]
        
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: reversedIndex)
        
        if let habit = habit, HabitsStore.shared.habit(habit, isTrackedIn: date) {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
}

