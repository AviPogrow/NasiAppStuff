//
//  SingleDetailViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/25/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class SingleDetailViewController: UITableViewController {

    var selectedSingle: SingleGirl!
    @IBOutlet weak var lookingForLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    @IBOutlet weak var familySituationLabel: UILabel!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var contactCellLabel: UILabel!
    
    
    @IBOutlet weak var contactEmailLabel: UILabel!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var saveLabel: UILabel!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var lastName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        detailImageView.layer.borderWidth = 4
        detailImageView.layer.borderColor = UIColor.black.cgColor
        detailImageView.layer.shadowRadius = 5
        detailImageView.layer.shadowOpacity = 0.3
        */
        
        
        
        if selectedSingle.isSaved == "true" {
            saveButton.isEnabled = false
            //saveButton.isHidden = true
            saveLabel.textColor = UIColor.red
            saveLabel.text = "Already saved to favorites"
        }
        
      navigationItem.title = "\(selectedSingle.firstName)" + " " + "\(selectedSingle.lastName)"
        
       
        if (selectedSingle!.briefDescription != nil) && selectedSingle.lookingFor != nil {
        lookingForLabel.text = selectedSingle.lookingFor!
            descriptionLabel.text = selectedSingle.briefDescription
        } else {
            lookingForLabel.text = "Placeholder for nil"
            descriptionLabel.text = "Placeholder for nil"
        }
    
        lastName = selectedSingle.lastName
        
        let nameOfImage = "\(selectedSingle.imageName)"
        
        
        
         let fixedImageName = nameOfImage.replacingOccurrences(of: " ", with: "")
     
        
        let currentSingleImage = UIImage(named: fixedImageName)
        
        if currentSingleImage != nil {
           detailImageView.image = currentSingleImage
        } else {
            detailImageView.image = UIImage(named: "face02")
        }
        
        contactCellLabel.text = selectedSingle.contactCell
        contactNameLabel.text = selectedSingle.contactName
        contactEmailLabel.text = selectedSingle.contactEmail
        familySituationLabel.text = selectedSingle.familySituation
        
    }
    
    func fetchAfterSave() {
        
        let lastNamePredicate = NSPredicate(format: "%K == %@", #keyPath(SingleGirl.lastName), selectedSingle.lastName)
        
        
    
        let request: NSFetchRequest<SingleGirl> = SingleGirl.fetchRequest()
        
        let ageSortDescriptor = NSSortDescriptor(key: "age", ascending: true)
                        
        request.sortDescriptors = [ageSortDescriptor]
                        
        request.predicate = lastNamePredicate
                        
        do {
         let results =  try managedObjectContext.fetch(request)
            let firstResult = results.first
            let isSaved = firstResult?.isSaved
            print("firstResult is \(firstResult) and isSaved is \(firstResult?.isSaved)")
        } catch {
            print("error fetching core data")
        }
    }
    
    @IBAction func callTapped(_ sender: UIButton) {
        if let url = URL(string: "tel:\( contactCellLabel.text)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
    
     
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        hudView.text = "\(selectedSingle.firstName)-Saved"
      
        
        
    
    do {
        
        selectedSingle.isSaved = "true"
     
        
        try managedObjectContext.save()
      afterDelay(0.4) {
        self.fetchAfterSave()
        hudView.hide()
        self.navigationController?.popViewController(animated: true)
        }
        
    }  catch let error as NSError {

         if error.domain == NSCocoaErrorDomain &&
           (error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError) {
       
         } else {
           print("Could not save \(error), \(error.userInfo)")
         }
       }
 
}
    
   
    // MARK: - Navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
       if segue.identifier == "ShowResume" {
        let controller = segue.destination as! ResumeViewController
           
        controller.selectedSingle = selectedSingle
        }
    }
}
    
    
    

