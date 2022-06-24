//
//  File.swift
//  
//
//  Created by Ashley Chapman on 25/12/2021.
//

import Foundation
import Combine

extension ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher  {

  func subscribe<T: ObservableObject>(
    _ observableObject: T
  ) -> AnyCancellable where T.ObjectWillChangePublisher == ObservableObjectPublisher {
    return objectWillChange
      // Publishing changes from background threads is not allowed.
      .receive(on: DispatchQueue.main)
      .sink { [weak observableObject] (_) in
        observableObject?.objectWillChange.send()
      }
  }
}
