//
//  Date+Utility.swift
//  AnimationKit
//
//  Created by Ferdinand on 31/12/21.
//

import Foundation

extension Date {
    
    func components(_ components: Set<Calendar.Component>) -> DateComponents {
            return Calendar.current.dateComponents(components, from: self)
        }

        func component(_ component: Calendar.Component) -> Int {
            return Calendar.current.component(component, from: self)
        }

        var era: Int { return component(.era) }
        var year: Int { return component(.year) }
        var month: Int { return component(.month) }
        var day: Int { return component(.day) }
        var hour: Int { return component(.hour) }
        var minute: Int { return component(.minute) }
        var second: Int { return component(.second) }
        var weekday: Int { return component(.weekday) }
        var weekdayOrdinal: Int { return component(.weekdayOrdinal) }
        var quarter: Int { return component(.quarter) }
        var weekOfMonth: Int { return component(.weekOfMonth) }
        var weekOfYear: Int { return component(.weekOfYear) }
        var yearForWeekOfYear: Int { return component(.yearForWeekOfYear) }
        var nanosecond: Int { return component(.nanosecond) }
        var calendar: Calendar? { return components([.calendar]).calendar }
        var timeZone: TimeZone? { return components([.timeZone]).timeZone }
}
