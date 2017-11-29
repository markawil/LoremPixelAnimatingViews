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
    var isFirstLaunchScroll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "LoremPixel"
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let size = (self.view.bounds.width/2.0) - 5
        layout.itemSize = CGSize(width: size, height: size)
        
        isFirstLaunchScroll = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
//        let width = Int(cell.frame.size.width)
//        let url = URL(string: "http://lorempixel.com/\(width)/\(width)")!
//        cell.imageView.fkb_setImageWithURL(url: url, placeholder: nil)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lastSelectedIndexPath = indexPath
        
        let navBar = navigationController!.navigationBar
        if isAnimatingBack == false && navBar.alpha < 1.0 {
            isAnimatingBack = true
            UIView.animate(withDuration: 0.5, animations: {
                navBar.alpha = 1.0
            }, completion: { (finished) in
                self.isAnimatingBack = false
            })
        }
         self.showDetailVC(forIndexPath: indexPath)
    }
    
    func showDetailVC(forIndexPath indexPath: IndexPath) {
        
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let cell = self.collectionView!.cellForItem(at: indexPath) as! ImageCell
        let image = cell.imageView.image
        detailVC.image = image
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isFirstLaunchScroll = false
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

        scrollViewScrolledForTranslucentNavBar(scrollView)
        //scrollViewScrolledForOpaqueNavBar(scrollView)
    }
    
    func scrollViewScrolledForTranslucentNavBar(_ scrollView: UIScrollView) {
        
        if let validNavBar = self.navigationController?.navigationBar, let validTabBar = self.tabBarController?.tabBar {
            if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0)
            {
                // scrolling upward
                if isAnimatingBack == false && (validNavBar.alpha == 0.0) {
                    isAnimatingBack = true
                    UIView.animate(withDuration: 0.5, animations: {
                        validNavBar.alpha = 1.0
                        validTabBar.alpha = 1.0
                    }, completion: { (finished) in
                        if finished {
                            self.isAnimatingBack = false
                            print("finished animating back into view")
                        }
                    })
                }
            }
            else if !isFirstLaunchScroll {
                // scrolling downward
                if isAnimatingAway == false && (validNavBar.alpha == 1.0) {
                    isAnimatingAway = true
                    UIView.animate(withDuration: 0.5, animations: {
                        validNavBar.alpha = 0.0
                        validTabBar.alpha = 0.0
                    }, completion: { (finished) in
                        if finished {
                            self.isAnimatingAway = false
                            print("finished animating away")
                        }
                    })
                }
            }
        }
    }
    
    func scrollViewScrolledForOpaqueNavBar(_ scrollView: UIScrollView) {
        
        if let validNavController = self.navigationController, let validTabBar = self.tabBarController?.tabBar {
            
            var updatedTabBarFrame = validTabBar.frame
            
            if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0)
            {
                // show the bars again
                validNavController.setNavigationBarHidden(false, animated: true)
                updatedTabBarFrame.origin.y = validNavController.view.frame.height - updatedTabBarFrame.height
                if isAnimatingBack == false && (validTabBar.frame.origin.y != updatedTabBarFrame.origin.y) {
                    isAnimatingBack = true
                    UIView.animate(withDuration: 0.5, animations: {
                        validTabBar.frame = updatedTabBarFrame
                    }, completion: { (finished) in
                        if validTabBar.frame.origin.y == updatedTabBarFrame.origin.y {
                            self.isAnimatingBack = false
                            print("finished animating back into view")
                        }
                    })
                }
            }
            else if !isFirstLaunchScroll {
                // scrolling downward
                validNavController.setNavigationBarHidden(true, animated: true)
                updatedTabBarFrame.origin.y = validNavController.view.frame.height + updatedTabBarFrame.height
                if isAnimatingAway == false && (validTabBar.frame.origin.y != updatedTabBarFrame.origin.y) {
                    isAnimatingAway = true
                    UIView.animate(withDuration: 0.5, animations: {
                        validTabBar.frame = updatedTabBarFrame
                    }, completion: { (finished) in
                        if validTabBar.frame.origin.y == updatedTabBarFrame.origin.y {
                            self.isAnimatingAway = false
                            print("finished animating away")
                        }
                    })
                }
            }
        }
    }
}
