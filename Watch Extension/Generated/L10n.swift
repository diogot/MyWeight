// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  enum Add {

    enum Button {
      /// Save
      static let save = L10n.tr("Localizable", "add.button.save")
    }
  }

  enum List {

    enum Button {
      /// Add
      static let add = L10n.tr("Localizable", "list.button.add")
      /// Done
      static let done = L10n.tr("Localizable", "list.button.done")
    }

    enum Denied {
      /// Access to Health data denied, you need to allow in Health App on your iPhone
      static let text = L10n.tr("Localizable", "list.denied.text")
    }

    enum LastEntry {
      /// Last Entry
      static let text = L10n.tr("Localizable", "list.last_entry.text")
    }

    enum Loading {
      /// Loading ...
      static let text = L10n.tr("Localizable", "list.loading.text")
    }

    enum NoEntry {
      /// No entry
      static let text = L10n.tr("Localizable", "list.no_entry.text")
    }

    enum NotDetermined {
      /// You need to authorize in your iPhone.
      static let text = L10n.tr("Localizable", "list.not_determined.text")
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
