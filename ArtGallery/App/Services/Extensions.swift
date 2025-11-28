//
//  Extensions.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import Foundation
import UIKit

extension String {
    var htmlStripped: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            return self
        }
    }
}

extension String {
    func toUIImage() -> UIImage? {
            let separator = "base64,"
            
            guard let separatorRange = self.range(of: separator) else {
                return nil
            }
            let dataSubstring = self.suffix(from: separatorRange.upperBound)
            
            guard let data = Data(base64Encoded: String(dataSubstring)) else {
                return nil
            }
            return UIImage(data: data)
        }
}
