//
//  NotificationService.swift
//  Bingeable
//
//  Created by Lucas Machi on 6/22/18.
//  Copyright © 2018 Appealing Applications. All rights reserved.
//

//THIS FILE WILL BE USED LATER!
//NOT READY TO IMPLEMENT AT THIS TIME

/*
import Foundation
import UserNotifications
import UserNotificationsUI

extension NotificationService {
    
    /// Use this function to download an image and present it in a notification
    ///
    /// - Parameters:
    ///   - url: the url of the picture
    ///   - completion: return the image in the form of UNNotificationAttachment to be added to the bestAttemptContent attachments eventually
    private func downloadImageFrom(url: URL, with completionHandler: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            // 1. Test URL and escape if URL not OK
            guard let downloadedUrl = downloadedUrl else {
                completionHandler(nil)
                return
            }
            
            // 2. Get current's user temporary directory path
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            // 3. Add proper ending to url path, in the case .jpg (The system validates the content of attached files before scheduling the corresponding notification request. If an attached file is corrupted, invalid, or of an unsupported file type, the notification request is not scheduled for delivery. )
            let uniqueURLEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueURLEnding)
            
            // 4. Move downloadedUrl to newly created urlPath
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            
            // 5. Try adding getting the attachment and pass it to the completion handler
            do {
                let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                completionHandler(attachment)
            }
            catch {
                completionHandler(nil)
            }
        }
        task.resume()
}
*/
