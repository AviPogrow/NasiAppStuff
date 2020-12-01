//
//  GetStartedVC.swift
//  Hi Me
//
//  Created by apple on 06/04/20.
//  Copyright © 2020 Soft Radix. All rights reserved.
//

import UIKit

class GetStartedVC: UIViewController {
    
    // MARK:- IBoutlets
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var blurBg: GradientTransView!

    fileprivate var hasViewAppeared = false

    // MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        blurBg.backgroundColor = UIColor.gradient(style: .topToBottom, frame: CGRect(x: 0, y: 0, width: blurBg.frame.size.width, height: blurBg.frame.size.height), colors: Constant.AppGradientColor.aryGradientTopLightBlackLayer)
        btnGetStarted.setCornerRadius(radius: btnGetStarted.frame.size.height/2,colorBorder: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

// MARK:- IBactions
extension GetStartedVC {
    
    @IBAction func btnGetStartedTapped(_ sender: UIButton) {
        let vcLoginParent : SignUpVC = Constant.AppStoryboard.UserAuth.instance.instantiateViewController()
       // Variables.sharedVariables.isFromSignUp = true
        self.navigationController?.pushViewController(vcLoginParent, animated: true)
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        let vcLoginParent : LoginVC = Constant.AppStoryboard.UserAuth.instance.instantiateViewController()
        self.navigationController?.pushViewController(vcLoginParent, animated: true)
    }
    
}
