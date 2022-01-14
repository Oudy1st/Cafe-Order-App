//
//  SummaryTableViewCell.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 13/1/2565 BE.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewIcon: LazyImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func bind(_ product:Product) {
        
        
        self.imageViewIcon.load(urlString: product.imageUrl, defaultImage: nil)
        self.lblName.text = product.name
        self.lblPrice.text = "\(product.price)"
        self.lblTotal.text = "x \(product.total ?? 0)"
    }
    

}
