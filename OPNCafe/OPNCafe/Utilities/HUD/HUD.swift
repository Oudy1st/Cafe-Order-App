//
//  HUD.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 13/1/2565 BE.
//

import UIKit

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

class HUD : UIView {

    static let shared:HUD = HUD().loadNib() as! HUD
    var count:Int = 0
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    
    static func displayHUD(title:String) {
        DispatchQueue.main.async {
            let hud = HUD.shared
            hud.lblTitle.text = title
            
            if hud.count == 0
            {
                if let window = UIApplication.shared.windows.last {
                    window.addSubview(hud)
                    hud.frame = window.bounds
                }
                
                hud.setNeedsLayout()
                hud.layoutIfNeeded()
            }
            
            hud.count += 1
        }
        
    }
    
    static func dismissHUD(_ forceDismiss:Bool = false) {
        DispatchQueue.main.async {
            
            let hud = HUD.shared
            hud.count -= 1
            if hud.count <= 0 || forceDismiss {
                hud.count = 0
                hud.removeFromSuperview()
            }
        }
    }
}
