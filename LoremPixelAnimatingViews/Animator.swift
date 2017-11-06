//
//  Animator.swift
//  LoremPixelAnimatingViews
//
//  Created by Mark Wilkinson on 10/31/17.
//  Copyright © 2017 Mark Wilkinson. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    var presenting = false
    
    // This is used for percent driven interactive transitions, as well as for
    // container controllers that have companion animations that might need to
    // synchronize with the main animation.
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if presenting {
            animatePush(transitionContext: transitionContext)
        } else {
            animatePop(transitionContext: transitionContext)
        }
    }
    
    func getCellImageView(_ viewController: ViewController) -> UIImageView {
        
        let indexPath = viewController.lastSelectedIndexPath!
        let cell = viewController.collectionView!.cellForItem(at: indexPath) as! ImageCell
        
        return cell.imageView
    }
    
    func animatePush(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! ViewController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! DetailViewController
        let container = transitionContext.containerView
        
        toVC.view.setNeedsLayout()
        toVC.view.layoutIfNeeded()
        
        let fromImageView = getCellImageView(fromVC)
        let toImageView = toVC.imageView!
        
        let snapshot = fromImageView.snapshotView(afterScreenUpdates: false)
        fromImageView.isHidden = true
        toImageView.isHidden = true
        
        // backdrop is to remove the modal rising affect of the detailViewController
        let backdrop = UIView(frame: toVC.view.frame)
        backdrop.backgroundColor = toVC.view.backgroundColor
        container.addSubview(backdrop)
        backdrop.alpha = 0
        toVC.view.backgroundColor = UIColor.clear
        
        toVC.view.alpha = 0
        let finalFrame = transitionContext.finalFrame(for: toVC)
        var frame = finalFrame
        frame.origin.y += frame.size.height
        toVC.view.frame = frame
        container.addSubview(toVC.view)
        
        snapshot?.frame = container.convert(fromImageView.frame, from: fromImageView)
        container.addSubview(snapshot!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            backdrop.alpha = 1
            toVC.view.alpha = 1
            toVC.view.frame = finalFrame
            snapshot?.frame = container.convert(toImageView.frame, from: toImageView)
            
        }, completion: { (finished) in
            
            toVC.view.backgroundColor = backdrop.backgroundColor
            backdrop.removeFromSuperview()
            
            fromImageView.isHidden = false
            toImageView.isHidden = false
            snapshot?.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
    
    func animatePop(transitionContext: UIViewControllerContextTransitioning) {
        
        // basically go backwards
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! DetailViewController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! ViewController
        let container = transitionContext.containerView
        
        let fromImageView = fromVC.imageView!
        let toImageView = getCellImageView(toVC)
        
        let snapshot = fromImageView.snapshotView(afterScreenUpdates: false)
        fromImageView.isHidden = true
        toImageView.isHidden = true
        
        let backdrop = UIView(frame: fromVC.view.frame)
        backdrop.backgroundColor = fromVC.view.backgroundColor
        container.insertSubview(backdrop, belowSubview: fromVC.view)
        backdrop.alpha = 1
        fromVC.view.backgroundColor = UIColor.clear
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = finalFrame
        
        var frame = finalFrame
        frame.origin.y += frame.size.height
        container.insertSubview(toVC.view, belowSubview: backdrop)
        
        snapshot?.frame = container.convert(fromImageView.frame, from: fromImageView)
        container.addSubview(snapshot!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            backdrop.alpha = 0
            fromVC.view.frame = frame
            snapshot?.frame = container.convert(toImageView.frame, from: toImageView)
            
        }, completion: { (finished) in
            
            fromVC.view.backgroundColor = backdrop.backgroundColor
            backdrop.removeFromSuperview()
            
            fromImageView.isHidden = false
            toImageView.isHidden = false
            snapshot?.removeFromSuperview()
            
            transitionContext.completeTransition(finished)
        })
    }
}
