//
//  ViewController.swift
//  ImageViewer
//
//  Created by Alexey Baryshnikov on 19/09/2019.
//  Copyright © 2019 Alexey Baryshnikov. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

enum SelectionType: Int {
    case single
    case multiple
}
private let reuseIdentifier = "cell"

class ViewController: UICollectionViewController {

    var selectionTypeSegmentedControl = UISegmentedControl()
    var bottomSheet = UIView()
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    private var images = [UIImage]()
    var totalImages = 0
    var selectedImage: (row: Int, imageView: ImageFullScreenVC)?
    
    let activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    let imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
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
    
    func setupImage() {
        self.imageView.addSubview(numberLabel)
        numberLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        numberLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 5).isActive = true
        numberLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -5).isActive = true
    }
    
    func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let homeCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        homeCollectionView.backgroundColor = .white
        view.addSubview(homeCollectionView)
    }
    
    func registerCell() {
        self.collectionView!.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func setImagesArray() {
        images = [UIImage(named: "1.jpg"), UIImage(named: "2.jpg"), UIImage(named: "3.jpg"), UIImage(named: "4.jpg"), UIImage(named: "5.jpg")] as! [UIImage]
    }
    
    func setTotalImages() {
        totalImages = images.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCollectionView()
        registerCell()
        setImagesArray()
        setTotalImages()
        
        navigationItem.title = "Images: \(totalImages)"
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return totalImages
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        cell.set(image: nil)
        cell.imageView.image = images[indexPath.row]
        cell.pictureNumber.text = String(indexPath.row + 1)
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageFullScreenVC = ImageFullScreenVC()
        let image = (collectionView.cellForItem(at: indexPath) as! ImageCell).imageView.image
        imageFullScreenVC.set(image: image)
        selectedImage = (indexPath.row, imageFullScreenVC)

        navigationController?.pushViewController(imageFullScreenVC, animated: true)
    }
    
    @objc func presentUnsplashPhotoPicker(sender: AnyObject?) {
        let allowsMultipleSelection = selectionTypeSegmentedControl.selectedSegmentIndex == SelectionType.multiple.rawValue
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "cd6ac1623c39cfce21be8f06ebe60713c0f510dbaaf986b8b8154c7d5c5cbcbe",
            secretKey: "dab6c4318fae59961348e3fd864f4db7592445d3a59bdcb0f005281ed977a1c2",
            allowsMultipleSelection: allowsMultipleSelection
        )
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = self as? UnsplashPhotoPickerDelegate
        
        present(unsplashPhotoPicker, animated: true, completion: nil)
    }
    
}
