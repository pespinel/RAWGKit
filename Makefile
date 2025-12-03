.PHONY: all build test lint format check clean help setup install-hooks

# Default target
all: check

help: ## Show this help
	@echo ""
	@echo "RAWGKit Development Commands"
	@echo "============================"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'
	@echo ""

# === Setup ===

setup: ## Install development tools and git hooks
	@echo "📦 Setting up development environment..."
	@which swiftlint > /dev/null || (echo "Installing SwiftLint..." && brew install swiftlint)
	@which swiftformat > /dev/null || (echo "Installing SwiftFormat..." && brew install swiftformat)
	@$(MAKE) install-hooks
	@echo "✅ Development environment ready!"

install-hooks: ## Install git pre-commit hook
	@echo "🔗 Installing git hooks..."
	@mkdir -p .git/hooks
	@echo '#!/bin/bash' > .git/hooks/pre-commit
	@echo 'echo "🔍 Running pre-commit checks..."' >> .git/hooks/pre-commit
	@echo 'make format && make lint || exit 1' >> .git/hooks/pre-commit
	@echo 'echo "✅ Pre-commit checks passed!"' >> .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "✅ Git hooks installed"

# === Build & Test ===

build: ## Build the package
	@echo "🔨 Building..."
	@swift build

build-release: ## Build in release mode
	@echo "🔨 Building release..."
	@swift build -c release

test: ## Run tests
	@echo "🧪 Running tests..."
	@swift test

test-verbose: ## Run tests with verbose output
	@swift test --verbose 2>&1 | xcpretty || swift test --verbose

# === Code Quality ===

lint: ## Run SwiftLint
	@echo "🔍 Running SwiftLint..."
	@swiftlint lint

lint-fix: ## Run SwiftLint with auto-fix
	@echo "🔧 Fixing lint issues..."
	@swiftlint lint --fix && swiftlint lint

format: ## Run SwiftFormat
	@echo "✨ Formatting code..."
	@swiftformat .

format-check: ## Check formatting without changes
	@echo "🔍 Checking format..."
	@swiftformat . --lint

# === Combined Commands ===

check: format-check lint test ## Run all checks (CI simulation)

pre-commit: format lint test ## Format, lint, and test (before committing)

# === Cleanup ===

clean: ## Clean build artifacts
	@echo "🧹 Cleaning..."
	@swift package clean
	@rm -rf .build

# === Documentation ===

docs: ## Generate documentation (requires swift-docc)
	@echo "📚 Generating documentation..."
	@swift package --allow-writing-to-directory docs \
		generate-documentation \
		--target RAWGKit \
		--output-path docs \
		--transform-for-static-hosting

docs-preview: ## Preview documentation locally
	@echo "📚 Starting documentation preview..."
	@swift package --disable-sandbox preview-documentation --target RAWGKit
