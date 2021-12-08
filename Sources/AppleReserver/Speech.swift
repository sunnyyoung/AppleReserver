//
//  File.swift
//
//
//  Created by MartinLau on 26/11/2021.
//

import Foundation
import AppKit

struct Speech {
    private var speechSynthesizer: NSSpeechSynthesizer
    
    init() {
        speechSynthesizer = NSSpeechSynthesizer()
    }
    
    @discardableResult func startSpeaking(_ text: String, voiceLanguage: String? = nil) -> Bool {
        if let voiceLanguage = voiceLanguage {
            let availableVoices = NSSpeechSynthesizer.availableVoices
            for v in availableVoices {
                let arrt = NSSpeechSynthesizer.attributes(forVoice: v)
                if let localeIdentifier = arrt[.localeIdentifier] as? String, localeIdentifier == voiceLanguage {
                    speechSynthesizer.setVoice(v)
                    break
                }
            }
        }
        return speechSynthesizer.startSpeaking(text)
    }
}


