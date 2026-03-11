# Infrastructure & Development Setup

This document outlines the CI/CD pipeline, development infrastructure, and setup instructions for the myMindMap macOS application.

---

## Prerequisites

Before you begin, ensure you have the following installed:

| Tool | Version | Purpose |
|------|---------|---------|
| Xcode | 15.0+ | IDE and SDK for macOS development |
| XcodeGen | 2.0+ | Generate Xcode projects from YAML |
| Homebrew | Latest | Package manager for macOS |
| SwiftLint | 0.54+ | Code linting |
| SwiftFormat | 0.53+ | Code formatting |

### Installing Prerequisites

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install XcodeGen
brew install xcodegen

# Install SwiftLint
brew install swiftlint

# Install SwiftFormat
brew install swiftformat
```

---

## Project Structure

```
myMindMap/
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions CI/CD
├── .swiftlint.yml              # SwiftLint configuration
├── .swiftformat                # SwiftFormat configuration
├── .gitignore                  # Git ignore rules
├── project.yml                 # XcodeGen project config
├── README.md                   # Project documentation
├── INFRASTRUCTURE.md           # This file
├── src/                        # Source code
│   ├── myMindMap/              # Main app target
│   │   ├── App/
│   │   ├── Views/
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   ├── Services/
│   │   └── Utilities/
│   └── myMindMapTests/         # Test target
├── resources/                  # Assets, fonts, etc.
└── tests/                      # Integration tests
```

---

## Local Development

### Generating the Xcode Project

```bash
# Navigate to project root
cd /Users/thotas/Development/MyAppsDev/myMindMap

# Generate Xcode project using XcodeGen
xcodegen generate
```

This will create `myMindMap.xcodeproj` based on the `project.yml` configuration.

### Building the Project

```bash
# Open in Xcode
open myMindMap.xcodeproj

# Or build from command line
xcodebuild -project myMindMap.xcodeproj -scheme myMindMap -configuration Debug build

# For release build
xcodebuild -project myMindMap.xcodeproj -scheme myMindMap -configuration Release build
```

### Running Tests

```bash
# Run all tests
xcodebuild -project myMindMap.xcodeproj -scheme myMindMap -configuration Debug test

# Run specific test target
xcodebuild -project myMindMap.xcodeproj -scheme myMindMapTests -configuration Debug test
```

### Code Analysis

```bash
# Static analysis using Xcode
xcodebuild -project myMindMap.xcodeproj -scheme myMindMap -configuration Debug analyze
```

### Code Linting

```bash
# Run SwiftLint
swiftlint

# Or with custom config
swiftlint --config .swiftlint.yml
```

### Code Formatting

```bash
# Check formatting (dry run)
swiftformat --dryrun .

# Apply formatting
swiftformat .

# Strict mode (fail on formatting issues)
swiftformat --strict .
```

---

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration and delivery.

### Workflow: ci.yml

| Job | Description | Triggers |
|-----|-------------|----------|
| **Build** | Compiles the project on macOS latest | Push/PR |
| **Test** | Runs XCTest unit tests | Push/PR |
| **Analyze** | Runs Xcode static analysis | Push/PR |
| **Lint** | Runs SwiftLint | Push/PR |
| **Format** | Checks code formatting | Push/PR |
| **Archive** | Creates release archive | Push to main/develop |

### Running CI Locally

You can validate the CI configuration locally using `act`:

```bash
# Install act (GitHub Actions local runner)
brew install act

# Run CI workflow locally
act -j build
```

### CI Environment Variables

For archive creation, the following secrets must be configured in GitHub:

| Secret | Description |
|--------|-------------|
| `CERTIFICATE` | Base64 encoded Apple Developer certificate (.p12) |
| `KEYCHAIN_PASSWORD` | Keychain password |
| `PROVISIONING_PROFILE` | Base64 encoded provisioning profile |
| `CODE_SIGN_IDENTITY` | Code signing identity |

---

## Code Signing & Distribution

### Development

1. Open Xcode Preferences > Accounts
2. Add your Apple Developer account
3. Select your team for signing

### CI/CD Signing

For automated builds without signing:

```bash
xcodebuild -project myMindMap.xcodeproj \
  -scheme myMindMap \
  -configuration Release \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build
```

### App Store Distribution

1. Create App Store Connect entry
2. Configure signing in project.yml
3. Run archive job in CI
4. Upload to App Store Connect

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| XcodeGen not found | Run `brew install xcodegen` |
| SwiftLint errors | Review rules in `.swiftlint.yml` or fix code |
| Build fails | Check `project.yml` configuration |
| Test failures | Run tests in Xcode to see detailed output |
| Code signing errors | Check certificates in Keychain Access |

### Resetting Environment

```bash
# Clean derived data
rm -rf DerivedData

# Clean build folder
xcodebuild clean

# Regenerate project
xcodegen generate

# Reset simulator
xcrun simctl delete all available
```

---

## Additional Resources

- [XcodeGen Documentation](https://github.com/yonaskolb/XcodeGen)
- [SwiftLint Rules](https://realm.github.io/SwiftLint/)
- [SwiftFormat Options](https://github.com/nicklockwood/SwiftFormat)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

*Last Updated: 2026-03-10*
*For questions, contact the DevOps team*