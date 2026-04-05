# AGENTS.md — AppGen

## Project Overview

- **Name**: AppGen (Application Generator)
- **Description**: Cross-platform mobile application generator with Expo/React Native and AI-powered code generation
- **Location**: `/Users/kooshapari/CodeProjects/Phenotype/repos/AppGen`
- **Language Stack**: React Native, Expo SDK 50+, TypeScript 5.3+
- **Published**: Private (Phenotype org)

## Quick Start

```bash
# Navigate to project
cd /Users/kooshapari/CodeProjects/Phenotype/repos/AppGen

# Install dependencies
npm install

# Start Expo development server
npx expo start

# Run on iOS simulator
npx expo start --ios

# Run on Android emulator
npx expo start --android

# Run web version
npx expo start --web
```

## Architecture

### Mobile App Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Presentation Layer                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐│
│  │   Screens       │  │   Components    │  │   Navigation    ││
│  │                 │  │                 │  │                 ││
│  │  • HomeScreen   │  │  • Button       │  │  • Stack        ││
│  │  • ListScreen   │  │  • Card         │  │  • Tab          ││
│  │  • DetailScreen │  │  • Input        │  │  • Drawer       ││
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘│
└───────────┼───────────────────┼─────────────────────┼───────────┘
            │                   │                     │
┌───────────▼───────────────────▼─────────────────────▼───────────┐
│                     Application Layer                              │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                    State Management                          │ │
│  │       Context API / Zustand / Redux Toolkit                │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │   Services      │  │   Hooks         │  │   Utils         │ │
│  │                 │  │                 │  │                 │ │
│  │  • API Service  │  │  • useAuth      │  │  • Formatters   │ │
│  │  • AI Service   │  │  • useFetch     │  │  • Validators   │ │
│  │  • Storage      │  │  • useLocalize  │  │  • Constants    │ │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘ │
└───────────┼───────────────────┼─────────────────────┼───────────┘
            │                   │                     │
┌───────────▼───────────────────▼─────────────────────▼───────────┐
│                     Infrastructure Layer                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │   Expo SDK      │  │   Native APIs   │  │   Third-Party   │ │
│  │                 │  │                 │  │     Libraries   │ │
│  │  • Constants    │  │  • Camera       │  │                 │ │
│  │  • Notifications│  │  • Location     │  │  • Supabase     │ │
│  │  • Asset        │  │  • Sensors      │  │  • Reanimated   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Data Flow Architecture

```
┌──────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────┐
│   User   │────▶│    Screen    │────▶│     Hook     │────▶│  Service │
│  Action  │     │   Component  │     │   (Logic)    │     │   (API)  │
└──────────┘     └──────────────┘     └──────────────┘     └──────────┘
     ▲                   ▲                   ▲                   │
     │                   │                   │                   │
     │                   │                   │                   ▼
     │                   │                   │            ┌──────────┐
     │                   │                   │            │  Backend │
     │                   │                   │            │   / AI   │
     │                   │                   │            └──────────┘
     │                   │                   │                   │
     │                   │                   │                   ▼
     │                   │                   │            ┌──────────┐
     │                   │                   └────────────│   State   │
     │                   │                              │  Update   │
     │                   │                              └──────────┘
     │                   │                                     │
     └───────────────────┴─────────────────────────────────────┘
                    Re-render with new state
```

### Navigation Structure

```
┌────────────────────────────────────────────────────────────────────┐
│                        Navigation Stack                           │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                      Root Navigator                           │  │
│  │                                                              │  │
│  │  ┌────────────────────────────────────────────────────────┐ │  │
│  │  │              (Auth State)                               │ │  │
│  │  │                                                        │ │  │
│  │  │  ┌──────────────┐        ┌──────────────────────────┐ │ │  │
│  │  │  │   Auth       │        │        App               │ │ │  │
│  │  │  │   Stack      │        │       (Tab)              │ │ │  │
│  │  │  │              │        │                          │ │ │  │
│  │  │  │  • Login     │        │  ┌──────────────────────┐ │ │  │
│  │  │  │  • Register  │        │  │ Home | List | Profile│ │ │  │
│  │  │  │  • Forgot    │        │  └──────────────────────┘ │ │  │
│  │  │  └──────────────┘        │                           │ │  │
│  │  │                          │  ┌──────────────────────┐ │ │  │
│  │  │                          │  │   Detail Stack       │ │ │  │
│  │  │                          │  │                      │ │ │  │
│  │  │                          │  │  • Detail Screen     │ │ │  │
│  │  │                          │  │  • Edit Screen       │ │ │  │
│  │  │                          │  └──────────────────────┘ │ │  │
│  │  │                          └───────────────────────────┘ │  │
│  │  └────────────────────────────────────────────────────────┘  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
└────────────────────────────────────────────────────────────────────┘
```

## Quality Standards

### TypeScript Code Quality

- **Formatter**: Prettier (configured in `.prettierrc`)
- **Linter**: ESLint with TypeScript parser
- **Type Checker**: `tsc --noEmit`
- **Import Organization**: ESLint import plugin

### Prettier Configuration

```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
```

### ESLint Rules

```bash
# Run linting
npm run lint

# Fix auto-fixable issues
npm run lint:fix

# Check specific file
npx eslint src/components/Button.tsx
```

### Test Requirements

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test
npm test -- Button.test.tsx

