//
//  FilmInformationAllFilmView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 01.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct FilmInformationAllFilmView: View {
    private var filmsInfo: FilmsInfo
    private var iframeSrc: String
    private var appBinding: Binding<AppState.AppData>
    
    init(filmsInfo: FilmsInfo, iframeSrc: String, appBinding: Binding<AppState.AppData>) {
        self.filmsInfo = filmsInfo
        self.iframeSrc = iframeSrc
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Информация по фильму", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            let filterarr = appBinding.film.filmsVideoHistory.wrappedValue.filter { $0.ruTitle == appBinding.film.filmInfo.data.wrappedValue?.nameRu }
            getLinkFromStringURL(strURL: filterarr.first?.iframeSrc)
        }) {
            Image(systemName: "play.rectangle")
                .font(.system(size: 24))
                .gradientForeground(colors: [Color.primaryError(), Color.red]).opacity(0.5)
        })
    }
}

private extension FilmInformationAllFilmView {
    var listResults: some View {
        List {
            HStack(spacing: 16) {
                Text(NSLocalizedString("Название фильма:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(filmsInfo.data?.nameRu ?? "")" : "\(filmsInfo.data?.nameEn ?? "")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
            
            HStack(spacing: 16) {
                Text(NSLocalizedString("Год:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text("\(filmsInfo.data?.year ?? "")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
            
            HStack(spacing: 16) {
                Text(NSLocalizedString("Продолжительность фильма:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text("\(filmsInfo.data?.filmLength ?? "")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
            
            HStack(spacing: 16) {
                Text(NSLocalizedString("Возрастные ограничения:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text("\(filmsInfo.data?.ratingAgeLimits ?? 0)+")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
            
            
            VStack(spacing: 8) {
                HStack {
                    Text(NSLocalizedString("Описание:", comment: ""))
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
                
                Text("\(filmsInfo.data?.description ?? "")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
        }
    }
}

struct FilmInformation_Previews: PreviewProvider {
    static var previews: some View {
        FilmInformationAllFilmView(filmsInfo: .init(), iframeSrc: "", appBinding: .constant(.init()))
    }
}
