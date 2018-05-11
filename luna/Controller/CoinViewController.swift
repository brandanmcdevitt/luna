//
//  CoinViewController.swift
//  luna
//
//  Created by Brandan McDevitt on 10/05/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {

    var coinPassedFromPrevious: String?
    
    @IBOutlet weak var tvCoinName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvCoinName.text = "Viewing stats for \(coinPassedFromPrevious!)"
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
