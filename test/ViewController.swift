//
//  ViewController.swift
//  test
//
//  Created by clare on 2017/3/22.
//  Copyright © 2017年 clare. All rights reserved.
//

import UIKit
import AdSupport


class ViewController: UIViewController {
    // 获取当前wifi的IP地址
    func getLocalIPAddressForCurrentWiFi() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func send(_ sender: UIButton) {
        //let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        //let requestUrl = "http://api.v5.9080app.com/SourceClick.ashx"
        let requestUrl = "http://www.baidu.com"
        //let appid =            //渠道id
        //let adid =             //每个广告的id
        //        var ip : String? = getLocalIPAddressForCurrentWiFi()          //手机ip
        //        var mac = "02:00:00:00:00:00"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var req = URLRequest(url: URL(string:requestUrl)!)
        req.httpMethod = "get"
        let task = session.dataTask(with: req, completionHandler: {(data, res, err) -> Void in
            // print(data,res,err)
            let av = UIAlertController(title: "MSG", message: res?.description, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (a) in
                self.dismiss(animated: true, completion: nil)
            })
            av.addAction(action)
            self.present(av, animated: true, completion: nil)
        })
        task.resume()
        
    }

}

