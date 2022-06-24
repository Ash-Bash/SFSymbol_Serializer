//
//  BaseViewModel.swift
//  Icon Studio
//
//  Created by Ashley Chapman on 19/03/2022.
//

import Foundation

class BaseViewModel: ObservableObject {
    func notifyWillUpdate() {
        objectWillChange.send()
    }
}
