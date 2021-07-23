//
//  CarouselImageView.swift
//  SwiftUI-Beauty
//
//  Created by Nelson on 2021/7/18.
//

import SwiftUI
import Kingfisher

struct CarouselImageView: View {
    let urls: [URL]

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LazyHStack {
                    PageView(urls: urls, size: proxy.size)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }

                HStack(spacing: 0) {
                    Spacer()
                    VStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .foregroundColor(.gray.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .padding(10)
                        })
                        Spacer()
                    }
                }
            }
        }
    }
}

struct CarouselImageView_Previews: PreviewProvider {
    static var previews: some View {
        let urls: [URL] = [
            URL(string: "http://www.timliao.com/bbs/forum_imgs/83262.jpg?v=10")!,
            URL(string: "https://www.sharefie.net/uploads/2020/05/63/63_1_5ec2510230fe6.jpg")!,
            URL(string: "https://www.sharefie.net/uploads/2020/05/70/70_1_5ec251044abb7.jpg")!,
            URL(string: "https://www.sharefie.net/uploads/2020/05/79/79_1_5ec25105a2736.jpg")!,
            URL(string: "http://www.timliao.com/bbs/forum_imgs/83262.jpg?v=10")!,
            URL(string: "https://www.sharefie.net/uploads/2020/05/63/63_1_5ec2510230fe6.jpg")!,
            URL(string: "https://www.sharefie.net/uploads/2020/05/70/70_1_5ec251044abb7.jpg")!,
            URL(string: "https://www.sharefie.net/uploads/2020/05/79/79_1_5ec25105a2736.jpg")!,
        ]
        CarouselImageView(urls: urls)
            .background(Color.black.ignoresSafeArea())
            .environment(\.selectedIndex, 2)
    }
}

struct PageView: View {
    let urls: [URL]
    let size: CGSize

    @Environment(\.selectedIndex) var selectedIndex: Int
    @State private var currentIndex = 0

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<urls.count, id: \.self) { index in
                KFImage(urls[index])
                    .cancelOnDisappear(true)
                    .scaleFactor(UIScreen.main.scale)
                    .downsampling(size: CGSize(width: size.width - 20, height: size.height))
                    .cacheOriginalImage()
                    .resizable()
                    .backgroundDecode()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width - 20)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onAppear(perform: {
            self.currentIndex = selectedIndex
        })
    }
}
