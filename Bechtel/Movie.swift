//
//  Movie.swift
//  Bechtel
//
//  Created by Juliana Strawn on 2/16/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var title: String
    var score: String
    var imdbID: String
    var year:String
    
    //get from moviesBD call
    var rating:String?
    var summary:String?
    var poster:UIImage?

    init(title:String, score:String, imdbID:String, year:String) {
        self.title = title
        self.score = score
        self.imdbID = imdbID
        self.year = year
        
    }

}
