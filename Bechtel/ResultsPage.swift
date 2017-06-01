//
//  ResultsPage.swift
//  Bechtel
//
//  Created by Juliana Strawn on 2/15/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class ResultsPage: UIViewController, UITableViewDelegate, UITableViewDataSource, DAODelegate {
    
    var tableView: UITableView = UITableView()
    var movieTitle:String!
    var frm: CGRect!
    var noResultsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set title & font size
        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        self.navigationController?.navigationBar.isTranslucent = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.title = "search results for \"\(movieTitle!)\""
        self.view.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:0.8)
        
        //reload tableview delegate
        DAO.delegate = self
        createTableView()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
//        
//        if DAO.movies.count == 0 {
//            noResultsLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.height/2, width: view.frame.width/2, height: 30))
//            noResultsLabel.text = "No results found"
//            noResultsLabel.textColor = UIColor.white
//            noResultsLabel.textAlignment = .center
//            view.addSubview(noResultsLabel)
//        } else if DAO.movies.count != 0 {
//            noResultsLabel.isHidden = true
//        }
    }
    
    
    func createTableView() {
        frm = self.view.frame
        
        let wide = frm.width
        let x = frm.minX
        let high = frm.height
        let y = frm.minY
        
        
        tableView.frame         =   CGRect(x:x, y:y, width:wide, height:high);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:0.8)
        
        tableView.register(UINib.init(nibName: "ResultsTableViewCell", bundle: .main), forCellReuseIdentifier: "cell")
        
        tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
        
    }
    
    
    //MARK: Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DAO.movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as!ResultsTableViewCell
        
        let currentMovie = DAO.movies[indexPath.row]
        
        cell.movieTitle.text = currentMovie.title
        cell.movieTitle.adjustsFontSizeToFitWidth = true
        
        cell.yearAndRating.text = "\(currentMovie.year!) | PG-13"
        cell.movieScore.text = "\(currentMovie.score!)/3"
        cell.movieScore.layer.cornerRadius = 5
        cell.moviePoster.layer.cornerRadius = 5
        
        if currentMovie.score == "3" {
            cell.testResult.image = UIImage(named: "checked-2")
        } else {
            cell.testResult.image = UIImage(named: "cancel")
        }
        
        
        if currentMovie.summary == nil {
            currentMovie.summary = "Loading description..."
            DAO.getMovieByImdbID(movie: currentMovie)
        } else if currentMovie.summary == "" {
            currentMovie.summary = "Loading description..."
        }
        else {
            cell.movieSummary.text = currentMovie.summary
        }
        
        cell.movieImage.image = currentMovie.poster
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let height = (frm.height * 0.25)
        return height
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMovie = DAO.movies[indexPath.row]
        
        let movieDetail = MovieDetailViewController()
        movieDetail.title = currentMovie.title
        movieDetail.currentMovie = currentMovie
        self.navigationController?.pushViewController(movieDetail, animated: true)
    }
    
    
    //completion handler
    func movieFetchComplete() {
        self.tableView.reloadData()
    }
    
    
}

