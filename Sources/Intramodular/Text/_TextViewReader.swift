//
// Copyright (c) Vatsal Manot
//

#if os(iOS) || os(tvOS) || os(macOS) || targetEnvironment(macCatalyst)

import Combine
import Swift
import SwiftUI

@_spi(Internal)
public enum _TextView_TextEditorEvent: Hashable {
    case insert(text: NSAttributedString, range: NSRange)
    case delete(text: NSAttributedString, range: NSRange)
    case replace(text: NSAttributedString, range: NSRange)

    public var text: String {
        switch self {
            case .insert(let text, _):
                return text.string
            case .delete(let text, _):
                return text.string
            case .replace(let text, _):
                return text.string
        }
    }
    
    /*case cursorMoved(position: Int)
    case selection(range: NSRange)
    case cut(text: String, range: NSRange)*/
}

@available(macOS 11.0, *)
public struct _TextViewReader<Content: View>: View {
    private let content: (_TextViewProxy) -> Content
    
    @PersistentObject private var proxy = _TextViewProxy()
    
    public init(
        @ViewBuilder content: @escaping (_TextViewProxy) -> Content
    ) {
        self.content = content
    }
    
    public var body: some View {
        content(proxy)
            .environment(\._textViewProxy, Binding(get: { proxy }, set: { proxy = $0 }))
    }
}

public final class _TextViewProxy: Equatable, ObservableObject {
    let _base = WeakReferenceBox<AppKitOrUIKitTextView>(nil)
    
    var _fakeTextCursor = _TextCursorTracking(owner: nil)
    
    var base: (any _PlatformTextView_Type)? {
        get {
            _base.wrappedValue.map({ $0 as! any _PlatformTextView_Type })
        } set {
            objectWillChange.send()
            
            _base.wrappedValue = newValue
        }
    }
    
    public var textCursor: _TextCursorTracking {
        base?._trackedTextCursor ?? _fakeTextCursor
    }
    
    @_spi(Internal)
    public var _textEditorEventsPublisher: AnyPublisher<_TextView_TextEditorEvent, Never>? {
        base?._textEditorEventPublisher
    }
    
    fileprivate init() {
        
    }
    
    public static func == (lhs: _TextViewProxy, rhs: _TextViewProxy) -> Bool {
        lhs.base === rhs.base
    }
}

// MARK: - Auxiliary

extension _TextViewProxy {
    fileprivate struct EnvironmentKey: SwiftUI.EnvironmentKey {
        static let defaultValue: Binding<_TextViewProxy>? = nil
    }
}

extension EnvironmentValues {
    @usableFromInline
    var _textViewProxy: Binding<_TextViewProxy>? {
        get {
            self[_TextViewProxy.EnvironmentKey.self]
        } set {
            self[_TextViewProxy.EnvironmentKey.self] = newValue
        }
    }
}

#endif