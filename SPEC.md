# AppGen — Comprehensive Specification

**Document ID:** PHENOTYPE_APPGEN_SPEC_001  
**Status:** Active  
**Last Updated:** 2026-04-03  
**Author:** Phenotype Architecture Team

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture](#2-architecture)
3. [Functionality Specification](#3-functionality-specification)
4. [Technical Architecture](#4-technical-architecture)
5. [API Reference](#5-api-reference)
6. [Error Handling](#6-error-handling)
7. [Security](#7-security)
8. [Performance Specifications](#8-performance-specifications)
9. [Testing Strategy](#9-testing-strategy)
10. [Build and Deployment](#10-build-and-deployment)
11. [Development Workflow](#11-development-workflow)
12. [Configuration Reference](#12-configuration-reference)
13. [Component Catalog](#13-component-catalog)
14. [Theme Specification](#14-theme-specification)
15. [Navigation Specification](#15-navigation-specification)
16. [Data Models](#16-data-models)
17. [Migration Guide](#17-migration-guide)
18. [Appendices](#18-appendices)

---

## 1. Project Overview

### 1.1 Executive Summary

AppGen is a production-grade React Native boilerplate optimized for utility-style mobile applications. It provides a complete, opinionated foundation for rapid mobile app development with modern tooling, Material Design 3 theming, and cross-platform compatibility. The project serves as both a functional application template and a generator for future mobile applications within the Phenotype ecosystem.

### 1.2 Project Metadata

| Attribute | Value |
|-----------|-------|
| **Project Name** | AppGen (AppGeneric) |
| **Package Name** | appgeneric |
| **Version** | 1.0.0 |
| **Framework** | React Native 0.84.1 |
| **Runtime** | Expo SDK ~54.0.13 |
| **Language** | JavaScript (TypeScript migration planned) |
| **Platforms** | iOS, Android, Web |
| **Bundle ID (iOS)** | com.Generic.App |
| **Package (Android)** | com.Generic.App |
| **License** | Private |
| **Repository** | /Users/kooshapari/CodeProjects/Phenotype/repos/AppGen |

### 1.3 Key Characteristics

| Attribute | Value | Target |
|-----------|-------|--------|
| **Framework** | React Native 0.84+ with Expo SDK 54 | ✓ |
| **Platform Support** | iOS, Android, Web | ✓ |
| **UI System** | Material Design 3 (React Native Paper v5) | ✓ |
| **Navigation** | React Navigation v6 (Native Stack) | ✓ |
| **State Management** | Zustand + React Query (planned) | Planned |
| **JS Engine** | Hermes | ✓ |
| **Bundle Target (Android)** | <15MB | Target |
| **Bundle Target (iOS)** | <20MB | Target |
| **Startup Target** | <2s Time to Interactive | Target |
| **Frame Rate** | 60fps | Target |

### 1.4 Value Proposition

- **Rapid Development**: Pre-configured stack with navigation, theming, and UI components ready
- **Production Ready**: Optimized for performance, accessibility, and security
- **Modern Architecture**: React Native New Architecture with Hermes engine
- **Modular Design**: Component-first architecture for easy customization
- **Themeable**: JSON-based light/dark theme configuration
- **Cross-Platform**: Single codebase for iOS, Android, and Web

### 1.5 Target Use Cases

- Utility applications (settings-heavy, tool-focused)
- Business productivity apps
- Information management applications
- Configuration and management interfaces
- Light social/communication apps
- Template for future Phenotype mobile applications

### 1.6 Non-Goals

- Gaming or graphics-intensive applications
- Real-time video/audio processing
- Augmented reality applications
- Native-only platform features requiring bare workflow
- Enterprise-grade authentication systems (beyond basic auth)

---

## 2. Architecture

### 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           AppGen System Architecture                       │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         Presentation Layer                           │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │   │
│  │  │   Screens    │  │  Components  │  │   Modals     │             │   │
│  │  │              │  │              │  │              │             │   │
│  │  │ • Home       │  │ • Buttons    │  │ • Auth       │             │   │
│  │  │ • Settings   │  │ • Cards      │  │ • Feedback   │             │   │
│  │  │ • Search     │  │ • Lists      │  │ • Confirm    │             │   │
│  │  │ • Support    │  │ • Inputs     │  │              │             │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘             │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        Navigation Layer                              │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │   │
│  │  │  Tab Nav     │  │  Stack Nav   │  │  Deep Link   │             │   │
│  │  │              │  │              │  │              │             │   │
│  │  │ • Home       │  │ • Settings   │  │ • URL Routes │             │   │
│  │  │ • Profile    │  │ • Account    │  │ • Push Notif │             │   │
│  │  │ • Notifs     │  │ • Privacy    │  │ • Universal  │             │   │
│  │  │ • Search     │  │ • Downloads  │  │              │             │   │
│  │  │ • Settings   │  │ • Help       │  │              │             │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘             │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        State Management Layer                        │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │   │
│  │  │   Zustand    │  │ React Query  │  │  Context     │             │   │
│  │  │              │  │              │  │              │             │   │
│  │  │ • Theme      │  │ • API Cache  │  │ • Theme      │             │   │
│  │  │ • User Prefs │  │ • Server     │  │ • Navigation │             │   │
│  │  │ • UI State   │  │   State      │  │              │             │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘             │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        Core Services Layer                           │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │   │
│  │  │    API       │  │   Storage    │  │   Analytics  │             │   │
│  │  │  Client      │  │              │  │              │             │   │
│  │  │              │  │ • AsyncStore │  │ • Events     │             │   │
│  │  │ • REST       │  │ • Secure     │  │ • Metrics    │             │   │
│  │  │ • GraphQL    │  │ • Files      │  │ • Crashes    │             │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘             │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Layer Responsibilities

#### Presentation Layer
- **Screens**: Full-screen components corresponding to navigation routes
- **Components**: Reusable UI building blocks (buttons, cards, lists)
- **Modals**: Overlay content for authentication, confirmations, feedback

#### Navigation Layer
- **Tab Navigator**: Primary app navigation with 5 bottom tabs
- **Stack Navigator**: Drill-down navigation within each tab
- **Deep Linking**: URL-based navigation and push notification handling

#### State Management Layer
- **Zustand**: Client state (theme, preferences, UI state) — planned
- **React Query**: Server state (API data, caching, synchronization) — planned
- **Context**: Theme and navigation context providers (current)

#### Core Services Layer
- **API Client**: Network request abstraction with authentication
- **Storage**: Local data persistence (AsyncStorage, SecureStore)
- **Analytics**: Event tracking and error reporting

### 2.3 Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Data Flow Patterns                                │
│                                                                             │
│  1. User Action                                                             │
│     │                                                                       │
│     ▼                                                                       │
│  2. Component Handler                                                        │
│     │                                                                       │
│     ├── UI State ──→ Zustand ──→ Component Re-render                     │
│     │                                                                       │
│     └── API Call ──→ React Query ──→ Cache ──→ Component Update          │
│                             │                                               │
│                             ▼                                               │
│                       3. API Client                                         │
│                             │                                               │
│                             ▼                                               │
│                       4. Network Request                                    │
│                             │                                               │
│                             ▼                                               │
│                       5. Server Response                                   │
│                             │                                               │
│                             ▼                                               │
│                       6. Cache Update (React Query)                         │
│                             │                                               │
│                             ▼                                               │
│                       7. Component Re-render (auto via hook)                 │
│                             │                                               │
│                             ▼                                               │
│                       8. UI Update                                         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.4 Project Structure

```
AppGen/
├── App.js                          # Application entry point (218 lines)
├── app.json                        # Expo configuration
├── babel.config.js                 # Babel configuration
├── metro.config.js                 # Metro bundler configuration
├── package.json                    # Dependencies and scripts
├── package-lock.json               # Dependency lock file
├── .eslintrc.json                  # ESLint configuration
├── .prettierrc                     # Prettier configuration
├── .prettierignore                 # Prettier ignore patterns
│
├── Components/                     # Feature components (modular)
│   ├── Page.js                     # Layout wrapper component
│   ├── Settings.js                 # Settings screen with menu
│   ├── Search.js                   # Global search functionality
│   ├── Support.js                  # Help/support content
│   ├── Link.js                     # Linked devices screen
│   ├── Star.js                     # Starred contacts screen
│   ├── Account.js                  # Account management screen
│   ├── Privacy.js                  # Privacy settings screen
│   ├── Notifications.js            # Notification center
│   ├── Downloads.js                # Downloads management
│   ├── TellAFriend.js              # Share/referral screen
│   └── Loadingscreen.js            # Loading/splash screen
│
├── assets/                         # Static resources
│   ├── icon.png                    # App icon
│   ├── splash.png                  # Splash screen image
│   ├── adaptive-icon.png           # Android adaptive icon
│   └── favicon.png                 # Web favicon
│
├── docs/                           # Documentation
│   ├── SOTA-RESEARCH.md            # State of the art research
│   ├── research/                   # Research documents
│   │   └── MOBILE_APP_GENERATORS_SOTA.md
│   └── adr/                        # Architecture Decision Records
│       ├── ADR-001-expo-framework.md
│       ├── ADR-002-state-management.md
│       └── ADR-003-native-modules.md
│
├── ios/                            # iOS native project (generated)
├── dark.json                       # Dark theme token definitions
├── light.json                      # Light theme token definitions
├── input.css                       # Input styles (unused)
├── VERSION                         # Version file
├── README.md                       # Project readme
├── PLAN.md                         # Implementation plan
└── CLAUDE.md                       # AI agent context
```

### 2.5 Technology Stack

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           AppGen Technology Stack                            │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐   │
│  │                        Application Layer                               │   │
│  │     React Native 0.84 │ JavaScript │ Expo SDK 54                       │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│  ┌─────────────────────────────────▼───────────────────────────────────────┐   │
│  │                        UI Layer                                        │   │
│  │  React Native Paper v5 │ Reanimated v3 │ MaterialCommunityIcons        │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│  ┌─────────────────────────────────▼───────────────────────────────────────┐   │
│  │                     Navigation Layer                                   │   │
│  │  React Navigation v6 │ Native Stack │ Material Bottom Tabs              │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│  ┌─────────────────────────────────▼───────────────────────────────────────┐   │
│  │                     State Management (Planned)                         │   │
│  │         Zustand │ React Query │ AsyncStorage                            │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│  ┌─────────────────────────────────▼───────────────────────────────────────┐   │
│  │                       Runtime Layer                                    │   │
│  │                  Hermes Engine │ React 18 │ Metro Bundler                │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│  ┌─────────────────────────────────▼───────────────────────────────────────┐   │
│  │                      Platform Layer                                    │   │
│  │                         iOS │ Android │ Web                              │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Functionality Specification

### 3.1 Core Features

#### 3.1.1 Application Entry Point

The `App.js` file serves as the application entry point, responsible for:
- Initializing the navigation container
- Configuring the theme provider (React Native Paper)
- Setting up safe area providers
- Managing color scheme detection (light/dark)
- Rendering the tab navigator with all screens

**Current Implementation**:
```javascript
// App.js — Entry point structure
import 'react-native-gesture-handler';
import { useColorScheme } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createMaterialBottomTabNavigator } from 'react-native-paper/react-navigation';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { PaperProvider, MD3DarkTheme, MD3LightTheme } from 'react-native-paper';

export default function App() {
  const colorScheme = useColorScheme();
  const theme = colorScheme === 'light'
    ? { ...MD3DarkTheme, colors: dark.colors }
    : { ...MD3LightTheme, colors: light.colors };

  return (
    <SafeAreaProvider>
      <NavigationContainer>
        <PaperProvider theme={theme}>
          <TabNavigator theme={theme} />
        </PaperProvider>
      </NavigationContainer>
    </SafeAreaProvider>
  );
}
```

#### 3.1.2 Theme System

AppGen implements a JSON-based theme system with two theme definitions:

**Theme Files**:
- `light.json` — Light theme token definitions
- `dark.json` — Dark theme token definitions

**Theme Structure**:
```json
{
  "colors": {
    "primary": "rgb(0, 106, 101)",
    "onPrimary": "rgb(255, 255, 255)",
    "primaryContainer": "rgb(112, 247, 238)",
    "secondary": "rgb(0, 104, 119)",
    "tertiary": "rgb(0, 99, 155)",
    "error": "rgb(186, 26, 26)",
    "background": "rgb(250, 253, 251)",
    "surface": "rgb(250, 253, 251)",
    "onSurface": "rgb(25, 28, 28)",
    "outline": "rgb(111, 121, 120)"
  }
}
```

**Theme Switching Logic**:
- System color scheme detection via `useColorScheme()`
- Dynamic theme application through PaperProvider
- Theme tokens loaded from JSON files at runtime
- Material Design 3 token compliance

### 3.2 Screen Specifications

#### 3.2.1 Home Screen

**Purpose**: Primary landing screen for the application

**Components**:
- Home component (Home.js)
- Navigation via HomeStack

**Behavior**:
- Displays primary content
- Accessible via HomeTab in bottom navigation
- Supports search action in navigation bar

#### 3.2.2 Settings Screen

**Purpose**: Central settings hub with navigation to sub-screens

**Components**:
- Settings component (Settings.js)
- Business profile header with avatar
- Scrollable menu of settings options

**Menu Items**:
| Item | Icon | Navigation Target |
|------|------|------------------|
| Starred Contacts | star | Starred Contacts screen |
| Linked Devices | cellphone-link | Linked Devices screen |
| Account | account-circle | Account screen |
| Privacy | shield-lock | Privacy screen |
| Notifications | bell | Notifications screen |
| Downloads | download-circle | Downloads screen |
| Help | help-circle | Support screen |
| Tell A Friend | share-variant | Tell A Friend screen |

**Implementation Pattern**:
```javascript
// Settings screen renders menu buttons
const screens = [
  { name: 'Starred Contacts', icon: 'star' },
  { name: 'Linked Devices', icon: 'cellphone-link' },
  { name: 'Account', icon: 'account-circle' },
  // ... additional items
];

// Each item renders as a Paper Button with icon
screens.map((screen) => (
  <Button
    icon={screen.icon}
    mode="elevated"
    onPress={() => navigation.navigate(screen.name)}
  >
    {screen.name}
  </Button>
));
```

#### 3.2.3 Search Screen

**Purpose**: Global search across app features and settings

**Behavior**:
- Real-time search input with filtering
- Empty state when no query entered
- "No results" state for unmatched queries
- Navigation to selected result on press
- Accessible via SearchTab in bottom navigation

#### 3.2.4 Support Screen

**Purpose**: Help and support content display

**Behavior**:
- Displays help content
- Accessible via NotificationsTab (current) and Settings sub-navigation
- Contact information and support resources

#### 3.2.5 Additional Screens

| Screen | Purpose | Access Path |
|--------|---------|-------------|
| Starred Contacts | Manage starred/favorite contacts | Settings → Starred Contacts |
| Linked Devices | View and manage linked devices | Settings → Linked Devices |
| Account | Account management | Settings → Account |
| Privacy | Privacy settings | Settings → Privacy |
| Notifications | Notification preferences | Settings → Notifications |
| Downloads | Download management | Settings → Downloads |
| Tell A Friend | Share/referral functionality | Settings → Tell A Friend |

### 3.3 Navigation Specification

#### 3.3.1 Tab Structure

| Tab | Label | Icon (focused) | Icon (unfocused) | Component |
|-----|-------|---------------|-----------------|-----------|
| HomeTab | Home | home | home-outline | HomeStack |
| ProfileTab | Profile | account | account-outline | NotificationsStack |
| NotificationsTab | Notifications | bell | bell-outline | Support |
| SearchTab | Search | magnify | magnify | Search |
| SettingsTab | Settings | cog | cog-outline | SettingsStack |

#### 3.3.2 Stack Navigators

**HomeStack**:
- Initial route: Home
- Header: Custom NavBar component

**ProfileStack**:
- Initial route: Settings
- Screens: Settings, Link
- Header: Custom NavBar component

**NotificationsStack**:
- Initial route: Settings
- Header: Custom NavBar component

**SettingsStack**:
- Initial route: Settings
- Screens: Settings, Starred Contacts, Linked Devices, Account, Privacy, Notifications, Downloads, Help, Tell A Friend
- Header: Custom NavBar component

#### 3.3.3 Navigation Bar (NavBar)

**Purpose**: Custom app bar with conditional actions

**Behavior**:
- Shows back action on non-root screens
- Shows search action on Home, Settings, and Profile screens
- Displays current screen title via `getHeaderTitle()`

**Conditional Logic**:
```javascript
const showSearch = route.name === 'Home' ||
                   route.name === 'Settings' ||
                   route.name === 'Profile';
const showBackAction = route.name !== 'Home' &&
                       route.name !== 'Settings' &&
                       route.name !== 'Profile';
```

---

## 4. Technical Architecture

### 4.1 Component Architecture

#### 4.1.1 Component Classification

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    AppGen Component Architecture                            │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Layout Components                                                   │   │
│  │  • Page.js — Screen wrapper with consistent padding/safe areas       │   │
│  │  • SafeAreaProvider — Handles notches, home indicators               │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Navigation Components                                               │   │
│  │  • NavBar — Custom app bar with back/search actions                  │   │
│  │  • TabNavigator — Bottom tab navigation (5 tabs)                     │   │
│  │  • Stack Navigators — Per-tab drill-down navigation                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Feature Components (Screens)                                        │   │
│  │  • Home.js — Primary landing screen                                  │   │
│  │  • Settings.js — Settings hub with menu navigation                   │   │
│  │  • Search.js — Global search functionality                           │   │
│  │  • Support.js — Help and support content                             │   │
│  │  • Link.js — Linked devices management                               │   │
│  │  • Star.js — Starred contacts                                        │   │
│  │  • Account.js — Account management                                   │   │
│  │  • Privacy.js — Privacy settings                                     │   │
│  │  • Notifications.js — Notification center                            │   │
│  │  • Downloads.js — Downloads management                               │   │
│  │  • TellAFriend.js — Share/referral                                   │   │
│  │  • Loadingscreen.js — Loading/splash states                          │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  UI Components (React Native Paper)                                  │   │
│  │  • Button — Elevated, filled, outlined modes                         │   │
│  │  • Appbar — Header with actions                                      │   │
│  │  • Avatar — Profile images                                           │   │
│  │  • Icon — Material Community Icons                                   │   │
│  │  • Text — Typography with theme tokens                               │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 4.1.2 Component Communication Patterns

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Component Communication Patterns                         │
│                                                                             │
│  1. Props Down                                                              │
│     Parent ──props──> Child                                                 │
│     For configuration and data passing                                       │
│     Example: theme passed to TabNavigator                                   │
│                                                                             │
│  2. Events Up                                                               │
│     Child ──callback──> Parent                                              │
│     For user interactions                                                    │
│     Example: button onPress triggers navigation                             │
│                                                                             │
│  3. Navigation                                                              │
│     Screen A ──navigate(params)──> Screen B                                 │
│     For screen-to-screen transitions                                         │
│     Example: Settings → Account                                             │
│                                                                             │
│  4. Theme Context                                                           │
│     PaperProvider ──useTheme()──> Component                                 │
│     For theme token access                                                   │
│     Example: component accesses theme.colors.primary                        │
│                                                                             │
│  5. Color Scheme                                                            │
│     useColorScheme() ──system change──> App re-render                       │
│     For automatic light/dark adaptation                                      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Build Configuration

#### 4.2.1 Expo Configuration (app.json)

```json
{
  "expo": {
    "name": "AppGeneric",
    "slug": "AppGeneric",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "userInterfaceStyle": "light",
    "splash": {
      "image": "./assets/splash.png",
      "resizeMode": "contain",
      "backgroundColor": "#ffffff"
    },
    "packagerOpts": {
      "config": "metro.config.js",
      "sourceExts": ["js", "jsx", "ts", "tsx", "svg"]
    },
    "assetBundlePatterns": ["**/*"],
    "ios": {
      "supportsTablet": true,
      "bundleIdentifier": "com.Generic.App"
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./assets/adaptive-icon.png",
        "backgroundColor": "#ffffff"
      },
      "package": "com.Generic.App"
    },
    "web": {
      "favicon": "./assets/favicon.png"
    }
  }
}
```

#### 4.2.2 Metro Configuration (metro.config.js)

```javascript
const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

const { transformer, resolver } = config;

config.transformer = {
  ...transformer,
  babelTransformerPath: require.resolve('react-native-svg-transformer'),
};

config.resolver = {
  ...resolver,
  assetExts: resolver.assetExts.filter((ext) => ext !== 'svg'),
  sourceExts: [...resolver.sourceExts, 'svg'],
};

module.exports = config;
```

#### 4.2.3 Babel Configuration (babel.config.js)

```javascript
module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
  };
};
```

### 4.3 Dependency Specification

#### 4.3.1 Production Dependencies

| Package | Version | Purpose | Category |
|---------|---------|---------|----------|
| expo | ~54.0.13 | Expo SDK runtime | Framework |
| react | 18.2.0 | React library | Framework |
| react-native | 0.84.1 | React Native runtime | Framework |
| hermes-engine | ^0.11.0 | JavaScript engine | Runtime |
| @react-navigation/native | ^6.1.9 | Navigation core | Navigation |
| @react-navigation/native-stack | ^6.9.17 | Native stack navigator | Navigation |
| @react-navigation/stack | ^6.3.20 | Stack navigator | Navigation |
| react-native-paper | ^5.11.3 | Material Design 3 UI | UI |
| react-native-reanimated | ~3.3.0 | Animation library | Animation |
| react-native-gesture-handler | ~2.12.0 | Gesture handling | Input |
| react-native-screens | ~3.22.0 | Native screen components | Navigation |
| react-native-safe-area-context | 4.6.3 | Safe area handling | Layout |
| react-native-vector-icons | ^10.0.2 | Icon library | UI |
| react-native-svg | 13.9.0 | SVG rendering | Graphics |
| expo-linear-gradient | ~12.3.0 | Gradient backgrounds | UI |
| expo-splash-screen | ~0.20.5 | Splash screen management | UX |
| expo-status-bar | ~1.6.0 | Status bar customization | UX |
| @pchmn/expo-material3-theme | ^1.3.1 | Material You theming | Theming |
| react-native-linear-gradient | ^2.8.3 | Native gradient | UI |
| react-native-splash-screen | ^3.3.0 | Splash screen | UX |
| reanimated-bottom-sheet | ^1.0.0-alpha.22 | Bottom sheet | UI |
| @react-native-community/masked-view | ^0.1.11 | Masked view | UI |
| @react-native-masked-view/masked-view | 0.2.9 | Masked view | UI |
| react-navigation | ^5.0.0 | Navigation (legacy) | Navigation |
| babel-eslint | ^10.1.0 | Babel ESLint parser | Dev |

#### 4.3.2 Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| @babel/core | ^7.23.5 | Babel compiler |
| @babel/eslint-parser | ^7.23.3 | ESLint Babel parser |
| @react-native-community/eslint-config | ^3.2.0 | RN ESLint config |
| eslint | ^9.26.0 | Code linting |
| eslint-plugin-react | ^7.33.2 | React ESLint rules |
| prettier | ^3.1.0 | Code formatting |
| concurrently | ^8.2.2 | Concurrent script runner |
| postcss | ^8.4.32 | CSS processing |
| react-native-svg-transformer | ^1.1.0 | SVG transformer |

### 4.4 Script Commands

| Command | Description |
|---------|-------------|
| `npm start` | Start Expo development server |
| `npm run android` | Run on Android device/emulator |
| `npm run ios` | Run on iOS simulator/device |
| `npm run web` | Run in web browser |
| `npm run lint` | Run ESLint on JS/JSX files |
| `npm run format` | Format code with Prettier |

---

## 5. API Reference

### 5.1 Navigation API

#### 5.1.1 Navigation Container

```javascript
// Root navigation container
<NavigationContainer>
  <PaperProvider theme={theme}>
    <TabNavigator theme={theme} />
  </PaperProvider>
</NavigationContainer>
```

**Properties**:
- `independent` (boolean): When true, creates isolated navigation state
- `linking` (object): Deep linking configuration
- `onStateChange` (function): Navigation state change callback
- `initialState` (object): Initial navigation state

#### 5.1.2 Tab Navigator

```javascript
const Tab = createMaterialBottomTabNavigator();

<Tab.Navigator theme={theme}>
  <Tab.Screen
    name="HomeTab"
    component={HomeStack}
    options={{
      tabBarLabel: 'Home',
      tabBarIcon: ({ focused }) => (
        <MaterialCommunityIcons
          size={24}
          color={theme.colors.tertiary}
          name={focused ? 'home' : 'home-outline'}
        />
      ),
    }}
  />
</Tab.Navigator>
```

**Tab Screen Options**:
| Option | Type | Description |
|--------|------|-------------|
| tabBarLabel | string | Tab label text |
| tabBarIcon | function | Icon renderer (receives focused state) |
| tabBarVisible | boolean | Tab visibility |
| tabBarColor | string | Tab background color |
| tabBarBadge | string/number | Badge display |

#### 5.1.3 Stack Navigator

```javascript
const Stack = createNativeStackNavigator();

<Stack.Navigator
  screenOptions={{
    header: (props) => <NavBar {...props} />,
  }}
>
  <Stack.Screen name="Home" component={Home} />
  <Stack.Screen name="Settings" component={Settings} />
</Stack.Navigator>
```

**Stack Screen Options**:
| Option | Type | Description |
|--------|------|-------------|
| header | function | Custom header renderer |
| title | string | Screen title |
| headerShown | boolean | Header visibility |
| animation | string | Transition animation type |
| presentation | string | Screen presentation style |

### 5.2 Theme API

#### 5.2.1 Theme Provider

```javascript
<PaperProvider theme={theme}>
  {/* App content */}
</PaperProvider>
```

#### 5.2.2 Theme Consumption

```javascript
import { useTheme } from 'react-native-paper';

const Component = () => {
  const theme = useTheme();
  const color = theme.colors.primary;
  return <Text style={{ color }}>{/* ... */}</Text>;
};
```

#### 5.2.3 Theme Token Reference

| Token | Type | Description |
|-------|------|-------------|
| colors.primary | string | Primary brand color |
| colors.onPrimary | string | Text on primary background |
| colors.primaryContainer | string | Primary container surface |
| colors.secondary | string | Secondary brand color |
| colors.tertiary | string | Tertiary/accent color |
| colors.error | string | Error state color |
| colors.background | string | App background color |
| colors.surface | string | Surface/elevated background |
| colors.onSurface | string | Text on surface |
| colors.outline | string | Border/divider color |
| roundness | number | Border radius (default: 12) |

### 5.3 Component API

#### 5.3.1 Page Component

```javascript
// Page.js interface
function Page({
  TITLE,           // Optional page title (string)
  bodyContent,     // Main content (ReactNode)
  navigation,      // Navigation object
  useNav,          // Show navigation bar (boolean)
  useSearch,       // Show search action (boolean)
})
```

#### 5.3.2 NavBar Component

```javascript
// NavBar interface
function NavBar({
  navigation,      // Navigation object
  route,           // Current route info
  options,         // Screen options
  back,            // Show back action (boolean)
})
```

### 5.4 Storage API (Planned)

#### 5.4.1 AsyncStorage Interface

```javascript
import AsyncStorage from '@react-native-async-storage/async-storage';

// Store data
await AsyncStorage.setItem('@key', JSON.stringify(value));

// Retrieve data
const value = await AsyncStorage.getItem('@key');

// Remove data
await AsyncStorage.removeItem('@key');

// Clear all
await AsyncStorage.clear();
```

#### 5.4.2 SecureStore Interface

```javascript
import * as SecureStore from 'expo-secure-store';

// Store sensitive data
await SecureStore.setItemAsync('auth_token', token);

// Retrieve sensitive data
const token = await SecureStore.getItemAsync('auth_token');

// Delete sensitive data
await SecureStore.deleteItemAsync('auth_token');
```

---

## 6. Error Handling

### 6.1 Error Categories

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Error Handling Categories                                │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Navigation Errors                                                   │   │
│  │  • Invalid route navigation                                          │   │
│  │  • Missing navigation prop                                           │   │
│  │  • Deep link parsing failures                                        │   │
│  │  Handling: Catch in navigation handlers, show fallback screen         │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Theme Errors                                                        │   │
│  │  • Missing theme file                                                │   │
│  │  • Invalid theme token                                               │   │
│  │  • Color scheme detection failure                                    │   │
│  │  Handling: Fallback to default theme, log warning                    │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Network Errors (Planned)                                            │   │
│  │  • Connection timeout                                                │   │
│  │  • Server errors (4xx, 5xx)                                          │   │
│  │  • Offline state                                                     │   │
│  │  Handling: Retry with exponential backoff, show offline UI           │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Storage Errors                                                      │   │
│  │  • AsyncStorage quota exceeded                                       │   │
│  │  • SecureStore access denied                                         │   │
│  │  • Data corruption                                                   │   │
│  │  Handling: Clear corrupted data, show error message                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Runtime Errors                                                      │   │
│  │  • JavaScript exceptions                                             │   │
│  │  • Native module failures                                            │   │
│  │  • Memory pressure                                                   │   │
│  │  Handling: Error boundary, crash reporting                           │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 6.2 Error Handling Strategy

#### 6.2.1 Error Boundary (Planned)

```javascript
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    // Log to analytics/crash reporting
    console.error('Uncaught error:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <View style={styles.errorContainer}>
          <Text>Something went wrong.</Text>
          <Button
            title="Try Again"
            onPress={() => this.setState({ hasError: false })}
          />
        </View>
      );
    }
    return this.props.children;
  }
}
```

#### 6.2.2 Network Error Handling (Planned)

```javascript
const fetchWithRetry = async (url, options, maxRetries = 3) => {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const response = await fetch(url, options);
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      return await response.json();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      await new Promise((resolve) =>
        setTimeout(resolve, 1000 * 2 ** i)
      );
    }
  }
};
```

#### 6.2.3 Theme Fallback

```javascript
const getSafeTheme = (colorScheme) => {
  try {
    const themeFile = colorScheme === 'dark' ? dark : light;
    return {
      ...(colorScheme === 'dark' ? MD3DarkTheme : MD3LightTheme),
      colors: themeFile.colors,
    };
  } catch (error) {
    console.warn('Theme loading failed, using default:', error);
    return MD3LightTheme;
  }
};
```

### 6.3 Error Codes

| Code | Category | Description | Action |
|------|----------|-------------|--------|
| NAV-001 | Navigation | Invalid route name | Verify route exists in navigator |
| NAV-002 | Navigation | Missing navigation prop | Wrap in NavigationContainer |
| THM-001 | Theme | Theme file not found | Check file path and permissions |
| THM-002 | Theme | Invalid color token | Validate theme JSON structure |
| NET-001 | Network | Connection timeout | Retry with backoff |
| NET-002 | Network | Server error (5xx) | Show maintenance message |
| NET-003 | Network | Client error (4xx) | Show validation error |
| NET-004 | Network | Offline | Show offline UI |
| STR-001 | Storage | Quota exceeded | Clear cache, notify user |
| STR-002 | Storage | Access denied | Request permissions |
| STR-003 | Storage | Data corruption | Clear corrupted data |
| RT-001 | Runtime | JavaScript exception | Error boundary recovery |
| RT-002 | Runtime | Native module failure | Fallback to alternative |
| RT-003 | Runtime | Memory pressure | Release cached resources |

---

## 7. Security

### 7.1 Security Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          AppGen Security Architecture                        │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐   │
│  │                        Transport Layer                                │   │
│  │  • HTTPS for all API communication                                   │   │
│  │  • Certificate pinning for production (planned)                      │   │
│  │  • TLS 1.3 minimum                                                   │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐   │
│  │                        Storage Layer                                  │   │
│  │  • SecureStore for sensitive data (tokens, credentials)               │   │
│  │  • AsyncStorage for non-sensitive data (preferences, cache)           │   │
│  │  • Keychain/Keystore integration                                     │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐   │
│  │                        Authentication Layer                           │   │
│  │  • JWT with refresh token rotation (planned)                         │   │
│  │  • Biometric authentication via expo-local-authentication (planned)   │   │
│  │  • Session timeout handling                                          │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐   │
│  │                        Application Layer                              │   │
│  │  • Input validation and sanitization                                  │   │
│  │  • Deep link validation                                               │   │
│  │  • Screenshot prevention for sensitive screens (planned)              │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 7.2 Data Classification

| Data Type | Sensitivity | Storage | Encryption |
|-----------|------------|---------|------------|
| Auth tokens | High | SecureStore | Keychain/Keystore |
| User credentials | High | SecureStore | Keychain/Keystore |
| User preferences | Low | AsyncStorage | None |
| Theme settings | Low | AsyncStorage | None |
| Cache data | Low | AsyncStorage | None |
| API responses | Medium | React Query cache | In-memory |

### 7.3 Security Best Practices

1. **Never store sensitive data in AsyncStorage** — Use SecureStore for tokens, credentials, and PII
2. **Validate all deep links** — Verify URL prefixes and parameters before navigation
3. **Implement certificate pinning** — For production API communication
4. **Use HTTPS exclusively** — No plaintext HTTP connections
5. **Sanitize user input** — Validate and sanitize all user-provided data
6. **Implement session timeout** — Automatically log out inactive users
7. **Enable biometric authentication** — For sensitive operations (planned)
8. **Prevent screenshots** — On sensitive screens (planned)

### 7.4 Secure Storage Implementation (Planned)

```javascript
import * as SecureStore from 'expo-secure-store';

export const SecureStorage = {
  async setItem(key, value) {
    await SecureStore.setItemAsync(key, value, {
      keychainService: 'com.appgen.service',
      keychainAccessible: SecureStore.WHEN_UNLOCKED,
    });
  },

  async getItem(key) {
    return await SecureStore.getItemAsync(key);
  },

  async deleteItem(key) {
    await SecureStore.deleteItemAsync(key);
  },
};
```

---

## 8. Performance Specifications

### 8.1 Performance Budget

| Metric | Target | Good | Poor | Measurement |
|--------|--------|------|------|-------------|
| Time to Interactive (TTI) | <2s | <3s | >4s | Manual timing |
| First Contentful Paint | <1s | <1.5s | >2s | Flipper |
| Bundle Size (Android) | <15MB | <20MB | >25MB | APK analysis |
| Bundle Size (iOS) | <20MB | <25MB | >30MB | IPA analysis |
| Memory Usage | <100MB | <150MB | >200MB | Xcode/Android Profiler |
| Frame Rate | 60fps | 55-60fps | <50fps | Reanimated Profiler |
| Cold Start | <1.5s | <2.5s | >3.5s | Manual timing |
| Warm Start | <0.5s | <1s | >1.5s | Manual timing |

### 8.2 Optimization Strategies

#### 8.2.1 Hermes Engine

- Enabled by default in Expo SDK 54
- Bytecode precompilation for faster startup
- ~30% faster startup vs JavaScriptCore
- ~35% smaller bundle size

#### 8.2.2 Metro Bundler Optimization

```javascript
config.transformer.minifierConfig = {
  compress: {
    dead_code: true,
    drop_debugger: true,
    drop_console: __DEV__ ? false : ['log', 'info'],
    passes: 3,
  },
};
```

#### 8.2.3 Component Optimization

- Use `React.memo` for pure components
- Implement `useMemo` for expensive computations
- Use `useCallback` for stable function references
- Avoid inline object/array creation in render

#### 8.2.4 List Optimization

- Use `getItemLayout` for fixed-height items
- Set `initialNumToRender` appropriately
- Enable `removeClippedSubviews` for Android
- Consider FlashList for long lists

### 8.3 Performance Monitoring (Planned)

```javascript
const measureStartup = () => {
  const startTime = performance.now();
  return {
    markInteractive: () => {
      const tti = performance.now() - startTime;
      console.log(`TTI: ${tti}ms`);
    },
  };
};
```

---

## 9. Testing Strategy

### 9.1 Testing Pyramid

```
                    ┌─────────────┐
                    │    E2E      │  10% — Critical user flows
                    │   (Detox)   │
                    └──────┬──────┘
                    ┌──────▼──────┐
                    │ Integration │  20% — Component interactions
                    │   (RNTL)    │
                    └──────┬──────┘
               ┌───────────▼───────────┐
               │      Unit Tests        │  70% — Business logic
               │        (Jest)         │
               └───────────────────────┘
```

### 9.2 Test Configuration (Planned)

```javascript
// jest.config.js
module.exports = {
  preset: 'jest-expo',
  setupFilesAfterEnv: ['@testing-library/jest-native/extend-expect'],
  transformIgnorePatterns: [
    'node_modules/(?!((react-native.*|@react-native.*|expo.*)/))',
  ],
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70,
    },
  },
};
```

### 9.3 Test Categories

| Category | Tool | Coverage | Priority |
|----------|------|----------|----------|
| Unit tests | Jest | Utilities, hooks, stores | High |
| Component tests | React Native Testing Library | UI components | High |
| Integration tests | RNTL + Jest | Screen flows | Medium |
| E2E tests | Detox | Critical user paths | Medium |
| Performance tests | Flipper | Startup, memory, FPS | Low |
| Accessibility tests | axe-core | WCAG compliance | Medium |

---

## 10. Build and Deployment

### 10.1 Build Configuration

#### 10.1.1 Development Build

```bash
# Start development server
npx expo start

# Run on specific platform
npx expo run:android
npx expo run:ios
```

#### 10.1.2 Production Build (Planned)

```bash
# EAS Build configuration
eas build --platform android --profile production
eas build --platform ios --profile production

# Submit to stores
eas submit --platform android
eas submit --platform ios
```

### 10.2 CI/CD Pipeline (Planned)

```yaml
# .github/workflows/build.yml
name: Build and Deploy
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm test

  build:
    needs: quality
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: expo/expo-github-action@v8
        with:
          eas-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
      - run: eas build --platform all --profile production
```

### 10.3 OTA Updates (Planned)

```javascript
import * as Updates from 'expo-updates';

export const checkForUpdates = async () => {
  const update = await Updates.checkForUpdateAsync();
  if (update.isAvailable) {
    await Updates.fetchUpdateAsync();
    return true;
  }
  return false;
};

export const applyUpdate = async () => {
  await Updates.reloadAsync();
};
```

---

## 11. Development Workflow

### 11.1 Getting Started

```bash
# Clone repository
git clone <repository-url>
cd AppGen

# Install dependencies
npm install

# Start development server
npm start

# Run on platform
npm run android
npm run ios
npm run web
```

### 11.2 Code Quality

```bash
# Lint code
npm run lint

# Format code
npm run format
```

### 11.3 Git Workflow

```
Branch Strategy
├── main              # Production branch
├── develop           # Integration branch
├── feature/*         # Feature branches
├── bugfix/*          # Bug fix branches
└── hotfix/*          # Emergency fixes
```

#### Commit Message Convention

```
Format: <type>(<scope>): <subject>

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- style: Formatting
- refactor: Code restructuring
- perf: Performance
- test: Tests
- chore: Build/tooling

Examples:
feat(navigation): add deep linking support
fix(settings): resolve button ripple clipping
docs(api): update authentication endpoints
```

### 11.4 Adding New Features

1. **New Screen**: Add component to `Components/`, register in App.js navigation
2. **New Theme Token**: Update `dark.json` and `light.json`
3. **New Dependency**: Prefer Expo-compatible packages, verify new architecture support
4. **New Config**: Update `app.json` and relevant config files

---

## 12. Configuration Reference

### 12.1 app.json Reference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| expo.name | string | Yes | App display name |
| expo.slug | string | Yes | URL-friendly identifier |
| expo.version | string | Yes | Semantic version |
| expo.orientation | string | Yes | Screen orientation (portrait/landscape/default) |
| expo.icon | string | Yes | Path to app icon |
| expo.userInterfaceStyle | string | Yes | UI style (light/dark/automatic) |
| expo.splash.image | string | Yes | Path to splash image |
| expo.splash.resizeMode | string | Yes | Splash resize mode (contain/cover/native) |
| expo.splash.backgroundColor | string | Yes | Splash background color |
| expo.ios.supportsTablet | boolean | Yes | iPad support |
| expo.ios.bundleIdentifier | string | Yes | iOS bundle ID |
| expo.android.package | string | Yes | Android package name |
| expo.android.adaptiveIcon.foregroundImage | string | Yes | Android adaptive icon |
| expo.android.adaptiveIcon.backgroundColor | string | Yes | Adaptive icon background |
| expo.web.favicon | string | Yes | Web favicon path |

### 12.2 Theme File Reference

| Token | Type | Description | Example |
|-------|------|-------------|---------|
| colors.primary | string | Primary brand color | "rgb(0, 106, 101)" |
| colors.onPrimary | string | Text on primary | "rgb(255, 255, 255)" |
| colors.primaryContainer | string | Primary surface | "rgb(112, 247, 238)" |
| colors.secondary | string | Secondary color | "rgb(0, 104, 119)" |
| colors.tertiary | string | Accent color | "rgb(0, 99, 155)" |
| colors.error | string | Error color | "rgb(186, 26, 26)" |
| colors.background | string | Background | "rgb(250, 253, 251)" |
| colors.surface | string | Surface | "rgb(250, 253, 251)" |
| colors.onSurface | string | Surface text | "rgb(25, 28, 28)" |
| colors.outline | string | Borders | "rgb(111, 121, 120)" |

---

## 13. Component Catalog

### 13.1 Current Components

| Component | File | Type | Lines | Dependencies |
|-----------|------|------|-------|-------------|
| App | App.js | Container | 218 | react-native, react-navigation, react-native-paper |
| Page | Components/Page.js | Layout | ~80 | react-native, react-native-paper |
| Settings | Components/Settings.js | Screen | ~120 | react-native, react-native-paper |
| Search | Components/Search.js | Screen | ~100 | react-native, react-native-paper |
| Support | Components/Support.js | Screen | ~60 | react-native, react-native-paper |
| Link | Components/Link.js | Screen | ~60 | react-native, react-native-paper |
| Star | Components/Star.js | Screen | ~60 | react-native, react-native-paper |
| Account | Components/Account.js | Screen | ~60 | react-native, react-native-paper |
| Privacy | Components/Privacy.js | Screen | ~60 | react-native, react-native-paper |
| Notifications | Components/Notifications.js | Screen | ~60 | react-native, react-native-paper |
| Downloads | Components/Downloads.js | Screen | ~60 | react-native, react-native-paper |
| TellAFriend | Components/TellAFriend.js | Screen | ~60 | react-native, react-native-paper |
| Loadingscreen | Components/Loadingscreen.js | Presentational | ~40 | react-native, react-native-paper |

### 13.2 Component Guidelines

#### 13.2.1 Naming Convention

- **Files**: PascalCase (e.g., `Settings.js`, `Loadingscreen.js`)
- **Components**: PascalCase function names
- **Variables**: camelCase
- **Constants**: UPPER_SNAKE_CASE

#### 13.2.2 Structure

```javascript
import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Text, Button } from 'react-native-paper';

const ComponentName = ({ navigation, route }) => {
  // Hooks
  const theme = useTheme();

  // State
  const [localState, setLocalState] = React.useState();

  // Effects
  React.useEffect(() => {
    // Side effects
  }, []);

  // Handlers
  const handleAction = () => {
    // Action logic
  };

  // Render
  return (
    <View style={styles.container}>
      {/* Content */}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
});

export default ComponentName;
```

---

## 14. Theme Specification

### 14.1 Material Design 3 Token System

AppGen implements the full Material Design 3 color token system with 28 color roles:

```
Color Token Groups
├── Primary Group
│   ├── primary
│   ├── onPrimary
│   ├── primaryContainer
│   └── onPrimaryContainer
├── Secondary Group
│   ├── secondary
│   ├── onSecondary
│   ├── secondaryContainer
│   └── onSecondaryContainer
├── Tertiary Group
│   ├── tertiary
│   ├── onTertiary
│   ├── tertiaryContainer
│   └── onTertiaryContainer
├── Error Group
│   ├── error
│   ├── onError
│   ├── errorContainer
│   └── onErrorContainer
├── Neutral Group
│   ├── background
│   ├── onBackground
│   ├── surface
│   ├── onSurface
│   ├── surfaceVariant
│   ├── onSurfaceVariant
│   ├── outline
│   └── outlineVariant
├── Utility Group
│   ├── shadow
│   ├── scrim
│   ├── inverseSurface
│   ├── inverseOnSurface
│   ├── inversePrimary
│   ├── surfaceDisabled
│   ├── onSurfaceDisabled
│   └── backdrop
└── Elevation Group
    ├── level0
    ├── level1
    ├── level2
    ├── level3
    ├── level4
    └── level5
```

### 14.2 Theme File Format

Both `light.json` and `dark.json` follow this structure:

```json
{
  "colors": {
    "primary": "rgb(R, G, B)",
    "onPrimary": "rgb(R, G, B)",
    "primaryContainer": "rgb(R, G, B)",
    "...": "... (all 28 color roles)"
  }
}
```

### 14.3 Theme Application

```javascript
// Theme loading
import dark from './dark.json';
import light from './light.json';

// Theme selection based on system color scheme
const theme = colorScheme === 'light'
  ? { ...MD3DarkTheme, colors: dark.colors }
  : { ...MD3LightTheme, colors: light.colors };

// Theme provider
<PaperProvider theme={theme}>
  {/* All children receive theme via useTheme() */}
</PaperProvider>
```

---

## 15. Navigation Specification

### 15.1 Navigation Hierarchy

```
NavigationContainer
└── Tab.Navigator (Material Bottom Tabs)
    ├── HomeTab
    │   └── Stack.Navigator
    │       └── Home
    ├── ProfileTab
    │   └── Stack.Navigator
    │       ├── Settings
    │       └── Link
    ├── NotificationsTab
    │   └── Stack.Navigator
    │       └── Settings
    ├── SearchTab
    │   └── Search
    └── SettingsTab
        └── Stack.Navigator
            ├── Settings
            ├── Starred Contacts
            ├── Linked Devices
            ├── Account
            ├── Privacy
            ├── Notifications
            ├── Downloads
            ├── Help
            └── Tell A Friend
```

### 15.2 Navigation Patterns

#### 15.2.1 Tab Navigation

- 5 tabs with Material Bottom Tab Navigator
- Each tab maintains independent navigation state
- Tab switching preserves stack state
- Icons change based on focused state

#### 15.2.2 Stack Navigation

- Each tab has its own stack navigator
- Screens pushed onto stack with slide animation
- Back navigation returns to previous screen in stack
- Custom header via NavBar component

#### 15.2.3 Deep Linking (Planned)

```javascript
const linking = {
  prefixes: ['appgen://', 'https://appgen.app'],
  config: {
    screens: {
      HomeTab: { path: 'home', screens: { Home: '' } },
      SettingsTab: {
        path: 'settings',
        screens: {
          Settings: '',
          Account: 'account',
          Privacy: 'privacy',
        },
      },
    },
  },
};
```

---

## 16. Data Models

### 16.1 Core Types

```javascript
// User
{
  id: string,
  email: string,
  name: string,
  avatar: string | null,
  createdAt: Date,
  updatedAt: Date
}

// Settings
{
  theme: 'light' | 'dark' | 'system',
  notifications: boolean,
  soundEnabled: boolean,
  hapticsEnabled: boolean,
  language: string
}

// Navigation
{
  name: string,
  icon: string,
  label: string,
  description: string | null,
  badge: number | null,
  action: function | null
}

// Search Result
{
  id: string,
  type: 'screen' | 'setting' | 'action',
  name: string,
  icon: string,
  description: string,
  route: string | null,
  params: object | null
}

// Theme
{
  colors: {
    primary: string,
    onPrimary: string,
    // ... 28 color roles
  },
  roundness: number,
  elevation: {
    level0: string,
    level1: string,
    // ... level5
  }
}
```

### 16.2 API Response Types (Planned)

```javascript
// API Response wrapper
{
  data: T,
  status: number,
  message: string | null
}

// API Error
{
  code: string,
  message: string,
  details: object | null
}

// Paginated Response
{
  data: T[],
  pagination: {
    page: number,
    perPage: number,
    total: number,
    totalPages: number
  }
}
```

---

## 17. Migration Guide

### 17.1 Planned Migrations

| Migration | From | To | Priority | Effort |
|-----------|------|----|----------|--------|
| TypeScript | JavaScript | TypeScript | High | Medium |
| Zustand State | Context API | Zustand | High | Low |
| React Query | Manual fetch | React Query | Medium | Medium |
| Expo Router | React Navigation | Expo Router | Low | High |
| Testing | None | Jest + RNTL | High | Medium |
| OTA Updates | None | expo-updates | Medium | Low |
| Analytics | None | Expo Analytics | Low | Low |
| CI/CD | None | GitHub Actions | Medium | Low |

### 17.2 TypeScript Migration Steps

1. Install TypeScript dependencies: `npm install -D typescript @types/react @types/react-native`
2. Create `tsconfig.json` with React Native preset
3. Rename `.js` files to `.tsx` incrementally
4. Add type annotations to components
5. Create type definitions in `types/` directory
6. Run type checking: `npx tsc --noEmit`
7. Fix type errors iteratively

### 17.3 Zustand Migration Steps

1. Install Zustand: `npm install zustand`
2. Create `store/appStore.js` with theme state
3. Replace Context-based theme with Zustand
4. Add persistence middleware
5. Migrate other state slices incrementally
6. Remove unused Context providers

---

## 18. Appendices

### 18.1 Glossary

| Term | Definition |
|------|-----------|
| **AppGen** | This project — a React Native boilerplate for utility-style mobile apps |
| **Expo** | Framework and platform for React Native development |
| **EAS** | Expo Application Services (Build, Submit, Update) |
| **M3** | Material Design 3, Google's latest design system |
| **Hermes** | JavaScript engine optimized for React Native |
| **JSI** | JavaScript Interface, enables synchronous native calls |
| **Fabric** | React Native's new rendering system |
| **OTA** | Over-The-Air updates without app store submission |
| **TTI** | Time to Interactive, metric for app startup performance |

### 18.2 Related Documents

| Document | Path | Purpose |
|----------|------|---------|
| SOTA Research | docs/SOTA-RESEARCH.md | Cross-platform development research |
| SOTA Research (Mobile) | docs/research/MOBILE_APP_GENERATORS_SOTA.md | Mobile app generator research |
| ADR-001 | docs/adr/ADR-001-expo-framework.md | Framework selection decision |
| ADR-002 | docs/adr/ADR-002-state-management.md | State management decision |
| ADR-003 | docs/adr/ADR-003-native-modules.md | Native module integration decision |
| PLAN | PLAN.md | Implementation plan |
| README | README.md | Project overview |

### 18.3 External References

- [React Native Documentation](https://reactnative.dev)
- [Expo Documentation](https://docs.expo.dev)
- [React Navigation](https://reactnavigation.org)
- [React Native Paper](https://callstack.github.io/react-native-paper)
- [Material Design 3](https://m3.material.io)
- [Hermes Engine](https://hermesengine.dev)
- [Zustand](https://docs.pmnd.rs/zustand)
- [TanStack Query](https://tanstack.com/query/latest)

### 18.4 Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-04-03 | Initial specification |

### 18.5 Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Author | Phenotype Architecture Team | 2026-04-03 | Approved |
| Reviewer | KooshaPari | 2026-04-04 | Approved |

---

### 18.6 Accessibility Specification

#### 18.6.1 WCAG 2.1 AA Compliance

AppGen components must meet WCAG 2.1 Level AA accessibility standards:

| Requirement | Implementation | Status |
|-------------|---------------|--------|
| Color contrast ratio | Minimum 4.5:1 for normal text, 3:1 for large text | ✓ |
| Screen reader support | accessibilityLabel on all interactive elements | Partial |
| Touch target size | Minimum 44x44dp for all tappable elements | ✓ |
| Focus indicators | Visible focus state for keyboard navigation | Partial |
| Dynamic type | Support for system font size scaling | ✓ |
| Reduced motion | Respect prefers-reduced-motion setting | Planned |

#### 18.6.2 Accessibility Props

```javascript
// Accessible button example
<Button
  icon="account"
  mode="elevated"
  accessibilityLabel="Open account settings"
  accessibilityHint="Navigates to the account management screen"
  accessibilityRole="button"
  onPress={() => navigation.navigate('Account')}
>
  Account
</Button>

// Accessible image
<Avatar.Image
  source={{ uri: avatarUrl }}
  accessibilityLabel="User profile photo"
  accessibilityRole="image"
/>
```

#### 18.6.3 Screen Reader Support

All navigation elements must include:
- `accessibilityLabel`: Descriptive text for the element
- `accessibilityRole`: Semantic role (button, link, header, etc.)
- `accessibilityHint`: Additional context for screen readers
- `accessibilityState`: Current state (selected, disabled, checked)

### 18.7 Internationalization (i18n) Specification

#### 18.7.1 Language Support

| Language | Code | Status | RTL Support |
|----------|------|--------|-------------|
| English | en | Default | No |
| Spanish | es | Planned | No |
| French | fr | Planned | No |
| German | de | Planned | No |
| Arabic | ar | Planned | Yes |
| Hebrew | he | Planned | Yes |
| Japanese | ja | Planned | No |
| Chinese (Simplified) | zh-CN | Planned | No |

#### 18.7.2 String Externalization

```javascript
// strings/en.js
export default {
  settings: {
    title: 'Settings',
    starredContacts: 'Starred Contacts',
    linkedDevices: 'Linked Devices',
    account: 'Account',
    privacy: 'Privacy',
    notifications: 'Notifications',
    downloads: 'Downloads',
    help: 'Help & Support',
    tellAFriend: 'Tell A Friend',
  },
  common: {
    search: 'Search',
    home: 'Home',
    profile: 'Profile',
    loading: 'Loading...',
    error: 'An error occurred',
    retry: 'Try Again',
    cancel: 'Cancel',
    confirm: 'Confirm',
  },
};
```

#### 18.7.3 RTL Layout Support

```javascript
import { I18nManager } from 'react-native';

// Enable RTL for Arabic/Hebrew
if (language === 'ar' || language === 'he') {
  I18nManager.forceRTL(true);
}

// Use flex-start/flex-end instead of left/right
const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'flex-start', // Adapts to RTL
    paddingStart: 16, // RTL-aware
    paddingEnd: 16,   // RTL-aware
  },
});
```

### 18.8 Offline Support Specification

#### 18.8.1 Offline Strategy

| Feature | Online | Offline | Sync Behavior |
|---------|--------|---------|---------------|
| Theme settings | Load from server | Load from cache | N/A |
| User preferences | Sync to server | Load from AsyncStorage | Sync on reconnect |
| Navigation | Full functionality | Full functionality | N/A |
| Search | Full index | Cached index | Update on reconnect |
| API data | Fresh data | Cached data | Refetch on reconnect |

#### 18.8.2 Network Detection

```javascript
import { useNetInfo } from '@react-native-community/netinfo';

const useOfflineAware = () => {
  const netInfo = useNetInfo();
  const isOnline = netInfo.isConnected && netInfo.isInternetReachable;

  return {
    isOnline,
    connectionType: netInfo.type, // wifi, cellular, none
    isExpensive: netInfo.isConnectionExpensive,
  };
};
```

### 18.9 Push Notification Specification (Planned)

#### 18.9.1 Notification Types

| Type | Trigger | Action | Priority |
|------|---------|--------|----------|
| System alerts | App updates, maintenance | Navigate to info screen | High |
| User messages | New messages, mentions | Navigate to conversation | High |
| Reminders | Scheduled events | Navigate to event details | Medium |
| Marketing | Promotions, features | Navigate to promotional screen | Low |

#### 18.9.2 Notification Permissions

```javascript
import * as Notifications from 'expo-notifications';

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});

// Request permissions
const { status } = await Notifications.requestPermissionsAsync();
if (status === 'granted') {
  // Configure push token
  const token = (await Notifications.getExpoPushTokenAsync()).data;
}
```

### 18.10 Analytics Specification (Planned)

#### 18.10.1 Tracked Events

| Event | Properties | Trigger |
|-------|-----------|---------|
| screen_view | screen_name, screen_class | Screen mount |
| button_tap | button_name, screen_name | Button press |
| search_query | query, result_count | Search submission |
| settings_change | setting_name, old_value, new_value | Setting update |
| app_start | cold_start, duration | App launch |
| error_occurred | error_code, error_message, screen | Error boundary catch |

#### 18.10.2 Privacy Compliance

- All analytics must be opt-in
- No PII collected in analytics events
- Users can disable analytics in settings
- Data retention policy: 90 days
- GDPR/CCPA compliance required

---

**Document Status**: Active  
**Next Review**: 2026-07-04  
**Owner**: Phenotype Architecture Team  
**Version**: 1.0.0

*This specification defines the complete architecture, functionality, and technical requirements for AppGen. All implementation work should reference this document. Changes to architecture require a new or updated ADR.*
