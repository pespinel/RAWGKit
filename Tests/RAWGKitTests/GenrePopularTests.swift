@testable import RAWGKit
import Testing

struct GenrePopularTests {
    @Test("Genre.Popular.action has correct values")
    func actionGenre() {
        #expect(Genre.Popular.action.id == 4)
        #expect(Genre.Popular.action.name == "Action")
        #expect(Genre.Popular.action.slug == "action")
    }

    @Test("Genre.Popular.adventure has correct values")
    func adventureGenre() {
        #expect(Genre.Popular.adventure.id == 3)
        #expect(Genre.Popular.adventure.name == "Adventure")
        #expect(Genre.Popular.adventure.slug == "adventure")
    }

    @Test("Genre.Popular.rpg has correct values")
    func rpgGenre() {
        #expect(Genre.Popular.rpg.id == 5)
        #expect(Genre.Popular.rpg.name == "RPG")
        #expect(Genre.Popular.rpg.slug == "role-playing-games-rpg")
    }

    @Test("Genre.Popular.shooter has correct values")
    func shooterGenre() {
        #expect(Genre.Popular.shooter.id == 2)
        #expect(Genre.Popular.shooter.name == "Shooter")
        #expect(Genre.Popular.shooter.slug == "shooter")
    }

    @Test("Genre.Popular.strategy has correct values")
    func strategyGenre() {
        #expect(Genre.Popular.strategy.id == 10)
        #expect(Genre.Popular.strategy.name == "Strategy")
        #expect(Genre.Popular.strategy.slug == "strategy")
    }

    @Test("Genre.Popular.simulation has correct values")
    func simulationGenre() {
        #expect(Genre.Popular.simulation.id == 14)
        #expect(Genre.Popular.simulation.name == "Simulation")
        #expect(Genre.Popular.simulation.slug == "simulation")
    }

    @Test("Genre.Popular.puzzle has correct values")
    func puzzleGenre() {
        #expect(Genre.Popular.puzzle.id == 7)
        #expect(Genre.Popular.puzzle.name == "Puzzle")
        #expect(Genre.Popular.puzzle.slug == "puzzle")
    }

    @Test("Genre.Popular.sports has correct values")
    func sportsGenre() {
        #expect(Genre.Popular.sports.id == 15)
        #expect(Genre.Popular.sports.name == "Sports")
        #expect(Genre.Popular.sports.slug == "sports")
    }

    @Test("Genre.Popular.racing has correct values")
    func racingGenre() {
        #expect(Genre.Popular.racing.id == 1)
        #expect(Genre.Popular.racing.name == "Racing")
        #expect(Genre.Popular.racing.slug == "racing")
    }

    @Test("Genre.Popular.fighting has correct values")
    func fightingGenre() {
        #expect(Genre.Popular.fighting.id == 6)
        #expect(Genre.Popular.fighting.name == "Fighting")
        #expect(Genre.Popular.fighting.slug == "fighting")
    }

    @Test("Genre.Popular.platformer has correct values")
    func platformerGenre() {
        #expect(Genre.Popular.platformer.id == 83)
        #expect(Genre.Popular.platformer.name == "Platformer")
        #expect(Genre.Popular.platformer.slug == "platformer")
    }

    @Test("Genre.Popular.indie has correct values")
    func indieGenre() {
        #expect(Genre.Popular.indie.id == 51)
        #expect(Genre.Popular.indie.name == "Indie")
        #expect(Genre.Popular.indie.slug == "indie")
    }

    @Test("Genre.Popular.massivelyMultiplayer has correct values")
    func massivelyMultiplayerGenre() {
        #expect(Genre.Popular.massivelyMultiplayer.id == 59)
        #expect(Genre.Popular.massivelyMultiplayer.name == "Massively Multiplayer")
        #expect(Genre.Popular.massivelyMultiplayer.slug == "massively-multiplayer")
    }

    @Test("Genre.Popular.all contains all genres")
    func allGenres() {
        #expect(Genre.Popular.all.count == 13)
        #expect(Genre.Popular.all.contains { $0.id == 4 }) // Action
        #expect(Genre.Popular.all.contains { $0.id == 3 }) // Adventure
        #expect(Genre.Popular.all.contains { $0.id == 5 }) // RPG
        #expect(Genre.Popular.all.contains { $0.id == 2 }) // Shooter
        #expect(Genre.Popular.all.contains { $0.id == 10 }) // Strategy
        #expect(Genre.Popular.all.contains { $0.id == 14 }) // Simulation
        #expect(Genre.Popular.all.contains { $0.id == 7 }) // Puzzle
        #expect(Genre.Popular.all.contains { $0.id == 15 }) // Sports
        #expect(Genre.Popular.all.contains { $0.id == 1 }) // Racing
        #expect(Genre.Popular.all.contains { $0.id == 6 }) // Fighting
        #expect(Genre.Popular.all.contains { $0.id == 83 }) // Platformer
        #expect(Genre.Popular.all.contains { $0.id == 51 }) // Indie
        #expect(Genre.Popular.all.contains { $0.id == 59 }) // Massively Multiplayer
    }
}
