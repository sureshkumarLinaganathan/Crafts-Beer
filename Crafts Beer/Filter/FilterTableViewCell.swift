//
//  FilterTableViewCell.swift
//  Crafts Beer
//
//  Created by Sureshkumar Linganathan on 6/30/18.
//  Copyright © 2018 ThoughtWorks. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    func setupView(filter:String)->Void{
        self.filterNameLabel.text = filter;
        self.backgroundColor = UIColor(patternImage: UIImage(named:"background")!);
        self.createCardEffect();
    }
    func createCardEffect()->Void{
        self.alpha = 1.0;
        self.layer.masksToBounds = false;
        self.layer.cornerRadius = 0;
        self.layer.shadowOffset = CGSize(width: 0, height: 0);
        self.layer.shadowRadius = 2.0;
        self.layer.shadowColor = UIColor.lightGray.cgColor;
        self.layer.shadowOpacity = 1.0
    }
}
