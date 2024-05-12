import UIKit


protocol BasHomeViewController{
    func displaydata();
}

class MyCollectionView: UICollectionViewController , UICollectionViewDelegateFlowLayout,BasHomeViewController{
  
    var indicator : UIActivityIndicatorView?
    var presnter : HomePresenterProtocol?
    
   // var movies: [Result] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        presnter = HomePrresenter(view: self, network: NetworkServices())
        loadMovies()
       
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return (presnter?.getResult().count)!
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! MyCollectionCell

        if let imagUrl = URL(string: "https://image.tmdb.org/t/p/w500" + ((presnter?.getResult()[indexPath.row].posterPath)!)){
            URLSession.shared.dataTask(with: imagUrl) { data, response, error in
                if let error = error {
                    print("Error fetching image data: \(error)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Error: Unable to create image from data")
                    return
                }
                
                DispatchQueue.main.async {
                  
                    if let imageView = cell.img {
                        imageView.image = image
                      //  cell.titlle?.text = self.presnter?.getResult()[indexPath.row].title
                    } else {
                        print("Error: cell.img is nil")
                    }
                  
                }
            }.resume()
        } else {
            print("Error: Invalid URL for image")
        }
        
        return cell
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: (self.view.frame.width * 0.45))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let details = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        details.presenter = presnter!
        details.index = indexPath.row
            navigationController?.pushViewController(details, animated: true)
        }
        
       
        override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
            return true
        }

        override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
            return action == #selector(delete(_:))
        }

        override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
            if action == #selector(delete(_:)) {
                presnter?.deleteMovie(index: indexPath.row)
                            collectionView.deleteItems(at: [indexPath])
            }
        }
    


    func loadMovies() {
        setIndicator()
        presnter?.loaddata()
       
    }
    
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
    func displaydata(){
       
        collectionView.reloadData()
       self.indicator?.stopAnimating()
    }

   
}
