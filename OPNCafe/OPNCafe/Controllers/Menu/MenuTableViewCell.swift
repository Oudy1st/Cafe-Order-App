//
//  MenuTableViewCell.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import UIKit


class MenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewIcon: LazyImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    
    var product:Product!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ product:Product) {
        self.product = product
        
        if self.product.total == nil {
            self.product.total = 0
        }
        
        self.imageViewIcon.load(urlString: self.product.imageUrl, defaultImage: nil)
        self.lblName.text = self.product.name
        self.lblPrice.text = "\(self.product.price)"
        
        self.handleTotal(self.product.total!)
    }
    
    
    @IBAction func btnPlusDidTap(_ sender: Any) {
        self.product.total! += 1
        self.handleTotal()
        
    }
    @IBAction func btnMinusDidTap(_ sender: Any) {
        self.product.total! -= 1
        if self.product.total! < 0 {
            self.product.total = 0
        }
        else {
            self.handleTotal()
        }
    }
    
    func handleTotal() {
        
        self.lblTotal.text = "x \(self.product.total ?? 0)"
        
        self.btnMinus.isHidden = self.product.total! == 0
            
    }
    
    func handleTotal(_ total:Int) {
        self.product.total = total
        
        self.lblTotal.text = "x \(self.product.total ?? 0)"
        
        self.btnMinus.isHidden = self.product.total! == 0
            
    }

}
