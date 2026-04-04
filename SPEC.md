# AppGen — SPEC.md

## Overview

AppGen is a React Native boilerplate optimized for utility-style mobile applications. It provides a modular, component-first architecture that enables rapid development of cross-platform mobile apps.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         AppGen                                   │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                     Application Layer                     │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐           │  │
│  │  │ Navigation │  │   Screens  │  │   Modals   │           │  │
│  │  │   (Stack)  │  │            │  │            │           │  │
│  │  └────────────┘  └────────────┘  └────────────┘           │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                   │
│  ┌───────────────────────────┴──────────────────────────────┐  │
│  │                    Component Layer                        │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │  │
│  │  │   UI     │ │  Form    │ │  Layout  │ │Feedback │      │  │
│  │  │Components│ │Components│ │Components│ │Components│      │  │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                   │
│  ┌───────────────────────────┴──────────────────────────────┐  │
│  │                     Core Layer                            │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────────────┐ │  │
│  │  │   Theme    │  │   State    │  │      Services      │ │  │
│  │  │  (M3/RN)   │  │  (Hooks)   │  │  (API/Storage/…)  │ │  │
│  │  └────────────┘  └────────────┘  └────────────────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Components

### UI Components

| Component | Purpose | Location |
|-----------|---------|----------|
| `Button` | Material Design 3 buttons | `Components/UI/Button/` |
| `Card` | Content containers | `Components/UI/Card/` |
| `Text` | Typography hierarchy | `Components/UI/Text/` |
| `Icon` | Vector icons | `Components/UI/Icon/` |

### Feature Components

| Component | Purpose | Dependencies |
|-----------|---------|--------------|
| `FormBuilder` | Dynamic forms | react-hook-form, zod |
| `DataTable` | Sortable/filterable tables | @tanstack/react-table |
| `ChartView` | Data visualization | recharts |
| `MapView` | Location display | react-native-maps |

### Navigation Structure

```
App.js (Entry)
├── Stack.Navigator
│   ├── HomeScreen
│   ├── DetailScreen
│   ├── SettingsScreen
│   └── ModalNavigator
│       ├── AuthModal
│       └── FeedbackModal
```

---

## Data Models

### Theme Configuration

```javascript
// dark.json / light.json
{
  "colors": {
    "primary": "#6750A4",
    "onPrimary": "#FFFFFF",
    "primaryContainer": "#EADDFF",
    "secondary": "#625B71",
    "surface": "#FFFBFE",
    "error": "#B3261E"
  },
  "typography": {
    "displayLarge": { "fontFamily": "Roboto", "fontSize": 57 },
    "headlineMedium": { "fontFamily": "Roboto", "fontSize": 28 },
    "bodyLarge": { "fontFamily": "Roboto", "fontSize": 16 }
  }
}
```

### Component Props Interface

```typescript
interface BaseComponentProps {
  variant?: 'filled' | 'outlined' | 'text';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
  loading?: boolean;
  onPress?: () => void;
  style?: ViewStyle;
  testID?: string;
}

interface FormFieldProps extends BaseComponentProps {
  name: string;
  label: string;
  validation?: ValidationRules;
  defaultValue?: any;
}
```

---

## Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Framework | React Native | 0.84.1 |
| Expo SDK | Expo | ~54.0.13 |
| Navigation | React Navigation | v6 |
| UI Kit | React Native Paper | v5 |
| State | Zustand / React Query | latest |
| Forms | React Hook Form | v7 |
| Theming | Material Design 3 | - |

---

## Performance

### Bundle Size Budgets

| Target | Size | Notes |
|--------|------|-------|
| Android APK | <30MB | Expo managed |
| iOS IPA | <40MB | Expo managed |
| JS Bundle | <3MB | Minified + gzipped |

### Runtime Targets

| Metric | Target |
|--------|--------|
| Time to Interactive | <3s |
| Frame rate | 60fps |
| Memory usage | <150MB |
| Launch time | <2s |

---

## Project Structure

```
AppGen/
├── App.js                    # Application entry
├── app.json                  # Expo configuration
├── babel.config.js           # Babel presets
├── Components/
│   ├── UI/                   # Reusable UI primitives
│   ├── Forms/                # Form-specific components
│   ├── Layout/               # Layout containers
│   └── Screens/              # Screen-level components
├── navigation/
│   └── RootNavigator.js      # Navigation configuration
├── hooks/                    # Custom React hooks
├── services/                 # API clients, storage
├── theme/
│   ├── dark.json             # Dark theme tokens
│   └── light.json            # Light theme tokens
├── utils/                    # Helper functions
└── assets/                   # Images, fonts
```

---

## Quick Start

```bash
# Clone and setup
git clone <repo> my-app
cd my-app
npm install

# Start development
npx expo start

# Run on platform
npx expo run:android
npx expo run:ios
```

---

## References

- [React Native](https://reactnative.dev)
- [Expo Documentation](https://docs.expo.dev)
- [Material Design 3](https://m3.material.io)
