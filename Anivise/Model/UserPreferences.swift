//
//  UserPreferences.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import Foundation

struct PreferencesHelper {
    static func saveOnboardingStatus(_ completed: Bool) {
        UserDefaults.standard.set(completed, forKey: "isOnboarded")
    }

    static func isOnboardingCompleted() -> Bool {
        return UserDefaults.standard.bool(forKey: "isOnboarded")
    }
}
