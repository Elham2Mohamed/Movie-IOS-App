import Foundation


protocol HomePresenterProtocol : BasePrresenter{
    func getResult()->[Movie]
    func deleteMovie(index : Int)
    func loaddata()
    func selectedMovie(index :Int) -> Movie
    
}
class HomePrresenter:HomePresenterProtocol{
   
    
    var network :NetworkProtocol?
    var view : BasHomeViewController
   
    var result : [Movie]?
    init(view : BasHomeViewController ,network: NetworkProtocol) {
        self.network = network
        self.view = view
    }
    
    func loaddata(){
        
        if Reachability.isConnectedToNetwork() {
            
            network?.fetchDataFromAPI (url:"https://api.themoviedb.org/3/movie/top_rated?api_key=abe7089daa19c4b98bff89bb7fe1acac"){ [weak self] movies in
               // guard let result = movies else { return }
                self?.result = movies
               
                for movie in movies! {
                    MovieDatabase.shared.addMovie(m: movie)
                }
                DispatchQueue.main.async {
                    self?.view.displaydata()
                }
            }
        } else {
        
            result = MovieDatabase.shared.fetchMovies()
            self.view.displaydata()
        }
        
    }
    
    func selectedMovie(index: Int) -> Movie {
        return (result?[index])!
    }
    
    
    func getResult()->[Movie]{
        return result ?? []
    }
    
    func deleteMovie(index : Int){
        let movieToDelete = (result![index])
                    MovieDatabase.shared.deleteMovie(m: movieToDelete)
        result!.remove(at: index)
        
    }
    
}
