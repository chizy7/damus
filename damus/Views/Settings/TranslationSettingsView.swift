//
//  TranslationSettingsView.swift
//  damus
//
//  Created by William Casarin on 2023-04-05.
//

import SwiftUI

struct TranslationSettingsView: View {
    @ObservedObject var settings: UserSettingsStore
    var damus_state: DamusState
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(NSLocalizedString("Translations", comment: "Section title for selecting the translation service.")) {
                Picker(NSLocalizedString("Service", comment: "Prompt selection of translation service provider."), selection: $settings.translation_service) {
                    ForEach(TranslationService.allCases.filter({ damus_state.purple.enable_purple ? true : $0 != .purple }), id: \.self) { server in
                        Text(server.model.displayName)
                            .tag(server.model.tag)
                    }
                }
                
                if settings.translation_service == .purple && damus_state.purple.enable_purple {
                    NavigationLink(destination: DamusPurpleView(damus_state: damus_state)) {
                        Text("Configure Damus Purple", comment: "Button to allow Damus Purple to be configured")
                    }
                }

                if settings.translation_service == .libretranslate {
                    Picker(NSLocalizedString("Server", comment: "Prompt selection of LibreTranslate server to perform machine translations on notes"), selection: $settings.libretranslate_server) {
                        ForEach(LibreTranslateServer.allCases, id: \.self) { server in
                            Text(server.model.displayName)
                                .tag(server.model.tag)
                        }
                    }

                    if settings.libretranslate_server == .custom {
                        TextField(NSLocalizedString("URL", comment: "Example URL to LibreTranslate server"), text: $settings.libretranslate_url)
                            .disableAutocorrection(true)
                            .autocapitalization(UITextAutocapitalizationType.none)
                    }

                    SecureField(NSLocalizedString("API Key (optional)", comment: "Prompt for optional entry of API Key to use translation server."), text: $settings.libretranslate_api_key)
                        .disableAutocorrection(true)
                        .disabled(settings.translation_service != .libretranslate)
                        .autocapitalization(UITextAutocapitalizationType.none)
                }

                if settings.translation_service == .deepl {
                    Picker(NSLocalizedString("Plan", comment: "Prompt selection of DeepL subscription plan to perform machine translations on notes"), selection: $settings.deepl_plan) {
                        ForEach(DeepLPlan.allCases, id: \.self) { server in
                            Text(server.model.displayName)
                                .tag(server.model.tag)
                        }
                    }

                    SecureField(NSLocalizedString("API Key (required)", comment: "Prompt for required entry of API Key to use translation server."), text: $settings.deepl_api_key)
                        .disableAutocorrection(true)
                        .disabled(settings.translation_service != .deepl)
                        .autocapitalization(UITextAutocapitalizationType.none)

                    if settings.deepl_api_key == "" {
                        Link(NSLocalizedString("Get API Key", comment: "Button to navigate to DeepL website to get a translation API key."), destination: URL(string: "https://www.deepl.com/pro-api")!)
                    }
                }

                if settings.translation_service == .nokyctranslate {
                    SecureField(NSLocalizedString("API Key (required)", comment: "Prompt for required entry of API Key to use translation server."), text: $settings.nokyctranslate_api_key)
                        .disableAutocorrection(true)
                        .disabled(settings.translation_service != .nokyctranslate)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    
                    if settings.nokyctranslate_api_key == "" {
                        Link(NSLocalizedString("Get API Key with BTC/Lightning", comment: "Button to navigate to nokyctranslate website to get a translation API key."), destination: URL(string: "https://nokyctranslate.com")!)
                    }
                }

                if settings.translation_service == .winetranslate {
                    SecureField(NSLocalizedString("API Key (required)", comment: "Prompt for required entry of API Key to use translation server."), text: $settings.winetranslate_api_key)
                        .disableAutocorrection(true)
                        .disabled(settings.translation_service != .winetranslate)
                        .autocapitalization(UITextAutocapitalizationType.none)

                    if settings.winetranslate_api_key == "" {
                        Link(NSLocalizedString("Get API Key with BTC/Lightning", comment: "Button to navigate to translate.nostr.wine to get a translation API key."), destination: URL(string: "https://translate.nostr.wine")!)
                    }
                }
                
                if settings.translation_service != .none {
                    Toggle(NSLocalizedString("Automatically translate notes", comment: "Toggle to automatically translate notes."), isOn: $settings.auto_translate)
                        .toggleStyle(.switch)
                    
                    /*
                    Toggle(NSLocalizedString("Translate DMs", comment: "Toggle to translate direct messages."), isOn: $settings.translate_dms)
                        .toggleStyle(.switch)
                     */
                }
            }
        }
        .navigationTitle(NSLocalizedString("Translation", comment: "Navigation title for translation settings."))
        .onReceive(handle_notify(.switched_timeline)) { _ in
            dismiss()
        }
    }
}

struct TranslationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationSettingsView(settings: UserSettingsStore(), damus_state: test_damus_state)
    }
}
