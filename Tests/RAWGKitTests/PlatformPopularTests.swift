@testable import RAWGKit
import Testing

struct PlatformPopularTests {
    @Test("Platform.Popular.pc has correct values")
    func pcPlatform() {
        #expect(Platform.Popular.pc.id == 4)
        #expect(Platform.Popular.pc.name == "PC")
        #expect(Platform.Popular.pc.slug == "pc")
    }

    @Test("Platform.Popular.playStation5 has correct values")
    func playStation5Platform() {
        #expect(Platform.Popular.playStation5.id == 187)
        #expect(Platform.Popular.playStation5.name == "PlayStation 5")
        #expect(Platform.Popular.playStation5.slug == "playstation5")
    }

    @Test("Platform.Popular.playStation4 has correct values")
    func playStation4Platform() {
        #expect(Platform.Popular.playStation4.id == 18)
        #expect(Platform.Popular.playStation4.name == "PlayStation 4")
        #expect(Platform.Popular.playStation4.slug == "playstation4")
    }

    @Test("Platform.Popular.xboxSeriesXS has correct values")
    func xboxSeriesXSPlatform() {
        #expect(Platform.Popular.xboxSeriesXS.id == 186)
        #expect(Platform.Popular.xboxSeriesXS.name == "Xbox Series X/S")
        #expect(Platform.Popular.xboxSeriesXS.slug == "xbox-series-x")
    }

    @Test("Platform.Popular.xboxOne has correct values")
    func xboxOnePlatform() {
        #expect(Platform.Popular.xboxOne.id == 1)
        #expect(Platform.Popular.xboxOne.name == "Xbox One")
        #expect(Platform.Popular.xboxOne.slug == "xbox-one")
    }

    @Test("Platform.Popular.nintendoSwitch has correct values")
    func nintendoSwitchPlatform() {
        #expect(Platform.Popular.nintendoSwitch.id == 7)
        #expect(Platform.Popular.nintendoSwitch.name == "Nintendo Switch")
        #expect(Platform.Popular.nintendoSwitch.slug == "nintendo-switch")
    }

    @Test("Platform.Popular.iOS has correct values")
    func iOSPlatform() {
        #expect(Platform.Popular.iOS.id == 3)
        #expect(Platform.Popular.iOS.name == "iOS")
        #expect(Platform.Popular.iOS.slug == "ios")
    }

    @Test("Platform.Popular.android has correct values")
    func androidPlatform() {
        #expect(Platform.Popular.android.id == 21)
        #expect(Platform.Popular.android.name == "Android")
        #expect(Platform.Popular.android.slug == "android")
    }

    @Test("Platform.Popular.macOS has correct values")
    func macOSPlatform() {
        #expect(Platform.Popular.macOS.id == 5)
        #expect(Platform.Popular.macOS.name == "macOS")
        #expect(Platform.Popular.macOS.slug == "macos")
    }

    @Test("Platform.Popular.linux has correct values")
    func linuxPlatform() {
        #expect(Platform.Popular.linux.id == 6)
        #expect(Platform.Popular.linux.name == "Linux")
        #expect(Platform.Popular.linux.slug == "linux")
    }

    @Test("Platform.Popular.all contains all platforms")
    func allPlatforms() {
        #expect(Platform.Popular.all.count == 10)
        #expect(Platform.Popular.all.contains { $0.id == 4 }) // PC
        #expect(Platform.Popular.all.contains { $0.id == 187 }) // PlayStation 5
        #expect(Platform.Popular.all.contains { $0.id == 18 }) // PlayStation 4
        #expect(Platform.Popular.all.contains { $0.id == 186 }) // Xbox Series X/S
        #expect(Platform.Popular.all.contains { $0.id == 1 }) // Xbox One
        #expect(Platform.Popular.all.contains { $0.id == 7 }) // Nintendo Switch
        #expect(Platform.Popular.all.contains { $0.id == 3 }) // iOS
        #expect(Platform.Popular.all.contains { $0.id == 21 }) // Android
        #expect(Platform.Popular.all.contains { $0.id == 5 }) // macOS
        #expect(Platform.Popular.all.contains { $0.id == 6 }) // Linux
    }
}
