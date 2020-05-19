//
//  ResumeViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/29/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import PDFKit
import MessageUI

class ResumeViewController: UIViewController {

    public var documentData: Data?
    @IBOutlet weak var pdfView: PDFView!
    
    let dataString = "TestingActivityVC"
    var shidduch =  Shidduch()
    var selectedSingle: SingleGirl!
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
      
        let resume = "Resume"
    
        let imageNameRaw = selectedSingle.imageName
        let fixedImageName = imageNameRaw.replacingOccurrences(of: " ", with: "")
        
        let resumeString = fixedImageName + resume
        
        print("the value of imageNameRaw: - \(imageNameRaw) fixedImageName: - \(fixedImageName) resumeString: - \(resumeString)")
        
        var document: PDFDocument!
        
        var  resumeURL = Bundle.main.url(forResource: resumeString,
        withExtension: "pdf")
        
        if resumeURL != nil {
            document = PDFDocument(url: resumeURL!)
        } else {
            
            let url =  resumeURL
            
            document = PDFDocument(url: url!)
        }
    
        if let document = document {
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = false
        
         pdfView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        
         pdfView.document = document
       // let page = pdfView.document?.page(at: 0)
       // let displayBox = pdfView.displayBox
       // let size = CGSize(width: 200, height: 200)
       // let image = page?.thumbnail(of: size , for: displayBox)
        //thumbnailImageView.image = image
         //let pdfString = pdfView.document?.string
        //let pdfStringComps = pdfString?.components(separatedBy: "\n")
        //print("the pdfString is \(pdfStringComps!)")
        }
 
      }
    

    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
    
        let resume = "Resume"
        let imageNameRaw = selectedSingle.imageName
        let fixedImageName = imageNameRaw.replacingOccurrences(of: " ", with: "")
               
        let resumeString = fixedImageName + resume
      
        let url = Bundle.main.url(forResource: resumeString,
        withExtension: "pdf")
        
        let resumeData = try! Data(contentsOf: url!)
        
        let currentSingleImage = UIImage(named: fixedImageName)
             
        if currentSingleImage != nil {
            //detailImageView.image = currentSingleImage
            } else {
           // detailImageView.image = UIImage(named: "face02")
        }
        
        
        
        let imageData = currentSingleImage?.jpegData(compressionQuality: 0.5)
        
        
        let activityVC = UIActivityViewController(activityItems: [imageData,resumeData], applicationActivities: [])
        
        activityVC.popoverPresentationController?.barButtonItem = sender
        
        present(activityVC, animated: true, completion: nil)
        
      
      /*
      // 2
      let activity = UIActivityViewController(
        activityItems: ["Here is the shidduch idea we discussed", url!],
        applicationActivities: nil
      )
      activity.popoverPresentationController?.barButtonItem = sender

      // 3
      present(activity, animated: true, completion: nil)
 */
    }

    
    

    
    @IBAction func showResumeTapped(_ sender: Any) {
        print("Need to show resume")
        
        //let resumeData = try! Data(contentsOf: url)
        //let vc = UIActivityViewController(activityItems: [resumeData], applicationActivities: [])
           
        //present(vc, animated: true, completion: nil)
    }
}
extension ResumeViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      dismiss(animated: true, completion: nil)
    }
}
