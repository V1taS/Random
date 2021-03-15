//
//  FilmInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol FilmInteractor {
    func getMovies(state: Binding<AppState.AppData>)
    func getCurrentFilmInfo(state: Binding<AppState.AppData>)
    func cleanFilms(state: Binding<AppState.AppData>)
    func saveFilmsToUserDefaults(state: Binding<AppState.AppData>)
    func getLinkOnPageKinopoiskVideo(state: Binding<AppState.AppData>)
    func validVideoplayerIcon(state: Binding<AppState.AppData>)
}

struct FilmInteractorImpl: FilmInteractor {
    
    func validVideoplayerIcon(state: Binding<AppState.AppData>) {
        switch state.film.selectedGenres.wrappedValue {
        case 0:
            state.film.showVideoPlayerIcon.wrappedValue = false
            let idKinopoisk = String(state.film.filmsBestInfo.filmId.wrappedValue ?? 0)
            Networking.share.searchMoviesFor(idKinopoisk: idKinopoisk) { film in
                guard (film.data.first?.iframeSrc) != nil else { return  }
                state.film.showVideoPlayerIcon.wrappedValue = true
            }
        case 1:
            state.film.showVideoPlayerIcon.wrappedValue = false
            let idKinopoisk = String(state.film.filmsPopularInfo.filmId.wrappedValue ?? 0)
            Networking.share.searchMoviesFor(idKinopoisk: idKinopoisk) { film in
                guard (film.data.first?.iframeSrc) != nil else { return }
                state.film.showVideoPlayerIcon.wrappedValue = true
            }
        case 2:
            state.film.showVideoPlayerIcon.wrappedValue = false
            guard let filmKinopoisk = state.film.filmInfo.data.wrappedValue?.filmId else { return }
            let idKinopoisk = String(filmKinopoisk)
            Networking.share.searchMoviesFor(idKinopoisk: idKinopoisk) { film in
                guard (film.data.first?.iframeSrc) != nil else { return }
                state.film.showVideoPlayerIcon.wrappedValue = true
            }
        default:
            print("Валидация не прошла")
        }
    }
    
    func getLinkOnPageKinopoiskVideo(state: Binding<AppState.AppData>) {
        switch state.film.selectedGenres.wrappedValue {
        case 0:
            let idKinopoisk = String(state.film.filmsBestInfo.filmId.wrappedValue ?? 0)
            Networking.share.searchMoviesFor(idKinopoisk: idKinopoisk) { film in
                guard let iframeSrc = film.data.first?.iframeSrc else { return }
                getLinkFromStringURL(strURL: iframeSrc)
            }
        case 1:
            let idKinopoisk = String(state.film.filmsPopularInfo.filmId.wrappedValue ?? 0)
            Networking.share.searchMoviesFor(idKinopoisk: idKinopoisk) { film in
                guard let iframeSrc = film.data.first?.iframeSrc else { return }
                getLinkFromStringURL(strURL: iframeSrc)
            }
        case 2:
            guard let filmKinopoisk = state.film.filmInfo.data.wrappedValue?.filmId else { return }
            let idKinopoisk = String(filmKinopoisk)
            Networking.share.searchMoviesFor(idKinopoisk: idKinopoisk) { film in
                guard let iframeSrc = film.data.first?.iframeSrc else { return }
                getLinkFromStringURL(strURL: iframeSrc)
            }
        default:
            print("ID Фильма не найденно")
        }
    }

