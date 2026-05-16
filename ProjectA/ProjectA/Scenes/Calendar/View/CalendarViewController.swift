import UIKit

final class CalendarViewController: UIViewController {
  
  private let viewModel: CalendarViewModel
  
  private let monthLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let yearLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .secondaryLabel
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var prevButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    button.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private lazy var nextButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let weekdayStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.translatesAutoresizingMaskIntoConstraints = false
    ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"].enumerated().forEach { index, title in
      let label = UILabel()
      label.text = title
      label.textAlignment = .center
      label.font = .systemFont(ofSize: 12, weight: .semibold)
      label.textColor = (index == 0) ? .systemRed : (index == 6 ? .systemBlue : .secondaryLabel)
      stack.addArrangedSubview(label)
    }
    return stack
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 4
    layout.minimumInteritemSpacing = 0
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .clear
    cv.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.reuseIdentifier)
    cv.dataSource = self
    cv.delegate = self
    cv.translatesAutoresizingMaskIntoConstraints = false
    return cv
  }()
  
  private let selectedDateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = .secondaryLabel
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var memoTextField: UITextField = {
    let field = UITextField()
    field.placeholder = "Add a memo for this day"
    field.borderStyle = .roundedRect
    field.delegate = self
    field.returnKeyType = .done
    field.translatesAutoresizingMaskIntoConstraints = false
    return field
  }()
  
  init(viewModel: CalendarViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationItem.title = "Calendar"
    setupViews()
    bindViewModel()
    render()
  }
  
  private func bindViewModel() {
    viewModel.onUpdate = { [weak self] in
      self?.render()
    }
  }
  
  private func render() {
    monthLabel.text = viewModel.monthTitle
    yearLabel.text = viewModel.yearTitle
    collectionView.reloadData()
    updateMemoSection()
  }
  
  private func updateMemoSection() {
    if let date = viewModel.selectedDate {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US")
      formatter.dateFormat = "EEEE, MMM d"
      selectedDateLabel.text = formatter.string(from: date)
      memoTextField.isEnabled = true
      memoTextField.text = viewModel.currentMemo
    } else {
      selectedDateLabel.text = "Select a date"
      memoTextField.isEnabled = false
      memoTextField.text = ""
    }
  }
  
  private func setupViews() {
    let header = UIView()
    header.translatesAutoresizingMaskIntoConstraints = false
    header.addSubview(yearLabel)
    header.addSubview(monthLabel)
    header.addSubview(prevButton)
    header.addSubview(nextButton)
    
    view.addSubview(header)
    view.addSubview(weekdayStack)
    view.addSubview(collectionView)
    view.addSubview(selectedDateLabel)
    view.addSubview(memoTextField)
    
    let safe = view.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      header.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
      header.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
      header.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20),
      header.heightAnchor.constraint(equalToConstant: 56),
      
      yearLabel.topAnchor.constraint(equalTo: header.topAnchor),
      yearLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor),
      monthLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 2),
      monthLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor),
      
      nextButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
      nextButton.trailingAnchor.constraint(equalTo: header.trailingAnchor),
      nextButton.widthAnchor.constraint(equalToConstant: 44),
      nextButton.heightAnchor.constraint(equalToConstant: 44),
      
      prevButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
      prevButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -8),
      prevButton.widthAnchor.constraint(equalToConstant: 44),
      prevButton.heightAnchor.constraint(equalToConstant: 44),
      
      weekdayStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
      weekdayStack.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
      weekdayStack.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
      weekdayStack.heightAnchor.constraint(equalToConstant: 24),
      
      collectionView.topAnchor.constraint(equalTo: weekdayStack.bottomAnchor, constant: 4),
      collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
      collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
      collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 6.0 / 7.0),
      
      selectedDateLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 24),
      selectedDateLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
      selectedDateLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20),
      
      memoTextField.topAnchor.constraint(equalTo: selectedDateLabel.bottomAnchor, constant: 8),
      memoTextField.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
      memoTextField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20),
      memoTextField.heightAnchor.constraint(equalToConstant: 44)
    ])
  }
  
  @objc private func didTapPrev() {
    viewModel.goToPreviousMonth()
  }
  
  @objc private func didTapNext() {
    viewModel.goToNextMonth()
  }
}

extension CalendarViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.days.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CalendarDayCell.reuseIdentifier,
      for: indexPath
    ) as! CalendarDayCell
    let day = viewModel.days[indexPath.item]
    cell.configure(
      day: day,
      isSelected: viewModel.isSelected(day),
      hasMemo: viewModel.hasMemo(for: day)
    )
    return cell
  }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.bounds.width / 7
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let day = viewModel.days[indexPath.item]
    guard day.isInCurrentMonth else { return }
    memoTextField.resignFirstResponder()
    viewModel.select(day: day)
  }
}

extension CalendarViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    viewModel.updateMemo(textField.text ?? "")
    collectionView.reloadData()
  }
}
