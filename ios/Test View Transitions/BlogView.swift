import SwiftUI

let MOCK_ARTICLES = [
    Article(),
    Article(),
    Article()
]

class Article: Identifiable, ObservableObject {
    var title = "How Now Brown Cow? Nursery Rhymes in the Age of Artificial Intelligence"
    var content = "Lorem ipsum dolor ist amet"
    var image = "hexter"
    
    // MARK: for animations
    var titleId: String { "article \(id) title" }
    var imageId: String { "article \(id) image" }
    var backgroundId: String { "article \(id) background"}
}

// iOS 16 supports Shape.rect(topLEadingRadius: 0, ...), but you'll need to roll this yourself for earlier iOS. Not too tricky.
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners))
    }
}

enum BlogViewState {
    case normal
    case article(article: Article)
}

struct BlogView: View {
    @Namespace private var articleAnimationNamespace
    @State private var state: BlogViewState
    
    init(state initialState: BlogViewState = .normal)  {
        state = initialState
    }
    
    var body: some View {
        switch state {
        case .normal:
            ScrollView {
                Text("Blog")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 16) {
                    ForEach(MOCK_ARTICLES) { article in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow(radius: 6)
                                .matchedGeometryEffect(id: article.backgroundId, in: articleAnimationNamespace, anchor: .top)
                            VStack {
                                Image(article.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(16, corners: [.topLeft, .topRight])
                                    .matchedGeometryEffect(
                                        id: article.imageId,
                                        in: articleAnimationNamespace
                                    )
                                VStack {
                                    Text(article.title)
                                        .font(.title2)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .matchedGeometryEffect(
                                            id: article.titleId,
                                            in: articleAnimationNamespace,
                                            properties: .position,
                                            anchor: .topLeading
                                        )
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .onTapGesture {
                            withAnimation {
                                state = .article(article: article)
                            }
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            
        case .article(let article):
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(.white)
                    .matchedGeometryEffect(id: article.backgroundId, in: articleAnimationNamespace, anchor: .top)
                ScrollView {
                    VStack {
                        ZStack(alignment: .topLeading) {
                            Image(article.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .matchedGeometryEffect(
                                    id: article.imageId,
                                    in: articleAnimationNamespace
                                )
                            
                            VStack {
                                Button {
                                    withAnimation { state = .normal }
                                } label: {
                                    Image(systemName: "chevron.left")
                                }
                                .frame(width: 40, height: 40)
                                .background( .ultraThickMaterial, in: Circle())
                                .shadow(radius: 5)
                                .offset(y: 12)
                            }
                            .padding(.horizontal)
                        }.frame(maxWidth: .infinity)
                        
                        VStack {
                            Text(article.title)
                                .font(.largeTitle)
                                .bold()
                                .matchedGeometryEffect(
                                    id: article.titleId,
                                    in: articleAnimationNamespace,
                                    properties: .position,
                                    anchor: .topLeading
                                )
                                .padding(.bottom, 8)
                            
                            Text(article.content)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BlogView(state: .normal)
            .previewDisplayName("Normal")
        BlogView(state: .article(article: MOCK_ARTICLES[0]))
            .previewDisplayName("Article")
    }
}
