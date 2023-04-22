//
//  ViewController.swift
//  demo_task
//
//  Created by Jayam Verma on 21/04/23.
//

import UIKit

class ViewController: UIViewController{
    
    var articlesList = [ArticleData]()
    var isSelected:Bool = false
    
    @IBOutlet weak var MyTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        MyTableView.addSubview(refreshControl)
        
        
        // Do any additional setup after loading the view.
        
        // Fetch Data from API
        fetchData()
    }
    
    // Reload and refresh the table data
    
    @objc func refresh(_sender: AnyObject){
        fetchData()
        self.MyTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // fetch data from API
    
    func fetchData()
    {
        
        let url = URL(string:"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=412fd9f51736425288edc282b0d0d8e9" )
        
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data,error == nil else
            {
                print("Error occured while accessing data with URL")
                return
            }
            var newsFullList:NewsData?
            do
            {
                newsFullList = try JSONDecoder().decode(NewsData.self,from: data)
            }
            catch{
                print("Error occured while decoding JSON into swift structure\(error)")
            }
            self.articlesList = newsFullList!.articles
            DispatchQueue.main.async{
                self.MyTableView.reloadData()
            }
            
        }
        dataTask.resume()
    }
    
}

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView
{
    
    //fetch Images
    
    func downloadImage(from url:URL){
        contentMode = .scaleToFill
        
        // check if image is available in cache else does API call
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        }
        else
        {
            let dataTask = URLSession.shared.dataTask(with: url) { data, response,error in
                guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200,
                      let  mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                      let data = data,error == nil,
                      let image = UIImage(data:data)
                else
                {
                    return
                }
                DispatchQueue.main.async{
                    let imageToCache = UIImage(data: data)
                    imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self.image = imageToCache
                }
                
            }
            dataTask.resume()
        }
    }
}

extension ViewController: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell
        
        let cell = MyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        
        // set title for table view
        
        cell.myLabel1.text = articlesList[indexPath.row].title
        
        
        // set description for table view
        
        if articlesList[indexPath.row].description != nil
        {
            cell.myLabel2.text = "Description: \(articlesList[indexPath.row].description!)"
        }
        else
        {
            cell.myLabel2.text = "No Description available"
        }
        
        // set image for table view
        
        if articlesList[indexPath.row].urlToImage != nil{
            let url = URL(string: articlesList[indexPath.row].urlToImage!)
            cell.myImageView.downloadImage(from: url!)
            cell.myImageView.contentMode = .scaleToFill
            cell.myImageView.layer.cornerRadius = 8
        }
        else
        {
            cell.myImageView.image = UIImage(named: "emptyimage")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentcell = tableView.cellForRow(at: indexPath)! as! MyTableViewCell
        
        print(currentcell.isSelected)
        
        // if checkbox is enabled display a dialog which shows the description else show alert
        
        if currentcell.btnCheckbox.isSelected {
            let alertController = UIAlertController(title: articlesList[indexPath.row].title, message: articlesList[indexPath.row].description, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Alert", message: "Checkbox is disabled", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
