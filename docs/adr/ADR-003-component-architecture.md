# ADR-003: UI Component Architecture

**Date**: 2026-04-04  
**Status**: Accepted  
**Deciders**: KooshaPari  

## Context

AppGen requires a comprehensive UI component architecture that:

1. **Implements Material Design 3** for modern, consistent visual language
2. **Supports dynamic theming** including dark mode and system adaptation
3. **Provides accessible components** meeting WCAG guidelines
4. **Enables rapid development** of utility-style interfaces
5. **Maintains performance** with minimal overhead
6. **Supports customization** for app-specific branding
7. **Works across platforms** with native look and feel

The component architecture must balance pre-built component reuse with customization flexibility.

## Decision Drivers

| Driver | Weight | Description |
|--------|--------|-------------|
| Design System | High | Material Design 3 compliance |
| Performance | High | Minimal render overhead |
| Accessibility | High | WCAG 2.1 AA compliance |
| Bundle Size | Medium | Reasonable package size |
| Customization | High | Theme and style overrides |
| Cross-Platform | High | iOS and Android parity |
| Documentation | Medium | Comprehensive docs |

## Options Considered

### Option A: React Native Paper v5 (Selected)

**Architecture Pattern**:
```
Material Design 3 Token System
├── Color Tokens (primary, secondary, tertiary, error, surface)
├── Typography Tokens (display, headline, title, body, label)
├── Shape Tokens (border radius, corner family)
├── Elevation Tokens (shadow levels 0-5)
└── Component Tokens (button, card, text field, etc.)

React Native Paper v5
├── Core Components
│   ├── Button (elevated, filled, tonal, outlined, text)
│   ├── Card (elevated, outlined, filled)
│   ├── TextInput (outlined, flat)
│   ├── Appbar (header, bottom)
│   ├── List (section, item, accordion)
│   ├── FAB (regular, small, large, extended)
│   └── Dialog, Menu, Snackbar, etc.
├── Theme Provider
│   ├── MD3LightTheme
│   ├── MD3DarkTheme
│   └── Custom theme extension
└── Theming Hooks
    ├── useTheme()
    ├── withTheme()
    └── ThemeConsumer
```

**Pros**:
- **Complete M3 Implementation**: Full Material Design 3 component library
- **Dynamic Theming**: Material You support on Android 12+
- **TypeScript**: Full type definitions
- **Accessibility**: Built-in accessibility props and behaviors
- **Performance**: Optimized for React Native with minimal re-renders
- **Customization**: Extensive theme override capabilities
- **Cross-Platform**: Consistent behavior on iOS and Android
- **Bundle Size**: ~150KB gzipped (acceptable for functionality)

**Cons**:
- Opinionated Material Design (not customizable to other design systems)
- Some components may need wrapping for app-specific behavior
- Limited animation customization compared to custom components

### Option B: NativeBase v3

**Pros**:
- Universal UI kit (not tied to specific design system)
- Good TypeScript support
- Theme customization

**Cons**:
- No Material Design 3 support
- Larger bundle size (~180KB)
- Less comprehensive component set
- Slower performance in benchmarks

**Verdict**: Rejected due to lack of M3 support.

### Option C: Tamagui

**Pros**:
- Cross-platform (web + native)
- Excellent performance
- Small bundle size (~80KB)
- Excellent TypeScript support

**Cons**:
- Partial Material Design 3 support
- Newer library with smaller community
- Different styling approach (requires learning)
- Not optimized for mobile-only apps

**Verdict**: Rejected. Overkill for mobile-only app; M3 support incomplete.

### Option D: Custom Component Library

**Pros**:
- Full control over design
- Minimal bundle (only what you need)
- No external dependencies

**Cons**:
- Significant development effort
- Maintenance burden for updates
- No accessibility testing at scale
- No Material Design 3 compliance out-of-box

**Verdict**: Rejected. Mature libraries exist; custom implementation not justified.

### Option E: React Native Elements

**Pros**:
- Popular library
- Easy to use

**Cons**:
- No Material Design 3 support (Material Design 2 only)
- Less active development
- Limited component set

**Verdict**: Rejected. MD2 is deprecated; need MD3 for modern apps.

## Decision

