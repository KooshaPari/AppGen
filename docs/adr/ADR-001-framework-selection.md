# ADR-001: Cross-Platform Framework Selection for AppGen

**Date**: 2026-04-04  
**Status**: Accepted  
**Deciders**: KooshaPari  

## Context

AppGen is a React Native boilerplate optimized for utility-style mobile applications. The project requires:

1. **Cross-platform deployment** targeting iOS and Android from a single codebase
2. **Native performance** for utility applications requiring smooth interactions
3. **Rapid development** with hot reload and extensive ecosystem
4. **Long-term maintainability** with strong community support
5. **Modern UI capabilities** supporting Material Design 3 theming
6. **Efficient resource usage** for utility-style applications

The mobile development landscape in 2026 offers multiple cross-platform solutions. We need to evaluate the optimal framework for AppGen's specific use case.

## Decision Drivers

| Driver | Weight | Description |
|--------|--------|-------------|
| Performance | High | Native-level performance for utility apps |
| Ecosystem | High | Access to libraries, tools, and community |
| Developer Experience | High | Fast iteration, debugging, hot reload |
| Bundle Size | Medium | Reasonable app size for distribution |
| Learning Curve | Medium | Accessible for JavaScript developers |
| Native Integration | Medium | Easy access to native modules when needed |
| Maintenance | High | Long-term viability and updates |

## Options Considered

### Option A: React Native with Expo (Selected)

**Pros**:
- **Mature ecosystem**: 500K+ npm packages, extensive community
- **Native performance**: Direct native rendering via Yoga layout engine
- **New architecture (0.74+)**: Fabric renderer and JSI for synchronous native calls
- **Hermes engine**: 30-40% faster startup than JSC
- **Expo SDK 51+**: Comprehensive native modules without ejecting
- **Hot reload**: Industry-standard development experience
- **TypeScript first**: Excellent type safety support
- **Material Design 3**: React Native Paper provides complete M3 implementation
- **EAS Build**: Cloud-based build infrastructure with OTA updates

**Cons**:
- Bridge overhead in old architecture (mitigated by new architecture)
- Native module integration complexity for custom native code
- iOS requires macOS for builds
- Larger bundle than pure native (mitigated by Hermes)

**Performance Benchmarks**:
| Metric | React Native | Target |
|--------|--------------|--------|
| TTI (Time to Interactive) | 1.5s | <2s |
| Bundle Size (Android) | ~15MB | <20MB |
| Memory Usage | 100MB | <150MB |
| Frame Rate | 60fps | 60fps |

### Option B: Flutter

**Pros**:
- Consistent rendering via Skia (60fps guaranteed)
- Single language (Dart) for UI and logic
- Smaller bundle size (~4MB)
- Growing enterprise adoption
- Hot reload with state preservation

**Cons**:
- Smaller ecosystem than React Native
- Dart learning curve for JavaScript developers
- Native module integration more complex
- Limited Material Design 3 adoption compared to React Native Paper
- Smaller talent pool for hiring

**Verdict**: Strong contender, but React Native's ecosystem advantage outweighs Flutter's benefits for utility applications.

### Option C: Ionic/Capacitor

**Pros**:
- Web-first development model
- Largest ecosystem (all npm packages)
- Fastest prototyping
- PWA capabilities

**Cons**:
- WebView rendering limitations
- Performance ceiling for animations
- Native feel compromises
- Not suitable for utility apps requiring native performance

**Verdict**: Rejected due to WebView performance limitations.

### Option D: NativeScript

**Pros**:
- Direct native API access
- JavaScript/TypeScript
- Native UI components

**Cons**:
- Small ecosystem (~1K packages)
- Limited community support
- Slower development iteration
- Declining adoption

**Verdict**: Rejected due to ecosystem size and maintenance concerns.

### Option E: SwiftUI + Jetpack Compose

**Pros**:
- Native performance (100% native)
- First-party framework support
- Platform-specific optimizations

**Cons**:
- Two separate codebases required
- Twice the development effort
- Skill diversity required (Swift + Kotlin)
- No cross-platform benefits

