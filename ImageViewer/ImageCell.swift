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
//        imageView.layer.borderColor = UIColor.orange.cgColor
//        imageView.layer.borderWidth = 1
        
        return imageView
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name:"AvenirNext-Bold", size: 15.0)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        label.textColor = .white
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.red.cgColor
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
        
//        backgroundColor = .lightGray
//        layer.borderColor = UIColor.black.cgColor
//        layer.borderWidth = 1
//        layer.cornerRadius = 4
        clipsToBounds = true
        
        
        addSubview(imageView)
        imageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)

        addSubview(numberLabel)
        numberLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))

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

