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
    
    var image: UIImage?
    var categoryName = "No Category"
    var selectedSingle: SingleGirl!
    
    
    @IBOutlet weak var boysTableView: UITableView!
    
    var boyList = ["Avi","Moishe", "Yehuda"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
     // Hide keyboard
     let gestureRecognizer = UITapGestureRecognizer(target: self,
                                     action: #selector(hideKeyboard))
     gestureRecognizer.cancelsTouchesInView = false
     tableView.addGestureRecognizer(gestureRecognizer)
        
        
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
     
        let imageName = selectedSingle.imageName
        let profileImage = UIImage(named: imageName)
        profileImageView.image = profileImage
        
       if selectedSingle.hasPhoto {
        if let theImage = selectedSingle.photoImage {
         show(image: theImage)
        }
      }
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
    if indexPath.section == 2 && indexPath.row == 0 {
    notesTextView.becomeFirstResponder()
    
    } else if indexPath.section == 1 && indexPath.row == 0 {
    
    tableView.deselectRow(at: indexPath, animated: true)
    pickPhoto()
   
    } else if indexPath.section == 4 && indexPath.row == 0 {
       
        presentResumeViewController()
        }
    }
    
    @IBAction func sendResumeTapped(_ sender: Any) {
        presentResumeViewController()
    }
    
    func presentResumeViewController() {
      let controller = storyboard!.instantiateViewController(withIdentifier: "ResumeViewController") as! ResumeViewController
      controller.selectedSingle = selectedSingle
      navigationController?.pushViewController(controller, animated: true)
      }

    
   func show(image: UIImage) {
     imageView.image = image
     imageView.isHidden = false
     addPhotoLabel.text = ""
     imageHeightConstraint.constant = 360
     tableView.reloadData()
   
   }

    func saveImage() {
        
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

