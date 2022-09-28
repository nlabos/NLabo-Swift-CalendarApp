//
//  Event.swift
//  NLabo-Swift-CalendarApp
//
//  Created by 髙津悠樹 on 2022/09/28.
//

import Foundation
import RealmSwift
//test

class Event: Object {
    
    @objc dynamic var date: String = ""
    @objc dynamic var event: String = ""
}
