//
//  DAO.swift
//  Bechtel
//
//  Created by Juliana Strawn on 2/15/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class DAO: NSObject {
    
    class func getMoviesByTitle(title:String) {
        var urlString = "http://bechdeltest.com/api/v1/getMoviesByTitle?title="
        let searchString = removeArticles(userString: title)
        urlString.append(searchString)
        let url = URL(string: urlString)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any]
                    {
                        
                        print("\(json)")
                        //object for key assign title and rating from json array to movie object
                        //put them into an array so tableview can access the movie objects? Do i need a shared manager?
                        //post an nsnofitiation to say it's downloaded
                        //reload tableview when downloaded (when posted)
                        
                        
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
    
    class func removeArticles (userString: String) -> String {

        var myMutableString:String
        
        //remove unecessary words and punctuation for better results
        myMutableString = userString.replacingOccurrences(of: "the ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: "The ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: " the ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: " The ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: "On ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: "on ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: " on ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: " On ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: " a ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: " A ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: "Of ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: " of ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: " or ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: "Or ", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: ",", with: "")
        myMutableString = myMutableString.replacingOccurrences(of: ".", with: "")

        
        //HTML encoding for weird characters
        myMutableString = myMutableString.replacingOccurrences(of: "'", with: "&#39;")
        
        //replace all spaces with &
        myMutableString = myMutableString.replacingOccurrences(of: " ", with: "&")
        
        return myMutableString
        
    }
    
}
