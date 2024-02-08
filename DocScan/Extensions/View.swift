//
//  View.swift
//  DocScan
//
//  Created by Ivan Lele on 26.12.2023.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
