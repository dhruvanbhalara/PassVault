.PHONY: clean pub_get build_runner watch_runner l10n generate run_dev run_prod build_apk_dev build_apk_prod build_appbundle_prod build_ios_dev build_ipa_prod test pod_install pod_repo_update lint format icons icons_dev icons_prod setup_hooks

# --- Cleaning ---
clean:
	@echo "Cleaning Flutter project..."
	flutter clean
	flutter pub get
	cd ios && rm -rf Pods Podfile.lock
	make pod_install

# --- Dependencies ---
pub_get:
	@echo "Getting dependencies..."
	flutter pub get

pod_install:
	cd ios && pod install

pod_repo_update:
	cd ios && pod install --repo-update

# --- Code Generation ---
build_runner:
	@echo "Running build_runner..."
	dart run build_runner build --delete-conflicting-outputs

build_runner_clean:
	@echo "Cleaning generated files..."
	dart run build_runner clean

watch_runner:
	dart run build_runner watch --delete-conflicting-outputs

l10n:
	@echo "Generating localization..."
	flutter gen-l10n

generate: pub_get l10n build_runner
	@echo "All files generated!"

# --- Running ---
run_dev:
	flutter run --flavor dev -t lib/main.dart

run_prod:
	flutter run --flavor prod -t lib/main.dart

build_apk_dev:
	@echo "Building Dev APK (64-bit, split per ABI)..."
	flutter build apk --flavor dev -t lib/main.dart \
		--split-per-abi \
		--obfuscate \
		--split-debug-info=build/symbols/dev \
		--tree-shake-icons

build_apk_prod:
	@echo "Building Prod APK (64-bit, split per ABI)..."
	flutter build apk --flavor prod -t lib/main.dart \
		--release \
		--split-per-abi \
		--obfuscate \
		--split-debug-info=build/symbols/prod \
		--tree-shake-icons

# Single fat APK (for testing on multiple devices - still 64-bit only due to ndk config)
build_apk_fat:
	@echo "Building Fat APK (all supported ABIs)..."
	flutter build apk --flavor prod -t lib/main.dart \
		--release \
		--obfuscate \
		--split-debug-info=build/symbols/prod \
		--tree-shake-icons

build_appbundle_prod:
	@echo "Building App Bundle (for Play Store)..."
	flutter build appbundle --flavor prod -t lib/main.dart \
		--release \
		--obfuscate \
		--split-debug-info=build/symbols/prod \
		--tree-shake-icons

# --- Building iOS ---
build_ios_dev:
	@echo "Building iOS Dev..."
	flutter build ios --flavor dev -t lib/main.dart \
		--obfuscate \
		--split-debug-info=build/symbols/dev \
		--tree-shake-icons

build_ios_prod:
	@echo "Building iOS Prod..."
	flutter build ios --flavor prod -t lib/main.dart \
		--release \
		--obfuscate \
		--split-debug-info=build/symbols/prod \
		--tree-shake-icons

build_ipa_prod:
	@echo "Building IPA for distribution..."
	flutter build ipa --flavor prod -t lib/main.dart \
		--release \
		--obfuscate \
		--split-debug-info=build/symbols/prod \
		--tree-shake-icons \
		--export-options-plist=ios/ExportOptions.plist

# --- Testing & Quality ---
test:
	flutter test

test_coverage:
	flutter test --coverage

lint:
	flutter analyze

format:
	dart format .

# --- Launcher Icons ---
icons_dev:
	dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml

icons_prod:
	dart run flutter_launcher_icons -f flutter_launcher_icons-prod.yaml

icons: icons_dev icons_prod
	@echo "Icons generated for all flavors!"

# --- Analyze APK Size ---
analyze_apk:
	@echo "Analyzing APK sizes..."
	@echo "64-bit APKs (supported):"
	@ls -lh build/app/outputs/flutter-apk/*arm64*.apk 2>/dev/null || echo "  No arm64 APKs found"
	@ls -lh build/app/outputs/flutter-apk/*x86_64*.apk 2>/dev/null || echo "  No x86_64 APKs found"
	@echo ""

# --- Full Workflows ---
build_all: generate build_apk_prod build_appbundle_prod
	@echo "All builds complete!"

# --- Git Hooks ---
setup_hooks:
	@echo "Setting up git hooks..."
	git config core.hooksPath .github/hooks
	@echo "✅ Git hooks configured! Hooks will run on commit and push."
