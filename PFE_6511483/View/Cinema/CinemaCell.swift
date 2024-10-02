

import UIKit
import Foundation

class CinemaCell: UITableViewCell {
    
    //MARK: -Variables
    static let cellIdentifier = "CinemaCell"
    var cinema : CinemaModel? = nil
    private var isHeartSelected: Bool = false // Renamed variable

    
    //MARK: - UIComponents
    
    private var movieImage : UIImageView = {
        let albumImage = UIImageView()
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        albumImage.clipsToBounds = true
        return albumImage
    }()
    
    
    private var cinemaName : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.tintColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Unknown"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private var zoneName : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.tintColor = .gray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Unknown"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    
    private var button : UIButton = {
          let button = UIButton()
           button.tintColor = UIColor.systemPink
           button.translatesAutoresizingMaskIntoConstraints = false
           button.isUserInteractionEnabled = true
        button.backgroundColor = .clear // Set to clear or any color you want
         button.tintColor = UIColor.systemPink //
           button.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
           return button
       }()
    
    
    //MARK: -Life Cycle Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not implemented ")
    }
    
    public func configure(cinema: CinemaModel) {
        self.cinema = cinema
        let imageName = distinguishCinemaImage
        self.movieImage.image = UIImage(named: imageName)
        self.cinemaName.text = cinema.cinema_name_en
        self.zoneName.text = cinema.zone_name_en
        checkIfAlbumIsSaved()  // Check if this cinema is a favorite
        updateHeartState()      // Update the button image based on the heart state
    }
    
    
    
    //MARK: - Set up UI
    private func setUpUI() {
        
        // Create Vertical Stack
               let verticalStack = UIStackView(arrangedSubviews: [cinemaName, zoneName])
               verticalStack.axis = .vertical
               verticalStack.spacing = 4 // Adjust spacing as needed
               verticalStack.translatesAutoresizingMaskIntoConstraints = false
               
               // Create Horizontal Stack
               let horizontalStack = UIStackView(arrangedSubviews: [movieImage, verticalStack, button])
               horizontalStack.axis = .horizontal
               horizontalStack.spacing = 12 // Adjust spacing as needed
               horizontalStack.translatesAutoresizingMaskIntoConstraints = false
               
               // Add horizontal stack to the cell's contentView
               contentView.addSubview(horizontalStack)
        
      
        
        NSLayoutConstraint.activate([
//                   horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                   horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                   horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                   horizontalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//                   horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                   
                   
                   // Image Constraints
                   movieImage.widthAnchor.constraint(equalToConstant: 45), // Set the width as per your design
                   movieImage.heightAnchor.constraint(equalToConstant: 45), // Set the height as per your design
                   
                   button.widthAnchor.constraint(equalToConstant: 44), // Width of the button
                   button.heightAnchor.constraint(equalToConstant: 44) // Height of the button
        ])
    }
    
    var distinguishCinemaImage: String {
           guard let cinema = cinema else { return "major" } // Default case
           switch cinema.brand_name_en {
           case "Paragon Cineplex":
               return "paragon"
           case "ICON CINECONIC":
               return "icon"
           case "Quartier CineArt":
               return "emq"
           case "IMAX Laser":
               return "imax"
           default:
               return "major" // For other cases
           }
       }
    
    
    
    @objc private func heartTapped() {
           print("Button tapped")
           isHeartSelected.toggle()
           updateHeartState()
           print(isHeartSelected)
           
           if let cinema = cinema {
                      if isHeartSelected {
                          saveAlbumToUserDefaults(cinema: cinema)
                      } else {
                          removeAlbumFromUserDefaults(cinema: cinema)
                      }
                  }
       }
       
    
    fileprivate func updateHeartState(){
          if isHeartSelected {
              button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
          } else {
              button.setImage(UIImage(systemName: "heart"), for: .normal)

          }
      }
    
       private func saveAlbumToUserDefaults(cinema: CinemaModel) {
           let defaults = UserDefaults.standard
           let encoder = JSONEncoder()
           
           // Fetch the current array of albums from UserDefaults
           if let savedData = defaults.data(forKey: "selectedAlbums"),
              var savedCinemas = try? JSONDecoder().decode([CinemaModel].self, from: savedData) {
               
               // Append the new album if it's not already saved
               if !savedCinemas.contains(where: { $0.cinema_id == cinema.cinema_id }) {
                   savedCinemas.append(cinema)
               }
               
               // Encode the updated array and save it back to UserDefaults
               if let encodedAlbums = try? encoder.encode(savedCinemas) {
                   defaults.set(encodedAlbums, forKey: "selectedAlbums")
                   print("Album added to UserDefaults: \(cinema)")
               }
               
           } else {
               // If no albums are saved yet, create a new array with the current album
               let newAlbumArray = [cinema]
               if let encodedAlbums = try? encoder.encode(newAlbumArray) {
                   defaults.set(encodedAlbums, forKey: "selectedAlbums")
                   print("First album saved to UserDefaults: \(cinema)")
               }
           }
       }


       private func removeAlbumFromUserDefaults(cinema: CinemaModel) {
           let defaults = UserDefaults.standard
           
           // Fetch the current array of albums from UserDefaults
           if let savedData = defaults.data(forKey: "selectedAlbums"),
              var savedAlbums = try? JSONDecoder().decode([CinemaModel].self, from: savedData) {
               
               // Remove the album by its id
               savedAlbums.removeAll(where: { $0.cinema_id == cinema.cinema_id }) // assuming AlbumModel has an `id`
               
               // Encode the updated array and save it back to UserDefaults
               let encoder = JSONEncoder()
               if let encodedAlbums = try? encoder.encode(savedAlbums) {
                   defaults.set(encodedAlbums, forKey: "selectedAlbums")
                   print("Album removed from UserDefaults: \(cinema)")
               }
               
           }
       }

       
       private func checkIfAlbumIsSaved() {
              guard let cinema = cinema else { return }

              let defaults = UserDefaults.standard
              if let savedData = defaults.data(forKey: "selectedAlbums"),
                 let savedAlbums = try? JSONDecoder().decode([CinemaModel].self, from: savedData) {
                  isHeartSelected = savedAlbums.contains(where: { $0.cinema_id == cinema.cinema_id })
              }
          }
    
    
}
