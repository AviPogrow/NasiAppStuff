//
//  MainResumeVC.swift
//  NasiShadchanHelper
//
//  Created by apple on 16/11/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import PDFKit

class ResumeViewController: UITableViewController {
    var selectedSingle: NasiGirlsList!
    // Section 1
    @IBOutlet weak var imgVwUserDP: UIImageView!
    @IBOutlet weak var btnShareResumeOnly: UIButton!
    @IBOutlet weak var btnShareResumeAndPhoto: UIButton!
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpProfilePhoto()
        self.setBackBarButton()
        self.setUpPDFView()
    }
    
    //TODO: Set Back Bar Button
    private func setBackBarButton() {
        let btn = UIBarButtonItem(image: UIImage.init(named: "imgBack"), style: .plain, target: self, action: #selector(back))
        btn.tintColor = .black
        self.navigationItem.leftBarButtonItem  = btn
    }
    
    func setUpPDFView() {
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
    
    //TODO: Back Button Action
    @objc func backBtnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //TODO: Initialize Data
    private func setUpProfilePhoto() {
        if (selectedSingle.imageDownloadURLString ?? "").isEmpty {
            imgVwUserDP?.image = UIImage.init(named: "placeholder")
        } else {
            imgVwUserDP.loadImageFromUrl(strUrl: String(format: "%@",selectedSingle.imageDownloadURLString!), imgPlaceHolder: "placeholder")
        }
        
        btnShareResumeOnly.addRoundedViewCorners(width: 4, colorBorder: Constant.AppColor.colorAppTheme)
        btnShareResumeAndPhoto.addRoundedViewCorners(width: 4, colorBorder: Constant.AppColor.colorAppTheme)
    }
    
    func shareResumeOnly() {
        let url = URL(string: selectedSingle.documentDownloadURLString ?? "")!
        let resumeData = try! Data(contentsOf: url)
        
        
        let activityVC = UIActivityViewController(activityItems: [resumeData], applicationActivities: [])
        //activityVC.popoverPresentationController?.barButtonItem = sender
        
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
    
    func shareResumeAndPhotos() {
        
        let url = URL(string: selectedSingle.documentDownloadURLString ?? "")!
        let resumeData = try! Data(contentsOf: url)
        
        let urlForImage = URL(string: selectedSingle.imageDownloadURLString ?? "")
        let imageData = try! Data(contentsOf: urlForImage!)
        
        let activityVC = UIActivityViewController(activityItems: [imageData,resumeData], applicationActivities: [])
        //activityVC.popoverPresentationController?.barButtonItem = sender
        
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
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
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
}

// ----------------------------------
// MARK: - BUTTION ACTION(S) -
//
extension ResumeViewController {
    @IBAction func btnShareResumeTapped(_ sender: Any) {
        self.shareResumeOnly()
    }
    
    @IBAction func btnShareResumePhotoTapped(_ sender: Any) {
        self.shareResumeAndPhotos()
    }
}

// ----------------------------------
// MARK: - TableView Delegate(S) -
//
extension ResumeViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                //   self.shareResumeOnly()
            } else if indexPath.row == 2 {
                // self.shareResumeAndPhotos()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 50
            } else if indexPath.row == 1 {
                return 310
            } else {
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
}