**Verdict**: Rejected for AppGen's cross-platform requirements.

## Decision

**Adopt React Native 0.74+ with Expo SDK 51+ as the primary framework for AppGen.**

### Rationale

1. **Ecosystem Dominance**: React Native has the largest ecosystem of any cross-platform framework, with 500K+ npm packages and extensive community resources.

2. **New Architecture Maturity**: React Native 0.74+ with the new architecture (Fabric + JSI) eliminates previous performance concerns:
   - Synchronous native calls via JSI
   - Fabric renderer for 60fps animations
   - TurboModules for type-safe native modules

3. **Expo Integration**: Expo SDK provides:
   - Managed workflow for zero native configuration
   - Comprehensive native modules (camera, location, notifications, etc.)
   - EAS Build for cloud-based CI/CD
   - OTA updates without app store review

4. **Material Design 3**: React Native Paper v5 provides the most complete Material Design 3 implementation available in the cross-platform ecosystem.

5. **Performance**: With Hermes engine and new architecture, React Native achieves:
   - 1.5s TTI (Time to Interactive)
   - 60fps animations with Reanimated 3
   - ~15MB bundle size

6. **Developer Experience**: Hot reload, Flipper debugging, and Metro bundler provide industry-leading development experience.

## Implementation Details

### Technology Stack

```
Framework: React Native 0.74+
Expo SDK: 51+
Navigation: React Navigation v6 (native-stack)
UI Library: React Native Paper v5
State Management: Zustand + React Query
Animation: Reanimated v3
Build: EAS Build
JavaScript Engine: Hermes
```

### Configuration

```json
// app.json
{
  "expo": {
    "name": "AppGen",
    "slug": "appgen",
    "version": "1.0.0",
    "orientation": "portrait",
    "newArchEnabled": true,
    "jsEngine": "hermes",
    "plugins": [
      "expo-secure-store",
      "expo-localization"
    ]
  }
}
```

### Migration Path

| Phase | Timeline | Actions |
|-------|----------|---------|
| Phase 1 | Week 1 | Upgrade to React Native 0.74, enable new architecture |
| Phase 2 | Week 2 | Migrate to Expo SDK 51+ |
| Phase 3 | Week 3 | Configure Hermes, optimize Metro bundler |
| Phase 4 | Week 4 | Performance testing and optimization |

## Consequences

### Positive

1. **Performance**: Hermes engine + new architecture delivers native-level performance
2. **Ecosystem**: Access to 500K+ npm packages
3. **Maintenance**: Strong community ensures long-term viability
4. **Development Speed**: Hot reload and Expo managed workflow accelerate iteration
5. **Hiring**: Large talent pool of React Native developers
6. **Tooling**: Mature tooling ecosystem (Flipper, React DevTools, etc.)

### Negative

1. **Native Complexity**: Custom native modules require ejecting from managed workflow
2. **Build Requirements**: iOS builds require macOS (or EAS Build)
3. **Bundle Size**: Larger than Flutter (~15MB vs ~4MB), mitigated by Hermes
4. **Architecture Migration**: New architecture requires library compatibility updates

## Performance Baselines

| Metric | Target | Measurement |
|--------|--------|-------------|
| TTI | <2s | Lighthouse-like measurement |
| Bundle Size | <15MB | Android APK analysis |
| Memory Usage | <100MB | Average during usage |
| Frame Rate | 60fps | Reanimated performance |
| Startup Time | <1.5s | Cold start measurement |

## References

- [React Native New Architecture](https://reactnative.dev/docs/new-architecture-intro)
- [Expo Documentation](https://docs.expo.dev)
- [Hermes Engine](https://hermesengine.dev)
- [React Native Paper](https://callstack.github.io/react-native-paper)
- [React Navigation](https://reactnavigation.org)
- [SOTA Research: Cross-Platform Mobile Development](./SOTA-RESEARCH.md)

---

*This ADR defines the foundational framework decision for AppGen. Architecture-specific decisions are covered in ADR-002 and ADR-003.*
