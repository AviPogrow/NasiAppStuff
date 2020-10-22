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
    var selectedSingle: NasiGirlsList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var document: PDFDocument!
        let pathURL = URL(string: selectedSingle.documentDownloadURLString ?? "")!
        document = PDFDocument(url: pathURL)
        
        if let document = document {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
            pdfView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
            pdfView.document = document
        }
        
    }
     
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
     
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        let url = URL(string: selectedSingle.documentDownloadURLString ?? "")!
        let resumeData = try! Data(contentsOf: url)
        
        let urlForImage = URL(string: selectedSingle.imageDownloadURLString ?? "")
        let imageData = try! Data(contentsOf: urlForImage!)
        
        let activityVC = UIActivityViewController(activityItems: [imageData,resumeData], applicationActivities: [])
        // activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.barButtonItem = sender
        
        activityVC.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.copyToPasteboard,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.reminders.sharingextension")
        ]
        
        present(activityVC, animated: true, completion: nil)
        
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
