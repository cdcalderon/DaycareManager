//
//  ExportManager.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/23/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import Foundation


//func createExportString(fetchedArray:[DMReport]) -> String {
////    var kidFirstName: String?
////    var kidLastName: String?
////    var kidKey: String?
////    var checkDay: Int?
////    var checkMonth: Int?
////    var checkYear: Int?
////    var parentFirstName: String?
////    var parentLastName: String?
//    
////    var sessionArrayBool: [Bool]? = []
////    var sessionArray: [Double]? = []
//    
//    var export: String = NSLocalizedString("Kid First Name, Kid Last Name, Kid Key, Check In Day, Check In Month, Check In Year, Check Out Day, Check Out Month, Check Out Year, Parent First Name, Parent Last Name \n", comment: "")
//    for report in fetchedArray {
//            let kidFirstName = report.kidFirstName
//            let kidLastName = report.kidLastName
//            let kidKey = "\(report.kidKey)"
//            let checkInDay = "\(report.checkInDay)"
//            let checkInMonth = "\(report.checkInMonth)"
//            let checkInYear = "\(report.checkInYear)"
//            let checkOutDay = "\(report.checkOutDay)"
//            let checkOutMonth = "\(report.checkOutMonth)"
//            let checkOutYear = "\(report.checkOutYear)"
//            let parentFirstName = "\(report.parentFirstName)"
//            let parentLastName = "\(report.parentLastName)"
//            
//            export += kidFirstName + "," + kidLastName + "," + kidKey + "," + checkInDay + "," + checkInMonth + "," + checkInYear + "," + checkOutDay + "," + checkOutMonth + "," + checkOutYear + "," + parentFirstName + "," + parentLastName + "\n"
//        
//    }
//    print("This is what the app will export: \(export)")
//    return export
//}
//
//func exportDatabase(fetchedArray:[DMReport]) {
//    let exportString = createExportString(fetchedArray)
//    saveAndExport(exportString)
//}
//
//func saveAndExport(exportString: String) {
//    let exportFilePath = NSTemporaryDirectory() + "export.csv"
//    let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
//    NSFileManager.defaultManager().createFileAtPath(exportFilePath, contents: NSData(), attributes: nil)
//    var fileHandleError: NSError? = nil
//    var fileHandle: NSFileHandle? = nil
//    do {
//        fileHandle = try NSFileHandle(forWritingToURL: exportFileURL)
//    } catch {
//        print("Error with fileHandle")
//    }
//    
//    if fileHandle != nil {
//        fileHandle!.seekToEndOfFile()
//        let csvData = exportString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//        fileHandle!.writeData(csvData!)
//        
//        fileHandle!.closeFile()
//        
//        let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
//        let activityViewController : UIActivityViewController = UIActivityViewController(
//            activityItems: [firstActivityItem], applicationActivities: nil)
//        
//        activityViewController.excludedActivityTypes = [
//            UIActivityTypeAssignToContact,
//            UIActivityTypeSaveToCameraRoll,
//            UIActivityTypePostToFlickr,
//            UIActivityTypePostToVimeo,
//            UIActivityTypePostToTencentWeibo,
//            UIActivityTypeMail
//        ]
//        
////        if requestBodyData.length > 0{
////            mc.addAttachmentData(requestBodyData, mimeType: "text/csv", fileName: "MyCSVFileName.csv")
////        } else {
////            
////        }
//
//        
//        self.presentViewController(activityViewController, animated: true, completion: nil)
//    }
//}
