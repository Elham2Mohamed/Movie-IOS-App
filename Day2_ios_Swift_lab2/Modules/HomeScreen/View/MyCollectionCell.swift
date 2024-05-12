//
//  MyCollectionCell.swift
//  Day4_ios_siwft_lab2
//
//  Created by Elham on 25/04/2024.
//

import UIKit

class MyCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var img: UIImageView?
    @IBOutlet weak var titlle: UILabel?
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
  
}
