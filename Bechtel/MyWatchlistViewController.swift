//
//  MyWatchlistViewController.swift
//  Bechtel
//
//  Created by Juliana Strawn on 5/31/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class MyWatchlistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:0.8)
        
        setUpCollectionView()
    }
    
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = false
        
        // register the collectionView cell
        self.collectionView!.register(UINib(nibName: "WatchlistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)

        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:0.8)
        collectionView.collectionViewLayout = layout
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DAO.watchlist.count
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WatchlistCollectionViewCell
        
        let currentMovie = DAO.watchlist[indexPath.row]
        
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
    
    
    
    
}

extension MyWatchlistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.30, height: collectionView.frame.height * 0.30)
    }
}

