//
//  photo.swift
//  Match.cat.GuangZ
//
//  Created by Guang on 7/12/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
struct Photo {
    var farm: Int
    var secret = ""
    var id = ""
    var server = ""
    var url_q = ""
    var dictionary: [String: AnyObject] {
        get {
            return [
                "farm":farm,
                "secret":secret,
                "id":id,
                "server":server,
                "url_q":url_q
            ]
        }
    }
}