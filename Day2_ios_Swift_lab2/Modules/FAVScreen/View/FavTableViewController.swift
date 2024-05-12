//
//  FavTableViewController.swift
//  Day2_ios_Swift_lab2
//
//  Created by Elham on 08/05/2024.
//

import UIKit

protocol BasFavViewController{
    func displaydata();
}
class FavTableViewController: UITableViewController,BasFavViewController {
  
  
    var presnter : FavPresenterProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        presnter = FavPrresenter(view: self)
        loadMovies()
       loadMovies()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       loadMovies()
    }
    func loadMovies() {
        presnter?.loaddata()
       
    }
    
   
    func displaydata(){
        
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return presnter?.getResult().count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavTableCell
        let movie = presnter?.getResult()[indexPath.row]
        cell.txt.text = movie?.title

        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + movie!.posterPath) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let error = error {
                    print("Error fetching image data: \(error)")
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    print("Error: Unable to create image from data")
                    return
                }
                DispatchQueue.main.async {
                    cell.img.image = image
                }
            }.resume()
        } else {
            print("Error: Invalid URL for image")
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        details.presenter = presnter!
        details.index = indexPath.row
        details.isFav = true
        navigationController?.pushViewController(details, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Delete Movie", message: "Are you sure you want to delete this movie?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.presnter?.deleteFavMovie(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }


}
