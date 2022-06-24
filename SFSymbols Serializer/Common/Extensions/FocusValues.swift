//
//  FocusValues.swift
//  SFSymbols Serializer
//
//  Created by Ashley Chapman on 22/06/2022.
//

import Foundation
import SwiftUI

extension FocusedValues {
    var presentFileExporterBinding: FocusedFileExporterBinding.Value? {
        get { self[FocusedFileExporterBinding.self] }
        set { self[FocusedFileExporterBinding.self] = newValue }
    }
}
