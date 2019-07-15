//
//  ObservableExtension.swift
//  MTG-CardOfTheDay
//
//  Created by 醍醐崇紘 on 2019/07/14.
//  Copyright © 2019 醍醐崇紘. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension ObservableType where E: OptionalType {
    func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { e -> Observable<E.Wrapped> in
            guard let value = e.value else {
                return Observable.empty()
            }
            return Observable.just(value)
        }
    }
}

extension Driver where E: OptionalType {
    func filterNil() -> Driver<E.Wrapped> {
        return self.flatMap { e -> Driver<E.Wrapped> in
            guard let value = e.value else {
                return Driver.empty()
            }
            return Driver.just(value)
        }
    }
}