**Adopt React Native Paper v5 as the primary UI component library with custom component wrappers for app-specific patterns.**

### Rationale

1. **Material Design 3**: Paper v5 is the only React Native library with complete M3 implementation:
   - All M3 color tokens (primary, secondary, tertiary, error, surface variants)
   - Complete typography scale (display, headline, title, body, label)
   - Shape tokens and elevation levels
   - Component-specific tokens

2. **Dynamic Theming**: Built-in support for:
   - System theme adaptation (light/dark)
   - Material You dynamic color extraction (Android 12+)
   - Runtime theme switching
   - Custom theme overrides

3. **Accessibility**: Paper components provide:
   - Screen reader support
   - Keyboard navigation
   - Focus management
   - ARIA attributes (mapped to native accessibility props)

4. **Performance**: Paper v5 optimizations:
   - React.memo on all components
   - Minimal re-renders with proper shouldComponentUpdate
   - Efficient styling with StyleSheet

5. **Ecosystem**: Part of Callstack's React Native ecosystem:
   - Active development
   - Regular updates for new React Native versions
   - Good documentation and examples

6. **Cross-Platform**: Components adapt to platform conventions while maintaining M3 styling:
   - iOS and Android both supported
   - Platform-specific optimizations

## Implementation Details

### Theme Configuration

```typescript
// theme.ts
import { MD3LightTheme, MD3DarkTheme } from 'react-native-paper';

// Custom color palette
export const lightColors = {
  primary: 'rgb(0, 106, 101)',
  onPrimary: 'rgb(255, 255, 255)',
  primaryContainer: 'rgb(112, 247, 238)',
  onPrimaryContainer: 'rgb(0, 32, 30)',
  secondary: 'rgb(0, 104, 119)',
  onSecondary: 'rgb(255, 255, 255)',
  secondaryContainer: 'rgb(162, 238, 255)',
  onSecondaryContainer: 'rgb(0, 31, 37)',
  tertiary: 'rgb(0, 99, 155)',
  onTertiary: 'rgb(255, 255, 255)',
  tertiaryContainer: 'rgb(206, 229, 255)',
  onTertiaryContainer: 'rgb(0, 29, 51)',
  error: 'rgb(186, 26, 26)',
  onError: 'rgb(255, 255, 255)',
  errorContainer: 'rgb(255, 218, 214)',
  onErrorContainer: 'rgb(65, 0, 2)',
  background: 'rgb(250, 253, 251)',
  onBackground: 'rgb(25, 28, 28)',
  surface: 'rgb(250, 253, 251)',
  onSurface: 'rgb(25, 28, 28)',
  surfaceVariant: 'rgb(218, 229, 227)',
  onSurfaceVariant: 'rgb(63, 73, 72)',
  outline: 'rgb(111, 121, 120)',
  outlineVariant: 'rgb(190, 201, 199)',
  shadow: 'rgb(0, 0, 0)',
  scrim: 'rgb(0, 0, 0)',
  inverseSurface: 'rgb(45, 49, 49)',
  inverseOnSurface: 'rgb(239, 241, 240)',
  inversePrimary: 'rgb(79, 218, 210)',
  elevation: {
    level0: 'transparent',
    level1: 'rgb(238, 246, 244)',
    level2: 'rgb(230, 241, 239)',
    level3: 'rgb(223, 237, 235)',
    level4: 'rgb(220, 235, 233)',
    level5: 'rgb(215, 232, 230)',
  },
  surfaceDisabled: 'rgba(25, 28, 28, 0.12)',
  onSurfaceDisabled: 'rgba(25, 28, 28, 0.38)',
  backdrop: 'rgba(41, 50, 49, 0.4)',
};

export const darkColors = {
  primary: 'rgb(79, 218, 210)',
  onPrimary: 'rgb(0, 55, 52)',
  primaryContainer: 'rgb(0, 80, 76)',
  onPrimaryContainer: 'rgb(112, 247, 238)',
  secondary: 'rgb(82, 215, 239)',
  onSecondary: 'rgb(0, 54, 62)',
  secondaryContainer: 'rgb(0, 78, 90)',
  onSecondaryContainer: 'rgb(162, 238, 255)',
  tertiary: 'rgb(150, 203, 255)',
  onTertiary: 'rgb(0, 51, 83)',
  tertiaryContainer: 'rgb(0, 74, 118)',
  onTertiaryContainer: 'rgb(206, 229, 255)',
  error: 'rgb(255, 180, 171)',
  onError: 'rgb(105, 0, 5)',
  errorContainer: 'rgb(147, 0, 10)',
  onErrorContainer: 'rgb(255, 180, 171)',
  background: 'rgb(25, 28, 28)',
  onBackground: 'rgb(224, 227, 226)',
  surface: 'rgb(25, 28, 28)',
  onSurface: 'rgb(224, 227, 226)',
  surfaceVariant: 'rgb(63, 73, 72)',
  onSurfaceVariant: 'rgb(190, 201, 199)',
  outline: 'rgb(136, 147, 145)',
  outlineVariant: 'rgb(63, 73, 72)',
  shadow: 'rgb(0, 0, 0)',
  scrim: 'rgb(0, 0, 0)',
  inverseSurface: 'rgb(224, 227, 226)',
  inverseOnSurface: 'rgb(45, 49, 49)',
  inversePrimary: 'rgb(0, 106, 101)',
  elevation: {
    level0: 'transparent',
    level1: 'rgb(28, 38, 37)',
    level2: 'rgb(29, 43, 43)',
    level3: 'rgb(31, 49, 48)',
    level4: 'rgb(32, 51, 50)',
    level5: 'rgb(33, 55, 54)',
  },
  surfaceDisabled: 'rgba(224, 227, 226, 0.12)',
  onSurfaceDisabled: 'rgba(224, 227, 226, 0.38)',
  backdrop: 'rgba(41, 50, 49, 0.4)',
};

// Complete theme objects
export const lightTheme = {
  ...MD3LightTheme,
  colors: lightColors,
  roundness: 12,
};

export const darkTheme = {
  ...MD3DarkTheme,
  colors: darkColors,
  roundness: 12,
};
```

