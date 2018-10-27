// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Add {
    internal enum Button {
      /// Save
      internal static let save = L10n.tr("Localizable", "add.button.save")
    }
  }

  internal enum List {
    internal enum Button {
      /// Add
      internal static let add = L10n.tr("Localizable", "list.button.add")
      /// Done
      internal static let done = L10n.tr("Localizable", "list.button.done")
    }
    internal enum Denied {
      /// Access to Health data denied, you need to allow in Health App on your iPhone
      internal static let text = L10n.tr("Localizable", "list.denied.text")
    }
    internal enum LastEntry {
      /// Last Entry
      internal static let text = L10n.tr("Localizable", "list.last_entry.text")
    }
    internal enum Loading {
      /// Loading ...
      internal static let text = L10n.tr("Localizable", "list.loading.text")
    }
    internal enum NoEntry {
      /// No entry
      internal static let text = L10n.tr("Localizable", "list.no_entry.text")
    }
    internal enum NotDetermined {
      /// You need to authorize in your iPhone.
      internal static let text = L10n.tr("Localizable", "list.not_determined.text")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
