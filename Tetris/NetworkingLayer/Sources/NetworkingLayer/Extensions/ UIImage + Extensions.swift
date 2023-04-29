//
//  UIImage + Extensions.swift
//  
//
//  Created by Arseny Drozdov on 28.07.2022.
//

import UIKit

extension UIImage {
  func resizeImage(_ maxSideSizeInPx: Int) -> UIImage {
    let maxSideSize = pxToPt(CGFloat(maxSideSizeInPx))

    let oldMaxSideSize = max(size.width, size.height)
    if oldMaxSideSize < maxSideSize { return self }

    let scaleFactor = maxSideSize / oldMaxSideSize

    let newWidth = size.width * scaleFactor
    let newHeight = size.height * scaleFactor
    let newSize = CGSize(width: newWidth, height: newHeight)

    let renderer = UIGraphicsImageRenderer(size: newSize)

    return renderer.image { _ in
      draw(in: CGRect(origin: .zero, size: newSize))
    }
  }

  func jpegDataMaxSize(_ maxSizeInMb: Float) -> Data {
    let maxSizeInMb = CGFloat(maxSizeInMb)

    var imgData = jpegData(compressionQuality: 1)!
    let sizeInMb = CGFloat(imgData.count) / 1024 / 1024

    if sizeInMb > maxSizeInMb {
      imgData = jpegData(compressionQuality: maxSizeInMb / sizeInMb)!
    }

    return imgData
  }

  private func pxToPt(_ px: CGFloat) -> CGFloat {
      px / UIScreen.main.scale
  }

}
