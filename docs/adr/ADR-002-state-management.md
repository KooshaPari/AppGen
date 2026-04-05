# ADR-002: State Management Strategy

**Document ID:** PHENOTYPE_APPGEN_ADR_002  
**Status:** Accepted  
**Last Updated:** 2026-04-03  
**Author:** Phenotype Architecture Team

---

## Table of Contents

1. [Context](#1-context)
2. [Decision Drivers](#2-decision-drivers)
3. [Options Considered](#3-options-considered)
4. [Decision](#4-decision)
5. [Consequences](#5-consequences)
6. [Implementation Details](#6-implementation-details)
7. [Cross-References](#7-cross-references)

---

## 1. Context

### 1.1 Problem Statement

AppGen requires a state management strategy that handles multiple categories of state across a utility-style mobile application with settings-heavy interfaces, potential API integration, and configurable theming. The state management solution must:

1. **Separate concerns** between client state, server state, and UI state
2. **Minimize boilerplate** for rapid development of generated apps
3. **Support persistence** for user preferences and settings
4. **Handle async operations** for API calls and data synchronization
5. **Enable type safety** for compile-time validation
6. **Scale appropriately** from simple utility apps to complex feature-rich applications
7. **Integrate seamlessly** with React Native and Expo ecosystem

### 1.2 Current State

AppGen currently manages state through:
- React's built-in `useState` and `useContext` hooks
- Theme state passed through React Native Paper's `PaperProvider`
- Component-local state for UI interactions
- No centralized state management solution
- No server state caching layer
- No persistence mechanism for user preferences

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Current State Management (Pre-ADR)                       │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  App.js                                                              │   │
│  │  ├── useColorScheme() → theme state                                  │   │
│  │  ├── PaperProvider → theme distribution                              │   │
│  │  └── NavigationContainer → navigation state                          │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Components/*                                                        │   │
│  │  ├── useState() → local component state                              │   │
│  │  ├── useTheme() → theme consumption                                  │   │
│  │  └── navigation.navigate() → routing state                           │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  Issues:                                                                    │
│  • No centralized state for cross-component sharing                         │
│  • No persistence for user preferences                                      │
│  • No server state caching                                                  │
│  • Theme state tightly coupled to PaperProvider                             │
│  • No separation between client and server state                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 State Categories

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    State Categories in AppGen                               │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Client State (Local to Device)                                      │   │
│  │  • Theme mode (light/dark/system)                                    │   │
│  │  • User preferences (notifications, sound, haptics)                  │   │
│  │  • UI state (modals, loading states, form inputs)                    │   │
│  │  • Feature flags                                                     │   │
│  │  • Search history                                                    │   │
│  │  • Language selection                                                │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Server State (Remote Data)                                          │   │
│  │  • User profile data                                                 │   │
│  │  • Settings from backend                                             │   │
│  │  • API responses with caching                                        │   │
│  │  • Real-time data (notifications, updates)                           │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Navigation State                                                    │   │
│  │  • Current route                                                     │   │
│  │  • Navigation history                                                │   │
│  │  • Deep link parameters                                              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Form State                                                          │   │
│  │  • Input values                                                      │   │
│  │  • Validation errors                                                 │   │
│  │  • Submission status                                                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Decision Drivers

### 2.1 Weighted Criteria

| Driver | Weight | Description | Measurement |
|--------|--------|-------------|-------------|
| Simplicity | 20% | Minimal boilerplate, easy to learn | Lines of code, onboarding time |
| Bundle Size | 15% | Impact on app bundle | KB added to bundle |
| Performance | 15% | Render optimization, memory usage | Re-render count, memory |
| Persistence | 15% | Built-in state persistence | Setup complexity |
| TypeScript | 10% | Type safety support | Type inference quality |
| Async Support | 10% | Handling async operations | API integration ease |
| DevTools | 10% | Debugging capabilities | Tool quality |
| Community | 5% | Community support and docs | Stack Overflow, docs |

### 2.2 State Separation Principle

The chosen solution must support clear separation between:
- **Client State**: Local device state (preferences, UI state)
- **Server State**: Remote data with caching and synchronization
- **URL State**: Navigation and routing state
- **Form State**: Input values and validation

This separation prevents common anti-patterns like storing server responses in global state or duplicating navigation state.

---

## 3. Options Considered

### 3.1 Option A: Zustand + React Query (Selected)

**Description**: Zustand for client state management with React Query (TanStack Query) for server state caching.

**Architecture**:
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Zustand + React Query Architecture                       │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    Client State (Zustand)                            │   │
│  │  ┌─────────────────────────────────────────────────────────────┐   │   │
│  │  │  useAppStore                                                 │   │   │
│  │  │  ├── theme: 'light' | 'dark' | 'system'                     │   │   │
│  │  │  ├── useDynamicTheme: boolean                               │   │   │
│  │  │  ├── notifications: boolean                                 │   │   │
│  │  │  ├── soundEnabled: boolean                                  │   │   │
│  │  │  ├── hapticsEnabled: boolean                                │   │   │
│  │  │  ├── language: string                                       │   │   │
│  │  │  ├── user: User | null                                      │   │   │
│  │  │  └── actions: setTheme, setUser, etc.                       │   │   │
│  │  └─────────────────────────────────────────────────────────────┘   │   │
│  │  Persisted via zustand/middleware → AsyncStorage                    │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    Server State (React Query)                        │   │
│  │  ┌─────────────────────────────────────────────────────────────┐   │   │
│  │  │  QueryClient                                                 │   │   │
│  │  │  ├── staleTime: 5 minutes                                    │   │   │
│  │  │  ├── cacheTime: 10 minutes                                   │   │   │
│  │  │  ├── retry: 3                                                │   │   │
│  │  │  └── Queries:                                                │   │   │
│  │  │      ├── ['user', userId] → UserProfile                      │   │   │
│  │  │      ├── ['settings'] → UserSettings                         │   │   │
│  │  │      └── ['notifications'] → Notification[]                  │   │   │
│  │  └─────────────────────────────────────────────────────────────┘   │   │
│  │  Mutations with optimistic updates                                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    Navigation State (React Navigation)               │   │
│  │  ┌─────────────────────────────────────────────────────────────┐   │   │
│  │  │  NavigationContainer                                         │   │   │
│  │  │  ├── Current route                                           │   │   │
│  │  │  ├── Navigation history                                      │   │   │
│  │  │  └── Deep link handling                                      │   │   │
│  │  └─────────────────────────────────────────────────────────────┘   │   │
│  │  Optional persistence via AsyncStorage                              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Pros**:
- **Minimal boilerplate**: Zustand requires ~1KB, no providers needed
- **Clear separation**: Client state (Zustand) vs server state (React Query)
- **Built-in persistence**: Zustand middleware for AsyncStorage
- **Excellent TypeScript**: Full type inference throughout
- **Optimistic updates**: React Query supports optimistic mutations
- **Background refetching**: Automatic data freshness
- **Small bundle**: Zustand ~1KB, React Query ~13KB
- **React 18 support**: Excellent concurrent features support
- **No context wrapper hell**: Zustand uses hooks directly

**Cons**:
- Two libraries to learn and maintain
- React Query has learning curve for caching strategies
- No built-in undo/redo (requires custom implementation)
- DevTools less comprehensive than Redux DevTools

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Simplicity | 9.0 | 20% | 1.80 |
| Bundle Size | 9.5 | 15% | 1.43 |
| Performance | 9.0 | 15% | 1.35 |
| Persistence | 9.0 | 15% | 1.35 |
| TypeScript | 9.5 | 10% | 0.95 |
| Async Support | 9.5 | 10% | 0.95 |
| DevTools | 7.0 | 10% | 0.70 |
| Community | 9.0 | 5% | 0.45 |
| **Total** | | | **8.98** |

### 3.2 Option B: Redux Toolkit

**Description**: Official Redux state management with Redux Toolkit for simplified setup.

**Pros**:
- Industry standard with extensive documentation
- Excellent DevTools (Redux DevTools)
- Middleware ecosystem (thunks, sagas)
- Time-travel debugging
- Strong TypeScript support

**Cons**:
- Significant boilerplate (actions, reducers, slices)
- Steep learning curve for beginners
- Requires Provider wrapper
- Larger bundle (~10KB vs ~1KB for Zustand)
- Overkill for utility apps
- No built-in server state management

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Simplicity | 5.0 | 20% | 1.00 |
| Bundle Size | 6.0 | 15% | 0.90 |
| Performance | 8.0 | 15% | 1.20 |
| Persistence | 6.0 | 15% | 0.90 |
| TypeScript | 9.0 | 10% | 0.90 |
| Async Support | 9.0 | 10% | 0.90 |
| DevTools | 10.0 | 10% | 1.00 |
| Community | 10.0 | 5% | 0.50 |
| **Total** | | | **7.30** |

**Verdict**: Too much boilerplate for AppGen's use case. Redux Toolkit is excellent for complex enterprise apps but overkill for utility-style applications with simple state requirements.

### 3.3 Option C: Jotai

**Description**: Atomic state management with primitive and derived atoms.

**Pros**:
- Minimal bundle size (~3KB)
- Atomic updates prevent unnecessary re-renders
- Excellent TypeScript support
- Simple mental model
- React 18 concurrent support

**Cons**:
- No built-in persistence (requires additional library)
- Less intuitive for complex state relationships
- Smaller community than Zustand
- Debugging more complex with many atoms
- No built-in async support pattern

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Simplicity | 8.0 | 20% | 1.60 |
| Bundle Size | 9.0 | 15% | 1.35 |
| Performance | 9.0 | 15% | 1.35 |
| Persistence | 5.0 | 15% | 0.75 |
| TypeScript | 9.0 | 10% | 0.90 |
| Async Support | 6.0 | 10% | 0.60 |
| DevTools | 7.0 | 10% | 0.70 |
| Community | 7.0 | 5% | 0.35 |
| **Total** | | | **7.60** |

**Verdict**: Good alternative but lacks built-in persistence and has less intuitive patterns for the state categories AppGen requires.

### 3.4 Option D: React Context + useReducer

**Description**: Built-in React APIs without external dependencies.

**Pros**:
- Zero bundle size impact
- No external dependencies
- Built into React
- Simple for basic use cases

**Cons**:
- Coarse-grained re-renders (all consumers re-render)
- No built-in persistence
- No devtools
- Complex for multiple state slices
- No async support pattern
- Boilerplate for multiple contexts

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Simplicity | 6.0 | 20% | 1.20 |
| Bundle Size | 10.0 | 15% | 1.50 |
| Performance | 5.0 | 15% | 0.75 |
| Persistence | 3.0 | 15% | 0.45 |
| TypeScript | 7.0 | 10% | 0.70 |
| Async Support | 4.0 | 10% | 0.40 |
| DevTools | 3.0 | 10% | 0.30 |
| Community | 10.0 | 5% | 0.50 |
| **Total** | | | **5.80** |

**Verdict**: Rejected due to performance limitations and lack of built-in persistence. Suitable only for very simple apps.

### 3.5 Option E: MobX

**Description**: Reactive state management with observable patterns.

**Pros**:
- Automatic dependency tracking
- Minimal boilerplate for reactive updates
- Good TypeScript support
- Excellent for complex derived state

**Cons**:
- Larger bundle (~16KB)
- Magic-like reactivity (harder to debug)
- Less predictable than explicit state updates
- Smaller community in React Native ecosystem
- Requires decorators or makeObservable calls

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Simplicity | 7.0 | 20% | 1.40 |
| Bundle Size | 5.0 | 15% | 0.75 |
| Performance | 8.0 | 15% | 1.20 |
| Persistence | 6.0 | 15% | 0.90 |
| TypeScript | 8.0 | 10% | 0.80 |
| Async Support | 7.0 | 10% | 0.70 |
| DevTools | 7.0 | 10% | 0.70 |
| Community | 7.0 | 5% | 0.35 |
| **Total** | | | **6.80** |

**Verdict**: Rejected due to larger bundle size and less predictable reactivity model. Better suited for complex data-heavy applications.

### 3.6 Option F: Recoil

**Description**: Facebook's experimental state management with atoms and selectors.

**Pros**:
- Designed by Meta (React team)
- Excellent for derived state
- Concurrent mode support
- Fine-grained subscriptions

**Cons**:
- Experimental status (not production-ready)
- Limited documentation
- Smaller community
- No built-in persistence
- Complex debugging

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Simplicity | 6.0 | 20% | 1.20 |
| Bundle Size | 7.0 | 15% | 1.05 |
| Performance | 8.0 | 15% | 1.20 |
| Persistence | 4.0 | 15% | 0.60 |
| TypeScript | 8.0 | 10% | 0.80 |
| Async Support | 7.0 | 10% | 0.70 |
| DevTools | 5.0 | 10% | 0.50 |
| Community | 5.0 | 5% | 0.25 |
| **Total** | | | **6.30** |

**Verdict**: Rejected due to experimental status. Recoil may become viable in the future but is not suitable for production use in 2026.

---

## 4. Decision

### 4.1 Selected Option

**Adopt Zustand for client state management and React Query (TanStack Query) for server state caching.**

### 4.2 Rationale

1. **Minimal Boilerplate (Score: 9/10)**: Zustand requires minimal setup—no providers, no action creators, no reducers. A complete store can be defined in ~30 lines of code. This is critical for an app generator where simplicity directly impacts adoption.

2. **Bundle Efficiency (Score: 9.5/10)**: Combined bundle impact of ~14KB (Zustand ~1KB + React Query ~13KB) is negligible compared to React Native Paper (~150KB) and React Navigation (~180KB).

3. **Clear State Separation (Score: 9/10)**: The Zustand + React Query combination enforces clean separation between client and server state, preventing common anti-patterns and making the codebase more maintainable.

4. **Built-in Persistence (Score: 9/10)**: Zustand's `persist` middleware provides seamless AsyncStorage integration with selective state persistence:

```javascript
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

export const useAppStore = create()(
  persist(
    (set) => ({
      theme: 'system',
      notifications: true,
      setTheme: (theme) => set({ theme }),
      setNotifications: (enabled) => set({ notifications: enabled }),
    }),
    {
      name: 'app-storage',
      storage: createJSONStorage(() => AsyncStorage),
      partialize: (state) => ({
        theme: state.theme,
        notifications: state.notifications,
      }),
    }
  )
);
```

5. **Server State Excellence (Score: 9.5/10)**: React Query provides automatic caching, background refetching, optimistic updates, and retry logic out of the box. This eliminates the need for manual cache management and reduces boilerplate significantly.

6. **TypeScript Integration (Score: 9.5/10)**: Both libraries provide excellent type inference. Zustand infers types from the store definition, and React Query provides full type safety for query keys, responses, and mutations.

### 4.3 State Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    AppGen State Architecture                                │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Client State (Zustand)                                              │   │
│  │  • Theme configuration                                               │   │
│  │  • User preferences                                                  │   │
│  │  • UI state (modals, loading)                                        │   │
│  │  • Feature flags                                                     │   │
│  │  Persisted: AsyncStorage via zustand/middleware                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Server State (React Query)                                          │   │
│  │  • User profile                                                      │   │
│  │  • Settings from backend                                             │   │
│  │  • Notifications                                                     │   │
│  │  • API responses with caching                                        │   │
│  │  Cached: In-memory with staleTime/gcTime configuration              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Navigation State (React Navigation)                                 │   │
│  │  • Current route                                                     │   │
│  │  • Navigation stack                                                  │   │
│  │  • Deep link parameters                                              │   │
│  │  Managed by: NavigationContainer                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Form State (Local useState/useReducer)                              │   │
│  │  • Input values                                                      │   │
│  │  • Validation errors                                                 │   │
│  │  • Submission status                                                 │   │
│  │  Managed by: Component-level state                                   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Consequences

### 5.1 Positive Consequences

1. **Reduced Boilerplate**: Zustand eliminates the need for action creators, reducers, and switch statements. A complete store definition is ~30 lines vs ~100+ lines with Redux Toolkit.

2. **Clear State Boundaries**: Separating client state (Zustand) from server state (React Query) prevents common anti-patterns like storing API responses in global state or duplicating navigation state.

3. **Automatic Caching**: React Query handles caching, deduplication, background refetching, and garbage collection automatically. This eliminates manual cache management code.

4. **Optimistic Updates**: React Query's mutation API supports optimistic updates with automatic rollback on failure, improving perceived performance for user actions.

5. **Persistence Made Simple**: Zustand's `persist` middleware with `partialize` option allows selective state persistence without manual AsyncStorage management.

6. **Type Safety**: Full TypeScript inference throughout both libraries enables compile-time validation of state shapes, actions, and API responses.

7. **Small Bundle Impact**: Combined ~14KB is negligible compared to existing dependencies (~400KB+).

8. **React 18 Ready**: Both libraries fully support React 18 concurrent features including `startTransition`, `useDeferredValue`, and Suspense.

9. **Developer Experience**: Zustand's hook-based API is intuitive for React developers. React Query DevTools provide excellent visibility into cache state.

10. **Testability**: Zustand stores are easy to mock and test. React Query provides testing utilities for query and mutation testing.

### 5.2 Negative Consequences

1. **Two Libraries to Maintain**: Requires managing dependencies for both Zustand and React Query, including version compatibility and updates.

2. **Learning Curve**: Developers unfamiliar with the client/server state separation pattern need to learn both libraries and understand when to use each.

3. **React Query Complexity**: Advanced caching strategies (staleTime, gcTime, refetch intervals) require understanding and configuration. Misconfiguration can lead to stale data or excessive network requests.

4. **No Built-in Undo/Redo**: Zustand doesn't provide undo/redo out of the box. Requires custom implementation using Zustand's subscribe API.

5. **Migration Effort**: Existing state management (Context-based theme state) needs to be migrated to Zustand, requiring refactoring of theme-related code.

6. **DevTools Limitations**: Zustand DevTools are less comprehensive than Redux DevTools. Time-travel debugging is not available.

### 5.3 Risk Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| React Query misconfiguration | Medium | Medium | Document caching strategy, add monitoring |
| Zustand store complexity | Low | Low | Enforce single store pattern, document structure |
| Bundle size growth | Low | Low | Monitor bundle, tree-shake unused features |
| Version incompatibility | Medium | Low | Pin versions, test before upgrading |
| Developer onboarding | Low | Medium | Document patterns, provide examples |

---

## 6. Implementation Details

### 6.1 Zustand Store

```javascript
// store/appStore.js
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

export const useAppStore = create(
  persist(
    (set) => ({
      // Theme
      theme: 'system',
      useDynamicTheme: true,

      // User
      user: null,
      isAuthenticated: false,

      // Preferences
      notifications: true,
      soundEnabled: true,
      hapticsEnabled: true,
      language: 'en',

      // UI State
      isLoading: false,
      error: null,

      // Actions
      setTheme: (theme) => set({ theme }),
      setDynamicTheme: (enabled) => set({ useDynamicTheme: enabled }),
      setUser: (user) => set({ user, isAuthenticated: !!user }),
      setNotifications: (enabled) => set({ notifications: enabled }),
      setSoundEnabled: (enabled) => set({ soundEnabled: enabled }),
      setHapticsEnabled: (enabled) => set({ hapticsEnabled: enabled }),
      setLanguage: (language) => set({ language }),
      setLoading: (isLoading) => set({ isLoading }),
      setError: (error) => set({ error }),
      clearError: () => set({ error: null }),
      logout: () => set({ user: null, isAuthenticated: false }),
    }),
    {
      name: 'appgen-storage',
      storage: createJSONStorage(() => AsyncStorage),
      partialize: (state) => ({
        theme: state.theme,
        useDynamicTheme: state.useDynamicTheme,
        notifications: state.notifications,
        soundEnabled: state.soundEnabled,
        hapticsEnabled: state.hapticsEnabled,
        language: state.language,
      }),
    }
  )
);
```

### 6.2 React Query Configuration

```javascript
// store/queryClient.js
import { QueryClient } from '@tanstack/react-query';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,
      gcTime: 10 * 60 * 1000,
      retry: 3,
      retryDelay: (attemptIndex) =>
        Math.min(1000 * 2 ** attemptIndex, 30000),
      refetchOnWindowFocus: false,
      refetchOnReconnect: true,
    },
    mutations: {
      retry: 1,
    },
  },
});
```

### 6.3 Usage Pattern

```javascript
// Components/Settings.js
import { useAppStore } from '../store/appStore';
import { useQuery, useMutation } from '@tanstack/react-query';
import { api } from '../services/api';

const Settings = ({ navigation }) => {
  // Client state from Zustand
  const {
    theme,
    setTheme,
    notifications,
    setNotifications,
  } = useAppStore();

  // Server state from React Query
  const { data: userSettings, isLoading } = useQuery({
    queryKey: ['settings'],
    queryFn: api.getSettings,
  });

  // Mutation with optimistic update
  const updateSettings = useMutation({
    mutationFn: api.updateSettings,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['settings'] });
    },
  });

  return (
    <View>
      <Switch
        value={notifications}
        onValueChange={setNotifications}
      />
      {/* ... */}
    </View>
  );
};
```

### 6.4 App Integration

```javascript
// App.js
import { QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from './store/queryClient';
import { useAppStore } from './store/appStore';

export default function App() {
  const theme = useAppStore((state) => state.theme);

  return (
    <QueryClientProvider client={queryClient}>
      <PaperProvider theme={getTheme(theme)}>
        <NavigationContainer>
          <TabNavigator />
        </NavigationContainer>
      </PaperProvider>
    </QueryClientProvider>
  );
}
```

### 6.5 Migration Path

| Phase | Timeline | Actions | Deliverable |
|-------|----------|---------|-------------|
| Phase 1 | Week 1 | Install Zustand + React Query | Dependencies added |
| Phase 2 | Week 1 | Create appStore with theme state | Store implementation |
| Phase 3 | Week 2 | Migrate theme state from Context | Refactored App.js |
| Phase 4 | Week 2 | Add persistence middleware | AsyncStorage integration |
| Phase 5 | Week 3 | Configure React Query client | Query setup |
| Phase 6 | Week 3 | Migrate API calls to React Query | Refactored services |
| Phase 7 | Week 4 | Testing and validation | Test coverage |

---

## 7. Cross-References

### 7.1 Related ADRs

- [ADR-001: Expo Framework Selection](./ADR-001-expo-framework.md) — Framework decision that this state management builds upon
- [ADR-003: Native Module Integration](./ADR-003-native-modules.md) — Native modules may produce state that feeds into Zustand

### 7.2 Related Documents

- [SOTA Research: Mobile App Generators](../research/MOBILE_APP_GENERATORS_SOTA.md) — State management comparison in Section 17.2
- [AppGen Specification](../../SPEC.md) — State architecture in Section 7
- [SOTA Research: Cross-Platform Development](../SOTA-RESEARCH.md) — State management analysis in Section 4

### 7.3 External References

- [Zustand Documentation](https://docs.pmnd.rs/zustand)
- [TanStack Query Documentation](https://tanstack.com/query/latest)
- [Zustand Persist Middleware](https://docs.pmnd.rs/zustand/integrations/persisting-store-data)
- [React Query DevTools](https://tanstack.com/query/latest/docs/devtools)

---

**Decision Date**: 2026-04-03  
**Review Date**: 2026-07-03  
**Status**: Accepted  
**Next Review**: Upon major Zustand or React Query version release

*This ADR establishes the state management architecture for AppGen. All state-related code should follow the patterns defined herein.*
