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
    
    let defaultHost: String = "localhost"
    let defaultPort: Int = 4141
        
    @IBOutlet weak var inputButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // welcome message
        console.log("nc-client for tvOS by vgmoose\nCC BY-NC-SA 4.0 license\n")
        
        // disable spell checking (messes up some commands)
        console.autocorrectionType = UITextAutocorrectionType.no;
        
        var alert = UIAlertController(title: "netcat client", message: "Enter hostname and port to connect. Leave blank and press OK for defaults.", preferredStyle: UIAlertControllerStyle.alert)
        //
        
        func hostPrompt(textField: UITextField!){
            // add the text field and make the result global
            textField.placeholder = "Hostname (default: \(defaultHost))"
            
            // load old value if it exists
            if let hostname = self.hostname {
                textField.text = hostname.text!
            }
            
            hostname = textField
        }
        
        func portPrompt(textField: UITextField!){
            // add the text field and make the result global
            textField.placeholder = "Port (default: \(defaultPort))"
            
            // load old value if it exists
            if let port = self.port {
                textField.text = port.text!
            }
            
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
        let host:String = (hostname!.text! != "") ? hostname!.text! : defaultHost
        let port:Int = Int(self.port!.text!) ?? defaultPort
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        
    }
    
    @IBAction func upButtonPress(_ sender: Any) {
        console.setContentOffset(CGPoint(x: 0, y: console.contentOffset.y - 250), animated: true)
    }
    @IBAction func downButtonPress(_ sender: Any) {
        console.setContentOffset(CGPoint(x: 0, y: console.contentOffset.y + 250), animated: true)
    }
    
    @IBAction func keyboardButtonPress(_ sender: Any) {
        // prompt for input
        
        if !console.connected
        {
            self.console.insertText("\n")
            return
        }
        
        var alert = UIAlertController(title: "Input Entry", message: "Text entered here will be sent to the remote server.", preferredStyle: UIAlertControllerStyle.alert)
        
        var sendText: UITextField?
        func textPrompt(textField: UITextField!){
            // add the text field and make the result global
            textField.placeholder = "text to send"
            
            sendText = textField
        }
        
        alert.addTextField(configurationHandler: textPrompt)
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler:{ (alertAction:UIAlertAction!) in
            if sendText!.text != nil {
                self.console.insertText(sendText!.text!)
            }
            self.console.insertText("\n")
        }))
        
        
        self.present(alert, animated: true)
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.console.contentInset = contentInset
    }
    
}

