//
//  ResultsTableViewCell.swift
//  Bechtel
//
//  Created by Juliana Strawn on 3/15/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var movieScore: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var yearAndRating: UILabel!
    @IBOutlet weak var moviePoster: UILabel!
    @IBOutlet weak var testResult: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
