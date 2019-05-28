//
//  View4.swift
//  pH Meter
//
//  Created by A.S.D.Vinay on 08/01/17.
//  Copyright © 2017 A.S.D.Vinay. All rights reserved.
//

import UIKit
extension UIView {
    func getColour(point:CGPoint) -> UIColor {
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        var pixelData:[UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context!.translateBy(x: -point.x, y: -point.y);
        self.layer.render(in: context!)
        
        let red:CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
        let green:CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
        let blue:CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
        let alpha:CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)
        
        let color:UIColor = UIColor(red: green, green: blue, blue: alpha, alpha: red)
        return color
    }
}
class View4: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var posx:Int = 0
    var posy:Int = 0
    var touch:UITouch? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first
        didpress()
    }
    
    func didpress(){
        let position = touch?.location(in: self.view)
        posx = Int((position?.x)!)
        posy = Int((position?.y)!)
        self.view.backgroundColor = self.view.getColour(point: position!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    func createAlert(title:String,message:String?){
//        
//        
//        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }

}
