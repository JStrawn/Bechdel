//
//  MovieDetailViewController.swift
//  Bechtel
//
//  Created by Juliana Strawn on 3/16/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var failTest: UIView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var text3: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var movieYearAndRating: UILabel!
    @IBOutlet weak var addToWatchlistButton: UIButton!
    
    var currentMovie:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.view.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:0.8)
        
        moviePoster.image = currentMovie.poster
        movieTitle.text = currentMovie.title
        movieSummary.text = currentMovie.summary
        movieYearAndRating.text = "\(currentMovie.year!) | PG-13"
        
        if currentMovie.score == "3" {
            failTest.isHidden = true
            
        } else if currentMovie.score == "2" {
            failTest.isHidden = true
            star3.isHidden = true
            text3.textColor = UIColor.lightGray
            
        } else if currentMovie.score == "1" {
            failTest.isHidden = true
            star2.isHidden = true
            text2.textColor = UIColor.lightGray
            star3.isHidden = true
            text3.textColor = UIColor.lightGray
            
        } else if currentMovie.score == "0" {
            failTest.isHidden = false
            star1.isHidden = true
            text1.isHidden = true
            star2.isHidden = true
            text2.isHidden = true
            star3.isHidden = true
            text3.isHidden = true
        }
        
        addToWatchlistButton.layer.cornerRadius = 5
        
        addToWatchlistButton.setTitle("Add to Watchlist", for: .normal)
        addToWatchlistButton.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DAO.sharedInstance.fetchWatchlist()
        for watchlistMovie in DAO.watchlist {
            let imbdID = watchlistMovie.value(forKey: "imdbID") as! String
            
            if imbdID == currentMovie.imdbID {
                addToWatchlistButton.setTitle("Remove from Watchlist", for: .normal)
                addToWatchlistButton.addTarget(self, action: #selector(removeFromWatchlist), for: .touchUpInside)
            }
        }
    }
    
    
    func addToWatchlist() {
        DAO.sharedInstance.saveToWatchlist(movie: currentMovie)
        addToWatchlistButton.setTitle("Remove from Watchlist", for: .normal)
        addToWatchlistButton.addTarget(self, action: #selector(removeFromWatchlist), for: .touchUpInside)
    }
    
    
    func removeFromWatchlist() {
        //TODO: method to delete from core data
        
        addToWatchlistButton.setTitle("Add to Watchlist", for: .normal)
        addToWatchlistButton.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
        
    }
    
}
