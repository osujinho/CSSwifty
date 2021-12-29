//
//  FilterViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 12/28/21.
//

import SwiftUI  // Need it for UIImage and Color to work

class FilterViewModel: ObservableObject {
    @Published var imageToFilter: UIImage = UIImage(named: "defaultImage") ?? UIImage() {
        didSet {
            processImage()
        }
    }
    @Published var filteredImage = UIImage(named: "loading") ?? UIImage()
    @Published var modification: Modification = .grayscale
    @Published var filterChoiceSelected = false
    @Published var filters: [Modification : UIImage] = [:]
    
    let week: Weeks = .week4
    let problem: Problems = .filter
    let intro = [
        "In filter, we implement a way to apply filters to BMPs"
    ]
    
    // Mark: - PROBLEM ALGORITHM
    
    // Function to reflect
    func processImage() {
        filters.updateValue(imageToFilter, forKey: .original)
        Task(priority: .medium) { @MainActor in
            filters.updateValue(try await getRawData(filterOption: .reflect), forKey: .reflect)
        }
        Task(priority: .medium) { @MainActor in
            filters.updateValue(try await getRawData(filterOption: .sepia), forKey: .sepia)
        }
        Task(priority: .medium) { @MainActor in
            filters.updateValue(try await getRawData(filterOption: .grayscale), forKey: .grayscale)
        }
        Task(priority: .medium) { @MainActor in
            filters.updateValue(try await getRawData(filterOption: .lowBlur), forKey: .lowBlur)
        }
        Task(priority: .medium) { @MainActor in
            filters.updateValue(try await getRawData(filterOption: .midBlur), forKey: .midBlur)
        }
        Task(priority: .medium) { @MainActor in
            filters.updateValue(try await getRawData(filterOption: .highBlur), forKey: .highBlur)
        }
        Task(priority: .medium) { @MainActor in
            filters.updateValue(try await getRawData(filterOption: .edge), forKey: .edge)
        }
    }
    
    func reflect(pixels: UnsafeMutableBufferPointer<Pixel>, height: Int, width: Int) async {
        
        for row in 0..<height {
            for column in 0..<(width / 2) {
                let index = row * width + column
                let reflectedIndex = row * width + (width - column - 1)

                let tempImage = pixels[index]
                pixels[index] = pixels[reflectedIndex]
                pixels[reflectedIndex] = tempImage
            }
        }
    }
    
    // Function for sepia
    func sepia(pixels: UnsafeMutableBufferPointer<Pixel>, height: Int, width: Int) async {
        for row in 0..<height {
            for column in 0..<width {
                let index = row * width + column
                var pixel = pixels[index]
                
                let sepiaRed = round((0.393 * Double(pixel.red)) + (0.769 * Double(pixel.green)) + (0.189 * Double(pixel.blue)))
                let pixelRed = UInt8(sepiaRed.clamp(minimum: 0, maximum: 255))
                
                let sepiaGreen = round((0.349 * Double(pixel.red)) + (0.686 * Double(pixel.green)) + (0.168 * Double(pixel.blue)))
                let pixelGreen = UInt8(sepiaGreen.clamp(minimum: 0, maximum: 255))
                
                let sepiaBlue = round((0.272 * Double(pixel.red)) + (0.534 * Double(pixel.green)) + (0.131 * Double(pixel.blue)))
                let pixelBlue = UInt8(sepiaBlue.clamp(minimum: 0, maximum: 255))
                
                pixel.red = pixelRed
                pixel.blue = pixelBlue
                pixel.green = pixelGreen
                pixels[index] = pixel
            }
        }
    }
    
    // Function for grayscale
    func grayscale(pixels: UnsafeMutableBufferPointer<Pixel>, height: Int, width: Int) async {
        for row in 0..<height {
            for column in 0..<width {
                let index = row * width + column
                var pixel = pixels[index]
                let average = Int(Double(Int(pixel.red) + Int(pixel.blue) + Int(pixel.green)) / 3.0)
                let pixelColor = UInt8(average)
                pixel.red = pixelColor
                pixel.blue = pixelColor
                pixel.green = pixelColor
                pixels[index] = pixel
            }
        }
    }
    
