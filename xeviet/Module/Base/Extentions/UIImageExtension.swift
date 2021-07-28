//
//  UIImageExtension.swift
//  Visunite
//
//  Created by luckymanbk on 8/30/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import UIKit

//
// Copyright (c) 2020 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//-------------------------------------------------------------------------------------------------------------------------------------------------
extension UIImage {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    class func image(_ path: String, size: CGFloat) -> UIImage? {

        let image = UIImage(contentsOfFile: path)
        return image?.square(to: size)
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func square(to extent: CGFloat) -> UIImage {

        var cropped: UIImage!

        let width = self.size.width
        let height = self.size.height

        if (width == height) {
            cropped = self
        } else if (width > height) {
            let xpos = (width - height) / 2
            cropped = self.crop(x: xpos, y: 0, width: height, height: height)
        } else if (height > width) {
            let ypos = (height - width) / 2
            cropped = self.crop(x: 0, y: ypos, width: width, height: width)
        }

        return cropped.resize(width: extent, height: extent)
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func resize(width: CGFloat, height: CGFloat) -> UIImage {

        let size = CGSize(width: width, height: height)
        let rect = CGRect(x: 0, y: 0, width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: rect)
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized!
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func crop(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImage {

        let rect = CGRect(x: x, y: y, width: width, height: height)

        if let cgImage = self.cgImage {
            if let cropped = cgImage.cropping(to: rect) {
                return UIImage(cgImage: cropped)
            }
        }

        return UIImage()
    }
}


public extension UIImage {

	/**
     create an image with UIColor
     
     - parameter color: input color
     
     - returns: UIImage object
     */
	class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		context!.setFillColor(color.cgColor)
		context!.fill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}

	/**
     Reference at https://github.com/cosnovae/fixUIImageOrientation/blob/master/fixImageOrientation.swift
     */
	class func fixImageOrientation(_ src: UIImage) -> UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
			return src
		}

		var transform: CGAffineTransform = CGAffineTransform.identity

		switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
			transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat.pi)
			break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
			transform = transform.translatedBy(x: src.size.width, y: 0)
			transform = transform.rotated(by: CGFloat.pi / 2)
			break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
			transform = transform.translatedBy(x: 0, y: src.size.height)
			transform = transform.rotated(by: -CGFloat.pi / 2)
			break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
			break
		}

		switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
			transform.translatedBy(x: src.size.width, y: 0)
			transform.scaledBy(x: -1, y: 1)
			break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
			transform.translatedBy(x: src.size.height, y: 0)
			transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
			break
		}

		let ctx: CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: src.cgImage!.bitsPerComponent, bytesPerRow: 0, space: src.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

		ctx.concatenate(transform)

		switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
			ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
			break
		default:
			ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
			break
		}

		let cgimage: CGImage = ctx.makeImage()!
		let image: UIImage = UIImage(cgImage: cgimage)

		return image
	}

	// https://github.com/melvitax/AFImageHelper/blob/master/AFImageHelper%2FAFImageExtension.swift
	public enum UIImageContentMode {
		case scaleToFill, scaleAspectFit, scaleAspectFill
	}

	/**
     Creates a resized copy of an image.
     
     - Parameter size: The new size of the image.
     - Parameter contentMode: The way to handle the content in the new size.
     - Parameter quality:     The image quality
     
     - Returns A new image
     */
	func resize(_ size: CGSize, contentMode: UIImageContentMode = .scaleToFill, quality: CGInterpolationQuality = .medium) -> UIImage? {
		let horizontalRatio = size.width / self.size.width;
		let verticalRatio = size.height / self.size.height;
		var ratio: CGFloat!

		switch contentMode {
		case .scaleToFill:
			ratio = 1
		case .scaleAspectFill:
			ratio = max(horizontalRatio, verticalRatio)
		case .scaleAspectFit:
			ratio = min(horizontalRatio, verticalRatio)
		}

		let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)

		// Fix for a colorspace / transparency issue that affects some types of
		// images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

		let transform = CGAffineTransform.identity
		// Rotate and/or flip the image if required by its orientation
		context!.concatenate(transform);
		// Set the quality level to use when rescaling
		context!.interpolationQuality = quality
		// CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))
		// Draw into the context; this scales the image
		context!.draw(self.cgImage!, in: rect)
		// Get the resized image from the context and a UIImage
		let newImage = UIImage(cgImage: context!.makeImage()!, scale: self.scale, orientation: self.imageOrientation)
        
		return newImage;
	}

    func resizeImageFitTo(size: CGFloat) -> UIImage {
        if self.size.height < size && self.size.width < size {
            return self
        }
        
        if self.size.width < self.size.height { // base on height
            return self.resizeWithHeight(image: self, newHeight: size)
        } else { // Base on width
            return self.resizeWithWidth(width: size)!
        }
    }

    func resizeWithHeight(image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return result
    }
    
    /**
     capture screeen with a view
     
     - Returns A new image
     */
	func screenCaptureWithView(_ view: UIView, rect: CGRect) -> UIImage {
		var capture: UIImage
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
		let context: CGContext = UIGraphicsGetCurrentContext()!
		context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
		// let layer: CALayer = view.layer
		if view.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
			view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
		} else {
			view.layer.render(in: UIGraphicsGetCurrentContext()!)
		}
		capture = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
        
		return capture
	}

    func cropToBounds(width: Double, height: Double) -> UIImage {
		let contextImage: UIImage = UIImage(cgImage: self.cgImage!)
		let contextSize: CGSize = contextImage.size

		var posX: CGFloat = 0.0
		var posY: CGFloat = 0.0
		let cgwidth: CGFloat = CGFloat(fmin(self.size.width, CGFloat(width)))
		let cgheight: CGFloat = CGFloat(fmin(self.size.height, CGFloat(height)))

		posX = (contextSize.width - cgwidth) / 2.0
		posY = (contextSize.height - cgheight) / 2.0

		let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
		// Create bitmap image from context using the rect
		let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
		// Create a new image based on the imageRef and rotate back to the original orientation
		let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

		return image
	}

	func croppIngimage(_ width: CGFloat, height: CGFloat) -> UIImage {
		let rect = CGRect(x: (self.size.width - width) / 2.0, y: (self.size.height - height) / 2, width: width, height: height)

		let imageRef: CGImage = self.cgImage!.cropping(to: rect)!
		let cropped: UIImage = UIImage(cgImage: imageRef)
        
		return cropped
    }
    
    func cropImage(rect: CGRect) -> UIImage {
        // Create bitmap image from context using the rect
        let imageRef: CGImage = self.cgImage!.cropping(to: rect)!
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return cropped
    }
    
	public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {
        /*
		let radiansToDegrees: (CGFloat) -> CGFloat = {
			return $0 * (180.0 / CGFloat(M_PI))
		}*/
		let degreesToRadians: (CGFloat) -> CGFloat = {
			return $0 / 180.0 * CGFloat.pi
		}

		// calculate the size of the rotated view's containing box for our drawing space
		let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
		let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
		rotatedViewBox.transform = t
		let rotatedSize = rotatedViewBox.frame.size

		// Create the bitmap context
		UIGraphicsBeginImageContext(rotatedSize)
		let bitmap = UIGraphicsGetCurrentContext()

		// Move the origin to the middle of the image so we will rotate and scale around the center.
		bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)

		// // Rotate the image context
		bitmap!.rotate(by: degreesToRadians(degrees))

		// Now, draw the rotated/scaled image into the context
		var yFlip: CGFloat

		if (flip) {
			yFlip = CGFloat(-1.0)
		} else {
			yFlip = CGFloat(1.0)
		}

		bitmap!.scaleBy(x: yFlip, y: -1.0)
		bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return newImage!
	}

	public func crop43() -> UIImage {
		if self.size.width / self.size.height >= 0.75 {
			return self.cropToBounds(width: Double(self.size.height * 4 / 3), height: Double(self.size.height))
		} else {
			return self.cropToBounds(width: Double(self.size.width), height: Double(self.size.width * 0.75))
		}
	}
    
    class func drawDottedImage(width: CGFloat, height: CGFloat, color: UIColor) -> UIImage {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 1.0, y: 1.0))
        path.addLine(to: CGPoint(x: width, y: 1))
        path.lineWidth = 1.5
        let dashes: [CGFloat] = [path.lineWidth, path.lineWidth * 5]
        path.setLineDash(dashes, count: 2, phase: 0)
        path.lineCapStyle = .butt
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 2)
        color.setStroke()
        path.stroke()
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIImage {
    
    func textToImage(drawText text: String, textColor: UIColor = UIColor.black) -> UIImage {
        let textFont = UIFont(name: "Helvetica Bold", size: 22)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font.rawValue: textFont,
            NSAttributedString.Key.foregroundColor: textColor] as! [NSAttributedString.Key : Any]
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        let point = CGPoint(x: 20, y: self.size.height - 90)
        let rect = CGRect(origin: point, size: self.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}

extension UIImageView {
    var imageScale: CGSize {
        let sx = Double(self.frame.size.width / self.image!.size.width)
        let sy = Double(self.frame.size.height / self.image!.size.height)
        var s = 1.0
        switch (self.contentMode) {
        case .scaleAspectFit:
            s = fmin(sx, sy)
            return CGSize (width: s, height: s)
            
        case .scaleAspectFill:
            s = fmax(sx, sy)
            return CGSize(width:s, height:s)
            
        case .scaleToFill:
            return CGSize(width:sx, height:sy)
            
        default:
            return CGSize(width:s, height:s)
        }
    }
}


















