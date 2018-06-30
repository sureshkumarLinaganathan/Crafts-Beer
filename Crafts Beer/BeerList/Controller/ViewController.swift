//
//  ViewController.swift
//  Crafts Beer
//
//  Created by Suresh Kumar on 30/06/18.
//  Copyright © 2018 ThoughtWorks. All rights reserved.
//

import UIKit
import NVActivityIndicatorView;

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButtonTapped: UIButton!
    var loadingIndicator:NVActivityIndicatorView?
    var loadingView:UIView?
    var beerArray:Array<Beer> = [];
    var sortView:SortView?;
    var sortEnabled:Bool = false;
    var searchItemArray:Array<Beer> = [];
    var isSearchEnabled:Bool = false;
    var cartArray:Array<Beer> = [];
    var filterView:FilterView?;
    
    @IBOutlet weak var erroeLabel: UILabel!
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    //MARK - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView();
        self.addLoadingIndicator();
        self.fetchBeerData();
    }
    
    func addLoadingIndicator()->Void{
        self.loadingView = UIView.init(frame: self.view.frame);
        self.loadingView?.backgroundColor = Theme().loadingIndicatorBackgroundColor();
        self.loadingView?.isUserInteractionEnabled = false;
        self.loadingIndicator = NVActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballSpinFadeLoader, color: UIColor.orange, padding: 0)
        self.loadingIndicator?.center = (self.loadingView?.center)!;
        self.loadingView?.addSubview(self.loadingIndicator!);
        self.view?.addSubview(self.loadingView!);
        self.loadingView?.isHidden = true;
        
    }
    
    func setupView(){
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named:"background")!);
        self.cartCountLabel.layer.masksToBounds = true;
        self.cartCountLabel.layer.cornerRadius = 10.0;
        self.addSortView();
        self.addfilterView();
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if(self.cartArray.count == 0){
            self.cartCountLabel.isHidden = true;
        }
        self.cartCountLabel.text = String(describing: self.cartArray.count);
        
    }
    
    func fetchBeerData()->Void{
         self.erroeLabel.isHidden = true;
        self.loadingView?.isHidden = false;
        self.loadingIndicator?.startAnimating();
        self.view.isUserInteractionEnabled = false;
        WebService().fetchBeerDetails(skipCount: 20) { (success, errorMsg, array) in
            self.loadingIndicator?.stopAnimating();
            self.loadingView?.isHidden = true;
            self.view.isUserInteractionEnabled = true;
            if(success){
                self.beerArray = array;
                self.sortButtonTapped(isAscending:true);
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                }
            }else{
                self.erroeLabel.isHidden = false;
                self.erroeLabel.text = errorMsg;
            }
        }
    }
    
    func addSortView()->Void{
        self.sortView = SortView().initViewFrame(frame:self.view.frame);
        self.view.addSubview(self.sortView!);
        self.sortView?.delegate = self as SortViewDelegate;
        self.sortView?.isHidden = true;
    }
    
    func addfilterView()->Void{
        self.filterView = FilterView().initViewFrame(frame:self.view.frame);
        self.view.addSubview(self.filterView!);
        self.filterView?.isHidden = true;
    }
    
    
    //MARK - IBActions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if(self.searchTextField.isHidden){
            self.searchTextField.isHidden = false;
        }else{
            self.searchTextField.isHidden = true;
            self.isSearchEnabled = false;
            self.searchItemArray = [];
            self.searchTextField.resignFirstResponder();
            self.tableView.reloadData();
            self.searchTextField.text = "";
        }
    }
    @IBAction func cartButtonTappped(_ sender: Any) {
       
        self.performSegue(withIdentifier: CartViewControllerSegue, sender: self)
    }
    @IBAction func sortButtonTapped(_ sender: Any) {
        self.sortView?.isHidden = false;
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.fetchBeerData();
    }
    @IBAction func filterButtonTapped(_ sender: Any) {
        self.filterView?.isHidden = false;
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == CartViewControllerSegue){
            let cartViewController:CartViewController = segue.destination as! CartViewController;
            cartViewController.cartArray = self.cartArray;
            cartViewController.delegate = self;
        }
    }
    
    deinit {
        
    }
    
    
}

extension ViewController:SortViewDelegate{
    
    func sortButtonTapped(isAscending: Bool) {
        if(isAscending){
            if(self.isSearchEnabled){
                self.searchItemArray = self.ascendingSort(array: self.searchItemArray);
            }else{
                self.beerArray = self.ascendingSort(array: self.beerArray);
            }
        }else{
            if(self.isSearchEnabled){
                self.searchItemArray = self.descendingArray(array: self.searchItemArray);
            }else{
                self.beerArray = self.descendingArray(array: self.beerArray);
            }
        }
        self.sortEnabled = true;
        self.tableView.reloadData();
        self.sortView?.isHidden = true;
    }
    func hideSortView() {
        self.sortView?.isHidden = true;
    }
    
    func ascendingSort(array:Array<Beer>)->Array<Beer>{
        return array.sorted(by: { $0.abv!*10 < ($1.abv)!*10});
    }
    func descendingArray(array:Array<Beer>)->Array<Beer>{
        return array.sorted(by: { $0.abv!*10 > ($1.abv)!*10});
    }
    
    
}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!self.isSearchEnabled){
            return  self.beerArray.count;
        }else{
            return self.searchItemArray.count;
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beerListCell:BeerListTableViewCell = tableView.dequeueReusableCell(withIdentifier: BeerListTableViewCellReuseIdentifier, for: indexPath) as! BeerListTableViewCell;
        beerListCell.delegate = self;
        if(!isSearchEnabled){
            beerListCell.setupView(beer: self.beerArray[indexPath.row]);
        }else{
            beerListCell.setupView(beer: self.searchItemArray[indexPath.row]);
        }
        return beerListCell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160;
    }
}

extension ViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        self.searchBeerByName(name: textField.text!);
        return true;
    }
    
    func searchBeerByName(name:String)->Void{
        
        self.searchItemArray =  self.beerArray.filter { ($0.name)?.range(of: name, options: [.diacriticInsensitive, .caseInsensitive]) != nil }
        self.isSearchEnabled = true;
        self.tableView.reloadData();
        
    }
}

extension ViewController:BeerListTableViewCellDelegate{
    
    func addItemInCart(cell: BeerListTableViewCell) {
        
        let indexPath:IndexPath = self.tableView.indexPath(for: cell)!
        let beer :Beer = self.beerArray[indexPath.row];
        if(!self.cartArray.contains(beer)){
        self.cartArray.append(beer);
        }
        self.cartCountLabel.text = String(describing: self.cartArray.count);
        self.cartCountLabel.isHidden = false;
    }
}

extension ViewController:CartViewControllerDelegate{
    
    func updateCartArray(array: Array<Beer>) {
        self.cartArray = [];
        self.cartArray = array;
    }
}

