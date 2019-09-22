//
//  ImageFullScreenVC.swift
//  ImageViewer
//
//  Created by Alexey Baryshnikov on 19/09/2019.
//  Copyright © 2019 Alexey Baryshnikov. All rights reserved.
//

import UIKit

class ImageFullScreenVC: UIViewController {
    
    var timer: Timer?
    let countdownSeconds: Double = 5
    
    let activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    let imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
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

        view.addSubview(imageView)
        
        let centerX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let centerY = imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = imageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        let heightConstraint = imageView.heightAnchor.constraint(equalTo: view.heightAnchor)
        NSLayoutConstraint.activate([centerX, centerY, widthConstraint, heightConstraint])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
        timer = Timer.scheduledTimer(timeInterval: countdownSeconds, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: false)

    }
    
    @objc func timerAction() {
        if timer != nil {
            timer?.invalidate()
            navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        print("Fullscreen deinited")
    }
}
