import Foundation

struct CalendarDay: Hashable {
  let date: Date
  let dayNumber: Int
  let isInCurrentMonth: Bool
  let isToday: Bool
}
