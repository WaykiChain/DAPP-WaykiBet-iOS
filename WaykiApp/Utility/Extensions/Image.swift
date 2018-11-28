//
//  Image.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

extension UIImage{
    
    class func QRwithString(string: String, imageName: String) -> UIImage{
        
        let stringData = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter?.outputImage
        
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor.init(red: 0, green: 0, blue: 0, alpha: 0), forKey: "inputColor1")
        // 返回二维码image
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5))))
        
        // 中间一般放logo
        if let iconImage = UIImage(named: imageName) {
            let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
            
            UIGraphicsBeginImageContext(rect.size)
            codeImage.draw(in: rect)
            let avatarSize = CGSize(width: rect.size.width*0.25, height: rect.size.height*0.25)
            
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            return resultImage!
        }
        return codeImage
    }
    
    //压缩图片
    static func compressImage(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = UIImageJPEGRepresentation(image, compression),
            data.count > maxLength else { return image }
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(image, compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength { return resultImage }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            
            
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            data = UIImageJPEGRepresentation(resultImage, compression)!
        }
        return resultImage
    }
    
    //根据scale压缩图片
    func compressScale(size:CGSize)-> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height),false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
    
    //图片转base64(呆前缀)
    func getPngBase64() ->String{
        let base64 = getNOPrefixBase64()
        
        if base64.count>0 {
            return "data:image/png;base64," + base64
        }
        return ""
    }
    
    func getNOPrefixBase64() ->String{
        let imageData = UIImageJPEGRepresentation(self,0.3)
        let imageBase64String = imageData?.base64EncodedString()
        if imageBase64String != nil {
            return imageBase64String!
        }
        return ""
    }
}
