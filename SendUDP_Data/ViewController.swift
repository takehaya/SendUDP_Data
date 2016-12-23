//
//  ViewController.swift
//  SendUDP_Data
//
//  Created by Takeru Hayasaka on 2016/12/08.
//  Copyright © 2016 Takeru Hayasaka. All rights reserved.
//

//import UIKit
//import CocoaAsyncSocket
//
//class ViewController: UIViewController,GCDAsyncSocketDelegate {
//    
//    let addr = "192.168.0.10"
//    let port:UInt16 = 35000
//    var socket:GCDAsyncSocket!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
//        do {
//            try socket.connect(toHost: addr, onPort: port)
//        } catch let e {
//            print(e)
//        }
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    @nonobjc func socket(socket : GCDAsyncSocket, didConnectToHost host:String, port p:UInt16)
//    {
//        print("Connected to \(addr) on port \(port).")
//    }
//    
//    
//}

import UIKit
import SwiftSocket

class ViewController: UIViewController {
    
    @IBOutlet weak var front_and_behind_slider: UISlider!
    
    @IBOutlet weak var right_and_left_slider: UISlider!
    @IBOutlet weak var senddataButton: UIButton!
    private let addr = "192.168.4.1"
    private let port:Int32 = 30000
    private var client: UDPClient?
    private let Top_String = "/osc/"
    private let ToSteering_of_Str:Int! = nil
    //private var SendAction_Order
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senddataButton.addTarget(self, action: #selector(ViewController.SendButton(button:)), for: UIControlEvents.touchUpInside)
        self.front_and_behind_slider.addTarget(self, action: #selector(ViewController.onChange_fb_Slider(sender: )), for: UIControlEvents.valueChanged)
        self.right_and_left_slider.addTarget(self, action: #selector(ViewController.onChange_lr_Slider(sender: )), for: UIControlEvents.valueChanged)

         front_and_behind_slider.transform = CGAffineTransform(rotationAngle: CGFloat(-(M_PI*0.5)))
        //SetCustomSlider(slider: front_and_behind_slider)
        self.client = UDPClient(address: addr, port: port)
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func SetCustomSlider(slider:UISlider!){
       
        //スライダー初期化
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        
        //スライダーのデザインをカスタマイズ
        let imageForThumb = UIImage(named: "slider_thumb.png")
        let imageMinBase = UIImage(named: "slider_left.png")
        let imageMaxBase = UIImage(named: "slider_right.png")
        let imageForMin = imageMinBase?.stretchableImage(withLeftCapWidth: 4, topCapHeight: 0)
        let imageForMax = imageMaxBase?.stretchableImage(withLeftCapWidth: 4, topCapHeight: 0)
        
        slider.setThumbImage(imageForThumb, for: .normal)
        slider.setThumbImage(imageForThumb, for: .highlighted)
        slider.setMinimumTrackImage(imageForMin, for: .normal)
        slider.setMaximumTrackImage(imageForMax, for: .normal)
        
    }
    func SendAction(str:String,num:Int32){
        let str=(Top_String + str + String(num)+".")
        if let data :Data = str.data(using: String.Encoding.ascii){
            let cmp = self.client?.send(data: data)
            if (cmp?.isFailure)!{
                print("send=\(data)")
            }
        }
    }
    
    //関数ハンドラ
    func SendButton(button:UIButton){
        self.SendAction(str: "L", num: 200)
    }
    func onChange_fb_Slider(sender:UISlider!){
        print("fbsender=\(sender.value)")
        self.SendAction(str: "M", num: Int32(sender.value))
    }
    func onChange_lr_Slider(sender:UISlider!){
        print("lrsender=\(sender.value)")
        self.SendAction(str: "S", num: Int32(sender.value))
    }
}
