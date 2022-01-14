//
//  SummaryViewController.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 13/1/2565 BE.
//

import UIKit

class SummaryViewController: UIViewController {
    
    private let viewModel = SummaryViewModel()
    
    
    @IBOutlet weak var tableViewSummary: UITableView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var txtAddress: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.isLoading.bind { isLoading in
            if isLoading.isLoading {
                HUD.displayHUD(title: isLoading.loadingMessage ?? "")
            }
            else {
                HUD.dismissHUD(true)
            }
        }
        
        viewModel.errorAlert.bind { [weak self] errorAlert in
            if errorAlert != nil {
                DispatchQueue.main.async {
                    self?.present(errorAlert!.generateAlertController(), animated: true, completion: nil)
                }
            }
        }
        
        self.viewModel.order.bind { [weak self] order in
            if order.products.count > 0 {
                self?.lblTotal.text = "\(order.total)"
                self?.txtAddress.text = order.deliveryAddress
            }
            else {
                //alert error and pop back?
                let alertC = UIAlertController.init(title: "Oop!!", message: "Something went wrong.(404)", preferredStyle: .alert)
                alertC.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                DispatchQueue.main.async {
                    self?.present(alertC, animated: true, completion: nil)
                }
            }
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnConfirmDidTap(_ sender: Any) {
        if !self.txtAddress.text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.viewModel.order.value.deliveryAddress = self.txtAddress.text
            self.viewModel.showLoading()
            ShopService.makeOrder(order: self.viewModel.order.value, completion: { response, wsErrorType, error in
                self.viewModel.hideLoading()
                if wsErrorType == .noError {
                    self.viewModel.clearOrder()
                    self.performSegue(withIdentifier: "goThanks", sender: nil)
                }
                else {
                    self.viewModel.errorAlert.value = ErrorAlert.init("Cannot confirm your drinks" ,message: error?.localizedDescription)
                }
            })
        }
        else {
            /// alert option
//            let alertC = UIAlertController.init(title: "Please input you delivery address.", message: "", preferredStyle: .alert)
//            alertC.addAction(UIAlertAction.init(title: "Sure", style: .default, handler: { _ in
//                self.txtAddress.becomeFirstResponder()
//            }))
//
//            self.present(alertC, animated: true, completion: nil)
            
            /// direct to the point -> add address
            self.txtAddress.becomeFirstResponder()
        }
    }

}



extension SummaryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.order.value.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell") as? SummaryTableViewCell {
           let info = self.viewModel.order.value.products[indexPath.row]
            cell.bind(info)
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

extension SummaryViewController : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        let alertC = UIAlertController.init(title: "Delivery address", message: "", preferredStyle: .alert)
        alertC.addTextField { txt in
            txt.text = textView.text
        }
        
        alertC.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in
            let textField = alertC.textFields![0]
            self.txtAddress.text = textField.text
        }))
        
        
        alertC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler:nil))
        
        self.present(alertC, animated: true, completion: nil)
        
        return false
    }
}
