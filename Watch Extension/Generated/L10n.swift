// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Add {
    internal enum Button {
      /// Save
      internal static let save = L10n.tr("Localizable", "add.button.save", fallback: "Save")
    }
  }
  internal enum List {
    internal enum Button {
      /// Localizable.strings
      ///   MyWeight
      /// 
      ///   Created by Diogo on 15/04/17.
      ///   Copyright © 2017 Diogo Tridapalli. All rights reserved.
      internal static let add = L10n.tr("Localizable", "list.button.add", fallback: "Add")
      /// Done
      internal static let done = L10n.tr("Localizable", "list.button.done", fallback: "Done")
    }
    internal enum Denied {
      /// Access to Health data denied, you need to allow in Health App on your iPhone
      internal static let text = L10n.tr("Localizable", "list.denied.text", fallback: "Access to Health data denied, you need to allow in Health App on your iPhone")
    }
    internal enum LastEntry {
      /// Last Entry
      internal static let text = L10n.tr("Localizable", "list.last_entry.text", fallback: "Last Entry")
    }
    internal enum Loading {
      /// Loading ...
      internal static let text = L10n.tr("Localizable", "list.loading.text", fallback: "Loading ...")
    }
    internal enum NoEntry {
      /// No entry
      internal static let text = L10n.tr("Localizable", "list.no_entry.text", fallback: "No entry")
    }
    internal enum NotDetermined {
      /// You need to authorize in your iPhone.
      internal static let text = L10n.tr("Localizable", "list.not_determined.text", fallback: "You need to authorize in your iPhone.")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
