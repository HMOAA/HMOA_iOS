//
//  CoreGraphicManager.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/07/07.
//

import UIKit
import UniformTypeIdentifiers

public final class CoreGraphicManager {

  public func downsample(imageAt url: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
      
      let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
      guard let source = CGImageSourceCreateWithURL(url as CFURL, sourceOptions) else { return nil }
      let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
      let downsampleOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
      ] as CFDictionary
    
      let downsampledImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions)!
      
      return UIImage(cgImage: downsampledImage)
  }
}
