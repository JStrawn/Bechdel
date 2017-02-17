//
//  ViewController.swift
//  Bechtel
//
//  Created by Juliana Strawn on 2/15/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var frm: CGRect!
    var searchField: UITextField!
    var movieTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red:0.61, green:0.77, blue:0.89, alpha:1.0)
        
        createSeachBox()
        createSearchButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createSeachBox() {
        
        frm = self.view.frame
        
        //Search field will take up 75% of the length of the view
        let wide = frm.width * 0.75
        //Therefore to center it, get center (maxX/2) minus half width of search field
        let x = frm.maxX/2 - wide/2
        //i want y to be 50% of the way down the view
        let y = frm.height * 0.40
        

        searchField = UITextField(frame: CGRect(x: x, y: y, width: wide, height: 50))
        searchField.placeholder = "Search..."
        searchField.borderStyle = UITextBorderStyle.bezel
        searchField.layer.cornerRadius = 25
        searchField.backgroundColor = UIColor.white


        self.view.addSubview(searchField)
    }
    
    func createSearchButton() {
        let wide = frm.width * 0.20
        let x = frm.maxX/2 - wide/2
        let y = frm.height * 0.60
        
        let searchButton = UIButton(frame: CGRect(x: x, y: y, width: wide, height: 30))
        searchButton.backgroundColor = UIColor.black
        searchButton.setTitle("Search", for: .normal)
        searchButton.layer.cornerRadius = 20
        searchButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        
        self.view.addSubview(searchButton)
        
    }
    
    func buttonClicked() {
        movieTitle = searchField.text
        DAO.getMoviesByTitle(title: movieTitle)
        //MARK: TODO set it up later to not do anything if there is no text in the search box
        
        let resultsPageViewController = ResultsPage()
        resultsPageViewController.movieTitle = movieTitle
        self.navigationController?.pushViewController(resultsPageViewController, animated: true)
    }
}

