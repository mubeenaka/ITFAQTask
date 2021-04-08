//
//  UIImageViewExtension.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/8/21.
//

import Foundation
import UIKit

extension UIImageView
{
    func downloadFrom(link:String?, contentmode: UIView.ContentMode)
    {
        contentMode = contentmode
        if link == nil
        {
            self.image = UIImage(named: "default")
            return
        }
        if let url = NSURL(string: link!)
        {
            print("\nstart download: \(url.lastPathComponent!)")
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, _, error) -> Void in
                guard let data = data, error == nil else {
                    print("\nerror on download \(error)")
                    return
                }
                DispatchQueue.main.async {
                    () -> Void in
                        print("\ndownload completed \(url.lastPathComponent!)")
                        self.image = UIImage(data: data)
                }
            }).resume()
        }
        else
        {
            self.image = UIImage(named: "default")
        }
    }
}
