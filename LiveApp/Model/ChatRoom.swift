//
//  ChatRoom.swift
//  LiveApp
//
//  Created by Class on 2022/4/14.
//

import Foundation

struct RoomEvent:Codable{
     let event:String?
 }
struct message:Codable {
    var userText:String?
    var contentText:String?
}
// 一般發話

struct NormalChat:Codable {
    let action:String?
    let content:String?
}
// 系統廣播
struct admin_all_broadcast:Codable{
     let event:String?
     let room_id:String?
     let sender_role:Int?
     let body:bodyA?
     let time:String?
 }
struct bodyA:Codable{
    let content:content?
}
struct content:Codable{
    let cn:String?
    let en:String?
    let tw:String?
}
// 一般發話
struct default_message:Codable{
     let event:String?
     let room_id:String?
     let sender_role:Int?
     let body:bodyB?
     let time:String?
 }
struct bodyB:Codable{
    let chat_id:String?
    let account:String?
    let nickname:String?
    let recipient:String?
    let type:String?
    let text:String?
    let accept_time:String?
    let info:info?
}
struct info:Codable{
    let last_login:Int?
    let is_ban:Int?
    let level:Int?
    let is_guardian:Int?
    let badges:String?
}
// 進出更新通知
struct sys_updateRoomStatus:Decodable{
    let event:String?
    let room_id:String?
    let sender_role:Int?
    var body:bodyC?
    let time:String?
     }
struct bodyC:Decodable{
    let entry_notice:entry_notice?
    let room_count:Int?
    let real_count:Int?
    let user_infos:user_infos?
    let guardian_count:Int?
    let guardian_sum:Int?
    let contribute_sum:Int?
}
struct entry_notice:Codable{
    let username:String?
    let head_photo:String?
    let action:String?
    let entry_banner:entry_banner?
}
struct entry_banner:Codable{
    let present_type:String?
    let img_url:String?
    let main_badge:String?
    let other_badges:other_badges?
}
struct other_badges:Codable{
}
struct user_infos:Codable{
    let guardianlist:guardianlist?
    let onlinelist:String?
}
struct guardianlist:Codable{
}
// 房間關閉
struct sys_room_endStream:Codable{
     let event:String?
     let room_id:String?
     let sender_role:Int?
     let body:bodyD?
     let time:String?
 }
struct bodyD:Codable{
    let type:String?
    let text:String?
}

    
   
    
    
    

