//
//  ViewController.swift
//  PFE_6511483
//
//  Created by Swan Nay Phue Aung on 02/10/2024.
//

import UIKit

class MovieViewController: UIViewController, UISearchResultsUpdating {

    
    //MARK: - Variables
    private let movieVM = MovieViewModel()
    private var filteredMovies: [MovieModel] = []
    private var isSearching = false

    
    //MARK: - UIComponents
    private let collectionView: UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .vertical
         layout.minimumInteritemSpacing = 12
         layout.minimumLineSpacing = 12
         layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
         
         
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         collectionView.showsHorizontalScrollIndicator = false
         return collectionView
     }()
     
    
    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Now Showing", "Upcoming"])
        sc.selectedSegmentIndex = 0 // Default selection
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    
    private let searchController = UISearchController(searchResultsController: nil)

    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        movieVM.onMoviesUpdate = {
            self.collectionView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Minor Cineplex"
        navigationController?.navigationBar.prefersLargeTitles = true
              
        navigationItem.largeTitleDisplayMode = .always
        
        
        view.backgroundColor = .white
        view.addSubview(segmentedControl)

        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

         collectionView.delegate = self
        collectionView.dataSource = self
               collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.movieCellIdentifier)
               setUpUI()
               setUpConstrains()
        collectionView.reloadData()

        movieVM.onMoviesUpdate = {
            self.collectionView.reloadData()
        }
        setupSearchController()

        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
           guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
               isSearching = false
               collectionView.reloadData()
               return
           }
           
           isSearching = true
           if segmentedControl.selectedSegmentIndex == 0 {
               filteredMovies = movieVM.nowShowingMovies.filter { $0.title_en.lowercased().contains(searchText.lowercased()) }
           } else {
               filteredMovies = movieVM.upcomingMovies.filter { $0.title_en.lowercased().contains(searchText.lowercased()) }
           }
           collectionView.reloadData()
       }
    
    fileprivate func setUpUI() {
          view.addSubview(collectionView)
      }
      
    fileprivate func setUpConstrains() {
           NSLayoutConstraint.activate([
           
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
               collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
               collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8),
               collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8),
               collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -8)
//               collectionView.heightAnchor.constraint(equalToConstant: 220),
               
             

           
           
           ])
       }

    @objc private func segmentedControlChanged() {
        collectionView.reloadData() // Reload collection view to reflect changes
    }
    
    private func setupSearchController() {
         searchController.searchResultsUpdater = self
         searchController.obscuresBackgroundDuringPresentation = false
         searchController.searchBar.placeholder = "Search Movies"
         navigationItem.searchController = searchController
         definesPresentationContext = true
     }
    
    

}


extension MovieViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if isSearching {
             return filteredMovies.count
         }
         if segmentedControl.selectedSegmentIndex == 0 {
             return movieVM.nowShowingMovies.count
         } else {
             return movieVM.upcomingMovies.count
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.movieCellIdentifier, for: indexPath) as! MovieCell
        
        // Use correct data source based on the search state
        let movie: MovieModel
        if isSearching {
            movie = filteredMovies[indexPath.row]
        } else {
            if segmentedControl.selectedSegmentIndex == 0 {
                movie = movieVM.nowShowingMovies[indexPath.row]
            } else {
                movie = movieVM.upcomingMovies[indexPath.row]
            }
        }
        cell.configure(movie: movie)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 170, height: 300)
       }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let detailVC = MovieDeatilViewController()
           let movie: MovieModel
           if isSearching {
               movie = filteredMovies[indexPath.row]
           } else {
               if segmentedControl.selectedSegmentIndex == 0 {
                   movie = movieVM.nowShowingMovies[indexPath.row]
               } else {
                   movie = movieVM.upcomingMovies[indexPath.row]
               }
           }
           detailVC.passDate(movie: movie)
           present(detailVC, animated: true, completion: nil)
       }
        
      
    }


