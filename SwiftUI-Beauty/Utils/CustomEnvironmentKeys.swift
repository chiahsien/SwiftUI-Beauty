//
//  CustomEnvironmentKeys.swift
//  SwiftUI-Beauty
//
//  Created by Nelson on 2021/7/23.
//

import SwiftUI

struct SelectedIndexEnvironmentKey: EnvironmentKey {
    static var defaultValue = 0
}

extension EnvironmentValues {
    var selectedIndex: Int {
        get { self[SelectedIndexEnvironmentKey.self] }
        set { self[SelectedIndexEnvironmentKey.self] = newValue }
    }
}
