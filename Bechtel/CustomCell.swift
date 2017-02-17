//
//  CustomCell.swift
//  Bechtel
//
//  Created by Juliana Strawn on 2/16/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var movieImage:UIImageView!
    var title:UILabel!
    var items: [String] = ["Movie1", "Movie2", "Movie3"]
    var frm:CGRect!


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let gap : CGFloat = 10
        let labelHeight: CGFloat = 30
        let labelWidth: CGFloat = 150
        //let lineGap : CGFloat = 5
        
        movieImage = UIImageView()
        movieImage.frame = CGRect(x:gap, y:gap, width:labelWidth, height:labelHeight)
        movieImage.image = UIImage(named: "q")
        self.addSubview(movieImage)
        
        title = UILabel()
        title.frame = CGRect(x: 40, y: 0, width: 70, height: 30)
        
    }
    
}
//        override func setSelected(_ selected: Bool, animated: Bool) {
//            super.setSelected(selected, animated: animated)
//
//            // Configure the view for the selected state
//        }
//        
//        func createImageView() {
//            movieImage = UIImageView(frame: CGRect(x: 0, y:0, width: 30, height:60))
//            movieImage.image = UIImage(named:"q")
//            self.addSubview(movieImage)
//        }
//        
//        func createTitleLabel() {
//            title = UILabel(frame: CGRect(x: 10, y: 10, width: 50, height: 10))
//            //title.text = items[IndexPath.row]
//            self.addSubview(title)
//        }


