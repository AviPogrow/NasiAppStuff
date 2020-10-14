
import UIKit

class TextFieldSupport: NSObject,UITextFieldDelegate {
    var tfDelegate: UITextFieldDelegate?
    //MARK: TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let shouldBeignEditing = tfDelegate?.textFieldShouldBeginEditing?(textField) else {
            return true
        }
        return shouldBeignEditing
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfDelegate?.textFieldDidBeginEditing?(textField)
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let shouldEndEditing = tfDelegate?.textFieldShouldEndEditing?(textField) else {
            return true
        }
        return shouldEndEditing
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let strText = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if textField.text == "\n" || textField.text == "" || strText == "" {
            textField.rightView = nil
            textField.text = nil
        }
        tfDelegate?.textFieldDidEndEditing?(textField)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let changeCharacters = tfDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) else {
            return true
        }
        return changeCharacters
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard let shouldClear = tfDelegate?.textFieldShouldClear?(textField) else {
            return true
        }
        return shouldClear
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let shouldReturn = tfDelegate?.textFieldShouldReturn?(textField) else {
            return true
        }
        return shouldReturn
    }
}

class AlignedPlaceholderTextField: UITextField {
    @IBInspectable var strErrorMsg: String!
    @IBInspectable var strValidRegex: String!
    @IBInspectable var alignPlaceholder: Bool = false
    @IBOutlet weak var txtConfirmtext: AlignedPlaceholderTextField!
    var support: TextFieldSupport = TextFieldSupport.init()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.tintColor = Constant.AppColor.colorAppTheme
        // self.setValue(UIColor.red, forKeyPath: "_placeholderLabel.textColor")
        self.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override var delegate: UITextFieldDelegate? {
        didSet {
            support.tfDelegate = delegate
            super.delegate = support
        }
    }
    func addLeftPadding() {
        let leftPading = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 45))
        leftPading.backgroundColor = UIColor.clear
        self.leftView = leftPading
        self.leftViewMode = .always
    }
    @objc func textChanged(textField: AlignedPlaceholderTextField) {
        let strText = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if textField.text == "\n" || textField.text == "" || strText == "" {
            textField.text = nil
        } else if alignPlaceholder == true {
            setAlignedPlaceHolder()
        } else {
            let validation =  NSPredicate.init(format: "SELF MATCHES %@",strValidRegex ?? String.Regex_Req)
            let btnTxtValidte = UIButton.init(frame: CGRect.init(x: 8, y: 8, width: 30, height: 30))
            btnTxtValidte.contentMode = .scaleAspectFit
            btnTxtValidte.isUserInteractionEnabled = false
            btnTxtValidte.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            if strValidRegex == "confirm" {
                (self.text == txtConfirmtext.text) ? btnTxtValidte.setImage(imgName: "imgTxtCDark1") : btnTxtValidte.setImage(imgName: "imgTxtCDark0")
            } else {
                (validation.evaluate(with: self.text)) ? btnTxtValidte.setImage(imgName: "imgTxtCDark1") : btnTxtValidte.setImage(imgName: "imgTxtCDark0")
            }
            self.rightView = btnTxtValidte
            self.rightViewMode = .always
        }
    }
    override var text: String? {
        willSet {
            let strText = self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if self.text == "\n" || self.text == "" || strText == "" {
                self.rightView = nil
            } else if alignPlaceholder == true {
                setAlignedPlaceHolder()
            }
        }
    }
    func setAlignedPlaceHolder() {
        let lblRightPlaceholder: UILabel = (self.rightView != nil) ? self.rightView as! UILabel : UILabel.init(frame: CGRect.zero)
        lblRightPlaceholder.numberOfLines = 1
        lblRightPlaceholder.font = UIFont.init(name: Constant.AppFont.fontRegular, size: 9.0)
        lblRightPlaceholder.textColor = UIColor.red
        lblRightPlaceholder.text = self.placeholder
        lblRightPlaceholder.textAlignment = .right
        lblRightPlaceholder.sizeToFit()
        self.rightView = lblRightPlaceholder
        self.rightViewMode = .always
    }
    @discardableResult func validate() -> Bool {
        let validation =  NSPredicate.init(format: "SELF MATCHES %@",strValidRegex)
        if strValidRegex == "confirm" && self.text == txtConfirmtext.text {
            return true
        } else if strValidRegex == "email" {
            let strText = self.text?.trimmingCharacters(in: .whitespaces)
            if (strText?.isValidEmail())! {
                return true
            }
            else {
                showErrorMessage()
                return false
            }
        } else if validation.evaluate(with: self.text) {
            return true
        } else {
            showErrorMessage()
            return false
        }
    }
    
    func showErrorMessage() {
        let btnErrMsg = UIButton.init(type: .custom)
        btnErrMsg.titleLabel?.font = UIFont.init(name: Constant.AppFont.fontRegular, size: 11.0)
        btnErrMsg.setTitleColor(UIColor.red, for: .normal)
        btnErrMsg.setTitle(title: self.isNoTextExists() ? "*Req " : strErrorMsg)
        btnErrMsg.isUserInteractionEnabled = false
        btnErrMsg.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.rightView = btnErrMsg
        btnErrMsg.sizeToFit()
        self.rightViewMode = .always
    }
    
    func showErrorMessage(msg: String) {
        let btnErrMsg = UIButton.init(type: .custom)
        btnErrMsg.titleLabel?.font = UIFont.init(name: Constant.AppFont.fontRegular, size: 11.0)
        btnErrMsg.setTitleColor(UIColor.red, for: .normal)
        btnErrMsg.setTitle(title: msg)
        btnErrMsg.isUserInteractionEnabled = false
        btnErrMsg.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.rightView = btnErrMsg
        btnErrMsg.sizeToFit()
        self.rightViewMode = .always
    }
}
