//
//  DailyCheckModel.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 06/09/23.
//

import Foundation

func check() -> Bool {
    if let referenceDate = UserDefaults.standard.object(forKey: "reference") as? Date {
        // reference date has been set, now check if date is not today
        if !Calendar.current.isDateInToday(referenceDate) {
            // if date is not today, do things
            // update the reference date to today
            UserDefaults.standard.set(Date(), forKey: "reference")
            return true
        }
    } else {
        // reference date has never been set, so set a reference date into UserDefaults
        UserDefaults.standard.set(Date(), forKey: "reference")
        return true
    }
    return false
}
