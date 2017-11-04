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
    
    func animatePush(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        // From -> To
        toVC.view.alpha = 0
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        // need to use the container view
        let container = transitionContext.containerView
        container.addSubview(toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.alpha = 1
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
    
    func animatePop(transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
