// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
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
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
