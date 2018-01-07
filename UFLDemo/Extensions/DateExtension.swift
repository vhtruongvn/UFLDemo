//
//  DateExtension.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/7/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

extension Date {
    
    func formatGameDate() -> String {
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(self) { return "YESTERDAY" }
        else if calendar.isDateInToday(self) { return "TODAY" }
        else if calendar.isDateInTomorrow(self) { return "TOMORROW" }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE dd MMMM"
            let dateText = dateFormatter.string(from: self)
            return dateText.uppercased()
        }
    }
    
}