    func getMovies(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            if state.film.filmsBest.wrappedValue.count == 0 || state.film.filmsBest.wrappedValue.count == 1 {
                let page = Int.random(in: 1...13)
                state.film.showActivityIndicator.wrappedValue = true
                Networking.share.getInfoKinopoiskBestFilms(page: page) { films in
                    let films = films.films?.shuffled()
                    state.film.filmsBest.wrappedValue.append(contentsOf: films ?? [])
                    state.film.showActivityIndicator.wrappedValue = false
                }
            }
            
            if state.film.filmsPopular.wrappedValue.count == 0 || state.film.filmsPopular.wrappedValue.count == 1 {
                let page = Int.random(in: 1...5)
                state.film.showActivityIndicator.wrappedValue = true
                Networking.share.getInfoKinopoiskPopularFilms(page: page) { films in
                    let films = films.films?.shuffled()
                    state.film.filmsPopular.wrappedValue.append(contentsOf: films ?? [])
                    state.film.showActivityIndicator.wrappedValue = false
                }
            }
            
            if state.film.films.wrappedValue.count == 0 || state.film.films.wrappedValue.count == 1 {
                let year = Int.random(in: 2010...2021)
                
                state.film.showActivityIndicator.wrappedValue = true
                Networking.share.getMovies(year: year, limit: 20) { films in
                    var films = films
                    
                    for (index, film) in films.data.enumerated() {
                        if film.kinopoiskID == nil {
                            films.data.remove(at: index)
                        }
                    }
                    
                    let filmsShuffled = films.data.shuffled()
                    state.film.films.wrappedValue.append(contentsOf: filmsShuffled)
                    
                    Networking.share.getInfoKinopoisk(films: filmsShuffled, state: state)

                    state.film.showActivityIndicator.wrappedValue = false
                }
            }
        }
    }
    
    func getCurrentFilmInfo(state: Binding<AppState.AppData>) {
        
        switch state.film.selectedGenres.wrappedValue {
        case 0:
            if !state.film.filmsBest.wrappedValue.isEmpty {
                let film = state.film.filmsBest.wrappedValue.first
                state.film.filmsBestInfo.wrappedValue = film!
                state.film.filmsBestHistory.wrappedValue.append(film!)
                state.film.filmsBest.wrappedValue.removeFirst()
            }
        case 1:
            if !state.film.filmsPopular.wrappedValue.isEmpty {
                let film = state.film.filmsPopular.wrappedValue.first
                state.film.filmsPopularInfo.wrappedValue = film!
                state.film.filmsPopularHistory.wrappedValue.append(film!)
                state.film.filmsPopular.wrappedValue.removeFirst()
            }
        case 2:
            if !state.film.films.wrappedValue.isEmpty {
                if state.film.films.wrappedValue.first?.kinopoiskID == nil {
                    state.film.films.wrappedValue.removeFirst()
                }
                
                guard let filmsTemp = state.film.filmsTemp.wrappedValue.first else { return }
                guard let films = state.film.films.wrappedValue.first else { return }
                
                state.film.filmInfo.wrappedValue = filmsTemp
                state.film.filmsHistory.wrappedValue.append(filmsTemp)
                state.film.filmsVideoHistory.wrappedValue.append(films)
                state.film.films.wrappedValue.removeFirst()
                state.film.filmsTemp.wrappedValue.removeFirst()
                
            }
        default: break
        }
    }
    
    func cleanFilms(state: Binding<AppState.AppData>) {
        state.film.films.wrappedValue = []
        state.film.filmsHistory.wrappedValue = []
        state.film.filmsVideoHistory.wrappedValue = []
        state.film.filmsTemp.wrappedValue = []
        
        state.film.filmsBest.wrappedValue = []
        state.film.filmsBestHistory.wrappedValue = []
        
        state.film.filmsPopular.wrappedValue = []
        state.film.filmsPopularHistory.wrappedValue = []
        
        state.film.showVideoPlayerIcon.wrappedValue = false
    }
    
    func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            saveFilms(state: state)
            saveFilmsVideoHistory(state: state)
            saveFilmsHistory(state: state)
            saveFilmsBest(state: state)
            saveFilmsBestHistory(state: state)
            saveFilmsPopular(state: state)
            saveFilmsBestPopular(state: state)
            saveFilmsTemp(state: state)
        }
    }
}

extension FilmInteractorImpl {
    private func encoderArrDatum(films: [Datum], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(films) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

extension FilmInteractorImpl {
    private func encoderArrFilmsInfo(filmInfo: [FilmsInfo], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(filmInfo) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

extension FilmInteractorImpl {
    private func encoderArrBestFilm(films: [BestFilm], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(films) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

// MARK - Films Save
extension FilmInteractorImpl {
    private func saveFilms(state: Binding<AppState.AppData>) {
        encoderArrDatum(films: state.film.films.wrappedValue, forKey: "FilmsData")
    }
    
    private func saveFilmsVideoHistory(state: Binding<AppState.AppData>) {
        encoderArrDatum(films: state.film.filmsVideoHistory.wrappedValue, forKey: "FilmsVideoHistory")
    }
    
    private func saveFilmsHistory(state: Binding<AppState.AppData>) {
        encoderArrFilmsInfo(filmInfo: state.film.filmsHistory.wrappedValue, forKey: "FilmsHistory")
    }
    
    private func saveFilmsTemp(state: Binding<AppState.AppData>) {
        encoderArrFilmsInfo(filmInfo: state.film.filmsTemp.wrappedValue, forKey: "FilmsTemp")
    }
}

// MARK - FilmsBest Save
extension FilmInteractorImpl {
    private func saveFilmsBest(state: Binding<AppState.AppData>) {
        encoderArrBestFilm(films: state.film.filmsBest.wrappedValue, forKey: "FilmsBest")
    }
    
    private func saveFilmsBestHistory(state: Binding<AppState.AppData>) {
        encoderArrBestFilm(films: state.film.filmsBestHistory.wrappedValue, forKey: "FilmsBestHistory")
    }
}

// MARK - FilmsPopular Save
extension FilmInteractorImpl {
    private func saveFilmsPopular(state: Binding<AppState.AppData>) {
        encoderArrBestFilm(films: state.film.filmsPopular.wrappedValue, forKey: "FilmsPopular")
    }
    
    private func saveFilmsBestPopular(state: Binding<AppState.AppData>) {
        encoderArrBestFilm(films: state.film.filmsPopularHistory.wrappedValue, forKey: "FilmsPopularHistory")
    }
}
