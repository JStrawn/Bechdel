//
//  HomeViewController.swift
//  Bechtel
//
//  Created by Juliana Strawn on 5/29/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var seachButton: UIButton!
    @IBOutlet weak var infoButton: UIView!
    @IBOutlet weak var recentMoviesButton: UIView!
    @IBOutlet weak var addMovieButton: UIView!
    @IBOutlet weak var noMoviesLabel: UILabel!
    @IBOutlet weak var watchlistLabel: UILabel!
    @IBOutlet weak var watchlistImage: UIImageView!
    @IBOutlet weak var keyboardTapZone: UIView!
    
    var frm: CGRect!
    var movieTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:0.8)
        self.navigationController?.navigationBar.isTranslucent = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.topItem?.title = "Bechdel Search"
        //self.navigationController?.navigationBar.title = "Bechdel Search"
        
        seachButton.layer.cornerRadius = 15
        seachButton.frame.size.width = view.frame.size.width/4
        seachButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        infoButton.layer.cornerRadius = 15
        infoButton.isUserInteractionEnabled = true
        let infoTouch = UITapGestureRecognizer(target: self, action: #selector(infoButtonTouched))
        infoButton.addGestureRecognizer(infoTouch)
        
        recentMoviesButton.layer.cornerRadius = 15
        
        addMovieButton.layer.cornerRadius = 15
        
        setUpCollectionView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        keyboardTapZone.addGestureRecognizer(tap)
        
        let watchlistTap = UITapGestureRecognizer(target: self, action: #selector(pushToWatchlistVC))
        let watchlistImageTap = UITapGestureRecognizer(target: self, action: #selector(pushToWatchlistVC))
        
        watchlistLabel.isUserInteractionEnabled = true
        watchlistLabel.addGestureRecognizer(watchlistTap)
        watchlistImage.isUserInteractionEnabled = true
        watchlistImage.addGestureRecognizer(watchlistImageTap)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DAO.sharedInstance.fetchWatchlist()
        collectionView.reloadData()
        
        if DAO.watchlist.count < 1 {
            noMoviesLabel.isHidden = false
        } else {
            noMoviesLabel.isHidden = true
        }
        
    }
    
    
    func infoButtonTouched() {
        //Push to info VC
    }
    
    
    
    func buttonClicked() {
        
        movieTitle = searchField.text
        
        if movieTitle == "" {
            return
        } else {
            DAO.getMoviesByTitle(title: movieTitle)
            
            let resultsPageViewController = ResultsPage()
            resultsPageViewController.movieTitle = movieTitle
            resultsPageViewController.navigationController?.navigationItem.leftBarButtonItem?.title = ""
            self.navigationController?.pushViewController(resultsPageViewController, animated: true)
            
        }
    }
    
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = false
        collectionView.allowsSelection = true
        
        // register the collectionView cell
        self.collectionView!.register(UINib(nibName: "WatchlistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layout.itemSize = CGSize(width: collectionView.frame.width * 0.25, height: collectionView.frame.height * 0.95)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:0.8)
        collectionView.collectionViewLayout = layout
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DAO.watchlist.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WatchlistCollectionViewCell
        
        let currentMovie = DAO.watchlist[indexPath.section]
        
        // Configure the cell
        cell.moviePoster.image = currentMovie.poster
        cell.layer.cornerRadius = 2
        
        cell.movieTitleLabel.text = currentMovie.title
        
        if currentMovie.score == "3" {
            cell.testResultImage.image = UIImage(named: "checked-2")
        } else {
            cell.testResultImage.image = UIImage(named: "cancel")
        }
        
        return cell
        
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap")
        let currentMovie = DAO.watchlist[indexPath.section]
        
        let movieDetail = MovieDetailViewController()
        movieDetail.title = currentMovie.title
        movieDetail.currentMovie = currentMovie
        self.navigationController?.pushViewController(movieDetail, animated: true)

    }    
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func pushToWatchlistVC() {
        let watchlistVC = MyWatchlistViewController()
        self.navigationController?.pushViewController(watchlistVC, animated: true)
    }
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.27, height: collectionView.frame.height * 0.9)
    }
}

