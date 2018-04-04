//
//  TournamentsModel.swift
//  BeelineCodingChallenge
//
//  Created by Arbi on 1/15/18.
//  Copyright © 2018 org.beelinecoding. All rights reserved.
//

import Foundation

struct Tournaments:Codable{
    
    var data:[Tournament];
    
    enum CodingKeys:String , CodingKey{
      
        case results = "data"
        
    }
 
    func encode(to encoder: Encoder) throws
    {

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decode([Tournament].self, forKey:.results)
        
    }
    
}

struct Tournament:Codable{
    var links:links
    var attributes:attributes
    var id:String
    var type:String
    
}

struct links:Codable{
    var enter_tournament:String
    var sel:String
    
    enum CodingKeys:String , CodingKey{
    
        case selfy = "self"
        case enter_tournament = "enter_tournament"
        
    }
    
    func encode(to encoder: Encoder) throws
    {
    
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        enter_tournament = try values.decode(String.self, forKey: .enter_tournament)
        sel = try values.decode(String.self, forKey:.selfy)
        
    }
  
 
}
struct attributes:Codable{

    var name:String
    var entry_message:String
    var date:String
    
    enum CodingKeys:String , CodingKey{
        
        case name = "name"
        case entry_message = "entry_message"
        case date = "created_at"
        
    }
    func encode(to encoder: Encoder) throws
    {
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey:.name)
        entry_message = try values.decode(String.self, forKey:.entry_message)
        date = try values.decode(String.self, forKey: .date)
        
    }
    
    
}

