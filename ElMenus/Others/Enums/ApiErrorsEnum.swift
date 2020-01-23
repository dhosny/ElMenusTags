//
//  ApiErrorsEnum.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/23/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
    case parsingError = "invalid format"
}
