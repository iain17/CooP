//
//  MasterViewController.swift
//  CooP
//
//  Created by Iain Munro on 26/03/16.
//  Copyright © 2016 Iain Munro. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {

    @IBOutlet weak var ClientStartBtn: NSButton!
    @IBOutlet weak var ClientStopBtn: NSButton!
    var client: CooPClient!
    
    @IBOutlet weak var ServerStartBtn: NSButton!
    @IBOutlet weak var ServerStopBtn: NSButton!
    var server: CooPServer!
    
    @IBOutlet weak var ServerImageView: NSImageView!
    @IBOutlet weak var ClientImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Client
        client = CooPClient(callback: { (image) in
            dispatch_async(dispatch_get_main_queue(), {
                print("callback!!");
                self.ClientImageView.image = image;
            });
        })
        
        //Server
        server = CooPServer()
        
        ClientStopBtn.enabled = false
        ServerStopBtn.enabled = false
    }
    
    override func viewDidDisappear() {
        server.stop()
        client.stop()
    }
    
    @IBAction func ServerStart(sender: AnyObject) {
        ServerStartBtn.enabled = false
        ServerStopBtn.enabled = true
        server.start()
    }
    
    @IBAction func ServerStop(sender: AnyObject) {
        ServerStartBtn.enabled = true
        ServerStopBtn.enabled = false
        server.stop()
    }
    
    @IBAction func ClientStart(sender: AnyObject) {
        client.listen()
        ClientStartBtn.enabled = false
        ClientStopBtn.enabled = true
    }
    
    @IBAction func ClientStop(sender: AnyObject) {
        client.stop()
        ClientStartBtn.enabled = true
        ClientStopBtn.enabled = false
    }
}
