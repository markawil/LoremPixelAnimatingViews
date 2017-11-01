//
//  RemoteImageViewCell.swift
//  LoremPixelAnimatingViews
//
//  Created by Mark Wilkinson on 10/31/17.
//  Copyright © 2017 Mark Wilkinson. All rights reserved.
//

import UIKit

class RemoteImageViewCell: UIImageView {

    static var configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        return config
    }()
    
    static var session: URLSession = {
        let session = URLSession(
            configuration: RemoteImageViewCell.configuration,
            delegate: nil,
            delegateQueue: nil)
        session.delegateQueue.maxConcurrentOperationCount = 2
        return session
    }()
    
    var imageTask: URLSessionDataTask?
    
    func fkb_setImageWithURL(url: URL!, placeholder: UIImage? = nil) {
        imageTask?.cancel()
        imageTask = type(of: self).session.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let http = response as? HTTPURLResponse {
                    if http.statusCode == 200 {
                        
                        assert(!Thread.isMainThread, "called on main thread!")
                        
                        if (self.imageTask!.state == URLSessionTask.State.canceling) {
                            return
                        }
                        self.fkb_loadImageWithData(data: data!)
                    } else {
                        print("received an HTTP \(http.statusCode) downloading \(url)")
                    }
                } else {
                    print("Not an HTTP response")
                }
            } else {
                print("Error downloading image: \(url.path) -- \(error!.localizedDescription)")
            }
        }
        if let placeholderImage = placeholder {
            image = placeholderImage
        }
        imageTask?.resume()
    }
    
    private func fkb_loadImageWithData(data: Data) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.image = image
                let transition = CATransition()
                transition.duration = 0.25
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                transition.type = kCATransitionFade
                self.layer.add(transition, forKey: nil)
            }
        }
    }
    
    func fkb_cancelImageLoad() {
        imageTask?.cancel()
    }

}