    // Functions for box blur
    func lowBlur(pixels: UnsafeMutableBufferPointer<Pixel>, pixels2D: [[Pixel]], height: Int, width: Int) async {
        for row in 0..<height {
            for column in 0..<width {
                let index = row * width + column
                var pixel = pixels[index]
                var totalRed = 0
                var totalGreen = 0
                var totalBlue = 0
                var totalNeighbor = 0
                
                for rowNeighbor in 0..<3 {
                    for columnNeighbor in 0..<3 {
                        if pixels2D.indices.contains(row + rowNeighbor - 1) && pixels2D[rowNeighbor].indices.contains(column + columnNeighbor - 1) {
                            let neighborPixel = pixels2D[row + rowNeighbor - 1][column + columnNeighbor - 1]
                            totalRed += Int(neighborPixel.red)
                            totalBlue += Int(neighborPixel.blue)
                            totalGreen += Int(neighborPixel.green)
                            totalNeighbor += 1
                        }
                    }
                }
                pixel.red = UInt8( round( Double(totalRed) / Double(totalNeighbor) ) )
                pixel.green = UInt8( round( Double(totalGreen) / Double(totalNeighbor) ) )
                pixel.blue = UInt8( round( Double(totalBlue) / Double(totalNeighbor) ) )
    
                pixels[index] = pixel
            }
        }
    }
    
    func midBlur(pixels: UnsafeMutableBufferPointer<Pixel>, pixels2D: [[Pixel]], height: Int, width: Int) async {
        for row in 0..<height {
            for column in 0..<width {
                let index = row * width + column
                var pixel = pixels[index]
                var totalRed = 0
                var totalGreen = 0
                var totalBlue = 0
                var totalNeighbor = 0
                
                for rowNeighbor in 0..<5 {
                    for columnNeighbor in 0..<5 {
                        if pixels2D.indices.contains(row + rowNeighbor - 2) && pixels2D[rowNeighbor].indices.contains(column + columnNeighbor - 2) {
                            let neighborPixel = pixels2D[row + rowNeighbor - 2][column + columnNeighbor - 2]
                            totalRed += Int(neighborPixel.red)
                            totalBlue += Int(neighborPixel.blue)
                            totalGreen += Int(neighborPixel.green)
                            totalNeighbor += 1
                        }
                    }
                }
                pixel.red = UInt8( round( Double(totalRed) / Double(totalNeighbor) ) )
                pixel.green = UInt8( round( Double(totalGreen) / Double(totalNeighbor) ) )
                pixel.blue = UInt8( round( Double(totalBlue) / Double(totalNeighbor) ) )
    
                pixels[index] = pixel
            }
        }
    }
    
    func highBlur(pixels: UnsafeMutableBufferPointer<Pixel>, pixels2D: [[Pixel]], height: Int, width: Int) async {
        for row in 0..<height {
            for column in 0..<width {
                let index = row * width + column
                var pixel = pixels[index]
                var totalRed = 0
                var totalGreen = 0
                var totalBlue = 0
                var totalNeighbor = 0
                
                for rowNeighbor in 0..<9 {
                    for columnNeighbor in 0..<9 {
                        if pixels2D.indices.contains(row + rowNeighbor - 4) && pixels2D[rowNeighbor].indices.contains(column + columnNeighbor - 4) {
                            let neighborPixel = pixels2D[row + rowNeighbor - 4][column + columnNeighbor - 4]
                            totalRed += Int(neighborPixel.red)
                            totalBlue += Int(neighborPixel.blue)
                            totalGreen += Int(neighborPixel.green)
                            totalNeighbor += 1
                        }
                    }
                }
                pixel.red = UInt8( round( Double(totalRed) / Double(totalNeighbor) ) )
                pixel.green = UInt8( round( Double(totalGreen) / Double(totalNeighbor) ) )
                pixel.blue = UInt8( round( Double(totalBlue) / Double(totalNeighbor) ) )
    
                pixels[index] = pixel
            }
        }
    }
    
    func edge(pixels: UnsafeMutableBufferPointer<Pixel>, pixels2D: [[Pixel]], height: Int, width: Int) async {
        
        let gx = [[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]]
        let gy = [[-1, -2, -1], [0, 0, 0], [1, 2, 1]]
        
        for row in 0..<height {
            for column in 0..<width {
                let index = row * width + column
                var pixel = pixels[index]
                
                var gxRed = 0
                var gyRed = 0
                var gxBlue = 0
                var gyBlue = 0
                var gxGreen = 0
                var gyGreen = 0
                
                for rowNeighbor in 0..<3 {
                    for columnNeighbor in 0..<3 {
                        if pixels2D.indices.contains(row + rowNeighbor - 1) && pixels2D[rowNeighbor].indices.contains(column + columnNeighbor - 1) {
                            let neighborPixel = pixels2D[row + rowNeighbor - 1][column + columnNeighbor - 1]
                            
                            // Gx values
                            gxRed += (Int(neighborPixel.red) * gx[rowNeighbor][columnNeighbor])
                            gxBlue += (Int(neighborPixel.blue) * gx[rowNeighbor][columnNeighbor])
                            gxGreen += (Int(neighborPixel.green) * gx[rowNeighbor][columnNeighbor])
                            
                            // Gy values
                            gyRed += (Int(neighborPixel.red) * gy[rowNeighbor][columnNeighbor])
                            gyBlue += (Int(neighborPixel.blue) * gy[rowNeighbor][columnNeighbor])
                            gyGreen += (Int(neighborPixel.green) * gy[rowNeighbor][columnNeighbor])
                        }
                    }
                }
                pixel.red = UInt8(sobelNumber(first: gxRed, second: gyRed))
                pixel.blue = UInt8(sobelNumber(first: gxBlue, second: gyBlue))
                pixel.green = UInt8(sobelNumber(first: gxGreen, second: gyGreen))
                
                pixels[index] = pixel
            }
        }
    }
    
