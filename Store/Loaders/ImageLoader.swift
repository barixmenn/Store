//
//  ImageLoader.swift
//  Store
//
//  Created by Baris on 6.01.2023.
//

import Foundation
import UIKit

class ImageLoader {
    
    static func load(url: URL) async -> UIImage? {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return nil
            }
            
            return UIImage(data: data)
        } catch {
            return nil
        }
        
    }
    
}
