//
//  View2.swift
//  pH Meter
//
//  Created by A.S.D.Vinay on 06/01/17.
//  Copyright © 2017 A.S.D.Vinay. All rights reserved.
//

import UIKit
import AVFoundation
extension UIColor {
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return (hsba.h,hsba.s,hsba.b,hsba.a)
    }
}
extension UIView {
    func getColourFromPoint(point:CGPoint) -> UIColor {
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


class View2 : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var captureSession : AVCaptureSession?
    var stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var posx:Int = 0
    var posy:Int = 0
    var color = UIColor.red
    
    


    @IBOutlet weak var helloMoto: UILabel!
    
    @IBOutlet var cameraView: UIView!
    
    @IBAction func photoLibrary(_ sender: UIButton) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = cameraView.bounds
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetHigh
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if (backCamera?.hasFlash)! {
            
            do {
                
                try backCamera?.lockForConfiguration()
                backCamera?.flashMode = AVCaptureFlashMode.auto
                backCamera?.unlockForConfiguration()
                
            } catch {
                
                // handle error
            }
        }
        
        let error_1 : NSError? = nil
        
        do {
            try captureSession?.addInput(AVCaptureDeviceInput(device: backCamera))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        if (error_1 == nil ){
            
            stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if (captureSession?.canAddOutput(stillImageOutput) != nil){
                captureSession?.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                cameraView.layer.addSublayer(previewLayer!)
                captureSession?.startRunning()
        
            }
            
            
        }
        
    }
    @IBOutlet var tempImageView: UIImageView!
    
    
    func didPressTakePhoto(){
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider  = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                    self.tempImageView.image = image
                    self.tempImageView.isHidden = false
                    
                }
                
                
            })
        }
        
        
    }
    
    
    var didTakePhoto = Bool()
    
    func didPressTakeAnother(){
        if didTakePhoto == true{
            let w = Int(cameraView.frame.size.width)
            let h = Int(cameraView.frame.size.height)
            let position = touch?.location(in: cameraView)
            posx = Int((position?.x)!)
            posy = Int((position?.y)!)
            print(posx,posy)
            let our = tempImageView.image
            let iw = Int((our?.size.width)!)
            let ih = Int((our?.size.height)!)
            print(iw,ih,w,h)
            print(iw * posx/w,ih * posy/h)
            let i = (our?.cgImage)!
            print(i.width,i.height)
            print(ih * posy/h,iw * posx/w)
            self.color = tempImageView.getColourFromPoint(point: position!)
            print(color)
            print((color.hsba.h)*360)
            createAlert(title: "pH Value", message: testRegion(hue: (color.hsba.h)*360).description, color: self.color)
//            createAlert(title: "pH Value", message:((color.hsba.h)*360).description, color: self.color)
            tempImageView.isHidden = true
            didTakePhoto = false
            
        }
        else{
            captureSession?.startRunning()
            didPressTakePhoto()
             didTakePhoto = true
        }
        
    }
    var touch:UITouch? = nil
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first!
        didPressTakeAnother()
    }
    
    func createAlert(title:String,message:String?,color:UIColor){
        
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
        alert.view.tintColor = color
        alert.addAction(UIAlertAction(title: "███", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func testRegion(hue:CGFloat)->CGFloat{
        if(hue>341.5 && hue<=350.1){
            return compute_less_2(x: hue)
        }
        else if(hue>350.1 && hue<=360 && hue>0 && hue<=8){
            return compute_less_3(x: hue)
        }
        else if(hue>8 && hue<=10.6){
            return compute_less_4(x: hue)
        }
        else if(hue>10.6 && hue<=15.6){
            return compute_less_5(x: hue)
        }
        else if(hue>15.6 && hue<=23){
            return compute_less_6(x: hue)
        }
        else if(hue>23 && hue<=37.7){
            return compute_less_7(x: hue)
        }
        else if(hue>37.7 && hue<=60.5){
            return compute_less_8(x: hue)
        }
        else if(hue>60.5 && hue<=71.2){
            return compute_less_9(x: hue)
        }
        else if(hue>71.2 && hue<=114.54){
            return compute_less_10(x: hue)
        }
        else if(hue>114.54 && hue<=118){
            return compute_less_11(x: hue)
        }
        else if(hue>118 && hue<=320){
            return compute_less_13(x: hue)
        }
        else if(hue>320 && hue<=331.875){
            return compute_less_14(x: hue)
        }
        else if(hue>331.875 && hue<=341.5){
            return 0
        }
        else{
            return 0
        }
    }
    func compute_less_2(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-341.5)/(8.6))+1
        return pH
    }
    func compute_less_3(x:CGFloat)->CGFloat{
        var pH:CGFloat
        if(x<=360){
        pH = (1*(x-350.1)/(17.9))+2
            return pH
        }
        else if(x>0){
            
           pH = (1*(x+360-350.1)/(17.9))+2
            return pH
    }
        else{
            return 3
        }
    }
    func compute_less_4(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-8)/(2.6))+3
        return pH
    }
    func compute_less_5(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-10.6)/(5))+4
        return pH
    }
    func compute_less_6(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-15.6)/(7.4))+5
        return pH
    }
    func compute_less_7(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-23)/(14.7))+6
        return pH
    }
    func compute_less_8(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-37.7)/(22.8))+7
        return pH
    }
    func compute_less_9(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-60.5)/(10.7))+8
        return pH
    }
    func compute_less_10(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-71.2)/(43.34))+9
        return pH
    }
    func compute_less_11(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-114.54)/(3.46))+10
        return pH
    }
    func compute_less_13(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (2*(x-118)/(202))+11
        return pH
    }
    func compute_less_14(x:CGFloat)->CGFloat{
        var pH:CGFloat
        pH = (1*(x-320)/(11.875))+13
        return pH
    }
}
