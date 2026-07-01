---
name: LexSecure Digital
colors:
  surface: '#031427'
  surface-dim: '#031427'
  surface-bright: '#2a3a4f'
  surface-container-lowest: '#000f21'
  surface-container-low: '#0b1c30'
  surface-container: '#102034'
  surface-container-high: '#1b2b3f'
  surface-container-highest: '#26364a'
  on-surface: '#d3e4fe'
  on-surface-variant: '#c3c6d7'
  inverse-surface: '#d3e4fe'
  inverse-on-surface: '#213145'
  outline: '#8d90a0'
  outline-variant: '#434655'
  surface-tint: '#b4c5ff'
  primary: '#b4c5ff'
  on-primary: '#002a78'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#0053db'
  secondary: '#c3c6d7'
  on-secondary: '#2c303e'
  secondary-container: '#424655'
  on-secondary-container: '#b1b4c6'
  tertiary: '#ffb596'
  on-tertiary: '#581e00'
  tertiary-container: '#bc4800'
  on-tertiary-container: '#ffede6'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#dfe2f4'
  secondary-fixed-dim: '#c3c6d7'
  on-secondary-fixed: '#171b28'
  on-secondary-fixed-variant: '#424655'
  tertiary-fixed: '#ffdbcd'
  tertiary-fixed-dim: '#ffb596'
  on-tertiary-fixed: '#360f00'
  on-tertiary-fixed-variant: '#7d2d00'
  background: '#031427'
  on-background: '#d3e4fe'
  surface-variant: '#26364a'
  compliance-success: '#10B981'
  compliance-warning: '#F59E0B'
  compliance-alert: '#EF4444'
  surface-deep: '#0B0B13'
  surface-document: '#262B3C'
typography:
  headline-xl:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-mono:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  headline-xl-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  gutter: 24px
  margin: 32px
  container-max-width: 1440px
---

## Brand & Style
The brand personality is authoritative, secure, and meticulously organized. This design system serves a high-stakes legal RegTech environment where trust is the primary currency. The visual narrative moves away from traditional tech aesthetics toward a "Digital Legal File" metaphor—clean, structured, and permanent.

The design style is **Corporate / Modern** with a focus on **Tonal Layering**. It prioritizes extreme legibility and a sense of "digital weight," mimicking the gravity of physical legal documents while leveraging the efficiency of modern SaaS. Interfaces should feel quiet and focused, reducing cognitive load for compliance officers and legal counsel.

## Colors
The palette is anchored by a deep navy and slate foundation to establish a professional, low-glare environment suitable for long periods of document review. 

- **Primary Action:** The bright corporate blue (#2563EB) is reserved exclusively for high-intent actions like "Iniciar Análisis de IA" or "Confirmar Cumplimiento."
- **Functional States:** Mint green is used for "Sello Digital" verification and successful compliance statuses. Amber and soft red are used for "Advertencia de Riesgo" and "Incumplimiento" respectively.
- **Surface Strategy:** Use #0B0B13 for the global background and #1E222F for primary containers. Use #262B3C for "active" or "focused" legal cards to create a subtle sense of elevation.

## Typography
We utilize **Inter** for all user interface elements to ensure maximum legibility across dense data tables and legal text. The typeface is chosen for its neutral, professional tone and exceptional rendering at small sizes.

- **Headlines:** Use Semi-Bold weights to provide clear hierarchy in "Panel de Control" and "Análisis de IA" sections.
- **Monospace:** **JetBrains Mono** is strictly reserved for cryptographic hashes, digital signatures, and "Sello Digital" metadata. It should never be used for standard UI labels.
- **Terminology:** All labels must use professional legal-tech terminology. Replace "Submit" with "Registrar Sello," "Process" with "Ejecutar Análisis," and "System Error" with "Fallo de Cumplimiento."

## Layout & Spacing
This design system utilizes a **Fixed Grid** model for desktop to maintain the "legal file" appearance, where content feels contained and structured.

- **Grid:** A 12-column grid with 24px gutters.
- **Rhythm:** An 8px base scaling system is used for component spacing, with 4px used for tight internal element padding (e.g., within a Sello Digital badge).
- **Reflow:** On mobile devices, the 12-column layout collapses into a single-column stack with 16px side margins. High-density data tables should transition to card-based summaries to maintain readability.

## Elevation & Depth
Hierarchy is conveyed through **Tonal Layers** supplemented by very soft, large-radius shadows that mimic the subtle lift of a paper folder off a desk.

- **Base Level:** `#0B0B13` (The desk).
- **Container Level:** `#1E222F` (The folder).
- **Active Level:** `#262B3C` with a `0px 4px 20px rgba(0,0,0,0.4)` shadow (The document in hand).
- **Interactive Elements:** Use 1px low-contrast outlines (`#334155`) instead of heavy shadows to keep the interface looking precise and sharp.

## Shapes
The shape language is "Soft Professional." While sharp corners feel too aggressive, overly rounded "bubble" shapes feel too casual for RegTech. 

- **Standard Radius:** 0.5rem (8px) for cards, input fields, and buttons. This provides a modern, approachable feel while maintaining a sense of structure.
- **Labels/Chips:** Use the `rounded-lg` (1rem) setting for "Estado de Cumplimiento" badges to differentiate them from actionable buttons.
- **Iconography:** Icons should be medium-stroke (2px) with slightly rounded terminals to match the shape language of the containers.

## Components
- **Buttons:** Primary buttons use the Corporate Blue. Text must be in All-Caps or Title Case for "Acciones Legales." Secondary buttons use a ghost style with a 1px border.
- **Digital Files (Cards):** These are the core of the system. They should have a subtle top-border accent (Primary Blue for active, Mint for compliant) and contain a "Sello Digital" section in the footer using the Monospace font.
- **Analysis Chips:** Used for "Análisis de IA." These should include a small spark icon and use a subtle blue-tinted background to distinguish AI-generated insights from human-entered data.
- **Inputs:** High-contrast fields with #FFFFFF text and clear focus states. Error states should change the border to `compliance-alert` and include a descriptive "Advertencia de Cumplimiento" message.
- **Sello Digital Badge:** A specialized component containing a shortened hash in JetBrains Mono and a timestamp. It should look "stamped" or "verified" through the use of a subtle background tint.