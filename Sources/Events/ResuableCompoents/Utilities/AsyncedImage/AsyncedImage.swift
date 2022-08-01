import SwiftUI

/// added typealaised to AsyncedImage to keep the usage of AsyncImage same for iOS 14.0 as that of iOS 15.0.
@available(iOS, deprecated: 15.0, renamed: "SwiftUI.AsyncImage")
public typealias AsyncImage = AsyncedImage

/// AsyncImage is a view that asynchronously loads and displays an image.
///
/// However, AsyncImage is available from iOS 15.
/// AsyncedImage provides interface and behavior of AsyncImage to earlier OS
/// Example:
///     struct ContentView: View {
///         var body: some View {
///             AsyncImage(url: URL(string: "https://example.com/icon.png")) { image in
///                     image.resizable()
///                     } placeholder: {
///                             ProgressView()
///                     }
///                     .frame(width: 50, height: 50)
///    }
/// }
///
@available(iOS, deprecated: 15.0, renamed: "SwiftUI.AsyncImage")
public struct AsyncedImage<Content: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    /// Loads and displays an image from the specified URL.
    ///
    /// Until the image loads, SwiftUI displays a default placeholder. When
    /// the load operation completes successfully, SwiftUI updates the
    /// view to show the loaded image. If the operation fails, SwiftUI
    /// continues to display the placeholder. The following example loads
    /// and displays an icon from an example server:
    ///
    ///     AsyncImage(url: URL(string: "https://example.com/icon.png"))
    ///
    /// If you want to customize the placeholder or apply image-specific
    /// modifiers --- like ``Image/resizable(capInsets:resizingMode:)`` ---
    /// to the loaded image, use the ``init(url:scale:content:placeholder:)``
    /// initializer instead.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to display.
    ///   - scale: The scale to use for the image. The default is `1`. Set a
    ///     different value when loading images designed for higher resolution
    ///     displays. For example, set a value of `2` for an image that you
    ///     would name with the `@2x` suffix if stored in a file on disk.
    public init(url: URL?, scale: CGFloat = 1) where Content == Image {
        self.url = url
        self.scale = scale
        transaction = Transaction()
        content = { $0.image ?? Image("") }
    }

    /// Loads and displays a modifiable image from the specified URL using
    /// a custom placeholder until the image loads.
    ///
    /// Until the image loads, SwiftUI displays the placeholder view that
    /// you specify. When the load operation completes successfully, SwiftUI
    /// updates the view to show content that you specify, which you
    /// create using the loaded image. For example, you can show a green
    /// placeholder, followed by a tiled version of the loaded image:
    ///
    ///     AsyncImage(url: URL(string: "https://example.com/icon.png")) { image in
    ///         image.resizable(resizingMode: .tile)
    ///     } placeholder: {
    ///         Color.green
    ///     }
    ///
    /// If the load operation fails, SwiftUI continues to display the
    /// placeholder. To be able to display a different view on a load error,
    /// use the ``init(url:scale:transaction:content:)`` initializer instead.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to display.
    ///   - scale: The scale to use for the image. The default is `1`. Set a
    ///     different value when loading images designed for higher resolution
    ///     displays. For example, set a value of `2` for an image that you
    ///     would name with the `@2x` suffix if stored in a file on disk.
    ///   - content: A closure that takes the loaded image as an input, and
    ///     returns the view to show. You can return the image directly, or
    ///     modify it as needed before returning it.
    ///   - placeholder: A closure that returns the view to show until the
    ///     load operation completes successfully.
    public init<I, P>(url: URL?,
                      scale: CGFloat = 1,
                      @ViewBuilder content: @escaping (Image) -> I,
                      @ViewBuilder placeholder: @escaping () -> P) where Content == _ConditionalContent<I, P>, I: View, P: View
    {
        self.url = url
        self.scale = scale
        transaction = Transaction()
        self.content = { phase -> _ConditionalContent<I, P> in
            if let image = phase.image {
                return ViewBuilder.buildEither(first: content(image))
            } else {
                return ViewBuilder.buildEither(second: placeholder())
            }
        }
    }

    /// Loads and displays a modifiable image from the specified URL in phases.
    ///
    /// If you set the asynchronous image's URL to `nil`, or after you set the
    /// URL to a value but before the load operation completes, the phase is
    /// ``AsyncImagePhase/empty``. After the operation completes, the phase
    /// becomes either ``AsyncImagePhase/failure(_:)`` or
    /// ``AsyncImagePhase/success(_:)``. In the first case, the phase's
    /// ``AsyncImagePhase/error`` value indicates the reason for failure.
    /// In the second case, the phase's ``AsyncImagePhase/image`` property
    /// contains the loaded image. Use the phase to drive the output of the
    /// `content` closure, which defines the view's appearance:
    ///
    ///     AsyncImage(url: URL(string: "https://example.com/icon.png")) { phase in
    ///         if let image = phase.image {
    ///             image // Displays the loaded image.
    ///         } else if phase.error != nil {
    ///             Color.red // Indicates an error.
    ///         } else {
    ///             Color.blue // Acts as a placeholder.
    ///         }
    ///     }
    ///
    /// To add transitions when you change the URL, apply an identifier to the
    /// ``AsyncImage``.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to display.
    ///   - scale: The scale to use for the image. The default is `1`. Set a
    ///     different value when loading images designed for higher resolution
    ///     displays. For example, set a value of `2` for an image that you
    ///     would name with the `@2x` suffix if stored in a file on disk.
    ///   - transaction: The transaction to use when the phase changes.
    ///   - content: A closure that takes the load phase as an input, and
    ///     returns the view to display for the specified phase.
    public init(url: URL?,
                scale: CGFloat = 1,
                transaction: Transaction = Transaction(),
                @ViewBuilder content: @escaping (AsyncImagePhase) -> Content)
    {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SwiftUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    public var body: some View {
        if #available(iOS 14.0, *) {
            ContentBody(url: url,
                        scale: scale,
                        transaction: transaction,
                        content: content)
        } else {
            ContentCompatBody(url: url,
                              scale: scale,
                              transaction: transaction,
                              content: content)
        }
    }
}

