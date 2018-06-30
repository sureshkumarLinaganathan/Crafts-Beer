//
//  SortView.swift
//  Crafts Beer
//
//  Created by Sureshkumar Linganathan on 6/30/18.
//  Copyright © 2018 ThoughtWorks. All rights reserved.
//

import UIKit

protocol SortViewDelegate {
    func sortButtonTapped(isAscending:Bool)
    func hideSortView()
}



class SortView: UIView {
    
    
    @IBOutlet weak var view: UIView!
    var sortView:SortView?;
    var delegate:SortViewDelegate?;
    
    @IBOutlet weak var maxMinSortImageView: UIImageView!
    @IBOutlet weak var minMaxImageView: UIImageView!
    func initViewFrame(frame:CGRect)->SortView{
        self.sortView = (Bundle.main.loadNibNamed("SortView", owner: self, options:nil)?.first as! SortView)
        self.sortView?.frame = frame;
        self.sortView?.addGesture(view:self.sortView!);
        self.sortView?.view?.frame = CGRect(x:0, y:frame.size.height-130 , width: frame.size.width, height: 130);
        self.sortView?.maxMinSortImageView.isHidden = true;
        return self.sortView!;
    }
    
    func addGesture(view:SortView)->Void{
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(hideSortView));
        tapGesture.cancelsTouchesInView = false;
        view.addGestureRecognizer(tapGesture);
    }
    
    @objc func hideSortView()->Void{
        self.delegate?.hideSortView();
    }
    
    @IBAction func descendingButtonTapped(_ sender: Any) {
        self.delegate?.sortButtonTapped(isAscending:false);
        self.minMaxImageView.isHidden = true;
        self.maxMinSortImageView.isHidden = false;
    }
    
    @IBAction func ascendingButtonTapped(_ sender: Any) {
        self.delegate?.sortButtonTapped(isAscending: true);
        self.maxMinSortImageView.isHidden = true;
        self.minMaxImageView.isHidden = false;
    }

}
