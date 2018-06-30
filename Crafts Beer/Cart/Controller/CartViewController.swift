//
//  CartViewController.swift
//  Crafts Beer
//
//  Created by Sureshkumar Linganathan on 6/30/18.
//  Copyright © 2018 ThoughtWorks. All rights reserved.
//

import UIKit

protocol CartViewControllerDelegate {
    func updateCartArray(array:Array<Beer>)->Void;
}

let CartViewControllerSegue = "cartViewControllerSegue";

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var cartArray:Array<Beer> = [];
    var delegate:CartViewControllerDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
}

extension CartViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beerListCell:BeerListTableViewCell = tableView.dequeueReusableCell(withIdentifier: BeerListTableViewCellReuseIdentifier, for: indexPath) as! BeerListTableViewCell
        beerListCell.setupView(beer: self.cartArray[indexPath.row]);
        beerListCell.delegate = self as BeerListTableViewCellDelegate;
        return beerListCell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160;
    }
    
    func `deinit`(){
        
    }
}

extension CartViewController:BeerListTableViewCellDelegate{
    
    func addItemInCart(cell: BeerListTableViewCell) {
        let indexPath:NSIndexPath = self.tableView.indexPath(for: cell)! as NSIndexPath
        self.cartArray.remove(at: indexPath.row)
        self.tableView.reloadData();
        self.delegate?.updateCartArray(array: self.cartArray);
    }
}
