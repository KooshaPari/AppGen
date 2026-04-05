# ADR-002: Navigation Architecture

**Date**: 2026-04-04  
**Status**: Accepted  
**Deciders**: KooshaPari  

## Context

AppGen requires a navigation system that supports:

1. **Bottom tab navigation** for primary app sections (Home, Profile, Notifications, Search, Settings)
2. **Stack navigation** within each tab for drill-down screens
3. **Deep linking** for external navigation and notifications
4. **Type safety** for compile-time route validation
5. **Performance** with 60fps transitions
6. **Material Design 3** visual integration

The navigation architecture must handle nested navigators cleanly while maintaining type safety and performance targets.

## Decision Drivers

| Driver | Weight | Description |
|--------|--------|-------------|
| Performance | High | 60fps transitions, minimal memory overhead |
| Type Safety | High | Compile-time route validation |
| Deep Linking | High | URL-based navigation support |
| Native Feel | High | Platform-appropriate animations |
| Flexibility | Medium | Support for modals, overlays |
| Bundle Size | Medium | Reasonable package size |
| Maintenance | High | Active development, documentation |

## Options Considered

### Option A: React Navigation v6 with Native Stack (Selected)

**Architecture Pattern**:
```
NavigationContainer
├── Tab.Navigator (Material Bottom Tabs)
│   ├── HomeTab
│   │   └── Stack.Navigator
│   │       └── HomeScreen
│   ├── ProfileTab
│   │   └── Stack.Navigator
│   │       └── SettingsScreen (initial)
│   ├── NotificationsTab
│   ├── SearchTab
│   └── SettingsTab
│       └── Stack.Navigator
│           ├── SettingsScreen (initial)
│           ├── Starred Contacts
│           ├── Linked Devices
│           ├── Account
│           ├── Privacy
│           ├── Notifications
│           ├── Downloads
│           ├── Help
│           └── Tell A Friend
```

**Pros**:
- **Native Stack**: Uses native iOS/Android navigation controllers
- **Performance**: 60fps transitions, minimal JS thread involvement
- **Type Safety**: Full TypeScript support with typed parameters
- **Deep Linking**: Comprehensive URL handling
- **Ecosystem**: Most popular React Native navigation library
- **Flexibility**: Supports modals, drawers, bottom sheets
- **Material Integration**: Works with React Native Paper

**Performance Metrics**:
| Metric | Native Stack | JS Stack |
|--------|--------------|----------|
| Transition FPS | 60fps | 45-55fps |
| Memory per Screen | 2-3MB | 4-6MB |
| Touch Latency | 16ms | 32-48ms |
| Bundle Size | ~120KB | ~80KB |

### Option B: Expo Router v3

**Pros**:
- File-based routing (automatic from file structure)
- Built-in deep linking
- Native Stack by default
- TypeScript types generated automatically
- Simplified configuration

**Cons**:
- Requires restructuring project to `app/` directory
- File-based routing less flexible for dynamic routes
- Newer library with less community adoption
- Migration effort from current structure

**Verdict**: Promising for new projects, but migration cost outweighs benefits for existing AppGen structure.

### Option C: React Native Navigation (Wix)

**Pros**:
- Truly native navigation (separate Activity per screen on Android)
- Best native performance
- Native tabs and navigation UI

**Cons**:
- Complex setup and configuration
- Limited flexibility for custom UI
- Larger bundle size
- Smaller ecosystem than React Navigation
- Harder to integrate with React Native Paper

**Verdict**: Rejected due to complexity and reduced flexibility.

### Option D: Custom Navigation

**Pros**:
- Full control over implementation
- Minimal dependencies

**Cons**:
- Significant development effort
- Maintenance burden
- No community support
- Risk of edge case bugs

**Verdict**: Rejected. Navigation is solved problem; custom solution not justified.

## Decision

**Adopt React Navigation v6 with Native Stack Navigator and Material Bottom Tabs.**

### Rationale

1. **Performance**: Native Stack provides 60fps transitions using platform-native navigation controllers, significantly outperforming JavaScript-based solutions.

2. **Type Safety**: React Navigation v6 provides comprehensive TypeScript support:
   ```typescript
   export type RootStackParamList = {
     Home: undefined;
     Settings: undefined;
     Account: undefined;
     // ... all routes typed
   };
   ```

3. **Deep Linking**: Built-in deep linking with configuration:
   ```typescript
   const linking = {
     prefixes: ['appgen://', 'https://appgen.app'],
     config: {
       screens: {
         SettingsTab: {
           screens: {
             Account: 'account',
             Privacy: 'privacy',
           },
         },
       },
     },
   };
   ```

4. **Material Design 3**: `react-native-paper/react-navigation` provides Material Bottom Tab Navigator that integrates seamlessly with Paper's theming system.

5. **Nested Navigation**: Clean support for the required pattern (Tab Navigator → Stack Navigator → Screens):
   - Each tab maintains independent navigation state
   - Back navigation works correctly within each stack
   - Tab switching preserves stack state

6. **Ecosystem**: Most widely adopted navigation solution with extensive documentation, community plugins, and Stack Overflow resources.

## Implementation Details

### Navigator Structure

