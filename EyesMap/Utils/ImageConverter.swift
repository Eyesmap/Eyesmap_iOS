//
//  ImageConverter.swift
//  EyesMap
//
//  Created by 박현준 on 2023/09/01.
//

import UIKit
import SDWebImage

class ImageConverter {
    static func convertURLArrayToImages(_ urls: [String], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let group = DispatchGroup()

        for url in urls {
            let url = URL(string: url)
            
            group.enter()

            SDWebImageManager.shared.loadImage(
                with: url,
                options: .continueInBackground,
                progress: nil,
                completed: { (image, _, _, _, _, _) in
                    if let image = image {
                        images.append(image)
                    }
                    group.leave()
                }
            )
        }

        group.notify(queue: .main) {
            completion(images)
        }
    }
}
