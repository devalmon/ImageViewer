//
//  ImageCell.swift
//  ImageViewer
//
//  Created by Alexey Baryshnikov on 19/09/2019.
//  Copyright © 2019 Alexey Baryshnikov. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class ImageCell: UICollectionViewCell {
    
    private var imageDataTask: URLSessionDataTask?
    private static var cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "unsplash")
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
    
        let centerX = imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerY = imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let widthConstraint = imageView.widthAnchor.constraint(equalTo: self.widthAnchor)
        let heigthConstraint = imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([centerX, centerY, widthConstraint, heigthConstraint])
        
        addSubview(numberLabel)
        
        let bottomText = numberLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor)
        NSLayoutConstraint.activate([bottomText])
    }
    
    func downloadPhoto(photo: UnsplashPhoto) {
        guard let url = photo.urls[.regular] else { return }
        
        if let cachedResponse = ImageCell.cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {
            imageView.image = image
            return
        }
        
        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }
            
            strongSelf.imageDataTask = nil
            
            guard let data = data, let image = UIImage(data: data), error == nil else { return }
            
            DispatchQueue.main.async {
                UIView.transition(with: strongSelf.imageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.imageView.image = image
                }, completion: nil)
            }
        }
        
        imageDataTask?.resume()
    }
}

