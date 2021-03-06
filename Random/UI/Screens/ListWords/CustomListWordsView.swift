//
//  CustomListWordsView.swift
//  Random
//
//  Created by Vitalii Sosin on 09.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CustomListWordsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    @State var listResult: [String] = []
    @State var textField = ""
    
    var body: some View {
        VStack {
            listResults
            VStack(spacing: 16) {
                TextField
                generateButton
            }
        }
        .onAppear {
            listResult = appBinding.listWords.listData.wrappedValue
        }
        .keyboardAware()
        .dismissingKeyboard()
        .navigationBarTitle(Text(NSLocalizedString("Список", comment: "")), displayMode: .inline)
    }
}

private extension CustomListWordsView {
    var listResults: some View {
        List {
            ForEach(listResult, id: \.self) { element in
                
                HStack {
                    Spacer()
                    Text("\(element)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
            } .onDelete(perform: { indexSet in
                listResult.remove(atOffsets: indexSet)
                appBinding.listWords.listData.wrappedValue.remove(atOffsets: indexSet)
                appBinding.listWords.listTemp.wrappedValue = appBinding.listWords.listData.wrappedValue
                saveListWordsToUserDefaults(state: appBinding)
            })
            
        }
    }
}

private extension CustomListWordsView {
    var TextField: some View {
        HStack {
            TextFieldUIKit(placeholder: NSLocalizedString("Напишите слово или фразу", comment: ""),
                           text: $textField,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .default,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 40)
                .frame(height: 40)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryGray())))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 16)
    }
}

private extension CustomListWordsView {
    var generateButton: some View {
        Button(action: {
            if !textField.isEmpty {
                appendWord(state: appBinding)
                clearTF(state: appBinding)
                saveListWordsToUserDefaults(state: appBinding)
                Feedback.shared.impactHeavy(.medium)
            }
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Добавить", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .padding(.horizontal, 16)
    }
}

private extension CustomListWordsView {
    private func appendWord(state: Binding<AppState.AppData>) {
        appBinding.listWords.listData.wrappedValue
            .append(textField)
        appBinding.listWords.listTemp.wrappedValue
            .append(textField)
        listResult.append(textField)
    }
}

private extension CustomListWordsView {
    private func clearTF(state: Binding<AppState.AppData>) {
        textField = ""
    }
}

private extension CustomListWordsView {
    private func saveListWordsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.listWordsInteractor
            .saveListWordsToUserDefaults(state: state)
    }
}

struct CustomListWordsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomListWordsView(appBinding: .constant(.init()))
    }
}
