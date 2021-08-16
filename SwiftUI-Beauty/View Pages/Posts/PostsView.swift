//
//  PostsView.swift
//  SwiftUI-Beauty
//
//  Created by Nelson on 2021/7/17.
//

import SwiftUI
import Kingfisher

struct PostsView: View {
    @ObservedObject var viewModel: PostsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.posts) { post in
                    NavigationLink(destination: PhotosView(viewModel: PhotosViewModel(fetcher: viewModel.fetcher, post: post))) {
                        PostView(post: post)
                            .padding(.horizontal, 15)
                            .onAppear {
                                if viewModel.posts.last == post {
                                    viewModel.fetchMorePosts()
                                }
                            }
                    }
                }
            }
            
            ActivityIndicatorView()
                .opacity(viewModel.isFetchingPosts ? 1 : 0)
        }
        .foregroundColor(.primary)
        .onAppear(perform: viewModel.fetchMorePosts)
        .navigationTitle(viewModel.forumName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PostsViewModel(fetcher: TimLiaoFetcher())
        PostsView(viewModel: viewModel)
    }
}

// MARK: - Subviews

struct PostView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(post.title)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            KFImage(post.coverURL)
                .cancelOnDisappear(true)
                .cacheOriginalImage()
                .scaleFactor(UIScreen.main.scale)
                .downsampling(size: CGSize(width: 300, height: 300))
                .resizable()
                .backgroundDecode()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0)
                .cornerRadius(10)
        }
    }
}

struct ActivityIndicatorView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .padding(20.0)
            Spacer()
        }
    }
}
