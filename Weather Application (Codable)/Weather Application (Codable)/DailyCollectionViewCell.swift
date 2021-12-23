//
//  DailyCollectionViewCell.swift
//  Weather Application (Codable)
//
//  Created by admin on 22/12/2021.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var minLbl: UILabel!
    @IBOutlet weak var maxLbl: UILabel!
    
    public func configure(day: String, image: UIImage, min: String, max: String){
        dayLbl.text = day
        weatherImage.image = image
        minLbl.text = min
        maxLbl.text = max
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "DailyCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