# Run E2E tests
npm run test:e2e
```

## Git Workflow

### Branch Naming

Format: `<type>/<platform>/<description>`

Types: `feat`, `fix`, `ui`, `perf`, `refactor`

Examples:
- `feat/ios/add-push-notifications`
- `fix/android/navigation-back-button`
- `ui/components/update-button-styles`

### Commit Messages

Format: `<type>(<scope>): <description>`

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Examples:
- `feat(auth): add biometric authentication`
- `fix(api): handle network timeout errors`
- `style(theme): update color palette for dark mode`

### Versioning

Uses Expo Application Services (EAS) versioning:
- Android: `versionCode` auto-increments
- iOS: `buildNumber` auto-increments

## File Structure

```
AppGen/
├── src/
│   ├── components/           # Reusable UI components
│   │   ├── atoms/           # Basic building blocks
│   │   ├── molecules/       # Combinations of atoms
│   │   └── organisms/       # Complex components
│   ├── screens/             # Screen components
│   │   ├── auth/
│   │   ├── main/
│   │   └── settings/
│   ├── navigation/          # Navigation configuration
│   │   ├── AppNavigator.tsx
│   │   ├── AuthNavigator.tsx
│   │   └── types.ts
│   ├── hooks/               # Custom React hooks
│   ├── services/            # API and external services
│   ├── store/               # State management
│   ├── utils/               # Utility functions
│   ├── constants/           # App constants
│   ├── types/               # TypeScript types
│   └── theme/               # Styling and theme config
├── assets/                  # Images, fonts, videos
├── app.json                 # Expo configuration
├── App.js                   # Entry point
├── babel.config.js          # Babel configuration
├── package.json             # Dependencies
├── tsconfig.json            # TypeScript config
└── AGENTS.md                # This file
```

## CLI Commands

```bash
# Development
npx expo start                    # Start dev server
npx expo start --ios             # iOS simulator
npx expo start --android         # Android emulator
npx expo start --web             # Web version

# Building
eas build --platform ios         # Build for iOS
eas build --platform android     # Build for Android
eas build --platform all         # Build for all platforms

# Publishing
eas submit -p ios               # Submit to App Store
eas submit -p android           # Submit to Play Store

# Updates
eas update --branch production  # Push OTA update

# Debugging
npx expo doctor                 # Check for issues
npx expo install --check        # Check dependencies
```

## Configuration

### app.json

```json
{
  "expo": {
    "name": "AppGen",
    "slug": "appgen",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "splash": {
      "image": "./assets/splash.png",
      "resizeMode": "contain"
    },
    "updates": {
      "fallbackToCacheTimeout": 0
    },
    "assetBundlePatterns": ["**/*"],
    "ios": {
      "supportsTablet": true,
      "bundleIdentifier": "com.phenotype.appgen"
    },
    "android": {
      "package": "com.phenotype.appgen",
      "adaptiveIcon": {
        "foregroundImage": "./assets/adaptive-icon.png"
      }
    },
    "web": {
      "favicon": "./assets/favicon.png"
    }
  }
}
```

### eas.json

```json
{
  "cli": {
    "version": ">= 7.0.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal"
    },
    "preview": {
      "distribution": "internal",
      "channel": "preview"
    },
    "production": {
      "channel": "production"
    }
  }
}
```

## Troubleshooting

### Metro bundler issues

```bash
# Clear Metro cache
npx expo start --clear

# Reset everything
watchman watch-del-all
rm -rf node_modules
rm -rf .expo
npm install
npx expo start --clear
```

### iOS build failures

```bash
# Clean iOS build
cd ios && rm -rf build Pods Podfile.lock
cd ..
npx pod-install

# Reset simulators
xcrun simctl erase all
```

### Android build failures

```bash
# Clean Android build
cd android && ./gradlew clean
cd ..

# Clear gradle cache
rm -rf ~/.gradle/caches
```

### Device/simulator not detected

```bash
# List iOS simulators
xcrun simctl list devices

# List Android emulators
emulator -list-avds

# Start specific emulator
emulator -avd Pixel_6_API_33
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `EXPO_PUBLIC_API_URL` | Backend API URL | Yes |
| `EXPO_PUBLIC_AI_API_KEY` | AI service API key | Optional |
| `EXPO_PUBLIC_SENTRY_DSN` | Error tracking DSN | Optional |
| `EXPO_PUBLIC_SUPABASE_URL` | Supabase project URL | Optional |
| `EXPO_PUBLIC_SUPABASE_ANON_KEY` | Supabase anon key | Optional |

## Performance Optimization

1. **Image Optimization**
   - Use `expo-image` for better performance
   - Implement lazy loading for lists
   - Cache images appropriately

2. **List Performance**
   - Use `FlashList` instead of `FlatList`
   - Implement `getItemLayout` when possible
   - Memoize expensive renders

3. **Animation**
   - Use `react-native-reanimated` for 60fps
   - Run animations on UI thread
   - Avoid JavaScript-driven animations

4. **Startup Time**
   - Defer non-critical initialization
   - Use code splitting
   - Minimize initial bundle size

## Security Considerations

1. Store secrets in environment variables
2. Use `expo-secure-store` for sensitive data
3. Implement certificate pinning for API calls
4. Enable ProGuard/R8 for Android
5. Use iOS Keychain for credentials
6. Validate all user inputs

## Resources

- [Expo Documentation](https://docs.expo.dev/)
- [React Native Docs](https://reactnative.dev/)
- [React Navigation](https://reactnavigation.org/)
- [EAS Build](https://docs.expo.dev/build/introduction/)

## Agent Notes

**Critical Implementation Details:**
- Always test on both iOS and Android
- Use platform-specific code when needed: `Platform.OS`
- Handle app state changes (background/foreground)
- Request permissions before using native features

**Known Gotchas:**
- Metro bundler caches aggressively - use `--clear` often
- iOS simulators don't support all features (Push, Camera)
- Android permissions require runtime requests
- Deep linking requires platform-specific setup

**Testing Strategy:**
- Unit tests for business logic
- Component tests with React Native Testing Library
- E2E tests with Detox or Maestro
- Manual testing on physical devices
