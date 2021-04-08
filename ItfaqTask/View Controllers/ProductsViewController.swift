//
//  ProductsViewController.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    var products : [Product]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Products"

        let cartBtn = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(cartBtnClicked))

        let logoutBtn = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logoutBtnClicked))

        self.navigationItem.rightBarButtonItems = [logoutBtn, cartBtn]
        
        //Products are loaded only one time. If already laoded, skip loading the products to DB.
        if !Utility.isProductsLoaded() {
            loadProductsToDB()
        }
        
        //Update products from DB to table view.
        updateProductsToView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBadge()

    }
    
    @objc func cartBtnClicked() {
        self.performSegue(withIdentifier: "showCart", sender: nil)
    }
    
    @objc func logoutBtnClicked() {
        Utility.logout()
    }

    //Update products to table view
    func updateProductsToView() {
        let productsInserted = CoredataManager.fetchEntity(entity: "Product", andPredicate: nil)! as! [Product]
        self.products = productsInserted
        self.productsTableView.reloadData()
    }
    
    //Read products from Products.json file and saving to DB.
    func loadProductsToDB() {
        if let filepath = Bundle.main.path(forResource: "Products", ofType: "json") {
            do {
                    let contents = try String(contentsOfFile: filepath)
                    do {
                        let products = try JSONDecoder().decode([D_Product].self, from: contents.data(using: .utf8)!)
                        CoredataManager.insertProducts(products: products)
                        
                        //Set products loaded to true, so that its loaded only one time.
                        UserDefaults.standard.set(true, forKey: "PRODUCTS_LOADED")
                        UserDefaults.standard.synchronize()
                    } catch {
                        print(error)
                    }
                } catch {
                    // contents could not be loaded
                }
        }
    }
    
    //Update badge of cart
    func updateBadge() {
        
        let loggedinUsercart = CoredataManager.getCartForUser(userid: Int16(Utility.loggedInUserID()))
        let cartitemsCount = loggedinUsercart?.cartItems.count
        let rightBarButton = self.navigationItem.rightBarButtonItems?[1]
        rightBarButton?.addBadge(text: "\(cartitemsCount!)")
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
extension ProductsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        let product = self.products[indexPath.row]
        cell.titleLabel.text = product.title
        cell.descriptionLabel.text = product.desc
        cell.priceLabel.text = "AED \(product.price)"
        cell.productImageView.downloadFrom(link: product.image, contentmode: UIView.ContentMode.scaleAspectFit)
        cell.delegate = self
        cell.product = product
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ProductsViewController : ProductCellProtocol {
    
    func addToCartBtnClicked(cell: ProductCell) {
        CoredataManager.addToCart(userId: Int16(Utility.loggedInUserID()), productId: cell.product!.id)
        let indexpath = self.productsTableView.indexPath(for: cell)
        self.productsTableView.reloadRows(at: [indexpath!], with: UITableView.RowAnimation.automatic)
        
        updateBadge()

    }
}
