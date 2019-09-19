//
//  ViewController.swift
//  ImageViewer
//
//  Created by Alexey Baryshnikov on 19/09/2019.
//  Copyright © 2019 Alexey Baryshnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var images = [UIImage]()
    var totalImages = 0
    var selectedImage: (row: Int, imageView: ImageFullScreenVC)?
    
    let activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = [UIImage(named: "1.jpg"), UIImage(named: "2.jpg"), UIImage(named: "3.jpg"), UIImage(named: "4.jpg"), UIImage(named: "5.jpg")] as! [UIImage]
        totalImages = images.count
        navigationItem.title = "Images: \(totalImages)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let homeCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        homeCollectionView.backgroundColor = .white
        view.addSubview(homeCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.imageView.image = images[indexPath.row]
        cell.pictureNumber.text = String(indexPath.row + 1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageFullScreenVC = ImageFullScreenVC()
        let image = (collectionView.cellForItem(at: indexPath) as! ImageCell).imageView.image
        imageFullScreenVC.set(image: image)
        selectedImage = (indexPath.row, imageFullScreenVC)
        navigationController?.pushViewController(imageFullScreenVC, animated: true)
    }

}

