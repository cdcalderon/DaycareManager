//
//  SendReportViewController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/28/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit
import Firebase

class SendReportViewController: UIViewController {

    
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    @IBAction func fromDatePickerChanged(sender: UIDatePicker) {
        sendReport()
    }
    
    @IBAction func toDatePickerChanged(sender: UIDatePicker) {
    }
    
    
    func setDateAndTime() {
        let dateFormatter = NSDateFormatter()
        let timeFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        
        
       // dateTimeDisplay.text = dateFormatter.stringFromDate(datePicker.date) + " " + timeFormatter.stringFromDate(timePicker.date)
    }
    
    func sendReport () {
        let calendar = NSCalendar.currentCalendar()

        var fromDateComponents = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: fromDatePicker.date)
        
        var toDateComponents = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: toDatePicker.date)
        
     let fromInterval = fromDatePicker.date.timeIntervalSince1970 * 1000
        
        print(fromInterval)
        
        let currentAppUser = DataService.ds.REF_USER_CURRENT
        
        DataService.ds.REF_CHECK_ACTION.queryOrderedByChild("timestamp").queryStartingAtValue(fromInterval).observeEventType(.Value, withBlock: { snapshot in
            print(snapshot)
            
       //     self.kidsArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    print("SNAP:  \(snap)")
                    
//                    if let kidDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let kid = DMKid(kidKey: key, dictionary: kidDict)
//                        self.kidsArray.append(kid)
//                    }
                }
            }
            
            //self.kidCollectionView.reloadData()
        })
        
        
        
//        var ar: [DMReport] = [DMReport]()
//        
//        ar.append(DMReport(kidFirstName: "Coky", kidLastName: "Calderon", kidKey: "123456789", checkInDay: 12, checkInMonth: 3, checkInYear: 2016, checkOutDay: 12, checkOutMonth: 3, checkOutYear: 2016, parentFirstName: "Carlos", parentLastName: "Calderon"))
//        
//        exportDatabase(ar)
        

    }
    
    
    
    func createExportString(fetchedArray:[DMReport]) -> String {
        
        var export: String = NSLocalizedString("Kid First Name, Kid Last Name, Kid Key, Check In Day, Check In Month, Check In Year, Check Out Day, Check Out Month, Check Out Year, Parent First Name, Parent Last Name \n", comment: "")
        for report in fetchedArray {
            let kidFirstName = report.kidFirstName
            let kidLastName = report.kidLastName
            let kidKey = "\(report.kidKey)"
            let checkInDay = "\(report.checkInDay)"
            let checkInMonth = "\(report.checkInMonth)"
            let checkInYear = "\(report.checkInYear)"
            let checkOutDay = "\(report.checkOutDay)"
            let checkOutMonth = "\(report.checkOutMonth)"
            let checkOutYear = "\(report.checkOutYear)"
            let parentFirstName = "\(report.parentFirstName)"
            let parentLastName = "\(report.parentLastName)"
            
            export += kidFirstName + "," + kidLastName + "," + kidKey + "," + checkInDay + "," + checkInMonth + "," + checkInYear + "," + checkOutDay + "," + checkOutMonth + "," + checkOutYear + "," + parentFirstName + "," + parentLastName + "\n"
            
        }
        print("This is what the app will export: \(export)")
        return export
    }
    
    func exportDatabase(fetchedArray:[DMReport]) {
        let exportString = createExportString(fetchedArray)
        saveAndExport(exportString)
    }
    
    func saveAndExport(exportString: String) {
        let exportFilePath = NSTemporaryDirectory() + "export.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        NSFileManager.defaultManager().createFileAtPath(exportFilePath, contents: NSData(), attributes: nil)
        var fileHandleError: NSError? = nil
        var fileHandle: NSFileHandle? = nil
        do {
            fileHandle = try NSFileHandle(forWritingToURL: exportFileURL)
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            fileHandle!.writeData(csvData!)
            
            fileHandle!.closeFile()
            
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivityTypeAssignToContact,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypePostToFlickr,
                UIActivityTypePostToVimeo,
                UIActivityTypePostToTencentWeibo,
                UIActivityTypeMail
            ]
            
            //        if requestBodyData.length > 0{
            //            mc.addAttachmentData(requestBodyData, mimeType: "text/csv", fileName: "MyCSVFileName.csv")
            //        } else {
            //
            //        }
            
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
}
