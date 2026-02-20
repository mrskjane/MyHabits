
import UIKit

final class HabitViewController: UIViewController {
    
    enum Mode {
        case create
        case edit(habit: Habit)
    }
    
    private let mode: Mode
    
    private var labelName: UILabel = {
        let label = UILabel()
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private var textFieldName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .secondaryLabel
        return textField
    }()
    
    private var labelColor: UILabel = {
        let label = UILabel()
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private lazy var colorCircleView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTapColorCircle), for: .touchUpInside)
        return button
    }()
    
    private var labelTime: UILabel = {
        let label = UILabel()
        label.text = "ВРЕМЯ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private var timeTextTableView: UILabel = {
        let label = UILabel()
        label.text = "Каждый день в "
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private var timeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "11:00 PM"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        return button
    }()
    
    required init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupLayout()
        dateChanged()
        configureForCurrentMode()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Создать",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveHabit))
        navigationController?.navigationBar.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
    }
    
    private func setupLayout() {
        view.addSubviews([labelName,
                          textFieldName,
                          labelColor,
                          colorCircleView,
                          labelTime,
                          timeTextTableView,
                          timeValueLabel,
                          datePicker,
                          deleteButton])
        
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            labelName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 7),
            textFieldName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            labelColor.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 15),
            labelColor.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            colorCircleView.topAnchor.constraint(equalTo: labelColor.bottomAnchor, constant: 7),
            colorCircleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorCircleView.widthAnchor.constraint(equalToConstant: 30),
            colorCircleView.heightAnchor.constraint(equalToConstant: 30),
            
            labelTime.topAnchor.constraint(equalTo: colorCircleView.bottomAnchor, constant: 15),
            labelTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            timeTextTableView.topAnchor.constraint(equalTo: labelTime.bottomAnchor, constant: 7),
            timeTextTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            timeValueLabel.centerYAnchor.constraint(equalTo: timeTextTableView.centerYAnchor),
            timeValueLabel.leadingAnchor.constraint(equalTo: timeTextTableView.trailingAnchor),
            
            datePicker.topAnchor.constraint(equalTo: timeTextTableView.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureForCurrentMode() {
        switch mode {
        case .edit(let habit):
            textFieldName.textColor = habit.color
            textFieldName.text = habit.name
            colorCircleView.backgroundColor = habit.color
            datePicker.date = habit.date
            dateChanged()
            
            deleteButton.isHidden = false
            navigationItem.title = "Править"
            navigationItem.rightBarButtonItem?.title = "Сохранить"
        case .create:
            textFieldName.text = nil
            textFieldName.textColor = .systemBlue
            colorCircleView.backgroundColor = .orange
            datePicker.date = Date()
            dateChanged()
            
            deleteButton.isHidden = true
            navigationItem.title = "Создать"
            navigationItem.rightBarButtonItem?.title = "Создать"
        }
    }

    
    @objc private func dismissVC() {
        if let nav = navigationController, nav.viewControllers.first != self {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func dateChanged() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeStyle = .short
        let timeString = formatter.string(from: datePicker.date)
        timeValueLabel.text = timeString
    }
    
    @objc private func didTapColorCircle() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = colorCircleView.backgroundColor ?? .orange
        present(colorPicker, animated: true)
    }
    
    @objc private func saveHabit() {
        guard let name = textFieldName.text, !name.isEmpty else {
            return
        }
        let color = colorCircleView.backgroundColor ?? .orange
        let date = datePicker.date
        switch mode {
        case .edit(let habit):
            habit.name = name
            habit.date = date
            habit.color = color
        case .create:
            let newHabit = Habit(
                name: name,
                date: datePicker.date,
                color: colorCircleView.backgroundColor ?? .orange
            )
            HabitsStore.shared.habits.append(newHabit)
        }
        dismissVC()
    }
    
    
    @objc func didTapDelete() {
        guard case .edit(let habitToDelete) = mode else { return }
        let message = "Вы хотите удалить привычку\n\"\(habitToDelete.name)\"?"
        let avc = UIAlertController(
            title: "Удалить привычку",
            message: message,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            if let index = HabitsStore.shared.habits.firstIndex(of: habitToDelete) {
                HabitsStore.shared.habits.remove(at: index)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        avc.addAction(cancelAction)
        avc.addAction(deleteAction)
        present(avc, animated: true)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorCircleView.backgroundColor = viewController.selectedColor
    }
}
