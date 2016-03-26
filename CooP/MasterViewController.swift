//
//  MasterViewController.swift
//  CooP
//
//  Created by Iain Munro on 26/03/16.
//  Copyright © 2016 Iain Munro. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {

    
    @IBOutlet weak var ServerStartBtn: NSButton!
    @IBOutlet weak var ServerStopBtn: NSButton!
    var screenRecorder: ScreenRecorder!
    
    @IBOutlet weak var ServerImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenRecorder = ScreenRecorder(callback: { (image) in
            dispatch_async(dispatch_get_main_queue(), {
                self.ServerImageView.image = image;
            });
        });
        
    }
    
    override func viewDidDisappear() {
        screenRecorder!.stop()
    }
    
    @IBAction func ServerStart(sender: AnyObject) {
        ServerStartBtn.enabled = false
        ServerStopBtn.enabled = true
        screenRecorder.start()
    }
    
    @IBAction func ServerStop(sender: AnyObject) {
        screenRecorder!.stop()
        
        ServerStartBtn.enabled = true
        ServerStopBtn.enabled = false
    }
    
}
