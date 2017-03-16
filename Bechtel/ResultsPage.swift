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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set title & font size
        let titleAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        self.title = "search results for \"\(movieTitle!)\""
        

        //reload tableview delegate
        DAO.delegate = self
        
        
        createTableView()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        tableView.backgroundColor = UIColor.lightGray
        
        tableView.register(UINib.init(nibName: "ResultsTableViewCell", bundle: .main), forCellReuseIdentifier: "cell")
        
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
        //cell.movieScore.layer.cornerRadius = 15
        
        if currentMovie.score == "3" {
            cell.testResult.image = UIImage(named: "checked-2")
        } else {
            cell.testResult.image = UIImage(named: "cancel")
        }
        
        cell.movieSummary.text = currentMovie.summary
        
        cell.movieImage.image = currentMovie.poster
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let height = (frm.height * 0.25)
        return CGFloat(height)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected!")
    }
    
    func movieFetchComplete() {
        self.tableView.reloadData()
    }
    
        
}
