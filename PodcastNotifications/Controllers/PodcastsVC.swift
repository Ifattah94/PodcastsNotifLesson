//
//  PodcastsVC.swift
//  PodcastNotifications
//
//  Created by C4Q on 10/30/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import UIKit

class PodcastsVC: UIViewController {
    
    //MARK: Properties
    
 
       private var currentSelectedPodCast: Podcast!
       private var currentImage: UIImage!
       private var unNotificationCenter: UNUserNotificationCenter!
    
    private var alarmTime: TimeInterval = 0.0 {
        didSet {
            triggerTimeNotification()
        }
    }
    
    
    
       private var podcasts = [Podcast]() {
           didSet {
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
       }
    

    
    //MARK: UI Objects
    
    lazy var tableView: UITableView = {
           let tv = UITableView(frame: view.bounds)
           tv.register(PodcastCell.self, forCellReuseIdentifier: "PodcastCell")
           tv.dataSource = self
           tv.delegate = self
           tv.rowHeight = 80
           return tv
       }()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constrainTableView()
        setupNotificationCenter()
        loadData()

    }
    
    
    //MARK: Private methods
    
    private func loadData() {
        self.podcasts = JSONParser.parsePodcastJSONFile()
    }
    
    private func setupNotificationCenter() {
        unNotificationCenter = UNUserNotificationCenter.current()
        unNotificationCenter.delegate = self
        
        unNotificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print(error)
            }
            print("access granted")
        }
    }
    
    
    
    
    private func constrainTableView() {
           view.addSubview(tableView)
           tableView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate(
               [tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
       }
    
    
    private func showActionSheet() {
        let alertController = UIAlertController(title: "Reminder", message: "Podcast starting soon", preferredStyle: .actionSheet)
        let tenSecondAction = UIAlertAction(title: "10 Seconds", style: .default) { (action) in
            self.alarmTime = 10
        }
        
        let twentySecondAction = UIAlertAction(title: "20 Seconds", style: .default) { (action) in
            self.alarmTime = 20
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(tenSecondAction)
        alertController.addAction(twentySecondAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    private func triggerTimeNotification() {
        let content = UNMutableNotificationContent()
        content.title = "\(currentSelectedPodCast.collectionName) Reminder"
        content.body = "\(currentSelectedPodCast.collectionName) will start now"
        content.sound = .default
        
        //TODO: insert podcast image into the notification
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageId = "image.png"
        let filePath = documentsDirectory.appendingPathComponent(imageId)
        
        let imageData = currentImage.pngData()
        do {
            try imageData?.write(to: filePath)
            let imageAttachment = try UNNotificationAttachment(identifier: imageId, url: filePath, options: nil)
            content.attachments = [imageAttachment]
        }
        catch {
           print(error)
        }
        
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alarmTime, repeats: false)
        let request = UNNotificationRequest(identifier: "PodcastAlarm", content: content, trigger: trigger)
        unNotificationCenter.add(request) { (error) in
            if let error = error {
                print("error with request \(error)")
            }
        }
        
        
    }
    
    
    
}
extension PodcastsVC: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        cell.selectionStyle = .none
        let podcast = podcasts[indexPath.row]
      cell.hostLabel.text = podcast.artistName
      cell.podcastTitleLabel.text = podcast.collectionName
      
      if let image = ImageHelper.shared.image(forKey: podcast.artworkUrl600 as NSString) {
          cell.podcastImage.image = image
      } else {
          ImageHelper.shared.getImage(urlStr: podcast.artworkUrl600) { (result) in
              DispatchQueue.main.async {
                  switch result {
                      
                  case .success(let image):
                      cell.podcastImage.image = image
                  case .failure(let error):
                      print(error)
                  }
              }
          }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedPodCast = podcasts[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! PodcastCell
        currentImage = cell.podcastImage.image
        showActionSheet()
    }
    
}


extension PodcastsVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}


