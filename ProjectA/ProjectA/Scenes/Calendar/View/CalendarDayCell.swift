import UIKit

final class CalendarDayCell: UICollectionViewCell {
  static let reuseIdentifier = "CalendarDayCell"
  
  private let dayLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let memoDot: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBlue
    view.layer.cornerRadius = 2
    view.isHidden = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let size = min(bounds.width, bounds.height) - 8
    contentView.layer.cornerRadius = size / 2
  }
  
  private func setupViews() {
    contentView.addSubview(dayLabel)
    contentView.addSubview(memoDot)
    
    NSLayoutConstraint.activate([
      dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      memoDot.widthAnchor.constraint(equalToConstant: 4),
      memoDot.heightAnchor.constraint(equalToConstant: 4),
      memoDot.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      memoDot.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
    ])
  }
  
  func configure(day: CalendarDay, isSelected: Bool, hasMemo: Bool) {
    dayLabel.text = "\(day.dayNumber)"
    memoDot.isHidden = !hasMemo
    
    if !day.isInCurrentMonth {
      dayLabel.textColor = .tertiaryLabel
      contentView.backgroundColor = .clear
    } else if isSelected {
      dayLabel.textColor = .white
      contentView.backgroundColor = .systemBlue
      memoDot.backgroundColor = .white
    } else if day.isToday {
      dayLabel.textColor = .systemBlue
      contentView.backgroundColor = .systemBlue.withAlphaComponent(0.12)
      memoDot.backgroundColor = .systemBlue
    } else {
      dayLabel.textColor = .label
      contentView.backgroundColor = .clear
      memoDot.backgroundColor = .systemBlue
    }
  }
}
