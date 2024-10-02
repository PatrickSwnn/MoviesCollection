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

class CinemaDetailViewController: UIViewController {

    
    //MARK: - Variables
    private var cinema : CinemaModel? = nil
    private var cinemaDetalStack : UIStackView? = nil
    private var webView: WKWebView!
    private var webViewHeightConstraint: NSLayoutConstraint!


    
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
       
    
   
    
    private var cinemaImage : UIImageView = {
        let albumImage = UIImageView()
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        albumImage.clipsToBounds = true
        albumImage.layer.cornerRadius = 15
        return albumImage
    }()
    
       
  
    
       private var cinemaTitle : UILabel = {
           let label = UILabel()
           label.textAlignment = .left
           label.tintColor = .gray
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Unknown"
           label.font = .systemFont(ofSize: 18, weight: .medium)
           return label
       }()
       
   
  
    
    private var zoneName : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .semibold)
        title.numberOfLines = 0
        return title
    }()
    
    private var officeHours : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .regular)
        title.textColor = .gray
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    
    private var phoneNum : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .regular)
        title.textColor = .gray
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    private var cinemaDescription : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .regular)
        title.textColor = .gray
        title.numberOfLines = 1000
        return title
    }()
    
   
       
    
    
   
       
       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .white
           
         
           setUpUI()
           setUpConstrains()

          
          
       }
       
   
    
       
    
    public func passData(cinema : CinemaModel) {
        self.cinema  = cinema
        let imageName = distinguishCinemaImage
        self.cinemaImage.image = UIImage(named: imageName)
        self.cinemaTitle.text = cinema.cinema_name_en
        self.zoneName.text = cinema.zone_name_en
        if let officeHours =  cinema.cinema_office_hour_en, let phoneNum = cinema.cinema_tel {
            self.officeHours.text = "Office Hours\n \(officeHours)"
            self.phoneNum.text = "Runtime \n \(phoneNum)"
        }
    }
    
       
    
    
    var distinguishCinemaImage: String {
           guard let cinema = cinema else { return "major" } // Default case
           switch cinema.cinema_name_en {
           case "Paragon Cineplex":
               return "paragon"
           case "Icon Cineconic":
               return "icon"
           case "Quartier Cineart":
               return "emq"
           case "Imax Laser":
               return "imax"
           default:
               return "major" // For other cases
           }
       }
    
    
    
    fileprivate func setUpUI() {
        
     
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        if let htmlContent = cinema?.cinema_content_detail1 {
            webView.loadHTMLString(htmlContent, baseURL: nil)
        }
      
        webView.scrollView.isScrollEnabled = true

        
        contentView.addSubview(webView)
        let cinemaInfoStack = UIStackView(arrangedSubviews: [officeHours, phoneNum])
        cinemaInfoStack.axis = .horizontal
        cinemaInfoStack.spacing = 35
        cinemaInfoStack.translatesAutoresizingMaskIntoConstraints = false
      

        cinemaDetalStack = UIStackView(arrangedSubviews: [cinemaImage, cinemaTitle, zoneName, cinemaInfoStack, webView])
        cinemaDetalStack?.axis = .vertical
        cinemaDetalStack?.alignment = .center
        cinemaDetalStack?.spacing = 20
        cinemaDetalStack?.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cinemaDetalStack!)
        webViewHeightConstraint = webView.heightAnchor.constraint(equalTo: view.heightAnchor)
        webViewHeightConstraint.isActive = true
              

        NSLayoutConstraint.activate([
            
            
            cinemaImage.widthAnchor.constraint(equalToConstant: 50),
            cinemaImage.heightAnchor.constraint(equalToConstant: 50),

      
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -12),

            cinemaDetalStack!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            cinemaDetalStack!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            cinemaDetalStack!.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            cinemaDetalStack!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
    


    
}


extension CinemaDetailViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (height, error) in
               guard let self = self, let height = height as? CGFloat else { return }
               
               self.webViewHeightConstraint.constant = height
               self.view.layoutIfNeeded()
           }
       }
}
