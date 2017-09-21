//
//  LoadingIndicatorView.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/21/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import UIKit

class LoadingIndicatorView {
    
    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingIndicatorView {
        struct Static {
            static let instance: LoadingIndicatorView = LoadingIndicatorView()
        }
        return Static.instance
    }
    
    func showLoading(_ view: UIView) {
        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.3)
        
        progressView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        progressView.center = view.center
        progressView.backgroundColor = UIColor(hex: 0x444444, alpha: 0.7)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        view.addSubview(containerView)
        
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}
