//
//  HomeViewController.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import UIKit

class MenuViewController: UIViewController {
    
    private let viewModel = MenuViewModel()
    
    @IBOutlet weak var tableViewMenu: UITableView!
    
    @IBOutlet weak var btnOrder: UIButton!
    
    
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
        
        viewModel.cafeInfo.bind { [weak self] shop in
            self?.title = shop?.name ?? "opn-cafe"
            
            self?.viewModel.reloadProducts()
        }
        
        viewModel.productList.bind { [weak self] products in
            self?.tableViewMenu.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.checkOrderSession()
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destination.
//     // Pass the selected object to the new view controller.
//         if let vc = segue.destination as? SummaryViewController {
//         }
//     }
     
    
    
    @IBAction func btnOrderDidTap(_ sender: Any) {
        if self.viewModel.hasOrder() {
            
            OrderSession.shared.order = self.viewModel.order!
            self.performSegue(withIdentifier: "goSummary", sender: nil)
        }
        else {
            let alertC = UIAlertController.init(title: "Please pick some drink.", message: "", preferredStyle: .alert)
            alertC.addAction(UIAlertAction.init(title: "Sure, Let's pick a drink", style: .default, handler: nil))
            
            self.present(alertC, animated: true, completion: nil)
        }
    }
    
}


extension MenuViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.productList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuTableViewCell,
            let info = self.viewModel.productList.value?[indexPath.row] {
            cell.bind(info)
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

