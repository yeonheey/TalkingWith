//
//  UserModel.swift
//  TalkingWith
//
//  Created by 정연희 on 2021/07/11.
//

import ObjectMapper

struct UserModel: Mappable {
    var profileImageUrl: String?
    var userName: String?
    var uid: String?
    
    init?(map: Map) {
    }
    init() {
    }
    
    mutating func mapping(map: Map) {
        userName <- map["userName"]
        uid <- map["uid"]
        profileImageUrl <- map["profileImageUrl"]
    }
}
