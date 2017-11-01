//
//  ImageCell.swift
//  LoremPixelAnimatingViews
//
//  Created by Mark Wilkinson on 10/31/17.
//  Copyright © 2017 Mark Wilkinson. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet var imageView: RemoteImageViewCell!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.fkb_cancelImageLoad()
        imageView.image = nil
    }
}