```typescript
// navigation/AppNavigator.tsx
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createMaterialBottomTabNavigator } from 'react-native-paper/react-navigation';

const Tab = createMaterialBottomTabNavigator();
const Stack = createNativeStackNavigator();

// Stack navigators for each tab
const HomeStack = () => (
  <Stack.Navigator
    screenOptions={{
      header: (props) => <NavBar {...props} />,
    }}
  >
    <Stack.Screen name="Home" component={Home} />
  </Stack.Navigator>
);

const SettingsStack = () => (
  <Stack.Navigator
    screenOptions={{
      header: (props) => <NavBar {...props} />,
    }}
  >
    <Stack.Screen name="Settings" component={SettingsScreen} />
    <Stack.Screen name="Starred Contacts" component={StarredContacts} />
    <Stack.Screen name="Linked Devices" component={LinkedDevices} />
    <Stack.Screen name="Account" component={Account} />
    <Stack.Screen name="Privacy" component={Privacy} />
    <Stack.Screen name="Notifications" component={Notifications} />
    <Stack.Screen name="Downloads" component={Downloads} />
    <Stack.Screen name="Help" component={Support} />
    <Stack.Screen name="Tell A Friend" component={TellAFriend} />
  </Stack.Navigator>
);

// Main tab navigator
const TabNavigator = ({ theme }) => (
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
    {/* ... other tabs */}
    <Tab.Screen
      name="SettingsTab"
      component={SettingsStack}
      options={{
        tabBarLabel: 'Settings',
        tabBarIcon: ({ focused }) => (
          <MaterialCommunityIcons
            size={24}
            color={theme.colors.tertiary}
            name={focused ? 'cog' : 'cog-outline'}
          />
        ),
      }}
    />
  </Tab.Navigator>
);

export const AppNavigator = () => {
  const colorScheme = useColorScheme();
  const theme = colorScheme === 'dark' 
    ? { ...MD3DarkTheme, colors: dark.colors }
    : { ...MD3LightTheme, colors: light.colors };

  return (
    <SafeAreaProvider>
      <NavigationContainer linking={linking}>
        <PaperProvider theme={theme}>
          <TabNavigator theme={theme} />
        </PaperProvider>
      </NavigationContainer>
    </SafeAreaProvider>
  );
};
```

### Type Definitions

```typescript
// navigation/types.ts
export type RootTabParamList = {
  HomeTab: NavigatorScreenParams<HomeStackParamList>;
  ProfileTab: NavigatorScreenParams<ProfileStackParamList>;
  NotificationsTab: undefined;
  SearchTab: undefined;
  SettingsTab: NavigatorScreenParams<SettingsStackParamList>;
};

export type SettingsStackParamList = {
  Settings: undefined;
  'Starred Contacts': undefined;
  'Linked Devices': undefined;
  Account: undefined;
  Privacy: undefined;
  Notifications: undefined;
  Downloads: undefined;
  Help: undefined;
  'Tell A Friend': undefined;
};

// Global declaration for useNavigation hook
declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootTabParamList {}
  }
}
```

### Deep Linking Configuration

```typescript
// navigation/linking.ts
export const linking = {
  prefixes: [
    'appgen://',
    'https://appgen.app',
    'https://www.appgen.app',
  ],
  config: {
    screens: {
      HomeTab: {
        path: 'home',
        screens: {
          Home: '',
        },
      },
      SettingsTab: {
        path: 'settings',
        screens: {
          Settings: '',
          Account: 'account',
          Privacy: 'privacy',
          Notifications: 'notifications',
          Downloads: 'downloads',
          Help: 'help',
          'Tell A Friend': 'share',
        },
      },
      SearchTab: 'search',
    },
  },
  // Handle incoming links
  getInitialURL: async () => {
    const url = await Linking.getInitialURL();
    return url;
  },
  // Subscribe to incoming links while app is open
  subscribe: (listener: (url: string) => void) => {
    const subscription = Linking.addEventListener('url', ({ url }) => {
      listener(url);
    });
    return () => subscription.remove();
  },
};
```

## Consequences

### Positive

1. **Performance**: Native Stack provides 60fps transitions and native gesture handling
2. **Type Safety**: Compile-time route validation prevents navigation errors
3. **Maintainability**: Well-documented, widely-used library with active development
4. **Flexibility**: Easy to add modals, drawers, or custom transitions
5. **Deep Linking**: Comprehensive URL handling for notifications and sharing
6. **Integration**: Seamless integration with React Native Paper theming

### Negative

1. **Bundle Size**: Adds ~180KB to bundle (acceptable for functionality provided)
2. **Learning Curve**: Nested navigators require understanding of navigation patterns
3. **Platform Differences**: iOS and Android have slightly different default behaviors
4. **Memory**: Each stack maintains its own state (mitigated by lazy loading)

## Migration Path

| Phase | Timeline | Actions |
|-------|----------|---------|
| Phase 1 | Week 1 | Install React Navigation v6 dependencies |
| Phase 2 | Week 1 | Configure Native Stack navigator |
| Phase 3 | Week 2 | Implement Tab Navigator with Material Bottom Tabs |
| Phase 4 | Week 2 | Add type definitions and deep linking |
| Phase 5 | Week 3 | Migrate existing screens to new structure |
| Phase 6 | Week 3 | Test navigation flows and edge cases |

## Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Transition FPS | 60fps | Animation profiling |
| Memory per Stack | <3MB | Memory profiling |
| Initial Load | <100ms | Navigator initialization |
| Deep Link Handling | <200ms | Time to navigate to target |

## References

- [React Navigation Documentation](https://reactnavigation.org)
- [Native Stack Navigator](https://github.com/software-mansion/react-native-screens)
- [React Native Paper Navigation](https://callstack.github.io/react-native-paper/docs/guides/react-navigation)
- [Deep Linking Guide](https://reactnavigation.org/docs/deep-linking)
- [TypeScript with React Navigation](https://reactnavigation.org/docs/typescript)

---

*This ADR defines the navigation architecture for AppGen. Component architecture is covered in ADR-003.*
