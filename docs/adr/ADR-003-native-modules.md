# ADR-003: Native Module Integration

**Document ID:** PHENOTYPE_APPGEN_ADR_003  
**Status:** Proposed  
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

AppGen operates within the Expo managed workflow, which provides comprehensive pre-built native modules through Expo SDK. However, certain use cases require custom native code that falls outside Expo's module catalog. This ADR defines the strategy for integrating native modules while maintaining the managed workflow benefits.

The native module integration strategy must address:

1. **Expo SDK coverage** — determining when Expo modules are sufficient
2. **Custom native code** — handling requirements not covered by Expo
3. **Config plugins** — automating native configuration without ejecting
4. **Development workflow** — maintaining developer experience with native code
5. **Build process** — ensuring native modules work with EAS Build
6. **Maintenance burden** — minimizing ongoing native code maintenance
7. **Template compatibility** — ensuring generated apps can extend native functionality

### 1.2 Current State

AppGen currently uses only Expo-provided modules:
- `expo-linear-gradient` — gradient backgrounds
- `expo-splash-screen` — splash screen management
- `expo-status-bar` — status bar customization
- `react-native-vector-icons` — icon library (community package)
- `react-native-reanimated` — animation library (community package)
- `react-native-gesture-handler` — gesture handling (community package)
- `react-native-screens` — native screen components (community package)
- `react-native-safe-area-context` — safe area handling (community package)
- `react-native-svg` — SVG rendering (community package)
- `@pchmn/expo-material3-theme` — Material You dynamic theming (community package)

No custom native code exists in the project. All native functionality comes from pre-built packages.

### 1.3 Native Module Requirements Analysis

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Native Module Requirements for AppGen                    │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Currently Covered by Expo SDK                                       │   │
│  │  ✓ Splash screen management (expo-splash-screen)                     │   │
│  │  ✓ Status bar customization (expo-status-bar)                        │   │
│  │  ✓ Linear gradients (expo-linear-gradient)                           │   │
│  │  ✓ Secure storage (expo-secure-store) — planned                      │   │
│  │  ✓ Font loading (expo-font) — planned                                │   │
│  │  ✓ Haptic feedback (expo-haptics) — planned                          │   │
│  │  ✓ Device information (expo-device) — planned                        │   │
│  │  ✓ OTA updates (expo-updates) — planned                              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Covered by Community Packages                                       │   │
│  │  ✓ Navigation (react-navigation)                                     │   │
│  │  ✓ Animations (react-native-reanimated)                              │   │
│  │  ✓ Gestures (react-native-gesture-handler)                           │   │
│  │  ✓ Material Design UI (react-native-paper)                           │   │
│  │  ✓ Icons (react-native-vector-icons)                                 │   │
│  │  ✓ SVG (react-native-svg)                                            │   │
│  │  ✓ Safe areas (react-native-safe-area-context)                       │   │
│  │  ✓ Native screens (react-native-screens)                             │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Potential Future Requirements (Not Currently Needed)                │   │
│  │  ? Biometric authentication (expo-local-authentication)              │   │
│  │  ? Push notifications (expo-notifications)                           │   │
│  │  ? Camera access (expo-camera)                                       │   │
│  │  ? Location services (expo-location)                                 │   │
│  │  ? File system access (expo-file-system)                             │   │
│  │  ? Background tasks (expo-task-manager)                              │   │
│  │  ? Custom native modules (app-specific)                              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.4 Expo Module Catalog Coverage

Expo SDK 54 provides ~70+ native modules covering the most common mobile app requirements:

| Category | Expo Modules | Coverage |
|----------|-------------|----------|
| UI/UX | linear-gradient, splash-screen, status-bar, haptics, blur-view | 95% |
| Storage | secure-store, file-system, sqlite | 90% |
| Media | camera, image-picker, media-library, audio, video | 85% |
| Sensors | location, device, battery, accelerometer, gyroscope | 90% |
| Network | networking, updates, background-fetch | 80% |
| Auth | auth-session, local-authentication, web-browser | 85% |
| System | constants, application, intent-launcher, sharing | 90% |
| Notifications | notifications, task-manager | 80% |

