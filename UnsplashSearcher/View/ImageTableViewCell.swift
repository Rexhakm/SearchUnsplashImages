//
//  ImageTableViewCell.swift
//  UnsplashSearcher
//
//  Created by Rexhep Kelmendi on 18.5.24.
//

import Foundation
import UIKit

class ImageTableViewCell: UITableViewCell {
    
    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(customImageView)
        
        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            customImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customImageView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func configure(cell with: Image) {
        let url =  with.urls.full
        customImageView.load(imgURL: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