### Component Usage Pattern

```typescript
// Components/Settings.tsx
import { Button, Avatar, useTheme, Appbar } from 'react-native-paper';
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons';

const Settings = () => {
  const theme = useTheme();
  const navigation = useNavigation();

  const styles = StyleSheet.create({
    buttonClipWrapper: {
      width: '80%',
      borderRadius: 12,
      overflow: 'hidden',
      marginTop: '1.25%',
      marginBottom: '1.25%',
      elevation: 3,
      shadowColor: 'black',
      shadowOffset: { width: 0, height: 2 },
      shadowRadius: 3,
      shadowOpacity: 0.15,
    },
    buttonContainer: {
      width: '100%',
      borderRadius: 12,
    },
    buttonContentStyle: {
      height: 60,
      justifyContent: 'flex-start',
      paddingLeft: 8,
    },
    buttonLabelStyle: {
      fontSize: 16,
      fontWeight: '400',
      letterSpacing: 0.1,
    },
    infocontainer: {
      flexDirection: 'row',
      width: '100%',
      alignItems: 'center',
      justifyContent: 'center',
      paddingTop: '5%',
      paddingBottom: '5%',
      paddingHorizontal: 16,
    },
    bizname: {
      color: theme.colors.primary,
      fontSize: 18,
      fontWeight: 'bold',
      marginLeft: 12,
    },
    pfp: {
      elevation: 4,
      shadowColor: 'black',
      shadowOffset: { width: 0, height: 2 },
      shadowRadius: 4,
      shadowOpacity: 0.3,
    },
  });

  const screens = [
    { name: 'Starred Contacts', icon: 'star' },
    { name: 'Linked Devices', icon: 'cellphone-link' },
    { name: 'Account', icon: 'account-circle' },
    { name: 'Privacy', icon: 'shield-lock' },
    { name: 'Notifications', icon: 'bell' },
    { name: 'Downloads', icon: 'download-circle' },
    { name: 'Help', icon: 'help-circle' },
    { name: 'Tell A Friend', icon: 'share-variant' },
  ];

  return (
    <View>
      <View style={styles.infocontainer}>
        <Avatar.Icon style={styles.pfp} size={64} icon="account-circle" />
        <Text style={styles.bizname}>NAME OF BUSINESS</Text>
      </View>

      <View style={styles.buttonList}>
        {screens.map((screen, index) => (
          <View key={index} style={styles.buttonClipWrapper}>
            <Button
              icon={screen.icon}
              mode="elevated"
              style={styles.buttonContainer}
              contentStyle={styles.buttonContentStyle}
              labelStyle={styles.buttonLabelStyle}
              onPress={() => navigation.navigate(screen.name)}
            >
              {screen.name}
            </Button>
          </View>
        ))}
      </View>
    </View>
  );
};
```

