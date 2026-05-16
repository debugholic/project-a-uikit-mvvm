import Foundation

final class CalendarViewModel {
  
  private let calendar: Calendar
  private(set) var currentMonth: Date
  private(set) var selectedDate: Date?
  private(set) var days: [CalendarDay] = []
  private var memos: [Date: String] = [:]
  
  var onUpdate: (() -> Void)?
  
  init(calendar: Calendar = .current, referenceDate: Date = Date()) {
    var cal = calendar
    cal.locale = Locale(identifier: "en_US")
    self.calendar = cal
    self.currentMonth = cal.startOfMonth(for: referenceDate)
    rebuildDays()
  }
  
  var monthTitle: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateFormat = "MMMM"
    return formatter.string(from: currentMonth)
  }
  
  var yearTitle: String {
    let year = calendar.component(.year, from: currentMonth)
    return "\(year)"
  }
  
  var currentMemo: String {
    guard let selectedDate else { return "" }
    return memos[calendar.startOfDay(for: selectedDate)] ?? ""
  }
  
  func goToPreviousMonth() {
    guard let prev = calendar.date(byAdding: .month, value: -1, to: currentMonth) else { return }
    currentMonth = prev
    rebuildDays()
    onUpdate?()
  }
  
  func goToNextMonth() {
    guard let next = calendar.date(byAdding: .month, value: 1, to: currentMonth) else { return }
    currentMonth = next
    rebuildDays()
    onUpdate?()
  }
  
  func select(day: CalendarDay) {
    selectedDate = day.date
    onUpdate?()
  }
  
  func updateMemo(_ text: String) {
    guard let selectedDate else { return }
    let key = calendar.startOfDay(for: selectedDate)
    if text.isEmpty {
      memos.removeValue(forKey: key)
    } else {
      memos[key] = text
    }
  }
  
  func hasMemo(for day: CalendarDay) -> Bool {
    memos[calendar.startOfDay(for: day.date)] != nil
  }
  
  func isSelected(_ day: CalendarDay) -> Bool {
    guard let selectedDate else { return false }
    return calendar.isDate(day.date, inSameDayAs: selectedDate)
  }
  
  private func rebuildDays() {
    let startOfMonth = calendar.startOfMonth(for: currentMonth)
    guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
      days = []
      return
    }
    
    let firstWeekday = calendar.component(.weekday, from: startOfMonth)
    let leadingEmpty = firstWeekday - calendar.firstWeekday
    
    var result: [CalendarDay] = []
    let today = calendar.startOfDay(for: Date())
    
    for i in 0..<leadingEmpty {
      guard let date = calendar.date(byAdding: .day, value: -(leadingEmpty - i), to: startOfMonth) else { continue }
      let dayNumber = calendar.component(.day, from: date)
      result.append(CalendarDay(
        date: date,
        dayNumber: dayNumber,
        isInCurrentMonth: false,
        isToday: calendar.isDate(date, inSameDayAs: today)
      ))
    }
    
    for day in range {
      guard let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) else { continue }
      result.append(CalendarDay(
        date: date,
        dayNumber: day,
        isInCurrentMonth: true,
        isToday: calendar.isDate(date, inSameDayAs: today)
      ))
    }
    
    let trailing = max(0, 42 - result.count)
    for _ in 0..<trailing {
      guard let lastDate = result.last?.date,
            let date = calendar.date(byAdding: .day, value: 1, to: lastDate) else { continue }
      let dayNumber = calendar.component(.day, from: date)
      result.append(CalendarDay(
        date: date,
        dayNumber: dayNumber,
        isInCurrentMonth: false,
        isToday: calendar.isDate(date, inSameDayAs: today)
      ))
    }
    
    days = result
  }
}

private extension Calendar {
  func startOfMonth(for date: Date) -> Date {
    let components = dateComponents([.year, .month], from: date)
    return self.date(from: components) ?? date
  }
}