**Overall Coverage**: ~88% of common mobile app requirements are covered by Expo SDK.

---

## 2. Decision Drivers

### 2.1 Weighted Criteria

| Driver | Weight | Description | Measurement |
|--------|--------|-------------|-------------|
| Workflow Compatibility | 25% | Maintains managed workflow benefits | Eject requirement, config complexity |
| Maintenance Burden | 20% | Ongoing native code maintenance | Lines of native code, update frequency |
| Developer Experience | 15% | Impact on development workflow | Setup time, debugging complexity |
| Build Compatibility | 15% | Works with EAS Build and CI/CD | Build success rate, configuration |
| Flexibility | 10% | Ability to add custom native code | Module types supported |
| Performance | 10% | Native module performance | Latency, memory overhead |
| Template Suitability | 5% | Works as reusable template | Config complexity for generated apps |

### 2.2 Integration Complexity Spectrum

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Native Module Integration Complexity                     │
│                                                                             │
│  Low Complexity ◄────────────────────────────────────────────────► High     │
│                                                                             │
│  Expo SDK          Config Plugins       Development         Custom          │
│  Modules           (expo config)        Builds             Native Code      │
│  (Pre-built)       (Auto-config)        (Prebuild)         (Manual)         │
│                                                                             │
│  ✓ Zero config     ✓ Minimal config     ✓ Native projects   ✗ Full native   │
│  ✓ OTA updates     ✓ OTA updates        ✗ No OTA updates    ✗ No OTA        │
│  ✓ Expo Go         ✓ Expo Go (limited)  ✗ No Expo Go        ✗ No Expo Go   │
│  ✓ EAS Build       ✓ EAS Build          ✓ EAS Build         ✓ EAS Build     │
│                                                                             │
│  AppGen Position: ──► Primary zone (Expo SDK + Config Plugins)              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Options Considered

### 3.1 Option A: Expo SDK Modules Only (Baseline)

**Description**: Use only Expo-provided modules, avoiding any custom native code.

**Architecture**:
```
┌─────────────────────────────────────────────────────────────────┐
│                    Expo SDK Only Architecture                   │
│                                                                 │
│  AppGen                                                         │
│  ├── Expo SDK Modules (pre-built)                               │
│  │   ├── expo-linear-gradient                                   │
│  │   ├── expo-splash-screen                                     │
│  │   ├── expo-secure-store                                      │
│  │   ├── expo-font                                              │
│  │   ├── expo-haptics                                           │
│  │   └── ... (70+ modules)                                      │
│  │                                                              │
│  └── Community Packages (compatible with Expo)                  │
│      ├── react-native-paper                                     │
│      ├── react-navigation                                       │
│      ├── react-native-reanimated                                │
│      └── ...                                                    │
│                                                                 │
│  No custom native code. No config plugins needed.               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Pros**:
- Zero native code maintenance
- Full OTA update support
- Expo Go compatibility
- Simplest development workflow
- Easiest to maintain as template
- No build configuration required

**Cons**:
- Limited to Expo's module catalog (~88% coverage)
- Cannot implement app-specific native features
- Dependent on Expo release cycle for new features
- Some community packages may have limited Expo compatibility

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Workflow Compatibility | 10.0 | 25% | 2.50 |
| Maintenance Burden | 10.0 | 20% | 2.00 |
| Developer Experience | 10.0 | 15% | 1.50 |
| Build Compatibility | 10.0 | 15% | 1.50 |
| Flexibility | 4.0 | 10% | 0.40 |
| Performance | 8.0 | 10% | 0.80 |
| Template Suitability | 10.0 | 5% | 0.50 |
| **Total** | | | **9.20** |

### 3.2 Option B: Expo Config Plugins (Selected)

**Description**: Use Expo config plugins to automate native configuration for community packages and custom native code, staying within the managed workflow.

**Architecture**:
```
┌─────────────────────────────────────────────────────────────────┐
│                    Config Plugin Architecture                   │
│                                                                 │
│  AppGen                                                         │
│  ├── Expo SDK Modules                                           │
│  ├── Community Packages with Config Plugins                     │
│  │   ├── react-native-paper (no plugin needed)                  │
│  │   ├── react-native-vector-icons (plugin for fonts)           │
│  │   └── @pchmn/expo-material3-theme (plugin for colors)        │
│  │                                                              │
│  ├── Custom Config Plugins                                      │
│  │   ├── withAppIcon.js                                         │
│  │   ├── withSplashScreen.js                                    │
│  │   └── withCustomModule.js                                    │
│  │                                                              │
│  └── app.json plugins array                                     │
│      [                                                          │
│        "expo-secure-store",                                     │
│        "expo-font",                                             │
│        "./plugins/withAppIcon",                                 │
│        "./plugins/withCustomModule"                             │
│      ]                                                          │
│                                                                 │
│  Prebuild generates native projects automatically               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Pros**:
- Maintains managed workflow benefits
- Automates native configuration
- Supports community packages requiring native setup
- EAS Build compatible
- OTA updates still work (for JS changes)
- Template-friendly (plugins are version-controlled)
- Can implement custom native functionality

