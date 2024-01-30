//
//  RNShare.swift
//  SharpsellSampleSDKIOS
//
//  Created by Surya on 30/01/24.
//

import Foundation
import UIKit
import SharpsellCore

@objc(RNShare)
class RNShare : NSObject {

  @objc static func requiresMainQueueSetup() -> Bool {
      return false
  }

  @objc func createSharpsellEngine(_ callback: RCTResponseSenderBlock) -> Void {
    Sharpsell.services.createFlutterEngine()
//    callback(true)
  }
  
  @objc func initilizeSharpsell(_ options: NSDictionary,_ callback: RCTResponseSenderBlock) -> Void {
  
    DispatchQueue.main.async {
      self._initSharpsell(options: options, () {
        callback(["success"])
      })
    }
  }
  
  @objc func open(_ options: NSDictionary) -> Void {
    DispatchQueue.main.async {
      self._openSharpsellScreen(arguments: options)
    }
  }
  
  @objc func logoutSharpsell(_  options: NSDictionary) -> Void {
    Sharpsell.services.clearData {
      // call back
      // Navigate back to your parent screen
//      let presentedViewController = RCTPresentedViewController();
//      presentedViewController?.navigationController?.popViewController(animated: true);
    } onFailure: { message, errorType in
      print("Logut Failed")
    }
  }
  
  func _initSharpsell(options: NSDictionary,_ callback: RCTResponseSenderBlock) -> Void {
    var items = [String]()
    let companyCode:String = RCTConvert.nsString(options["company_code"])
    let userUniqueId:String = RCTConvert.nsString(options["user_unique_id"])
    let sharpsellApiKey:String = RCTConvert.nsString(options["sharpsell_api_key"])
    let fcmToken:String = RCTConvert.nsString(options["fcm_token"])

    
    let initSharpsellData: [String:Any] = [
        "company_code":companyCode,
        "user_unique_id":  userUniqueId,
        "sharpsell_api_key": sharpsellApiKey,
        "fcm_token": fcmToken]
  
    
    Sharpsell.services.enableLogs(forProd: true) { flutterViewController in
        NSLog("Sharpsell Parent App: Logs enabled successfully")
    } onFailure: { message, errorType in
        NSLog("Sharpsell Parent App: Failed to enable sharpsell logs")
    }

    Sharpsell.services.initialize(smartsellParameters: initSharpsellData) {
        NSLog("Sharpsell Parent App - Flutter Initialization Success")
        callback(["succes"])
    } onFailure: { (errorMessage, smartsellError) in
        switch smartsellError {
        case .flutterError:
            NSLog("Error Message: \(errorMessage)")
        case .flutterMethodNotImplemented:
            NSLog("Error Message: Flutter Method Not Implemented")
        default:
            NSLog("Error Message: UnKnown Error in \(#function)")
        }
    }
  }
  
  func _openSharpsellScreen(arguments: NSDictionary) -> Void {
    var sharpsellOpenDataInString: String? = nil
    
    let sharpsellDict = arguments.swiftDictionary
    sharpsellOpenDataInString = Sharpsell.services.convertJsonToString(dict: sharpsellDict)
    
    Sharpsell.services.open(arguments: sharpsellOpenDataInString ?? ""){ (flutterViewController) in
        flutterViewController.navigationController?.navigationBar.isHidden = true
       let presentedViewController = RCTPresentedViewController();
      presentedViewController.navigationController?.pushViewController(flutterViewController, animated: true)
    } onFailure: { (errorMessage, smartSellError) in
        switch smartSellError {
        case .flutterError:
            debugPrint("Error Message: \(errorMessage)")
        case .flutterMethodNotImplemented:
            debugPrint("")
        default:
            debugPrint("")
        }
    }
  }
  

  }

//  func _open(options: NSDictionary) -> Void {
//    var items = [String]()
//    let message = RCTConvert.nsString(options["message"])
//
//    if message != "" {
//      items.append(message!)
//    }
//
//    if items.count == 0 {
//      print("No `message` to share!")
//      return
//    }
//
//    let controller = RCTPresentedViewController();
//    let shareController = UIActivityViewController(activityItems: items, applicationActivities: nil);
//
//    shareController.popoverPresentationController?.sourceView = controller?.view;
//
//    controller?.present(shareController, animated: true, completion: nil)
//  }
}

extension NSDictionary {
    var swiftDictionary: Dictionary<String, Any> {
        var swiftDictionary = Dictionary<String, Any>()

        for key : Any in self.allKeys {
            let stringKey = key as! String
            if let keyValue = self.value(forKey: stringKey){
                swiftDictionary[stringKey] = keyValue
            }
        }

        return swiftDictionary
    }
}
