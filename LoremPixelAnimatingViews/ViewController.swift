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

    var lastSelectedIndexPath: IndexPath?
    var isAnimatingAway: Bool = false
    var isAnimatingBack: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "LoremPixel"
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let size = (self.view.bounds.width/2.0) - 5
        layout.itemSize = CGSize(width: size, height: size)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        let width = Int(view.frame.size.width) * 2
        let url = URL(string: "http://lorempixel.com/\(width)/\(width)")!
        cell.imageView.fkb_setImageWithURL(url: url, placeholder: nil)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lastSelectedIndexPath = indexPath
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetails" {
            let selected = collectionView?.indexPathsForSelectedItems
            guard let indexPath = selected?.first else { return }
            
            let cell = collectionView!.cellForItem(at: indexPath) as! ImageCell
            let image = cell.imageView.image
            let detailsVC = segue.destination as! DetailViewController
            detailsVC.image = image
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            let animator = Animator()
            animator.presenting = true
            return animator
        } else {
            return nil
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let validNavController = self.navigationController {
            if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0)
            {
                // scrolling upward, (or scrolling down to see more cells)
                if isAnimatingBack == false && validNavController.navigationBar.isHidden == true {
                    isAnimatingBack = true
                    validNavController.setNavigationBarHidden(false, animated: true)
                } else {
                    isAnimatingBack = false
                }
            }
            else {
                // scrolling downward (or scrolling back up to the top cells)
                if isAnimatingAway == false && validNavController.navigationBar.isHidden == false {
                    isAnimatingAway = true
                    validNavController.setNavigationBarHidden(true, animated: true)
                } else {
                    // it's done hiding
                    isAnimatingAway = false
                }
            }
        }
    }
}

