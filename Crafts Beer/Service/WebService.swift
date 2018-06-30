//
//  WebService.swift
//  Crafts Beer
//
//  Created by Suresh Kumar on 30/06/18.
//  Copyright © 2018 ThoughtWorks. All rights reserved.
//

import UIKit

class WebService: NSObject {
    let apiUrl :String = "http://starlord.hackerearth.com/";
    let key:String = "beercraft";
    let limitValue = "20";
    
    func fetchBeerDetails(skipCount:Int,callback:@escaping (_ success:Bool,_ Error:String,_ beerArray:Array<Beer>)->Void)->Void{
        let urlString = apiUrl+key;
        let url:NSURL = NSURL(string:urlString)!
        var array:Array<Beer> = [];
        let theRequest :NSURLRequest = NSURLRequest.init(url: url as URL);
        let task = URLSession.shared.dataTask(with: theRequest as URLRequest) { (data, response, error) in
            do {
                if data?.count != 0 && error == nil {
                    let jsonObject:NSArray = try JSONSerialization.jsonObject(with: data!, options:.mutableLeaves) as! NSArray;
                  array =  Beer().initWithArray(array: jsonObject);
                    DispatchQueue.main.async {
                        callback(true,"", array);
                    }
                }
            }catch let error as NSError {
                DispatchQueue.main.async {
                    callback(false,error.localizedDescription,array);
                }
            }
        }
        
        task.resume();
        
    }

}
