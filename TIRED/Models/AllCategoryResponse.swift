//
//  AllCategoryResponse.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//


import Foundation

struct ALLCategoriesResponse:Codable {
    let categories:Categories
  
}
struct Categories:Codable {
    let items:[Category]
    
}

struct Category:Codable {
    let id:String
    let name:String
    let icons:[ApiImage]
}
