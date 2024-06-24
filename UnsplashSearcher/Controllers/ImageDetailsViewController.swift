//
//  ImageDetailsViewController.swift
//  UnsplashSearcher
//
//  Created by Rexhep Kelmendi on 19.5.24.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 14)
         label.numberOfLines = 0
         label.textColor = .black
         return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    func configure(with image: Image) {
        let url =  image.urls.full
        customImageView.load(imgURL: url)
        descriptionLabel.text = image.description ?? ""
    }

    private func setupLayout() {
        [customImageView, descriptionLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            customImageView.heightAnchor.constraint(equalToConstant: 400),
            customImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
}
