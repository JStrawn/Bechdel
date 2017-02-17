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
    var rating: Int
    

    init(title:String, rating:Int) {
        self.title = title
        self.rating = rating
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }


}
