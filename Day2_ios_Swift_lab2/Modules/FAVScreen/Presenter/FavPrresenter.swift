import Foundation


protocol FavPresenterProtocol : BasePrresenter{
    func getResult()->[Movie]
    func deleteFavMovie(index : Int)
    func loaddata()
    func selectedMovie(index: Int) -> Movie
    
}
class FavPrresenter:FavPresenterProtocol{
    func selectedMovie(index: Int) -> Movie {
        return result![index]
    }
    
    var view : BasFavViewController
   
    var result : [Movie]?
    init(view : BasFavViewController) {
        self.view = view
    }
    
    func loaddata(){
            result = MovieDatabase.shared.fetchMoviesFromFAV()
            self.view.displaydata()
    }
    
    func getResult()->[Movie]{
        return result ?? []
    }
    
    func deleteFavMovie(index : Int){
        let movieToDelete = (result![index])
        MovieDatabase.shared.deleteMovieFromFAV(m: movieToDelete)
        result!.remove(at: index)
        
    }
    
}
