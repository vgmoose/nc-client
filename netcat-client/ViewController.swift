//
//  ViewController.swift
//  netcat-client
//
//  Created by vgm on 12/17/16.
//  Copyright © 2016 vgmoose. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var console: ConsoleView!

    var hostname: UITextField?
    var port: UITextField?
    
    let defaultHost: String = "192.168.1.103" //"localhost"
    let defaultPort: Int = 4141
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let newName : String = alert.textFields![0].text!
//        print(newName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // welcome message
        console.log("nc-client for iOS by vgmoose\nCC BY-NC-SA 4.0 license\n")
        
        var alert = UIAlertController(title: "netcat client", message: "Enter hostname and port to connect. Leave blank and press OK for defaults.", preferredStyle: UIAlertControllerStyle.alert)
        //
        
        func hostPrompt(textField: UITextField!){
            // add the text field and make the result global
            textField.placeholder = "Hostname (default: \(defaultHost))"
            hostname = textField
        }
        
        func portPrompt(textField: UITextField!){
            // add the text field and make the result global
            textField.placeholder = "Port (default: \(defaultPort))"
            port = textField
        }
        
        alert.addTextField(configurationHandler: hostPrompt)
        alert.addTextField(configurationHandler: portPrompt)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ (alertAction:UIAlertAction!) in self.startNC()
        }))
        
        
        self.present(alert, animated: true)
        
    }
    
    func startNC() {
        
        // get input ports from alert textfields, or defaults
        var host:String = (hostname!.text! != "") ? hostname!.text! : defaultHost
        var port:Int = Int(self.port!.text!) ?? defaultPort

        // run on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            
            // connect to remote
            self.console.connect(host: host, port: port)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

