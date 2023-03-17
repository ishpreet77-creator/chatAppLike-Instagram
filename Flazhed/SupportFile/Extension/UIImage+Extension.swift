//
//  UIImage+Extension.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import SDWebImage

extension UIImageView {
    func roundedImageWithBorder() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        self.contentMode = .scaleToFill
        self.layer.borderWidth = 2
        self.layer.cornerRadius = self.bounds.width / 2
    }
}

extension UIImageView {
    func setImage(imageName:String = "",isStory:Bool=false,isHangout:Bool=false,placeHolderImage:String="placeholderImage")
    {
        DispatchQueue.main.async {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        var url:URL!
        
        if !imageName.contains(kHttps) &&  !imageName.contains(kHttp)
        {
            if isStory
            {
                url = URL(string: kstoryTale+imageName)
            }
            else if isHangout
            {
                url = URL(string: kHangoutTale+imageName)
            }
            else
            {
                url = URL(string: IMAGE_BASE_URL+imageName)
            }
          
        }
       else
        {
         url = URL(string: imageName)
        }
    
        self.sd_setImage(with: url, placeholderImage: UIImage(named: placeHolderImage), options: [], completed: nil)
        }
    }
    func loadingGif(gifName:String,placeholderImage:String = "placeholderImage") {
        let path1 : String = Bundle.main.path(forResource: gifName, ofType: "gif")!
        let url = URL(fileURLWithPath: path1)
        self.sd_setImage(with: url, placeholderImage: UIImage(named: placeholderImage), options: [], completed: nil)
   
    }
}


extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            debugPrint("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
 
    static func fromURLGif(frame: CGRect, resourceName: String,url:String) -> UIImageView?
        {

            let url = URL(string: url)!
            guard let gifData = try? Data(contentsOf: url),
                let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
            var images = [UIImage]()
            let imageCount = CGImageSourceGetCount(source)
            for i in 0 ..< imageCount {
                if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage(cgImage: image))
                }
            }
            let gifImageView = UIImageView(frame: frame)
            gifImageView.animationImages = images
            return gifImageView
        }
    
}
extension UIImageView
{
    func playVideoOnImage(_ videoUrl:URL,VC:UIViewController)
    {
        let videoURL = videoUrl //URL(string: videoUrl)
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        VC.present(playerViewController, animated: true)
        {
            playerViewController.player!.play()
        }
    }
}
extension UIImage {
      func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func getImageSizeWithURL(url:String?) -> CGSize
        {
            var imageSize:CGSize = .zero
            guard let imageUrlStr = url   else { return imageSize }
            guard imageUrlStr != "" else {return imageSize}
            guard let imageUrl = URL(string: imageUrlStr) else { return imageSize }
     
            guard let imageSourceRef = CGImageSourceCreateWithURL(imageUrl as CFURL, nil) else {return imageSize}
            guard let imagePropertie = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil)  as? Dictionary<String,Any> else {return imageSize }
            imageSize.width = CGFloat((imagePropertie[kCGImagePropertyPixelWidth as String] as! NSNumber).floatValue)
            imageSize.height = CGFloat((imagePropertie[kCGImagePropertyPixelHeight as String] as! NSNumber).floatValue)
            
            return imageSize
        
            
        }

    
    
}
extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
extension UIImage {
    func tinted(color: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color

        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage
        } else {
            return self
        }
    }
}
extension UIImage {
    
    func MakeblurImage(radius: CGFloat = 30) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        let inputCIImage = CIImage(cgImage: cgImage)
        let context = CIContext(options: nil)
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputCIImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        
        if let outputImage = outputImage,
            let cgImage = context.createCGImage(outputImage, from: inputCIImage.extent) {
            
            return UIImage(
                cgImage: cgImage,
                scale: scale,
                orientation: imageOrientation
            )
        }
        return nil
    }
 }
public extension UIImage {
    func height(forWidth width: CGFloat) -> CGFloat {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        let rect = AVMakeRect(
            aspectRatio: size,
            insideRect: boundingRect
        )
        return rect.size.height
    }
    
    
    func imageWithSize(size:CGSize) -> UIImage
    {
        var scaledImageRect = CGRect.zero;

        let aspectWidth:CGFloat = size.width / self.size.width;
        let aspectHeight:CGFloat = size.height / self.size.height;
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight);

        scaledImageRect.size.width = self.size.width * aspectRatio;
        scaledImageRect.size.height = self.size.height * aspectRatio;
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;

        UIGraphicsBeginImageContextWithOptions(size, false, 0);

        self.draw(in: scaledImageRect);

        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() };
        UIGraphicsEndImageContext();

        return scaledImage;
    }
    
   
}
extension UIImage {
    var grayed: UIImage {
        guard let ciImage = CIImage(image: self)
            else { return self }
        let filterParameters = [ kCIInputColorKey: CIColor.white, kCIInputIntensityKey: 1.0 ] as [String: Any]
        let grayscale = ciImage.applyingFilter("CIColorMonochrome", parameters: filterParameters)
        return UIImage(ciImage: grayscale)
    }
}
extension UIImageView
{
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                debugPrint(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    func convertToGrayScale(image: UIImage) -> UIImage? {
            let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)
            let colorSpace = CGColorSpaceCreateDeviceGray()
            let width = image.size.width
            let height = image.size.height
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
            let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
            if let cgImg = image.cgImage {
                context?.draw(cgImg, in: imageRect)
                if let makeImg = context?.makeImage() {
                    let imageRef = makeImg
                    let newImage = UIImage(cgImage: imageRef)
                    return newImage
                }
            }
            return UIImage()
        }
    
    
}
extension UIImageView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}
