//
//  ImageCell.swift
//  ImageViewer
//
//  Created by Alexey Baryshnikov on 19/09/2019.
//  Copyright © 2019 Alexey Baryshnikov. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.addSubview(pictureNumber)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        return activityIndicator
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var pictureNumber: UILabel = {
        let pictureNumber = UILabel(frame: CGRect(x: 100, y: 30, width: UIScreen.main.bounds.width, height: 40))
        pictureNumber.textAlignment = .left
        pictureNumber.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return pictureNumber
    }()
    
    func set(image: UIImage?) {
        imageView.image = image
        
        if image == nil {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func setupView() {
        backgroundColor = .lightGray
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        clipsToBounds = true
        
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerY = imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let widthConstraint = imageView.widthAnchor.constraint(equalTo: self.widthAnchor)
        let heigthConstraint = imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([centerX, centerY, widthConstraint, heigthConstraint])
        
        addSubview(pictureNumber)
        pictureNumber.translatesAutoresizingMaskIntoConstraints = false
        let bottomText = pictureNumber.bottomAnchor.constraint(equalTo: imageView.topAnchor)
        NSLayoutConstraint.activate([bottomText])
        
        let stack = UIStackView(arrangedSubviews: [imageView, pictureNumber])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 6
        addSubview(stack)
    }
}
