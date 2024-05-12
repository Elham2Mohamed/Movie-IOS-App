import Foundation
import UIKit
import CoreData

class MovieDatabase {
    static let shared = MovieDatabase()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Day2_ios_Swift_lab2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func addMovie(m: Movie) {
        let context = persistentContainer.viewContext
        guard let movieEntity = NSEntityDescription.entity(forEntityName: "Movies", in: context) else {
            fatalError("Failed to find entity ")
        }
        let movie = NSManagedObject(entity: movieEntity, insertInto: context)
        
        movie.setValue(m.title , forKey: "title")
        movie.setValue(m.voteAverage, forKey: "voteAverage")
        movie.setValue(m.releaseDate, forKey: "releaseDate")
        movie.setValue(m.overview, forKey: "overview")
        movie.setValue(m.posterPath , forKey: "posterPath")
        movie.setValue(m.backdropPath, forKey: "backdropPath")

        saveContext()
    }


    func fetchMovies() -> [Movie] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let movies = result as? [Movies] else {
                return []
            }
            return movies.map { movie in
                Movie(
                    adult: false,
                    backdropPath: movie.backdropPath ?? "",
                    genreIDS: [],
                    id: 0,
                    originalLanguage: "",
                    originalTitle: "",
                    overview: movie.overview ?? "",
                    popularity: 0.0,
                    posterPath: movie.posterPath ?? "",
                    releaseDate: movie.releaseDate ?? "",
                    title: movie.title ?? "",
                    video: false,
                    voteAverage: movie.voteAverage,
                    voteCount: Int(0)
                )
            }
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }

         
    
    func deleteMovie(m: Movie) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        let predicate = NSPredicate(format: "title = %@", m.title)
        fetchRequest.predicate = predicate
       
        do{
           let movies = try context.fetch(fetchRequest)
        
            context.delete(movies.first!)

        }catch let error{
            print(error.localizedDescription)
        }
        
       
        do {
            try context.save()
            print("Movie Deleted!")
        } catch let error {
            print("Error deleting movie: \(error.localizedDescription)")
        }
    }


    func addMovieTOFAV(m: Movie) {
        let context = persistentContainer.viewContext
        guard let movieEntity = NSEntityDescription.entity(forEntityName: "FAV", in: context) else {
            fatalError("Failed to find entity ")
        }
        let movie = NSManagedObject(entity: movieEntity, insertInto: context)
       
        movie.setValue(m.title , forKey: "title")
        movie.setValue(m.voteAverage, forKey: "voteAverage")
        movie.setValue(m.releaseDate, forKey: "releaseDate")
        movie.setValue(m.overview, forKey: "overview")
        movie.setValue(m.posterPath , forKey: "posterPath")
        movie.setValue(m.backdropPath, forKey: "backdropPath")
print("Movie is added")
        
        saveContext()
    }
   

    func fetchMoviesFromFAV () -> [Movie] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FAV")
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let movies = result as? [FAV] else {
                return []
            }
            return movies.map { movie in
                Movie(
                    adult: false,
                    backdropPath: movie.backdropPath ?? "",
                    genreIDS: [],
                    id: 0,
                    originalLanguage: "",
                    originalTitle: "",
                    overview: movie.overview ?? "",
                    popularity: 0.0,
                    posterPath: movie.posterPath ?? "",
                    releaseDate: movie.releaseDate ?? "",
                    title: movie.title ?? "",
                    video: false,
                    voteAverage: movie.voteAverage,
                    voteCount: Int(0)
                )
            }
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }

         
    
    func deleteMovieFromFAV(m: Movie) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FAV")
        let predicate = NSPredicate(format: "title = %@", m.title)
        fetchRequest.predicate = predicate
       
        do{
           let movies = try context.fetch(fetchRequest)
        
            context.delete(movies.first!)

        }catch let error{
            print(error.localizedDescription)
        }
        
       
        do {
            try context.save()
            print("Movie Deleted!")
        } catch let error {
            print("Error deleting movie: \(error.localizedDescription)")
        }
    }


}
