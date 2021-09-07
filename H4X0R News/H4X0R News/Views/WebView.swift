//
//  File.swift
//  H4X0R News
//
//  Created by Rosliakov Evgenii on 01.08.2021.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    var urlString: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let safeString = urlString else {
            print("No url string presented")
            return
        }
        guard let url = URL(string: safeString) else {
            print("Invalid url string")
            return
        }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
