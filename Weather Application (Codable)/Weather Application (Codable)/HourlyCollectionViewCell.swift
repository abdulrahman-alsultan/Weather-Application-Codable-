//
//  HourlyCollectionViewCell.swift
//  Weather Application (Codable)
//
//  Created by admin on 21/12/2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var hour: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var degree: UILabel!
    
    
    func configure(h: String, image: UIImage, d: String){
        hour.text = h
        imageView.image = image
        degree.text = d
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