### Dynamic Theme Support

```typescript
// App.tsx - Dynamic theme with system adaptation
import { useColorScheme } from 'react-native';
import { MD3DarkTheme, MD3LightTheme, Provider as PaperProvider } from 'react-native-paper';
import { useMaterial3Theme } from '@pchmn/expo-material3-theme';

const App = () => {
  const colorScheme = useColorScheme();
  const { theme: material3Theme } = useMaterial3Theme();
  
  // Priority: Material You (Android 12+) > System Theme > Manual Override
  const theme = material3Theme || (
    colorScheme === 'dark'
      ? { ...MD3DarkTheme, colors: darkColors }
      : { ...MD3LightTheme, colors: lightColors }
  );

  return (
    <PaperProvider theme={theme}>
      <NavigationContainer>
        <RootNavigator />
      </NavigationContainer>
    </PaperProvider>
  );
};
```

## Component Architecture

### Component Hierarchy

```
AppGen Component Architecture
├── Layout Components
│   ├── Page (screen wrapper with consistent padding/safe areas)
│   └── SafeAreaWrapper (handles notches, home indicators)
├── Navigation Components
│   ├── NavBar (custom app bar with back/search actions)
│   └── TabBar (bottom navigation)
├── Feature Components
│   ├── SettingsScreen (settings menu with buttons)
│   ├── SearchScreen (search with results)
│   ├── SupportScreen (help/support content)
│   └── ... other screens
└── UI Components (React Native Paper)
    ├── Buttons (elevated, filled, outlined)
    ├── Cards (for content containers)
    ├── Lists (for menu items)
    ├── TextInputs (for forms)
    └── Dialogs (for modals)
```

## Consequences

### Positive

1. **Design Consistency**: Complete Material Design 3 implementation ensures visual consistency
2. **Accessibility**: Built-in accessibility features meet WCAG guidelines
3. **Performance**: Optimized components minimize render overhead
4. **Theming**: Comprehensive theme system supports light/dark/dynamic modes
5. **Documentation**: Well-documented API with comprehensive examples
6. **Maintenance**: Active development ensures long-term support

### Negative

1. **Design Lock-in**: Tightly coupled to Material Design 3 (difficult to switch design systems)
2. **Bundle Size**: Adds ~150KB to bundle (acceptable trade-off)
3. **Learning Curve**: Must learn Paper component API patterns
4. **Customization Limits**: Some components have limited style override options

## Performance Baselines

| Metric | Target | Measurement |
|--------|--------|-------------|
| Component Render | <16ms | React DevTools Profiler |
| Theme Update | <8ms | Re-render time |
| Bundle Impact | <150KB | Source map analysis |
| Memory per Screen | <2MB | Heap snapshot |

## Migration Path

| Phase | Timeline | Actions |
|-------|----------|---------|
| Phase 1 | Week 1 | Install React Native Paper v5 |
| Phase 2 | Week 1 | Configure theme with custom colors |
| Phase 3 | Week 2 | Replace existing buttons with Paper Button |
| Phase 4 | Week 2 | Implement dynamic theming |
| Phase 5 | Week 3 | Add accessibility props |
| Phase 6 | Week 3 | Performance testing |

## References

- [React Native Paper Documentation](https://callstack.github.io/react-native-paper)
- [Material Design 3 Guidelines](https://m3.material.io)
- [Material Theme Builder](https://m3.material.io/theme-builder)
- [React Native Paper GitHub](https://github.com/callstack/react-native-paper)
- [Expo Material 3 Theme](https://github.com/pchmn/expo-material3-theme)

---

*This ADR completes the core architecture trilogy (ADR-001 Framework, ADR-002 Navigation, ADR-003 Components) for AppGen.*