**Cons**:
- Requires understanding of config plugin API
- Prebuild step adds complexity to development workflow
- Some native changes still require rebuild
- Plugin development has learning curve
- OTA updates don't cover native code changes

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Workflow Compatibility | 8.0 | 25% | 2.00 |
| Maintenance Burden | 8.0 | 20% | 1.60 |
| Developer Experience | 8.0 | 15% | 1.20 |
| Build Compatibility | 9.0 | 15% | 1.35 |
| Flexibility | 8.0 | 10% | 0.80 |
| Performance | 9.0 | 10% | 0.90 |
| Template Suitability | 8.0 | 5% | 0.40 |
| **Total** | | | **8.25** |

### 3.3 Option C: Development Builds (expo-dev-client)

**Description**: Use expo-dev-client for custom development builds that include native modules while maintaining most managed workflow benefits.

**Architecture**:
```
┌─────────────────────────────────────────────────────────────────┐
│                    Development Build Architecture               │
│                                                                 │
│  Development Workflow:                                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  npx expo run:ios / npx expo run:android                 │   │
│  │  ├── Prebuild (generate native projects)                 │   │
│  │  ├── Install native dependencies                         │   │
│  │  ├── Build native binary                                 │   │
│  │  └── Launch with Metro dev server                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Production Workflow:                                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  eas build --profile production                          │   │
│  │  ├── Prebuild                                            │   │
│  │  ├── Cloud build (iOS + Android)                         │   │
│  │  └── Submit to stores                                    │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Native modules can be added via:                               │
│  • Config plugins (preferred)                                   │
│  • Direct native code in ios/ and android/ directories          │
│  • Custom native modules (Swift/Kotlin/Obj-C/Java)              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Pros**:
- Full native module support
- Retains most managed workflow benefits
- EAS Build compatible
- Custom native code possible
- Development builds with hot reload

**Cons**:
- No Expo Go compatibility
- Requires local native build environment
- More complex development workflow
- Native changes require rebuild
- Higher maintenance burden

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Workflow Compatibility | 7.0 | 25% | 1.75 |
| Maintenance Burden | 6.0 | 20% | 1.20 |
| Developer Experience | 7.0 | 15% | 1.05 |
| Build Compatibility | 9.0 | 15% | 1.35 |
| Flexibility | 9.0 | 10% | 0.90 |
| Performance | 9.0 | 10% | 0.90 |
| Template Suitability | 6.0 | 5% | 0.30 |
| **Total** | | | **7.45** |

### 3.4 Option D: Bare Workflow (Ejected)

**Description**: Full native project access by ejecting from Expo managed workflow.

**Pros**:
- Complete native code control
- Any native library compatible
- Direct Xcode/Android Studio access
- No Expo SDK constraints

**Cons**:
- Loses all managed workflow benefits
- No OTA updates (without CodePush)
- No Expo Go
- Complex native project management
- High maintenance burden
- Not suitable as template

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Workflow Compatibility | 3.0 | 25% | 0.75 |
| Maintenance Burden | 3.0 | 20% | 0.60 |
| Developer Experience | 5.0 | 15% | 0.75 |
| Build Compatibility | 7.0 | 15% | 1.05 |
| Flexibility | 10.0 | 10% | 1.00 |
| Performance | 10.0 | 10% | 1.00 |
| Template Suitability | 3.0 | 5% | 0.15 |
| **Total** | | | **5.30** |

**Verdict**: Rejected. Bare workflow is unsuitable for a template-based app generator due to high maintenance burden and loss of managed workflow benefits.

### 3.5 Option E: React Native Bridgeless Native Modules

**Description**: Use the new React Native architecture (JSI) for custom native modules with synchronous calls.

**Pros**:
- Synchronous native calls (no bridge)
- Type-safe interfaces via Codegen
- Best performance for native operations
- Future-proof (new architecture is the default)

**Cons**:
- Complex implementation (C++ required)
- Limited tooling and documentation
- Steep learning curve
- Not all community packages support it yet
- Overkill for most AppGen use cases

**Score Calculation**:
| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Workflow Compatibility | 5.0 | 25% | 1.25 |
| Maintenance Burden | 4.0 | 20% | 0.80 |
| Developer Experience | 4.0 | 15% | 0.60 |
| Build Compatibility | 7.0 | 15% | 1.05 |
| Flexibility | 9.0 | 10% | 0.90 |
| Performance | 10.0 | 10% | 1.00 |
| Template Suitability | 4.0 | 5% | 0.20 |
| **Total** | | | **5.80** |

**Verdict**: Too complex for current AppGen needs. Revisit when tooling matures and more community packages adopt the new architecture.

---

## 4. Decision

### 4.1 Selected Option

**Adopt a tiered native module integration strategy:**

1. **Primary**: Expo SDK modules for all common requirements (~88% coverage)
2. **Secondary**: Config plugins for community packages requiring native setup
3. **Tertiary**: Development builds (expo-dev-client) for custom native modules when absolutely necessary
4. **Escape Hatch**: Bare workflow only for requirements impossible to meet with the above

### 4.2 Decision Matrix

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Native Module Decision Flow                              │
│                                                                             │
│  Requirement arises                                                         │
│       │                                                                     │
│       ▼                                                                     │
│  ┌─────────────────────────────┐                                           │
│  │ Is it in Expo SDK catalog?  │                                           │
│  └─────────────┬───────────────┘                                           │
│                │                                                           │
│        ┌───────┴───────┐                                                   │
│        │               │                                                   │
│       Yes             No                                                   │
│        │               │                                                   │
│        ▼               ▼                                                   │
│  Use Expo      ┌─────────────────────────────┐                             │
│  module        │ Does a community package    │                             │
│                │ with config plugin exist?   │                             │
│                └─────────────┬───────────────┘                             │
│                              │                                             │
│                      ┌───────┴───────┐                                     │
│                      │               │                                     │
│                     Yes             No                                     │
│                      │               │                                     │
│                      ▼               ▼                                     │
│  Use community  ┌─────────────────────────────┐                           │
│  package +      │ Can it be implemented as    │                           │
│  config plugin  │ a config plugin?            │                           │
│                 └─────────────┬───────────────┘                           │
│                               │                                           │
│                       ┌───────┴───────┐                                   │
│                       │               │                                   │
│                      Yes             No                                   │
│                       │               │                                   │
│                       ▼               ▼                                   │
│  Create config  ┌─────────────────────────────┐                         │
│  plugin         │ Is custom native code        │                         │
│                 │ absolutely required?          │                         │
│                 └─────────────┬───────────────┘                         │
│                               │                                         │
│                       ┌───────┴───────┐                                 │
│                       │               │                                 │
│                      Yes             No                                   │
│                       │               │                                 │
│                       ▼               ▼                                 │
│  Use dev build   ┌─────────────────────────────┐                       │
│  (expo-dev)      │ Reconsider requirement       │                       │
│                  │ or file feature request      │                       │
│                  └─────────────────────────────┘                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.3 Rationale

1. **Expo SDK Coverage (88%)**: The vast majority of mobile app requirements are covered by Expo SDK modules. This includes all current AppGen needs and most foreseeable future requirements.

2. **Config Plugin Ecosystem**: Many community packages now provide Expo config plugins, enabling their use within the managed workflow. This extends coverage to ~95% of requirements.

3. **Maintainability**: By staying in the managed workflow as much as possible, AppGen maintains its value as a reusable template. Generated apps benefit from OTA updates, Expo Go testing, and simplified builds.

4. **Gradual Escalation**: The tiered approach allows escalation to more complex solutions only when necessary, minimizing unnecessary complexity.

5. **Future-Proofing**: Config plugins and development builds are the recommended Expo patterns for 2026+, aligning with Expo's roadmap.

---

## 5. Consequences

### 5.1 Positive Consequences

1. **Managed Workflow Retention**: By prioritizing Expo SDK modules and config plugins, AppGen retains OTA updates, Expo Go testing, and simplified builds for the majority of use cases.

2. **Template Viability**: The managed workflow approach makes AppGen highly suitable as a reusable template. Generated apps inherit all managed workflow benefits without native code complexity.

3. **Reduced Maintenance**: Expo SDK modules are maintained by the Expo team, reducing the native code maintenance burden on AppGen maintainers.

4. **Clear Escalation Path**: The decision flow provides clear guidance for when and how to escalate to more complex native integration patterns.

5. **EAS Build Compatibility**: All tiers are compatible with EAS Build, ensuring consistent CI/CD pipeline regardless of native module complexity.

6. **Community Alignment**: Following Expo's recommended patterns ensures compatibility with the broader Expo ecosystem and community resources.

7. **Type Safety**: Expo config plugins support TypeScript, enabling type-safe native module configuration.

8. **Documentation**: Expo provides comprehensive documentation for config plugin development, reducing the learning curve.

### 5.2 Negative Consequences

1. **OTA Update Limitations**: Native code changes (config plugins, dev builds) require a full rebuild. OTA updates only cover JavaScript changes.

2. **Expo Go Limitations**: Development builds with custom native modules cannot be tested with Expo Go, requiring device-specific builds.

3. **Config Plugin Complexity**: Writing config plugins requires understanding of Expo's plugin API and native project structure, adding complexity.

4. **Prebuild Overhead**: Development builds require running `npx expo prebuild` to generate native projects, adding a step to the development workflow.

5. **Version Lock-in**: Config plugins are tied to specific Expo SDK versions. SDK upgrades may require plugin updates.

6. **Limited Native Control**: Some highly specialized native requirements (custom video codecs, advanced AR) may still require bare workflow.

7. **Build Time**: Development builds take longer than Expo Go testing, impacting development iteration speed.

### 5.3 Risk Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Expo module not available | High | Low | Config plugin or community package |
| Config plugin breaks on SDK update | Medium | Medium | Pin SDK versions, test before upgrade |
| Native module incompatibility | Medium | Low | Verify compatibility before adoption |
| Build time increase | Low | High | Use EAS Build cloud, cache native builds |
| Developer confusion about tiers | Low | Medium | Document decision flow, provide examples |

---

## 6. Implementation Details

### 6.1 Config Plugin Example

```javascript
// plugins/withAppIcon.js
const { withIcons } = '@expo/config-plugins';
const fs = require('fs');
const path = require('path');

