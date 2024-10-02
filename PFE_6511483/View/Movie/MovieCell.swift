//
//  MovieCell.swift
//  PFE_6511483
//
//  Created by Swan Nay Phue Aung on 02/10/2024.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    
    
    private (set) var movie : MovieModel? = nil
    static let movieCellIdentifier = "MovieCell"
    
    //MARK: - UI Components
    private var movieImage : UIImageView = {
        let albumImage = UIImageView()
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        albumImage.clipsToBounds = true
        albumImage.layer.cornerRadius = 15
        return albumImage
    }()
    
    
    private var movieDate : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .semibold)
        title.textColor = .gray
        title.numberOfLines = 0
        title.lineBreakMode = .byTruncatingTail
        return title
    }()
    
    private var movieTitle : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        return title
    }()
    
    private var movieGenere : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .semibold)
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        return title
    }()
    
    
    private var movieStack : UIStackView = {
      let movieStack = UIStackView()
       movieStack.axis = .vertical
        movieStack.spacing = 4
       movieStack.alignment = .leading
       movieStack.translatesAutoresizingMaskIntoConstraints = false
        return movieStack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(movie : MovieModel){
        self.movie = movie
        if let posterURL = URL(string: movie.poster_url) {
            movieImage.kf.setImage(with: posterURL)
        }
        movieDate.text = movie.release_date
        movieTitle.text = movie.title_en
        movieGenere.text = movie.genre
    }
    
    //MARK: - Set Up UI
    fileprivate func setUpUI() {
        
        
        // Stack for movie cell
         movieStack = UIStackView(arrangedSubviews: [movieImage, movieDate,movieTitle,movieGenere])
        movieStack.axis = .vertical
        movieStack.alignment = .leading
        movieStack.spacing = 4
        movieStack.distribution = .equalCentering
        movieStack.translatesAutoresizingMaskIntoConstraints = false
      
        
        contentView.addSubview(movieStack)

        
       
    }
    
    
    fileprivate func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            movieStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            movieImage.widthAnchor.constraint(equalToConstant: 160),
            movieImage.heightAnchor.constraint(equalToConstant: 200),
//
//            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor),
//            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

//            
//            movieDate.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 12),
//            movieDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            movieDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            
//            movieTitle.topAnchor.constraint(equalTo: movieDate.bottomAnchor, constant: 12),
//            movieTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            movieTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//
//            
//            movieGenere.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 12),
//            movieGenere.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            movieGenere.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            movieGenere.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
}
