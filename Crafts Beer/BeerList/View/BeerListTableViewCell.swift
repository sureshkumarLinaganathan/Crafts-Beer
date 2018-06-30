//
//  BeerListTableViewCell.swift
//  Crafts Beer
//
//  Created by Suresh Kumar on 30/06/18.
//  Copyright © 2018 ThoughtWorks. All rights reserved.
//

import UIKit


let BeerListTableViewCellReuseIdentifier = "beerListTableViewCellReuseIdentifier"

protocol  BeerListTableViewCellDelegate{
    
    func addItemInCart(cell:BeerListTableViewCell)
}

class BeerListTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerStyleLabel: UILabel!
    @IBOutlet weak var alcoholContentLabel: UILabel!
    var delegate:BeerListTableViewCellDelegate?;
    
    func setupView(beer:Beer)->Void{
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!);
        self.beerNameLabel.text = beer.name ?? "---";
        if(beer.style == ""){
            self.beerStyleLabel .text = "-----";
        }else{
            self.beerStyleLabel .text = beer.style;
        }
        self.alcoholContentLabel.text = "Alcohol Content:"+String(beer.abv!) ;
        self.createCardEffect();
    }
    
    func createCardEffect()->Void{
        self.view.alpha = 1.0;
        self.view.layer.masksToBounds = false;
        self.view.layer.cornerRadius = 0;
        self.view.layer.shadowOffset = CGSize(width: 0, height: 0);
        self.view.layer.shadowRadius = 2.0;
        self.view.layer.shadowColor = UIColor.lightGray.cgColor;
        self.view.layer.shadowOpacity = 1.0
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        self.delegate?.addItemInCart(cell: self);
       
    }
    
}