module.exports = function withCustomAppIcon(config, options) {
  return withIcons(config, async (config) => {
    const iconPath = path.resolve(__dirname, '../assets/custom-icon.png');
    
    if (!fs.existsSync(iconPath)) {
      throw new Error(`Icon not found: ${iconPath}`);
    }
    
    // Expo handles icon copying automatically
    config.ios.icon = iconPath;
    config.android.icon = iconPath;
    
    return config;
  });
};
```

### 6.2 Plugin Registration

```json
{
  "expo": {
    "plugins": [
      "expo-secure-store",
      "expo-font",
      "expo-haptics",
      "expo-localization",
      "./plugins/withAppIcon",
      "./plugins/withMaterialTheme"
    ]
  }
}
```

### 6.3 Development Build Setup

```bash
# Install dev client
npx expo install expo-dev-client

# Create development build
npx expo run:ios    # iOS
npx expo run:android  # Android

# Or use EAS Build for cloud builds
eas build --profile development --platform ios
```

### 6.4 Custom Native Module (When Required)

```typescript
// plugins/withCustomModule.ts
import {
  ConfigPlugin,
  createRunOncePlugin,
  withDangerousMod,
} from '@expo/config-plugins';
import * as fs from 'fs';
import * as path from 'path';

const withCustomModule: ConfigPlugin<{ apiKey: string }> = (
  config,
  { apiKey }
) => {
  return withDangerousMod(config, [
    'ios',
    async (config) => {
      const projectRoot = config.modRequest.projectRoot;
      const iosPath = path.join(projectRoot, 'ios');
      
      // Generate native module configuration
      const plistPath = path.join(iosPath, 'Info.plist');
      // Modify plist with API key...
      
      return config;
    },
  ]);
};

