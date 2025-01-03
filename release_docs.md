# Circle App CI/CD Pipeline Documentation

## Overview
The Circle App uses GitHub Actions for continuous integration and deployment, with two main workflows:
1. Build & Analyze Pipeline (PR Validation)
2. Deployment Pipeline (Release Management)

## Build & Analyze Pipeline

This pipeline runs on every pull request to the `main` branch and consists of three parallel jobs:

1. **Code Analysis**
    - Runs Flutter analyzer to check code quality
    - Validates code formatting and structure

2. **Android Build**
    - Builds debug APK
    - Provides build artifacts for testing
    - Runs on Ubuntu latest

3. **iOS Build**
    - Builds unsigned iOS release build
    - Runs on macOS latest
    - No codesigning for PR validation

## Deployment Pipeline

### Release Process

To create a new release:

1. Create a new branch with prefix `release/` (e.g., `release/v1.2.3`)
2. Add/update release notes in:
    - `distribution/release_notes/release_notes.md` (GitHub Release notes)
    - `distribution/whats_new/whatsnew-en-US` (Play Store release notes)
3. Create a pull request targeting `main`

### Pipeline Steps

The deployment pipeline consists of two main jobs:

#### 1. Version Management (`version` job)
- Automatically triggers on PRs from release branches
- Extracts current version from `pubspec.yaml`
- Increments build number
- Updates version in `pubspec.yaml`
- Commits changes and creates a git tag
- Exposes version information to subsequent jobs

#### 2. Deployment (`deploy` job)
- Builds release artifacts (APK/AAB)
- Creates GitHub Release with:
    - Release notes from `release_notes.md`
    - Build artifacts attached
    - Auto-generated release notes
- Deploys to Google Play Store:
    - Uploads to internal track
    - Uses release notes from `whats_new` directory
    - Creates as draft release
    - Uses service account authentication

### Version Format
- Format: `<semantic_version>+<build_number>`
- Example: `1.2.3+45`
- Release name format: `45(1.2.3)`

### Required Secrets
- `ANDROID_KEYSTORE`
- `ANDROID_KEY_PROPERTIES`
- `GCP_CIRCLE_SERVICE_ACCOUNT_KEY`
- `GITHUB_TOKEN` (Uses the token automatically provided by GitHub Actions)

### Directory Structure
```
distribution/
├── release_notes/
│   └── release_notes.md
└── whats_new/
    └── whatsnew-en-US
```

## Environment Configuration
- Flutter Channel: main
- Java Version: 17
- Java Distribution: Zulu
- Package Name: co.circleapp.app

## Build Artifacts
- APK Location: `build/app/outputs/flutter-apk/app-release.apk`
- AAB Location: `build/app/outputs/bundle/release/app-release.aab`

## Security Notes
- All deployments require appropriate permissions
- Service account keys and signing keys are stored as GitHub secrets
- Workload identity federation is configured but currently commented out because it doesn't play nice with Google Play Developer API for some reason