private final class Provider: ObservableObject {
    @Published var phase: AsyncImagePhase

    init() {
        phase = .empty
    }

    func task(url: URL?,
              scale: CGFloat,
              transaction: Transaction)
    {
        guard let url = url else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.phase = .failure(error)
                    return
                }

                withTransaction(transaction) {
                    self?.phase = self?.image(from: data, scale: scale)
                        .map { AsyncImagePhase.success($0) }
                        ?? .empty
                }
            }
        }
        .resume()
    }

    private func image(from data: Data?, scale: CGFloat) -> Image? {
        return data
            .flatMap { UIImage(data: $0, scale: scale) }
            .map(Image.init(uiImage:))
    }
}

@available(iOS 14.0, *)
private struct ContentBody<Content: View>: View {
    @StateObject private var provider = Provider()
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    init(url: URL?,
         scale: CGFloat,
         transaction: Transaction,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content)
    {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    var body: some View {
        content(provider.phase)
            .onAppear {
                provider.task(url: url, scale: scale, transaction: transaction)
            }
    }
}

@available(iOS, deprecated: 15.0)
private struct ContentCompatBody<Content: View>: View {
    struct Body: View {
        @ObservedObject private var provider: Provider
        private let content: (AsyncImagePhase) -> Content

        init(provider: Provider,
             url: URL?,
             scale: CGFloat,
             transaction: Transaction,
             @ViewBuilder content: @escaping (AsyncImagePhase) -> Content)
        {
            self.provider = provider
            self.content = content
            self.provider.task(url: url, scale: scale, transaction: transaction)
        }

        var body: some View {
            content(provider.phase)
        }
    }

    @State private var provider = Provider()
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    init(url: URL?,
         scale: CGFloat,
         transaction: Transaction,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content)
    {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    var body: Body {
        Body(provider: provider,
             url: url,
             scale: scale,
             transaction: transaction,
             content: content)
    }
}
