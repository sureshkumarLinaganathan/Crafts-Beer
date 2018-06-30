//
//  FilterView.swift
//  Crafts Beer
//
//  Created by Sureshkumar Linganathan on 6/30/18.
//  Copyright © 2018 ThoughtWorks. All rights reserved.
//

import UIKit

class FilterView: UIView,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var filterView:FilterView?;
    func initViewFrame(frame:CGRect)->FilterView{
        self.filterView = (Bundle.main.loadNibNamed("FilterView", owner: self, options:nil)?.first as! FilterView)
        self.filterView?.frame = frame;
        //self.filterView?.tableView.backgroundColor = UIColor(patternImage: UIImage(named:"background")!);
        self.filterView?.setupTableViewCell();
        self.filterView?.tableView.dataSource = self;
        self.filterView?.tableView.delegate = self;
        return self.filterView!;
    }
    
    func setupTableViewCell()->Void{
        self.tableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "filterReuseIdentifier");
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterCell:FilterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "filterReuseIdentifier", for: indexPath) as! FilterTableViewCell;
        filterCell.setupView(filter:"aly");
        return filterCell;
    }
    
}
