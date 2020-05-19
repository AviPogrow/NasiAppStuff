//
//  Shidduch.swift
//  NasiShadchanHelper
//
//  Created by user on 5/1/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

struct Shidduch: Codable {
  var id = UUID()
  var name = "New Book"
  var rating = 1
  var imageData: Data?
  var note: String?
  
  // grab the imageData and return a UIImage
  func getImage() -> UIImage? {
    if let data = imageData {
      return UIImage(data: data)
    }
    return nil
  }

 // pass in the UIImage nad convert it to data
  mutating func set(image: UIImage?) {
    imageData = image?.jpegData(compressionQuality: 0.5)
  }
}

// MARK: - Exporting/Importing
extension Shidduch {
  
  // encode the book struct into a JSON object
  func exportToURL() -> URL? {
    guard let encoded = try? JSONEncoder().encode(self) else { return nil }
    
    // get the url to the doc directory
    let documents = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
    ).first
    
    // create a path to the url
    guard let path = documents?.appendingPathComponent("/\(name).btkr") else {
      return nil
    }
    
   // write the data to the file path
    do {
      try encoded.write(to: path, options: .atomicWrite)
      return path
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
}
