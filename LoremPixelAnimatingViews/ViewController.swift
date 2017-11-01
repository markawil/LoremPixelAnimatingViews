//
//  ViewController.swift
//  LoremPixelAnimatingViews
//
//  Created by Mark Wilkinson on 10/31/17.
//  Copyright © 2017 Mark Wilkinson. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UICollectionViewController, UINavigationControllerDelegate {

    var lastSelectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "LoremPixel"
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let size = (self.view.bounds.width/2.0) - 5
        layout.itemSize = CGSize(width: size, height: size)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        let width = Int(view.frame.size.width) * 2
        let url = URL(string: "http://lorempixel.com/\(width)/\(width)")!
        cell.imageView.fkb_setImageWithURL(url: url, placeholder: nil)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }
}

