//
//  ShadchanListDetailViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 5/29/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class ShadchanListDetailViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lookingForLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var familySituationLabel: UILabel!
    
    // Section 0
    @IBOutlet weak var imgVwUserDP: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!

    // Section 1
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblMiddleName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    //Section 2
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblHeightft: UILabel!
    @IBOutlet weak var lblHeightInches: UILabel!
    @IBOutlet weak var lblFamilySituation: UILabel!
    @IBOutlet weak var lblYearItOccurred: UILabel!
    @IBOutlet weak var lblGirlsCellNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    
    //Section 3
    @IBOutlet weak var lblSeminary: UILabel!
    @IBOutlet weak var lblLookingForBriefDescrp: UILabel!
    @IBOutlet weak var lblBriefDescrp: UILabel! //Brief Description of what she is like
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblLivingInIsrael: UILabel!
    @IBOutlet weak var lblFamilyBg: UILabel!
    
    //Section 4
    @IBOutlet weak var lblLastNameToRed: UILabel!
    @IBOutlet weak var lblFirstNameToRed: UILabel!
    @IBOutlet weak var lblCellNumberToRed: UILabel!
    @IBOutlet weak var lblEmailToRed: UILabel!
    
    //Section 5
    @IBOutlet weak var lblContactLastName: UILabel!
    @IBOutlet weak var lblContactFirstName: UILabel!
    @IBOutlet weak var lblContactCell: UILabel!
    @IBOutlet weak var lblContactEmail: UILabel!
    @IBOutlet weak var lblContactRelationshipToSingle: UILabel!
    
    
    var image: UIImage?
    var categoryName = "No Category"
    var selectedSingle: NasiGirlsList!
    
    @IBOutlet weak var boysTableView: UITableView!
    
    var boyList = ["Avi","Moishe", "Yehuda"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackBtn()
        
        // Hide keyboard
        /*
         let gestureRecognizer = UITapGestureRecognizer(target: self,
         action: #selector(hideKeyboard))
         gestureRecognizer.cancelsTouchesInView = false
         tableView.addGestureRecognizer(gestureRecognizer)
         */
        
        /*
         if (selectedSingle!.briefDescriptionOfWhatGirlIsLike != nil) && selectedSingle.briefDescriptionOfWhatGirlIsLookingFor != nil {
         lookingForLabel.text = selectedSingle.briefDescriptionOfWhatGirlIsLookingFor!
         descriptionLabel.text = selectedSingle.briefDescriptionOfWhatGirlIsLike
         } else {
         lookingForLabel.text = "Placeholder for nil"
         descriptionLabel.text = "Placeholder for nil"
         }*/
        
        //self.setBackBtn()
        self.setUpProfilePhoto()
        self.setUpFirstSection()
        self.setUpSecondSection()
        self.setUpThirdSection()
        self.setUpForthSection()
        self.setUpFifthSection()
    }
    
    func setUpProfilePhoto() {
        if (selectedSingle.imageDownloadURLString ?? "").isEmpty {
            imgVwUserDP?.image = UIImage.init(named: "placeholder")
        } else {
            imgVwUserDP.loadImageFromUrl(strUrl: String(format: "%@",selectedSingle.imageDownloadURLString!), imgPlaceHolder: "placeholder")
        }
        
        lblFullName?.text =  "\(selectedSingle.firstNameOfGirl ?? "")" + " "  + "\(selectedSingle.lastNameOfGirl ?? "")" //top 1 name

    }
    
    func setUpFirstSection() {
        lblFirstName?.text = selectedSingle.firstNameOfGirl ?? ""
        lblMiddleName.text = selectedSingle.middleNameOfGirl ?? ""
        lblLastName.text = selectedSingle.lastNameOfGirl ?? ""
        lblName.text = selectedSingle.nameSheIsCalledOrKnownBy ?? ""
    }
    
    func setUpSecondSection() {
        lblDob?.text = "\(selectedSingle.dateOfBirth ?? 0.0)"
        /*
        lblHeightft.text = selectedSingle.heightInFeet ?? ""
        lblHeightInches.text = selectedSingle.heightInInches ?? ""
        */
        
        lblFamilySituation.text = selectedSingle.girlFamilySituation ?? ""
        lblYearItOccurred.text = selectedSingle.yearsOfLearning ?? ""
        lblGirlsCellNumber.text = selectedSingle.girlsCellNumber ?? ""
        lblAddress.text = "Address - Need to discuss"
        lblCity.text = selectedSingle.cityOfResidence ?? ""
        lblState.text = selectedSingle.stateOfResidence ?? ""
        lblZip.text = selectedSingle.zipCode ?? ""
        
        let heightInFt = selectedSingle.heightInFeet ?? ""
        let heightInInches = selectedSingle.heightInInches ?? ""
        let height = "\(heightInFt)\'" + "\(heightInInches)\""
        lblHeightft.text = height

    }
    
    func setUpThirdSection() {
        lblSeminary?.text = "\(selectedSingle.seminaryName ?? "")"
        lblLookingForBriefDescrp?.text = "\(selectedSingle.briefDescriptionOfWhatGirlIsLookingFor ?? "")"
        lblBriefDescrp?.text = "\(selectedSingle.briefDescriptionOfWhatGirlIsLookingFor ?? "")"
        lblPlan?.text = "\(selectedSingle.plan ?? "")"
        lblLivingInIsrael?.text = "\(selectedSingle.livingInIsrael ?? "")"
        lblFamilyBg?.text = "\(selectedSingle.girlFamilyBackground ?? "")"
    }
    
    func setUpForthSection() {
        lblLastNameToRed?.text = "\(selectedSingle.lastNameOfPersonToContactToReddShidduch ?? "")"
        lblFirstNameToRed?.text = "\(selectedSingle.firstNameOfPersonToContactToReddShidduch ?? "")"
        lblCellNumberToRed.text = selectedSingle.cellNumberOfContactToReddShidduch ?? ""
        lblEmailToRed.text = selectedSingle.emailOfContactToReddShidduch
    }
    
    func setUpFifthSection() {
        lblContactLastName?.text = "\(selectedSingle.lastNameOfAContactWhoKnowsGirl ?? "")"
        lblContactFirstName?.text = "\(selectedSingle.firstNameOfAContactWhoKnowsGirl ?? "")"
        lblContactCell.text = selectedSingle.cellNumberOfContactWhoKNowsGirl ?? ""
        lblContactEmail.text = selectedSingle.emailOfContactWhoKnowsGirl ?? ""
        lblContactRelationshipToSingle.text = selectedSingle.relationshipOfThisContactToGirl ?? ""
    }
    
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: tableView)
        
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath != nil && indexPath!.section == 2
            && indexPath!.row == 0 {
            return
        }
        notesTextView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        
        /*
         if (selectedSingle.imageDownloadURLString ?? "").isEmpty {
         profileImageView?.image = UIImage.init(named: "placeholder")
         } else {
         profileImageView.loadImageFromUrl(strUrl: String(format: "%@",selectedSingle.imageDownloadURLString!), imgPlaceHolder: "placeholder")
         }*/
        
    }
    
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        saveImage()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func categoryPickerDidPickCategory(
        _ segue: UIStoryboardSegue) {
        let controller = segue.source as!
        CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        //categoryLabel.text = categoryName
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as!
            CategoryPickerViewController
            controller.selectedCategoryName = categoryName
            
        }
    }
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 || indexPath.section == 2 { return indexPath
        } else {
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         if indexPath.section == 3 && indexPath.row == 0 {
         notesTextView.becomeFirstResponder()
         
         } else if indexPath.section == 1 && indexPath.row == 0 {
         
         tableView.deselectRow(at: indexPath, animated: true)
         pickPhoto()
         
         } else if indexPath.section == 5 && indexPath.row == 0 {
         
         presentResumeViewController()
         } else if indexPath.section == 2 {
         print("add notes")
         self.openNotesListScreen()
         }*/
        
    }
    
    func openNotesListScreen() {
        let vcNotesList = self.storyboard?.instantiateViewController(withIdentifier: "NotesListVC") as! NotesListVC
        vcNotesList.hidesBottomBarWhenPushed = true
        vcNotesList.girlId = selectedSingle.currentGirlUID
        self.navigationController?.pushViewController(vcNotesList, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2  || indexPath.section == 3 || indexPath.section == 4  || indexPath.section == 5 {
            return UITableView.automaticDimension
        }
        else if indexPath.section == 8 {
            return 60
        } else if indexPath.section == 0 {
            if indexPath.row == 0 {
                 return 225
            } else if indexPath.row == 1 {
                return 60
            } else if indexPath.row == 2 {
                return 140
            }
        }
       return UITableView.automaticDimension
    }
    
    @IBAction func sendResumeTapped(_ sender: Any) {
        presentResumeViewController()
    }
    
    func presentResumeViewController() {
        if (selectedSingle.documentDownloadURLString?.isEmpty)! {
            self.showAlert(title: Constant.ValidationMessages.oopsTitle, msg: Constant.ValidationMessages.msgDocumentUrlEmpty, onDismiss: {
            })
        } else {
            let controller = storyboard!.instantiateViewController(withIdentifier: "ResumeViewController") as! ResumeViewController
            controller.selectedSingle = selectedSingle
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        addPhotoLabel.text = ""
        imageHeightConstraint.constant = 360
        tableView.reloadData()
        
    }
    
    func saveImage() {
        /*
         // Save image
         if let image = image {
         // 1
         if !selectedSingle.hasPhoto {
         
         var tempNumber = SingleGirl.nextPhotoID() as NSNumber
         
         
         selectedSingle.photoID = Int(tempNumber) + 1 as NSNumber
         
         }
         // 2
         if let data = image.jpegData(compressionQuality: 0.5) { // 3
         do {
         try data.write(to: selectedSingle.photoURL, options: .atomic)
         } catch {
         print("Error writing file: \(error)")
         }
         }
         }
         */
    }
    
    
}
extension ShadchanListDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- Image Helper Methods
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if true || UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
        })
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

