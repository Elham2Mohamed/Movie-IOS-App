//
//  ViewController.swift
//  Day2_ios_Swift_lab2
//
//  Created by JETSMobileLabMini5 on 22/04/2024.
//

import UIKit
import Cosmos
import SQLite3
class ViewController: UIViewController {
    
    var presenter : BasePrresenter!
    var index :Int = 0
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var rele: UILabel!
    var isFav : Bool = false
    @IBOutlet weak var img: UIImageView!
//    @IBOutlet weak var cosmos: UIView!
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var disc: UILabel!
   // var movie :Result?
    
//    lazy var cosmosView: CosmosView = {
//        let view = CosmosView()
//        view.settings.updateOnTouch = false
//        // view.settings.totalStars = 10
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cosmosView.rating = (presenter.selectedMovie(index: index).voteAverage) / 2.0
        
//        cosmos.addSubview(cosmosView)
//        cosmosView.center = CGPointMake(cosmos.bounds.width / 2, cosmos.bounds.height / 2)
//        
        titleLable.text = presenter.selectedMovie(index: index).title
        rele.text = presenter.selectedMovie(index: index).releaseDate
        disc.text = presenter.selectedMovie(index: index).overview
        if(isFav){
            favBtn.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
          
        }
        let imagUrl = URL(string:"https://image.tmdb.org/t/p/w500"+( (presenter.selectedMovie(index: index).backdropPath)))
        //+ "/image.tmdb.org/t/p/w500")
        
        URLSession.shared.dataTask(with: imagUrl!) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                print(" error in put image")
                return
            }
            
            DispatchQueue.main.async {
                self.img.image = image
            }
        }.resume()
        
        
        
        
        
        
    }
    
    @IBAction func addToFav(_ sender: Any) {
        
        if(!isFav){
            
            MovieDatabase.shared.addMovieTOFAV(m: presenter.selectedMovie(index: index))
            isFav = true
            
        }
       
        favBtn.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
      
        
    }
}
