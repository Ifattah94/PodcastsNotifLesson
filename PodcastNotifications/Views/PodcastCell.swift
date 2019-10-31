//
//  PodcastCell.swift
//  PodcastNotifications
//
//  Created by C4Q on 10/30/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {

  lazy var podcastImage: UIImageView = {
      let imageView = UIImageView()
      imageView.contentMode = .scaleToFill
      return imageView
  }()
  
  lazy var podcastTitleLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
      label.adjustsFontSizeToFitWidth = true
      return label
  }()
  
  lazy var hostLabel: UILabel = {
      let label = UILabel()
      label.textColor = .lightGray
      label.font = UIFont.systemFont(ofSize: 14, weight: .light)
      label.adjustsFontSizeToFitWidth = true
      return label
  }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "PodcastCell")
        setupPodcastImageView()
        setupTitleLabel()
        setupHostLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Constraint Functions
    
    private func setupPodcastImageView() {
        addSubview(podcastImage)
        podcastImage.translatesAutoresizingMaskIntoConstraints =  false
        NSLayoutConstraint.activate(
            [podcastImage.heightAnchor.constraint(equalTo: self.heightAnchor),
             podcastImage.widthAnchor.constraint(equalTo: podcastImage.heightAnchor),
             podcastImage.leadingAnchor.constraint(equalTo: self.leadingAnchor)])
        
       
    }
    
    
    private func setupTitleLabel() {
         let padding: CGFloat = 16
        addSubview(podcastTitleLabel)
        podcastTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [podcastTitleLabel.leadingAnchor.constraint(equalTo: podcastImage.trailingAnchor, constant: padding),
             podcastTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
                podcastTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)])
    }
    
    private func setupHostLabel() {
         let padding: CGFloat = 16
        addSubview(hostLabel)
        hostLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [hostLabel.leadingAnchor.constraint(equalTo: podcastTitleLabel.leadingAnchor),
             hostLabel.topAnchor.constraint(equalTo: podcastTitleLabel.bottomAnchor),
             hostLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)])
    }
    
    
    
    
    
    
    


}
