//
//  DAO.swift
//  Bechtel
//
//  Created by Juliana Strawn on 2/15/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import CoreData

protocol DAODelegate {
    func movieFetchComplete()
}

class DAO: NSObject {
    
    static var delegate : DAODelegate?
    static var movies = [Movie]()
    
    static var managedWatchlist: [NSManagedObject] = []
    static var watchlist = [Movie]()
    
    static var fixedMovieTitle:String!
    
    static let sharedInstance = DAO()
    
    class func getMoviesByTitle(title:String) {
        
        DAO.movies.removeAll()
        
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
                        //object for key assign title, rating, and ID from json array to movie object
                        //put them into an array so tableview can access the movie objects
                        //reload tableview when downloaded
                        
                        if let jsonMovieArray = json as? [[String: Any]] {
                            for jsonMovie in jsonMovieArray {
                                
                                
                                
                                
                                let movieTitle = jsonMovie["title"] as! String
                                let movieScore = jsonMovie["rating"] as! String
                                let movieID = jsonMovie["imdbid"] as! String
                                let movieYear = jsonMovie["year"] as! String
                                
                                //If movie title is "Twilight Saga, The" or something, move "The"
                                //else, just replace weird html code with readable stuff
                                
                                if movieTitle.range(of:", The") != nil{
                                    
                                    let theMovieTitle = moveTheToBeginningOfTitle(movieTitle: movieTitle)
                                    fixedMovieTitle = removeHTMLEncoding(movieTitle: theMovieTitle)
                                    
                                } else {
                                    
                                    fixedMovieTitle = removeHTMLEncoding(movieTitle: movieTitle)
                                }
                                
                                //Movie
                                let currentMovie = Movie(title: fixedMovieTitle, score: movieScore, imdbID: movieID, year: movieYear)
                                
                                //get the movie summary and poster
                                //DAO.getMovieByImdbID(movie: currentMovie)
                                
                                movies.append(currentMovie)
                            }
                            //dao reload delegate
                            DispatchQueue.main.async {
                                delegate?.movieFetchComplete()
                                //[self getMovieDescriptions]
                                
                            }
                            
                            print("RESULTS RETURNED: \(movies.count)")
                        }
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
    
    
    class func getMovieByImdbID(movie:Movie) {
        
        let appDel = AppDelegate()
        let urlString = "https://api.themoviedb.org/3/find/tt\(movie.imdbID!)?api_key=\(appDel.apiKey)&language=en-US&external_source=imdb_id"
        
        let url = URL(string: urlString)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                    {
                        print("\(json!)")
                        
                        if let root = json,
                            
                            let movieResultsArray = root["movie_results"] as? [Any] {
                            
                            if movieResultsArray.count == 0 {
                                movie.summary = "No description avaliable."
                                movie.poster = UIImage(named: "greyImage")
                                DispatchQueue.main.async {
                                    delegate?.movieFetchComplete()
                                    
                                }
                                return
                                
                            } else {
                                
                                if let searchResultMovie = movieResultsArray[0] as? [String: Any] {
                                    
                                    // it crashes right here because the dictionary is totally empty
                                    // how to best handle this error?
                                    // A guard statement wants me to use == or let
                                    movie.imageURL = searchResultMovie["poster_path"] as? String ?? "No image"
                                    
                                    movie.summary = searchResultMovie["overview"] as? String ?? "No description avaliable."
                                    
                                    
                                    DAO.downloadImageFromMovie(movie: movie)
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
        })
        task.resume()
    }
    
    
    class func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    class func downloadImageFromMovie(movie: Movie) {
        
        if movie.imageURL! == "No image" {
            movie.poster = UIImage(named: "greyImage")
            DispatchQueue.main.async {
                delegate?.movieFetchComplete()
                
            }
            return
        } else {
            
            var urlString = "https://image.tmdb.org/t/p/w640"
            urlString.append(movie.imageURL!)
            
            let url = URL(string: urlString)
            getDataFromUrl(url: url!) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { () -> Void in
                    movie.poster = UIImage(data: data)
                    DispatchQueue.main.async {
                        delegate?.movieFetchComplete()
                        
                    }
                }
                
            }
        }
    }
    
    
    // MARK: String manipulation functions
    
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
        myMutableString = myMutableString.replacingOccurrences(of: "ü", with: "&uuml;")
        
        //replace all spaces with &
        myMutableString = myMutableString.replacingOccurrences(of: " ", with: "&")
        
        return myMutableString
        
    }
    
    
    class func removeHTMLEncoding(movieTitle:String) -> String {
        var myMutableString:String
        
        //remove weird HTML encoding in titles of movies
        myMutableString = movieTitle.replacingOccurrences(of: "&#39;", with: "'")
        myMutableString = myMutableString.replacingOccurrences(of: "&amp;", with: "&")
        myMutableString = myMutableString.replacingOccurrences(of: "&uuml;", with: "ü")
        
        return myMutableString
    }
    
    
    class func moveTheToBeginningOfTitle(movieTitle:String) -> String {
        var myMutableString:String
        
        myMutableString = movieTitle.replacingOccurrences(of: ", The", with: "")
        var theString = "The "
        theString.append(myMutableString)
        
        return theString
    }
    
    
    // MARK: Core data methods
    func saveToWatchlist(movie: Movie) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "ManagedMovie",
                                       in: managedContext)!
        
        let managedMovie = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        managedMovie.setValue(movie.title, forKeyPath: "title")
        managedMovie.setValue(movie.score, forKey: "score")
        managedMovie.setValue(movie.year, forKey: "year")
        managedMovie.setValue(movie.rating, forKey: "rating")
        managedMovie.setValue(movie.imdbID, forKey: "imdbID")
        managedMovie.setValue(movie.imageURL, forKey: "imageURL")
        managedMovie.setValue(movie.summary, forKey: "summary")
        
        let movieImage = UIImageJPEGRepresentation(movie.poster!, 0.0)
        managedMovie.setValue(movieImage, forKey: "uiimage")
        
        // 4
        do {
            try managedContext.save()
            DAO.managedWatchlist.insert(managedMovie, at: 0)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func fetchWatchlist() {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ManagedMovie")
        
        //3
        do {
            DAO.managedWatchlist = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        DAO.watchlist.removeAll()
        
        for managedMovie in DAO.managedWatchlist {
            let title = managedMovie.value(forKey: "title") as! String
            let score = managedMovie.value(forKey: "score") as! String
            let imdbID = managedMovie.value(forKey: "imdbID") as! String
            let year = managedMovie.value(forKey: "year") as! String
            let summary = managedMovie.value(forKey: "summary") as! String
            
            let posterData = managedMovie.value(forKey: "uiimage") as! Data
            
            let newMovie = Movie(title: title, score: score, imdbID: imdbID, year: year)
            newMovie.summary = summary
            newMovie.poster = UIImage(data: posterData)

            DAO.watchlist.insert(newMovie, at: 0)
            //DAO.watchlist.append(newMovie)
            
        }
    }
    
    
}
