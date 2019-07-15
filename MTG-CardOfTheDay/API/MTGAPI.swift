//
//  MTGAPI.swift
//  MTG-CardOfTheDay
//
//  Created by 醍醐崇紘 on 2019/07/14.
//  Copyright © 2019 醍醐崇紘. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

enum MTGAPI {
    case CardSearch([CardSearchParam])
}

extension MTGAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.magicthegathering.io/v1")!
    }
    
    var path: String {
        switch self {
        case .CardSearch(_):
            return "/cards"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .CardSearch(let params):
            return .requestParameters(parameters: params.toDict(), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Page-Size": "10"]
    }
    
    
}

extension Array where Element == CardSearchParam {
    fileprivate func toDict() -> [String: String] {
        var dict: [String: String] = [:]
        self.forEach {
            dict.updateValue($0.value, forKey: $0.key)
        }
        return dict
    }
}
