//
//  MovieDeatilViewController.swift
//  PFE_6511483
//
//  Created by Swan Nay Phue Aung on 02/10/2024.
//

import UIKit
import AVFoundation
import AVKit
import WebKit
import Kingfisher

class MovieDeatilViewController: UIViewController {

    
    //MARK: - Variables
    private var movie : MovieModel? = nil
    private var movieDetailStack : UIStackView? = nil

    
    //MARK: - UI Components

       private let scrollView : UIScrollView = {
            let scrollView = UIScrollView()
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           scrollView.isScrollEnabled = true
             return scrollView
         }()
         
         private let contentView : UIView = {
             let contentView = UIView()
             contentView.translatesAutoresizingMaskIntoConstraints = false
             return contentView
         }()
       
    
    private let movieImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
      
    private var movieImage : UIImageView = {
        let albumImage = UIImageView()
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        albumImage.clipsToBounds = true
        albumImage.layer.cornerRadius = 15
        return albumImage
    }()
    
       
    private var playButton: UIButton = {
        let playButton = UIButton(type: .system)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        playButton.tintColor = .white
        playButton.setTitleColor(.white, for: .normal)
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        return playButton
    }()
    
       private var movieTitle : UILabel = {
           let label = UILabel()
           label.textAlignment = .left
           label.tintColor = .gray
           label.numberOfLines = 0
           label.textAlignment = .center
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Unknown"
           label.font = .systemFont(ofSize: 18, weight: .medium)
           return label
       }()
       
   
  
    
    private var movieGenere : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .semibold)
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        return title
    }()
    
    private var movieDate : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .semibold)
        title.textColor = .gray
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    
    private var movieRuntime : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .semibold)
        title.textColor = .gray
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    
    private var movieDescription : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .semibold)
        title.textColor = .gray
        title.numberOfLines = 1000
        return title
    }()
    
       
    
    
   
       
       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .white
         
           navigationItem.largeTitleDisplayMode = .always
         
           setUpUI()
           setUpConstrains()

          
          
       }
       
   
       
    
    public func passDate(movie : MovieModel) {
        self.movie  = movie
        self.movieTitle.text = movie.title_en
        self.movieGenere.text = movie.genre
        self.movieDescription.text = movie.synopsis_en
        DispatchQueue.main.async {
            if movie.widescreen_url == nil || movie.widescreen_url!.isEmpty {
                self.movieImage.backgroundColor = .gray
                self.playButton.setTitle("Trailer not available", for: .normal)  
                self.playButton.setTitleColor(.black, for: .normal)
                self.playButton.isEnabled = false
            } else {
                if let posterURL = URL(string: movie.widescreen_url ?? "") {
                    self.movieImage.kf.setImage(with: posterURL)
                    self.movieImage.backgroundColor = .clear
                }
            }
            self.movieDate.text = "Release Date\n \(movie.release_date)"
            self.movieRuntime.text = "Runtime \n \(movie.duration) mins"
        }
    }
    
       
    fileprivate func setUpUI() {
        let movieReleaseDateStack = UIStackView(arrangedSubviews: [movieDate, movieRuntime])
        movieReleaseDateStack.axis = .horizontal
        movieReleaseDateStack.spacing = 35
        movieReleaseDateStack.translatesAutoresizingMaskIntoConstraints = false
        movieImageContainer.addSubview(movieImage)
        movieImageContainer.addSubview(playButton)

        movieDetailStack = UIStackView(arrangedSubviews: [movieImageContainer, movieTitle, movieGenere, movieReleaseDateStack, movieDescription])
        
        movieDetailStack?.axis = .vertical
        movieDetailStack?.alignment = .center
        movieDetailStack?.spacing = 20
        movieDetailStack?.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(movieDetailStack!)
       
              

        NSLayoutConstraint.activate([
            
            
            movieImageContainer.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            movieImageContainer.heightAnchor.constraint(equalToConstant: 200),
            
            movieImage.leadingAnchor.constraint(equalTo: movieImageContainer.leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: movieImageContainer.trailingAnchor),
            movieImage.heightAnchor.constraint(equalToConstant: 200),
            movieImage.widthAnchor.constraint(equalTo: movieImageContainer.widthAnchor),
            
            playButton.centerXAnchor.constraint(equalTo: movieImageContainer.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: movieImageContainer.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50), // Adjust size as needed
            playButton.heightAnchor.constraint(equalToConstant: 50) ,
            
            
            movieDetailStack!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            movieDetailStack!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            movieDetailStack!.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieDetailStack!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

      
    fileprivate func setUpConstrains(){
        
        NSLayoutConstraint.activate([

        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
        
        
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        
        
        
        
        ])
        
    }

    @objc private func playVideo() {
        // URL of the video to be played
        if let movieURL = movie?.tr_mp4,let  url = URL(string: movieURL) {
            print("Video URL: \(url)")

            // Create an AVPlayer
            let player = AVPlayer(url: url)
            
            // Create an AVPlayerViewController and pass the player to it
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            // Present the AVPlayerViewController
            present(playerViewController, animated: true) {
                // Automatically start the video playback once the player is ready
                player.play()
            }
        }
    }
    
}
