//
//  AboutViewController.swift
//  PhoneBook
//
//  Created by dima on 01.04.18.
//  Copyright © 2018 dima. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var productLab: UILabel!
    @IBOutlet var versionLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        productLab.text = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        versionLab.text = "Version " + version!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
