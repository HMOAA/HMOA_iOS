//
//  CustomNavigationAnimation.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2/17/24.
//

import UIKit

class CustomNavigationAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var pushing = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // 애니메이션 지속 시간
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        if pushing {
            // push할 때 왼쪽 -> 오른쪽 슬라이드
            containerView.addSubview(toVC.view)
            toVC.view.frame = CGRect(x: -containerView.frame.width, y: 0, width: containerView.frame.width, height: containerView.frame.height)
            
            UIView.animate(withDuration: duration, animations: {
                toVC.view.transform = CGAffineTransform(translationX: containerView.frame.width, y: 0)
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            // pop할 때 오른쪽 -> 왼쪽 슬라이드
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
            fromVC.view.frame = containerView.frame

            UIView.animate(withDuration: duration, animations: {
                fromVC.view.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
            }) { _ in
                fromVC.view.transform = .identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
