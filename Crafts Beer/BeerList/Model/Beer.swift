//
//  Beer.swift
//  Crafts Beer
//
//  Created by Suresh Kumar on 30/06/18.
//  Copyright © 2018 ThoughtWorks. All rights reserved.
//

import UIKit

class Beer: NSObject {
    var name:String?;
    var style:String?;
    var ounces:Int?;
    var id:Int?;
    var abv:Float?;
    var ibu:String?;
    
    func initWithArray(array:NSArray)->Array<Beer>{
        var beerArray:Array<Beer> = [];
        for data in array  {
            let dictData:NSDictionary = (data as?NSDictionary)!;
            let beerObject:Beer = Beer();
            beerObject.name = dictData["name"] as? String;
            beerObject.style = dictData["style"] as?String;
            beerObject.ounces = dictData["ounces"] as? Int;
            beerObject.id = dictData["id"] as? Int;
            var value = dictData["abv"] as? String;
            if(value! == ""){
                value = "0.0";
            }
            beerObject.abv = Float(value!);
            beerObject.ibu = dictData["ibu"] as?String;
            beerArray.append(beerObject);
        }
        return beerArray;
    }
    
}
