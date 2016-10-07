//
//  ViewController.swift
//  ReplayKitSample
//
//  Created by Prianka Liz Kariat on 9/26/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit
import ReplayKit

struct BookListVCConstants {
  
  static let recordButtonOuterViewSize: CGFloat = 40.0
  static let recordButtonViewSize: CGFloat = 32.0

  
}

class BookListVC: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var cameraPreviewView: UIView!
  var screenRecorder: RPScreenRecorder?
  var previewVC: RPPreviewViewController?
  var books: [[String : String]] = []
  var window: UIWindow?
  var recordButtonView: UIView?
  var recordButtonOuterView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpRecordIndicationWindow()
    
    buildData()
  
    screenRecorder = RPScreenRecorder.shared()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.dataSource = self
    tableView.delegate = self
    
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  
  func setUpRecordIndicationWindow() {

    recordButtonOuterView = UIView(frame: CGRect(x: view.bounds.midX - BookListVCConstants.recordButtonOuterViewSize/2.0, y: self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height, width: BookListVCConstants.recordButtonOuterViewSize, height: BookListVCConstants.recordButtonOuterViewSize))
    recordButtonOuterView?.backgroundColor = UIColor(red: 171.0/255.0, green: 171.0/255.0, blue: 171.0/255.0, alpha: 0.3)
    
    recordButtonView = UIView(frame: CGRect(x:
      recordButtonOuterView!.bounds.midX - BookListVCConstants.recordButtonViewSize / 2.0, y: (BookListVCConstants.recordButtonOuterViewSize - BookListVCConstants.recordButtonViewSize) / 2.0, width: BookListVCConstants.recordButtonViewSize, height: BookListVCConstants.recordButtonViewSize))
    
    recordButtonView?.backgroundColor = UIColor(red: 200.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    recordButtonView?.layer.cornerRadius = recordButtonView!.bounds.size.width/2.0
    
    recordButtonOuterView?.addSubview(recordButtonView!)
    
    window = UIWindow(frame: view.bounds)

    window?.backgroundColor = UIColor.clear
    window?.isUserInteractionEnabled = false
    
    window?.addSubview(recordButtonOuterView!)
    window?.makeKeyAndVisible()
    
  }
  
  func buildData() {
    
    books.append(["BookName" : "A Tale of Two Cities", "Author" : "Charles Dickens", "Image" : "charles"])
    books.append(["BookName" : "1984", "Author" : "George Orwell", "Image" : "george"])
    books.append(["BookName" : "Adventures of Huckleberry Finn", "Author" : "Mark Twain", "Image" : "mark"])
    books.append(["BookName" : "The Unexpected Guest", "Author" : "Agatha Christie", "Image" : "agatha"])
    books.append(["BookName" : "Pride and Prejudice", "Author" : "Jane Austen", "Image" : "jane"])
    books.append(["BookName" : "Deception Point", "Author" : "Dan Brown", "Image" : "dan"])
    books.append(["BookName" : "Harry Potter and the Chamber of Secrets", "Author" : "JK Rowling", "Image" : "jk"])
    books.append(["BookName" : "A Thousand Splendid Suns", "Author" : "Khaled Hosseini", "Image" : "khaleid"])

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onClickRecordButton(_ sender: AnyObject) {
    
    let button = sender as? UIButton
    
    guard button?.isSelected == false else {
      
      stopRecordingWithSender(sender: button)
      return
    }
    
   startRecordingWithSender(sender: button)
  }
  
  
  private func startRecordingWithSender(sender: UIButton?) {
    
    screenRecorder?.isMicrophoneEnabled = true
    
    sender?.isEnabled = false
    
    screenRecorder?.startRecording(handler: {[weak self] (error) in
      
      DispatchQueue.main.async {
        
        guard error == nil else {
          
          self?.showErrorAlertWithMesage(message: "Sorry!! Your recording couldn't be started. Please try again.")
          self?.recordButtonView?.layer.cornerRadius = (self?.recordButtonView)!.bounds.size.width/2.0
          sender?.isSelected = false
          sender?.isEnabled = true
          return
        }
        
        self?.recordButtonView?.layer.cornerRadius = 0.0
        sender?.isSelected = true
        sender?.isEnabled = true

      }
      
    })
    
    if screenRecorder?.isRecording == true {
      recordButtonView?.layer.cornerRadius = 0.0
      sender?.isSelected = true
    }

  }
  
  
  private func stopRecordingWithSender(sender: UIButton?) {
    
    sender?.isEnabled = false
    
    screenRecorder?.stopRecording(handler: {[weak self] (previewViewController, error) in
      
      DispatchQueue.main.async {
        
        guard error == nil else {
          
          self?.showErrorAlertWithMesage(message: "Sorry!! Your recording couldn't be stopped. Please try again.")
          self?.recordButtonView?.layer.cornerRadius = 0.0
          sender?.isSelected = true
          sender?.isEnabled = true
          
          return
        }
        
        previewViewController?.previewControllerDelegate = self
        self?.previewVC = previewViewController
        if let previewVC = self?.previewVC {
          self?.present(previewVC, animated: true, completion: nil)
          self?.window?.isHidden = true
          
        }
        
        self?.recordButtonView?.layer.cornerRadius = (self?.recordButtonView)!.bounds.size.width/2.0
        sender?.isSelected = false
        sender?.isEnabled = true
        
      }
      
      })
    
    if screenRecorder?.isRecording == false {
      recordButtonView?.layer.cornerRadius = recordButtonView!.bounds.size.width/2.0
      sender?.isSelected = false
      
    }
  }
  
  private func showErrorAlertWithMesage(message: String) {

      let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Camera Capture"), message:NSLocalizedString("This app doesn't have permission to use the camera. Please change the privacy settings", comment: "Camera Capture"), preferredStyle: UIAlertControllerStyle.alert)
      
      let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
  }

}


extension BookListVC : UITableViewDataSource, UITableViewDelegate{

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return books.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "BOOK_CELL") as! BookCell
    let book = books[indexPath.row]
    
    cell.bookNameLabel.text = book["BookName"]
    cell.authorNameLabel.text = book["Author"]
    cell.authorImageView.image = UIImage(named: book["Image"]!)
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 200.0
  }

}

extension BookListVC : RPPreviewViewControllerDelegate {
  
  func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
    
    previewController.dismiss(animated: true) { 
      
      self.window?.isHidden = false
            
    }
  }
  
}

