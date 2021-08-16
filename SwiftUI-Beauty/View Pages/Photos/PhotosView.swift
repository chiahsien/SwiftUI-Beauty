//
//  PhotosView.swift
//  SwiftUI-Beauty
//
//  Created by Nelson on 2021/7/18.
//

import SwiftUI
import Kingfisher

private struct PresentationIndex: Identifiable {
    let id = UUID()
    let index: Int
}

struct PhotosView: View {
    @ObservedObject var viewModel: PhotosViewModel
    @State private var presentationIndex: PresentationIndex?

    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 15) {
                ForEach(0..<viewModel.urls.count, id: \.self) { index in
                    Button(action: {
                        self.presentationIndex = PresentationIndex(index: index)
                    }, label: {
                        KFImage(viewModel.urls[index])
                            .cancelOnDisappear(true)
                            .cacheOriginalImage()
                            .scaleFactor(UIScreen.main.scale)
                            .downsampling(size: CGSize(width: 150, height: 150))
                            .resizable()
                            .backgroundDecode()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0)
                            .cornerRadius(10)
                            .clipped()
                    })
                }
            }
            .padding(15)
            .fullScreenCover(item: $presentationIndex) { presentationIndex in
                CarouselImageView(urls: viewModel.urls, initialIndex: presentationIndex.index)
                    .background(Color.black.ignoresSafeArea())
            }
        }
        .onAppear(perform: viewModel.fetchPhotos)
        .navigationTitle(viewModel.postTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        let post = Post(title: "Test",
                        coverURL: URL(string: "http://www.timliao.com/bbs/forum_imgs/83262.jpg?v=10")!,
                        url: URL(string: "http://www.timliao.com/bbs/viewthread.php?tid=83262")!)
        let viewModel = PhotosViewModel(fetcher: TimLiaoFetcher(), post: post)
        PhotosView(viewModel: viewModel)
    }
}
