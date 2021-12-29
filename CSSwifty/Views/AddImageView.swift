//
//  AddImageView.swift
//  CSSwifty
//
//  Created by Michael Osuji on 12/28/21.
//

import SwiftUI

struct FilterImage: View {
    @State var changeImageSelected = false
    @State private var imageLocation: ImageLocaion = .library
    @State private var isShowingImageLocation = false
    @Binding var imageToFilter: UIImage
    @Binding var filterChoiceSelected: Bool
    
    var filteredImage: UIImage
    
    enum ImageLocaion {
        case camera, library, online
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: filterChoiceSelected ? filteredImage: imageToFilter)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Image(systemName: "plus")
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .background(Color.gray)
                .clipShape(Circle())
        }
        .onTapGesture {
            changeImageSelected = true
            filterChoiceSelected = false
        }
        .containerViewModifier(fontColor: .white, borderColor: .black)
        .actionSheet(isPresented: $changeImageSelected) {
            ActionSheet(
                title: Text("Location of Image"),
                buttons: [
                    .default(Text("Open Camera")) {
                        self.imageLocation  = .camera
                        self.isShowingImageLocation = true
                    },
                    .default(Text("Choose From Library")) {
                        self.imageLocation  = .library
                        self.isShowingImageLocation = true
                    },
                    .default(Text("Get From Website")) {
                        self.imageLocation  = .online
                        self.isShowingImageLocation = true
                    },
                    .cancel()
            ])
        }
        .sheet(isPresented: $isShowingImageLocation) {
            switch imageLocation {
            case .camera: ImagePicker(imageToFilter: $imageToFilter, sourceType: .camera)
            case .library: ImagePicker(imageToFilter: $imageToFilter, sourceType: .photoLibrary)
            case .online: WebImageView(imageToFilter: $imageToFilter)
            }
        }
    }
}

struct WebImageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var imageToFilter: UIImage
    
    @State private var imageURL = ""
    
    let gradientColor = [Colors(red: 25, green: 161, blue: 134), Colors(red: 242, green: 207, blue: 67)]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: gradientColor)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    LabelButton(
                        label: "Cancel",
                        bgColor: .red,
                        action: { presentationMode.wrappedValue.dismiss() })
                    Spacer()
                }.padding()
                
                Image("website")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .padding(50)
                
                VStack(spacing: 20) {
                    HStack {
                        HeadlineLabel(label: "Image URL")
                        TextField("Enter image URL...", text: $imageURL)
                            .foregroundColor(.black)
                            .font(.footnote)
                            .frame(height: 25)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal, 8)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                            .background(Color.white.cornerRadius(10))
                            .padding(.horizontal, 5)
                    }
                    HStack(spacing: 50) {
                        Spacer()
                        LabelButton(
                            label: "Clear",
                            bgColor: .red,
                            action: { imageURL.removeAll() },
                            isDisabled: imageURL.isEmpty)
                        LabelButton(
                            label: "Submit",
                            bgColor: .green,
                            action: {
                                imageToFilter = getWebImage()
                                presentationMode.wrappedValue.dismiss()
                            },
                            isDisabled: imageURL.isEmpty)
                    }
                }
                .containerViewModifier(fontColor: .white, borderColor: .black)
                
                Spacer()
            }
        }
    }
    
    func getWebImage() -> UIImage {
        do {
            guard let url = URL(string: imageURL) else {
                return UIImage(named: "loadingError") ?? UIImage()
            }
            
            let data: Data = try Data(contentsOf: url)
            if let imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.5), let compressedImage = UIImage(data: imageData) {
                return compressedImage
            } else {
                return UIImage(named: "loadingError") ?? UIImage()
            }
        } catch {
            
        }
        
        return UIImage(named: "loadingError") ?? UIImage()
    }
}
