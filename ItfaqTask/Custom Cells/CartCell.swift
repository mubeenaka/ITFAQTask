//
//  CartCell.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import UIKit

protocol CartCellProtocol {
    func removeFromCartBtnClicked(cell : CartCell)
    func increment(cell : CartCell)
    func decrement(cell : CartCell)
}

class CartCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productimage: UIImageView!
    @IBOutlet weak var removeFromCartBtn: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    var product : Product?
    var delegate : CartCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onMinusBtnClick(_ sender: Any) {
        self.delegate?.decrement(cell: self)
    }
    
    @IBAction func onAddBtnClick(_ sender: Any) {
        self.delegate?.increment(cell: self)
    }
    
    @IBAction func onRemoveFromCartBtnclick(_ sender: Any) {
        self.delegate?.removeFromCartBtnClicked(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
