//
//  CartViewController.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var cartTabelView: UITableView!
    @IBOutlet weak var TotalPriceLabel: UILabel!
    
    var items : [CartItem] = []
    var totalPrice : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Cart"
        
        self.TotalPriceLabel.text = "AED \(totalPrice)"
        
        self.items = []
        showCartItems()
        updateTotalPrice()
        
        
    }
    
    func showCartItems() {
        
        self.items = CoredataManager.getCartItems(userId: Int16(Utility.loggedInUserID()))
        self.cartTabelView.reloadData()
    }

    func updateTotalPrice() {
        
        var price = Float(0.0)
        for item in self.items {
            if let pdt = CoredataManager.getproduct(id: item.productId) {
                let p = Float(item.quantity) * pdt.price
                price = price + p
            }
        }
        self.totalPrice = price
        self.TotalPriceLabel.text = "AED \(totalPrice)"

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - UITableView Delegate Methods
extension CartViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        let item = self.items[indexPath.row]
        if let product = CoredataManager.getproduct(id: item.productId) {
            cell.titleLabel.text = product.title
            cell.descLabel.text = product.desc
            let price = Float(item.quantity) * product.price
            cell.itemPriceLabel.text = "AED \(price)"
            cell.productimage.downloadFrom(link: product.image, contentmode: UIView.ContentMode.scaleAspectFit)

            cell.product = product

        }
        cell.quantityLabel.text = item.quantity.description
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension CartViewController : CartCellProtocol {
    
    func removeFromCartBtnClicked(cell: CartCell) {
        CoredataManager.removeFromCart(userId: Int16(Utility.loggedInUserID()), productId: cell.product!.id)
        self.showCartItems()
        self.updateTotalPrice()
    }
    
    func increment(cell: CartCell) {
        CoredataManager.incrementQuantity(userId: Int16(Utility.loggedInUserID()), productId: cell.product!.id)
        let indexpath = self.cartTabelView.indexPath(for: cell)
        self.cartTabelView.reloadRows(at: [indexpath!], with: UITableView.RowAnimation.automatic)
        self.updateTotalPrice()

    }
    
    func decrement(cell: CartCell) {
        CoredataManager.decrementQuantity(userId: Int16(Utility.loggedInUserID()), productId: cell.product!.id)
        let indexpath = self.cartTabelView.indexPath(for: cell)
        self.cartTabelView.reloadRows(at: [indexpath!], with: UITableView.RowAnimation.automatic)
        self.updateTotalPrice()

    }
}

