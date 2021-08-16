//
//  TimLiaoFetcher.swift
//  SwiftUI Beauty
//
//  Created by Nelson on 2018/8/8.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation
import Combine
import SwiftSoup

struct TimLiaoFetcher: Fetcher {
    private static let cfEncoding = CFStringEncodings.dosChineseTrad
    private static let nsEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
    private static let encoding = String.Encoding(rawValue: nsEncoding)

    // MARK: - Fetcher

    var name: String {
        return "提姆正妹"
    }

    func fetchPosts(at page: UInt) -> AnyPublisher<[Post], CustomError> {
        let urlString = "http://www.timliao.com/bbs/forumdisplay.php?fid=18&filter=0&orderby=dateline&page=\(page)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"

        return fetchContent(for: request, encoding: TimLiaoFetcher.encoding, using: postsParser)
    }

    func fetchPhotos(at url: URL) -> AnyPublisher<[URL], CustomError> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return fetchContent(for: request, encoding: TimLiaoFetcher.encoding, using: photosParser)
    }

    // MARK: - Private Methods
    private let postsParser: Parser<Post> = { html in
        let document: Document = try SwiftSoup.parse(html)
        let query = "#container_all > form li.forum-card > div.pic > a:not([href='http://www.timliao.com'])"
        let elements = try document.select(query)

        let posts = elements.array().compactMap { e -> Post? in
            guard let image = try? e.select("img").first(),
                  let title = try? e.parent()?.parent()?.select("h2.subject > a").first()
            else {
                return nil
            }
            guard let t = try? title.text(),
                  let href = try? title.attr("href")
            else {
                return nil
            }

            if let src = try? image.attr("data-src"), src != "" {
                let post = Post(title: t,
                                coverURL: URL(string: "http://www.timliao.com/bbs/\(src)")!,
                                url: URL(string: "http://www.timliao.com/bbs/\(href)")!)
                return post
            } else if let src = try? image.attr("src"), src != "" {
                let post = Post(title: t,
                                coverURL: URL(string: "http://www.timliao.com/bbs/\(src)")!,
                                url: URL(string: "http://www.timliao.com/bbs/\(href)")!)
                return post
            } else {
                return nil
            }
        }
        return posts
    }

    private let photosParser: Parser<URL> = { html in
        let document: Document = try SwiftSoup.parse(html)
        let query = "div.postcontent > div.mt10 > a > img"
        let elements = try document.select(query)

        let urls = elements.array().compactMap { e -> URL? in
            guard let src = try? e.attr("src") else {
                return nil
            }
            return URL(string: src, relativeTo: URL(string: "http://www.timliao.com/bbs/"))
        }
        return urls
    }
}
