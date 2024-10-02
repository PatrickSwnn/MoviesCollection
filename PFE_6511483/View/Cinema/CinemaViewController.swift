


import Foundation
import UIKit

class CinemaViewController : UIViewController,UISearchResultsUpdating {
  
    
    private var cinemaVM = CinemaViewModel()
    private var isSearching = false
    private var filteredCinemas: [CinemaModel] = []
    private var favouriteCinemas : [CinemaModel] = []


    
    //MARK: -UI Components
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(CinemaCell.self, forCellReuseIdentifier: CinemaCell.cellIdentifier)
        return tableView
    }()
    
    
    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Cinemas", "Favourite Cinemas"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        view.backgroundColor = .white
        navigationItem.title = "Cinemas"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        tableView.delegate = self
        tableView.dataSource = self
        setUpUI()
    }


    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        favouriteCinemas = retrieveSavedCinemas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    //MARK: -UI Set Up
    private func setUpUI() {
        self.view.addSubview(tableView)
        view.addSubview(segmentedControl)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        NSLayoutConstraint.activate([
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.reloadData()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
           guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
               isSearching = false
               tableView.reloadData()
               return
           }
           
           isSearching = true
        if segmentedControl.selectedSegmentIndex == 0, let cinemas = cinemaVM.cinemas {
               filteredCinemas = cinemas.filter { $0.brand_name_en.lowercased().contains(searchText.lowercased()) }
           } else {
               let
               filteredMovies = favouriteCinemas.filter { $0.brand_name_en.lowercased().contains(searchText.lowercased()) }
           }
           tableView.reloadData()
       }
    
    
   

    
    private func setupSearchController() {
         searchController.searchResultsUpdater = self
         searchController.obscuresBackgroundDuringPresentation = false
         searchController.searchBar.placeholder = "Search Cinemas"
         navigationItem.searchController = searchController
         definesPresentationContext = true
     }
    
    @objc private func segmentedControlChanged() {
        tableView.reloadData()
    }
}

extension CinemaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCinemas.count
        } else {
            if segmentedControl.selectedSegmentIndex == 0 {
                return cinemaVM.cinemas?.count ?? 0
            } else {
                return favouriteCinemas.count
            }
            
        }
    }
    
   
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CinemaCell.cellIdentifier, for: indexPath) as! CinemaCell
        if isSearching {
            cell.configure(cinema: filteredCinemas[indexPath.row])
        } else {
            if segmentedControl.selectedSegmentIndex == 0 {
                guard let cinema = cinemaVM.cinemas?[indexPath.row] else { return cell }
                cell.configure(cinema: cinema)
            } else {
                let favCinema = favouriteCinemas[indexPath.row]
                cell.configure(cinema: favCinema)
            }
        }
        
        return cell
      
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = CinemaDetailViewController()
        
        if isSearching {
            detailVC.passData(cinema: filteredCinemas[indexPath.row])
        } else {
            if segmentedControl.selectedSegmentIndex == 0 {
                guard let cinema = cinemaVM.cinemas?[indexPath.row] else { return }
                detailVC.passData(cinema: cinema)
            } else {
                let favCinema = favouriteCinemas[indexPath.row]
                detailVC.passData(cinema: favCinema)
            }
        }
        
            present(detailVC, animated: true, completion: nil)
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    private func retrieveSavedCinemas() -> [CinemaModel] {
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "selectedAlbums"),
           let savedAlbums = try? JSONDecoder().decode([CinemaModel].self, from: savedData) {
            return savedAlbums
        }
        return []
    }
}