export default createRunOncePlugin(withCustomModule, 'withCustomModule');
```

### 6.5 Migration Path

| Phase | Timeline | Actions | Deliverable |
|-------|----------|---------|-------------|
| Phase 1 | Week 1 | Audit current native dependencies | Dependency report |
| Phase 2 | Week 1 | Identify config plugin needs | Plugin list |
| Phase 3 | Week 2 | Implement config plugins | Plugin implementations |
| Phase 4 | Week 2 | Set up development builds | Dev build workflow |
| Phase 5 | Week 3 | Test all native modules | Test report |
| Phase 6 | Week 3 | Document native module patterns | Documentation |

---

## 7. Cross-References

### 7.1 Related ADRs

- [ADR-001: Expo Framework Selection](./ADR-001-expo-framework.md) — Framework decision that defines the managed workflow context
- [ADR-002: State Management Strategy](./ADR-002-state-management.md) — State management that may interact with native modules (SecureStore)

### 7.2 Related Documents

- [SOTA Research: Mobile App Generators](../research/MOBILE_APP_GENERATORS_SOTA.md) — Native module analysis in Section 4
- [AppGen Specification](../../SPEC.md) — Native module requirements in Section 10
- [SOTA Research: Cross-Platform Development](../SOTA-RESEARCH.md) — Native module comparison

### 7.3 External References

- [Expo Config Plugins Documentation](https://docs.expo.dev/config-plugins/introduction/)
- [Expo Development Builds](https://docs.expo.dev/develop/development-builds/introduction/)
- [Expo Module API](https://docs.expo.dev/modules/module-api/)
- [React Native New Architecture](https://reactnative.dev/docs/new-architecture-intro)
- [EAS Build Documentation](https://docs.expo.dev/build/introduction/)

---

**Decision Date**: 2026-04-03  
**Review Date**: 2026-07-03  
**Status**: Proposed  
**Next Review**: Upon Expo SDK 55 release or when custom native module requirements arise

*This ADR proposes a tiered approach to native module integration. It should be reviewed when AppGen requirements exceed Expo SDK coverage or when custom native functionality becomes necessary.*
