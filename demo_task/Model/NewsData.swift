//
//  NewsData.swift
//  demo_task
//
//  Created by Jayam Verma on 21/04/23.
//

import Foundation

struct NewsData:Codable{
    
    let status:String
    let articles:[ArticleData]
}
