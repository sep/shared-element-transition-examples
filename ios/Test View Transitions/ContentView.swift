import SwiftUI

let MOCK_ARTICLES = [
    Article(),
    Article(),
    Article()
]

class Article: Identifiable, ObservableObject {
    var title = "Example Article"
    var content = "Lorem ipsum dolor ist amet"
    var image = "hexter"
    
    // MARK: for animations
    var titleId: String { "article \(id) title" }
    var imageId: String { "article \(id) image" }
    var containerId: String { "article \(id) container"}
}

enum ContentViewState {
    case normal
    case article(article: Article)
}

struct ContentView: View {
    @Namespace private var articleAnimationNamespace;
    @State private var state: ContentViewState
    
    init(state initialState: ContentViewState = .normal)  {
        state = initialState
    }
    
    var body: some View {
        switch state {
        case .normal:
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(MOCK_ARTICLES) { article in
                        VStack {
                            Image(article.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .matchedGeometryEffect(id: article.imageId, in: articleAnimationNamespace, properties: .position)
                            VStack {
                                Text(article.title)
                                    .font(.largeTitle)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .matchedGeometryEffect(id: article.titleId, in: articleAnimationNamespace, anchor: .topLeading)
                                Button("Read More") {
                                    withAnimation { state = .article(article: article) }
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.white).shadow(radius: 6))
                        .matchedGeometryEffect(id: article.containerId, in: articleAnimationNamespace, anchor: .top)
                    }
                }
                .padding()
            }
            
        case .article(let article):
            GeometryReader { geometry in
                VStack {
                    ZStack(alignment: .topLeading) {
                        Image(article.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .matchedGeometryEffect(id: article.imageId, in: articleAnimationNamespace, properties: .position)
                            
                        VStack {
                            Button {
                                withAnimation { state = .normal }
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            .frame(width: 40, height: 40)
                            .background( .ultraThickMaterial, in: Circle())
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .frame(height: 180)
                    }
                    
                    Text(article.title)
                        .font(.largeTitle)
                        .bold()
                        .matchedGeometryEffect(id: article.titleId, in: articleAnimationNamespace, anchor: .topLeading)
                    
                    Text(article.content)
                    Spacer()
                }
                .matchedGeometryEffect(
                    id: article.containerId,
                    in: articleAnimationNamespace,
                    properties: [.position, .size],
                    anchor: .top
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(state: .normal)
            .previewDisplayName("Normal")
        ContentView(state: .article(article: MOCK_ARTICLES[0]))
            .previewDisplayName("Article")
    }
}
