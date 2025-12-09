# Contributing to RAWGKit

Thank you for your interest in contributing to RAWGKit! This document provides guidelines and instructions for contributing.

## Code of Conduct

Be respectful and constructive in all interactions with the community.

## Development Setup

### Prerequisites

- macOS 13+ or later
- Xcode 15.0+ with Swift 6.0
- [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat)

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/pespinel/RAWGKit.git
cd RAWGKit

# Install development tools and git hooks
make setup
```

This will:
- Install SwiftLint and SwiftFormat via Homebrew
- Set up pre-commit hooks for automatic formatting and linting

### Manual Setup

If you prefer manual setup:

```bash
# Install tools
brew install swiftlint swiftformat

# Install git hooks
make install-hooks
```

## Development Workflow

### Making Changes

1. **Create a branch** for your work:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the code style guidelines below

3. **Run tests** to ensure everything works:
   ```bash
   make test
   ```

4. **Run all checks** before committing:
   ```bash
   make pre-commit
   ```
   This runs SwiftFormat, SwiftLint, and tests.

### Available Make Commands

```bash
make help           # Show all available commands
make setup          # Install tools and git hooks
make lint           # Run SwiftLint
make format         # Run SwiftFormat
make test           # Run tests
make pre-commit     # Format, lint, and test
make check          # Run all checks (CI simulation)
make clean          # Clean build artifacts
```

## Code Style Guidelines

### Swift Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use SwiftFormat for automatic formatting (configured in `.swiftformat`)
- Follow SwiftLint rules (configured in `.swiftlint.yml`)
- Maximum line length: 120 characters
- Maximum file length: 500 lines
- Maximum function body length: 60 lines

### Naming Conventions

- Use clear, descriptive names
- Types: `PascalCase` (e.g., `RAWGClient`, `NetworkError`)
- Functions/variables: `camelCase` (e.g., `fetchGames`, `apiKey`)
- Constants: `camelCase` (e.g., `defaultTimeout`)
- Enums cases: `camelCase` (e.g., `.success`, `.notFound`)

### Documentation

All public APIs must have complete DocC documentation:

```swift
/// Brief description of the function.
///
/// More detailed description if needed, explaining the purpose,
/// behavior, and any important notes.
///
/// - Parameters:
///   - paramName: Description of the parameter
///   - anotherParam: Description of another parameter
/// - Returns: Description of the return value
/// - Throws: Description of errors that can be thrown
///
/// ## Example
/// ```swift
/// let result = try await someFunction(param: "value")
/// print(result)
/// ```
///
/// - Note: Additional notes or warnings
/// - SeeAlso: Related types or functions
public func someFunction(param: String) async throws -> Result {
    // Implementation
}
```

### Concurrency

- Use Swift's structured concurrency (`async`/`await`, actors)
- Mark types as `Sendable` when appropriate
- Follow strict concurrency checking (enabled in Package.swift)
- Use actors for mutable shared state

### Error Handling

- Use typed errors (`NetworkError`, `DecodingError`, etc.)
- Provide clear, actionable error messages
- Include recovery suggestions when possible
- Don't use force unwraps (`!`) or force try (`try!`)

## Testing

### Writing Tests

- Use Swift Testing framework (`@Test`, `@Suite`)
- Test file names should match the tested file: `FileName.swift` → `FileNameTests.swift`
- Group related tests in suites using `@Suite`
- Use descriptive test names that explain what is being tested

Example:

```swift
@Suite("NetworkManager Tests")
struct NetworkManagerTests {
    @Test("Fetch returns decoded data")
    func fetchReturnsDecodedData() async throws {
        // Arrange
        let manager = NetworkManager(...)
        
        // Act
        let result = try await manager.fetch(...)
        
        // Assert
        #expect(result.isValid)
    }
}
```

### Integration Tests

Integration tests require a RAWG API key:

```bash
export RAWG_API_KEY="your-key-here"
swift test
```

Integration tests are automatically skipped if the API key is not set.

### Test Coverage

- Aim for high test coverage (>80%)
- All new features must include tests
- Bug fixes should include regression tests

## Pull Request Process

### Before Submitting

1. **Update documentation** if you changed public APIs
2. **Add tests** for new functionality
3. **Update CHANGELOG.md** under `[Unreleased]` section
4. **Run all checks**:
   ```bash
   make check
   ```
5. **Ensure all tests pass**:
   ```bash
   swift test
   ```

### PR Guidelines

- Use a clear, descriptive title following [Conventional Commits](https://www.conventionalcommits.org/):
  - `feat: add new feature`
  - `fix: correct bug in X`
  - `docs: update documentation for Y`
  - `refactor: improve code structure in Z`
  - `test: add tests for W`
  - `ci: update GitHub Actions workflow`

- Fill out the PR template completely
- Link related issues using "Closes #123" or "Fixes #456"
- Keep PRs focused on a single feature or fix
- Respond to review feedback promptly

### What Happens Next

1. **CI checks** will run automatically (lint, format, tests)
2. **Code review** by maintainers
3. **Approval and merge** once all checks pass and review is complete

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>: <short summary>

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `ci`: CI/CD changes
- `chore`: Maintenance tasks

Example:
```
feat: add support for game DLC endpoints

- Add fetchGameAdditions method
- Add DLC model
- Add tests for DLC fetching

Closes #42
```

## Reporting Issues

### Bug Reports

Use the bug report template and include:
- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Code sample demonstrating the issue
- Platform and version information

### Feature Requests

Use the feature request template and include:
- Problem you're trying to solve
- Proposed solution
- Alternative solutions considered
- Example API usage

### Questions

For questions, use [GitHub Discussions](https://github.com/pespinel/RAWGKit/discussions) instead of issues.

## Project Structure

```
RAWGKit/
├── Sources/RAWGKit/
│   ├── RAWGClient.swift          # Main client actor
│   ├── GamesQueryBuilder.swift   # Fluent query builder
│   ├── QueryFilters.swift        # Type-safe filter enums
│   ├── RAWGConstants.swift       # Centralized constants
│   ├── RAWGLogger.swift          # Structured logging
│   ├── Endpoints/                # API endpoint definitions
│   ├── Extensions/               # Swift extensions
│   ├── Models/                   # Data models
│   │   ├── Core/                 # Core models (Game, Response)
│   │   ├── Resources/            # API resources
│   │   ├── GameContent/          # Game-related content
│   │   └── Metadata/             # Metadata models
│   └── Networking/               # Network layer
│       ├── NetworkManager.swift  # HTTP client actor
│       ├── NetworkError.swift    # Error types
│       ├── CacheManager.swift    # Response caching
│       └── RetryPolicy.swift     # Retry logic
├── Tests/RAWGKitTests/           # Test suite
└── Examples.swift                # Usage examples
```

## Code Review Checklist

When reviewing PRs, check for:

- [ ] Code follows Swift style guidelines
- [ ] Public APIs have complete DocC documentation
- [ ] All tests pass locally and in CI
- [ ] New features have tests
- [ ] No force unwraps or force casts
- [ ] Proper error handling
- [ ] Sendable conformance where appropriate
- [ ] CHANGELOG.md updated
- [ ] No unnecessary dependencies added
- [ ] Performance considerations addressed
- [ ] Breaking changes documented

## Getting Help

- **Questions**: Use [GitHub Discussions](https://github.com/pespinel/RAWGKit/discussions)
- **Bugs**: Open an issue using the bug report template
- **Features**: Open an issue using the feature request template
- **Documentation**: Open an issue using the documentation template

## License

By contributing to RAWGKit, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in the project's README and release notes.

Thank you for contributing to RAWGKit! 🎮
