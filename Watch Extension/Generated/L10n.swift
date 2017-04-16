// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs
// swiftlint:disable type_name

enum L10n {

  enum List {

    enum Button {
      /// Add
      static let add = L10n.tr("list.button.add")
      /// Done
      static let done = L10n.tr("list.button.done")
    }

    enum Denied {
      /// Access to Health data denied, you need to allow in Health App on your iPhone
      static let text = L10n.tr("list.denied.text")
    }

    enum LastEntry {
      /// Last Entry
      static let text = L10n.tr("list.last_entry.text")
    }

    enum Loading {
      /// Loading ...
      static let text = L10n.tr("list.loading.text")
    }

    enum NoEntry {
      /// No entry
      static let text = L10n.tr("list.no_entry.text")
    }

    enum NotDetermined {
      /// You need to authorize in your iPhone.
      static let text = L10n.tr("list.not_determined.text")
    }
  }
}

extension L10n {
  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

// swiftlint:enable type_body_length
// swiftlint:enable nesting
// swiftlint:enable variable_name
// swiftlint:enable valid_docs
