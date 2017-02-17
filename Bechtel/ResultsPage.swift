//
//  ResultsPage.swift
//  Bechtel
//
//  Created by Juliana Strawn on 2/15/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class ResultsPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    var items: [String] = ["Movie1", "Movie2", "Movie3"]
    var movieTitle:String!
    var frm: CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "search results for \"\(movieTitle!)\""
        
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
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
    }
    
    //MARK: Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! CustomCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let height = (frm.height * 0.20)
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected!")
    }
    
    
    
}