    func sobelNumber(first: Int, second: Int) -> Int {
        let firstSq = first * first
        let secondSq = second * second
        
        let sqRoot = Double(firstSq + secondSq).squareRoot()
        
        return Int(sqRoot.rounded()).clamp(minimum: 0, maximum: 255)
    }
    
    // Filter Image based on selection
    func getRawData(filterOption: Modification) async throws -> UIImage {
        guard let reducedImage = await imageToFilter.resized(toWidth: imageToFilter.size.width > UIScreen.main.bounds.width ? (UIScreen.main.bounds.width * 0.75) : imageToFilter.size.width) else { throw ImageError.reduceFailure }
        
        guard let inputCGImage = reducedImage.cgImage else { throw ImageError.cgImageFailure }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let width = inputCGImage.width
        let height = inputCGImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let emptyPixel = Pixel(value: 0)
        
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        
        guard let context = CGContext(
            data: imageData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { throw ImageError.cgContextFailure }
        
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        
        var pixels2D = [[Pixel]](repeating: [Pixel](repeating: emptyPixel, count: width), count: height)
        
        var index = 0
        for row in pixels2D.indices {
            for pixel in pixels2D[row].indices {
                pixels2D[row][pixel] = pixels[index]
                index += 1
            }
        }
        
        switch filterOption {
        case .grayscale:
            await grayscale(pixels: pixels, height: height, width: width)
        case .sepia:
            await sepia(pixels: pixels, height: height, width: width)
        case .reflect:
            await reflect(pixels: pixels, height: height, width: width)
        case .lowBlur:
            await lowBlur(pixels: pixels, pixels2D: pixels2D, height: height, width: width)
        case .midBlur:
            await midBlur(pixels: pixels, pixels2D: pixels2D, height: height, width: width)
        case .highBlur:
            await highBlur(pixels: pixels, pixels2D: pixels2D, height: height, width: width)
        case .edge:
            await edge(pixels: pixels, pixels2D: pixels2D, height: height, width: width)
        case .original:
            filters.updateValue(imageToFilter, forKey: .original)
        }
        
        guard let outputCGImage = context.makeImage() else { throw ImageError.makeImageFailure }
        let outputImage = UIImage(cgImage: outputCGImage, scale: imageToFilter.scale, orientation: imageToFilter.imageOrientation)
        return outputImage
    }
}

enum Modification: String, Identifiable, CaseIterable {
    case grayscale, sepia, reflect, lowBlur, midBlur, highBlur, edge, original
    
    var id: Modification { self }
    
    var label: String {
        switch self {
        case .grayscale: return "Grayscale"
        case .lowBlur: return "Low Blur"
        case .midBlur: return "Mid Blur"
        case .highBlur: return "High Blur"
        case .reflect: return "Reflect"
        case .sepia: return "Sepia"
        case .edge: return "Edge"
        case .original: return "Original"
        }
    }
    
    var color: Color {
        switch self {
        case .grayscale: return getColor(color: Colors(red: 129, green: 133, blue: 137))
        case .sepia: return getColor(color: Colors(red: 112, green: 66, blue: 20))
        case .lowBlur: return getColor(color: Colors(red: 100, green: 181, blue: 246))
        case .midBlur: return getColor(color: Colors(red: 30, green: 136, blue: 229))
        case .highBlur: return getColor(color: Colors(red: 19, green: 96, blue: 164))
        case .reflect: return getColor(color: Colors(red: 187, green: 182, blue: 22))
        case .edge: return getColor(color: Colors(red: 80, green: 65, blue: 53))
        case .original: return .green
        }
    }
}

enum ImageError: Error {
    case reduceFailure
    case cgImageFailure
    case cgContextFailure
    case makeImageFailure
}
