//
//  FlowLayout.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import SwiftUI

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    var data: Data
    var content: (Data.Element) -> Content
    @State private var totalHeight = CGFloat.zero

    init(_ data: Data, id: KeyPath<Data.Element, Data.Element>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            generateContent(in: geo)
        }
        .frame(minHeight: totalHeight)
    }

    func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(data, id: \.self) { item in
                content(item)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        width -= d.width
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        height -= d.height
                        return result
                    }
            }
        }
        .background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    totalHeight = -geo.frame(in: .local).origin.y
                }
                return .clear
            }
        )
    }
}
