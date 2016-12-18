//
//  ViewController.swift
//  netcat-client
//
//  Created by vgm on 12/17/16.
//  Copyright © 2016 vgmoose. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var hostname: UITextField?
    var port: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let newName : String = alert.textFields![0].text!
//        print(newName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var alert = UIAlertController(title: "netcat client", message: "Enter hostname and port to connect. Leave blank and press OK for defaults.", preferredStyle: UIAlertControllerStyle.alert)
        //
        
        func hostPrompt(textField: UITextField!){
            // add the text field and make the result global
            textField.placeholder = "Hostname (default: localhost)"
            hostname = textField
        }
        
        func portPrompt(textField: UITextField!){
            // add the text field and make the result global
            textField.placeholder = "Port (default: 4141)"
            port = textField
        }
        
        alert.addTextField(configurationHandler: hostPrompt)
        alert.addTextField(configurationHandler: portPrompt)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ (alertAction:UIAlertAction!) in self.startNC()
        }))
        
        
        self.present(alert, animated: true)
        
    }
    
    func startNC() {
        print("Got values")
        print(hostname!.text)
        print(port!.text)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

