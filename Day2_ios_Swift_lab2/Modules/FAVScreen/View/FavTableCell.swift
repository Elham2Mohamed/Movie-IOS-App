//
//  FavTableCell.swift
//  Day2_ios_Swift_lab2
//
//  Created by Elham on 08/05/2024.
//

import UIKit

class FavTableCell: UITableViewCell {

    @IBOutlet weak var txt: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

}
