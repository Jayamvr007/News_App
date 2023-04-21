//
//  ArticleData.swift
//  demo_task
//
//  Created by Jayam Verma on 21/04/23.
//

import Foundation

struct ArticleData : Codable {
    
    let author:String?
    let title:String
    let description:String?
    let urlToImage:String?
    let content:String?
    
}
