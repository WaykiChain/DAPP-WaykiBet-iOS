//
//  Account.swift
//  WaykiChain
//
//  Created by louis on 2018/6/8.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

class Account:NSObject,NSCoding{
    
    var password:String = ""
    var helpString:String =  ""
    var adress:String =  ""
    var privatekey:String = ""
    var regId:String = ""
    var validHeight:Double = 0
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(SecurityManager.getEncryptingString(str: password), forKey: "password")
        aCoder.encode(SecurityManager.getEncryptingString(str: helpString) , forKey: "helpString")
        aCoder.encode(adress, forKey: "adress")
        aCoder.encode(SecurityManager.getEncryptingString(str: privatekey) , forKey: "privatekey")
        aCoder.encode(regId, forKey: "regId")
        aCoder.encode(validHeight, forKey: "validHeight")
        
    }
    required init?(coder aDecoder: NSCoder) {
        password =  SecurityManager.getDecryptingString(str: aDecoder.decodeObject(forKey: "password") as! String)
        helpString =  SecurityManager.getDecryptingString(str: aDecoder.decodeObject(forKey: "helpString") as! String)
        adress = aDecoder.decodeObject(forKey: "adress") as! String
        privatekey =  SecurityManager.getDecryptingString(str: aDecoder.decodeObject(forKey: "privatekey") as! String)
        regId = aDecoder.decodeObject(forKey: "regId") as! String
        validHeight = aDecoder.decodeDouble(forKey: "validHeight")
    }
    
    
    override init() {
        super.init()
    }
    
}
