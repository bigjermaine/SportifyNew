//
//  RecommendedGenresResponse.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation


struct RecommendedGenresResponse:Codable {
    let genres:[String]
}





struct RecommendationResponse:Codable {
    let tracks:[AudioTrack]
    
}


