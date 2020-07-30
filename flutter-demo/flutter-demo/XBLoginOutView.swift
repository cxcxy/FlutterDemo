//
//  XBLoginOutView.swift
//  XBShinkansen
//
//  Created by mac on 2017/12/11.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

enum XBOutType {
    case outLogin
    case delete
    case YesOrNo
    case closeConvert
    case backIsSave// 退出是否保存
    case isFinish // 是否完成
    case setting
    case inviteBusi
}

class XBLoginOutView: ETPopupView {

    var delay : Double = 0.0
    @IBOutlet weak var lbTitleDes: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOut: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        animationDuration = 0.3
        type = .alert
        self.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            //make.height.equalTo(170)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        UIApplication.shared.keyWindow?.endEditing(true)
        self.layoutIfNeeded()
    }
    func  setUI_Title(_ titleStr: String) {
//        lbTitleDes.set_text = titleStr
    }
//    func setUIInfo(_ manager_Type:DepartMentManagerType?, des:String)  {
//        var des_str = des
//        if let manager_Type = manager_Type {
//            switch manager_Type {
//            case .authManager:
//                des_str = "管理操作人" + des
//                break
//            case .department:
//                des_str = "部门" + des
//                break
//            case .departmentMember:
//                des_str = "成员" + des
//                break
//            }
//        }
//
//        lbTitleDes.set_text = "是否删除" + des_str + "？"
//    }
    @IBAction func clickCancelAction(_ sender: Any) {
        self.hide()
//        if let block = self.cancelBlock {
//            XBDelay.start(delay: delay) {
//                block()
//            }
//        }
    }
    
    @IBAction func clickContinueAction(_ sender: Any) {
        self.hide()
//        XBDelay.start(delay: delay) {
//            if let block = self.sureBlock {
//                block()
//            }
//        }
    }
}
