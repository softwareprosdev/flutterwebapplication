# <p align="center"><img src="https://readme-typing-svg.herokuapp.com?font=Orbitron&weight=700&size=48&color=00E5FF&center=true&vCenter=true&width=800&height=80&lines=Crypto+Mecca+Wallet&animation=glow-blur-infinite"></p>

<p align="center">
  <a href="https://github.com/softwareprosdev/flutterwebapplication"><img src="https://img.shields.io/badge/version-1.0.0-00E5FF?style=for-the-badge&logo=dart&logoColor=00E5FF"></a>
  <a href="https://github.com/softwareprosdev/flutterwebapplication"><img src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter"></a>
  <a href="https://github.com/softwareprosdev/flutterwebapplication"><img src="https://img.shields.io/badge/License-MIT-FF3DF2?style=for-the-badge"></a>
  <a href="https://github.com/softwareprosdev/flutterwebapplication"><img src="https://img.shields.io/badge/Status-Active-2DFF8F?style=for-the-badge"></a>
</p>

---

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=00E5FF&height=200&section=header&textSize=80&fontAlignY=35&animation=glow-waving&desc=Enterprise+Crypto+Wallet&descAlignY=50&descSize=24&descColor=8B5CF6" width="100%"/>
</p>

## <p align="center">🔐 Secure • 🌍 Cross-Platform • ⚡ Enterprise-Grade</p>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Security](#-security)
- [Getting Started](#-getting-started)
- [Deployment](#-deployment)
- [Screenshots](#-screenshots)
- [Tech Stack](#-tech-stack)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**Crypto Mecca Wallet** is an enterprise-grade, non-custodial cryptocurrency wallet built with Flutter. It provides comprehensive crypto asset management, portfolio tracking, mining ROI calculations, and affiliate e-commerce integration - all with a stunning neon-dark UI.

<p align="center">
  <img src="https://komarev.com/ghpvc/?username=softwareprosdev&repo=flutterwebapplication&style=for-the-badge&color=00E5FF&label=Views" alt="views"/>
  <img src="https://img.shields.io/github/forks/softwareprosdev/flutterwebapplication?style=for-the-badge&color=FF3DF2" alt="forks"/>
  <img src="https://img.shields.io/github/stars/softwareprosdev/flutterwebapplication?style=for-the-badge&color=2DFF8F" alt="stars"/>
</p>

---

## ✨ Features

### 🔑 Wallet Features
| Feature | Description |
|---------|-------------|
| **HD Wallet Generation** | BIP39 mnemonic generation with BIP32 derivation |
| **Multi-Chain Support** | Bitcoin, Ethereum, Solana support |
| **Secure Storage** | Platform-backed encrypted keystore |
| **2FA Integration** | TOTP-based two-factor authentication |
| **Address Whitelisting** | Trusted address management |

### 📊 Portfolio Features
| Feature | Description |
|---------|-------------|
| **Multi-Asset Tracking** | Track 50+ cryptocurrencies |
| **Profit/Loss Analysis** | Real-time P&L calculations |
| **Price Alerts** | Customizable notifications |
| **Historical Charts** | Interactive price history |

### ⛏️ Mining Features
| Feature | Description |
|---------|-------------|
| **ROI Calculator** | Calculate mining profitability |
| **Hardware Suggestions** | Recommended mining equipment |
| **Power Cost Analysis** | Electricity cost tracking |

### 🛒 E-Commerce Features
| Feature | Description |
|---------|-------------|
| **Hardware Wallets** | Ledger, Trezor affiliate links |
| **Mining Equipment** | Antminer, WhatsMiner deals |
| **Cold Storage** | Steel wallet backups |
| **Affiliate Tracking** | Commission tracking |

---

## 🏗️ Architecture

```mermaid
flowchart TB
    subgraph Presentation
        UI[UI Layer - Flutter Widgets]
        BLOC[State Management - BLoC]
    end
    
    subgraph Domain
        USECASE[Use Cases]
        ENTITY[Entities]
        REPO_INTERFACE[Repository Interfaces]
    end
    
    subgraph Data
        API[API Services]
        STORAGE[Secure Storage]
        CACHE[Local Cache]
    end
    
    UI --> BLOC
    BLOC --> USECASE
    USECASE --> REPO_INTERFACE
    REPO_INTERFACE --> API
    REPO_INTERFACE --> STORAGE
    REPO_INTERFACE --> CACHE
    
    style UI fill:#0B1020,stroke:#00E5FF,color:#00E5FF
    style BLOC fill:#0B1020,stroke:#FF3DF2,color:#FF3DF2
    style USECASE fill:#0B1020,stroke:#8B5CF6,color:#8B5CF6
    style API fill:#0B1020,stroke:#2DFF8F,color:#2DFF8F
    style STORAGE fill:#0B1020,stroke:#FFB020,color:#FFB020
```

```mermaid
sequenceDiagram
    participant User
    participant App
    participant API
    participant Storage
    
    User->>App: Open App
    App->>Storage: Check wallet exists
    Storage-->>App: Wallet state
    App->>API: Fetch prices
    API-->>App: Price data
    App->>User: Display Dashboard
    
    User->>App: Send Transaction
    App->>Storage: Verify 2FA
    Storage-->>App: Verified
    App->>API: Broadcast tx
    API-->>App: TX confirmed
    App->>User: Success
```

```mermaid
flowchart LR
    subgraph Security Layers
        SSL[SSL Pinning] --> AUTH[Authentication]
        AUTH --> ENC[Encryption]
        ENC --> WALLET[Wallet Security]
        WALLET --> COMPLIANCE[VASP Compliance]
    end
    
    subgraph Crypto Operations
        GEN[Key Generation] --> DERIVE[HD Derivation]
        DERIVE --> SIGN[Transaction Signing]
        SIGN --> VERIFY[Verification]
    end
    
    style Security Layers fill:#05070D,stroke:#00E5FF,stroke-width:2px
    style Crypto Operations fill:#05070D,stroke:#FF3DF2,stroke-width:2px
```

---

## 🔒 Security

### Implemented Security Measures

```
┌─────────────────────────────────────────────────────────────┐
│                    SECURITY LAYERS                           │
├─────────────────────────────────────────────────────────────┤
│  🔐 SSL/TLS Pinning        →  Dio Interceptors            │
│  🔐 Secure Storage         →  flutter_secure_storage      │
│  🔐 HD Wallet              →  BIP39/BIP32                 │
│  🔐 2FA                   →  TOTP Algorithm               │
│  🔐 Transaction Verify     →  Address Whitelisting        │
│  🔐 Code Obfuscation      →  Flutter Obfuscator          │
│  🔐 VASP Compliance       →  US/EU/UK/CA/KR              │
└─────────────────────────────────────────────────────────────┘
```

### VASP Compliance Jurisdictions

| Region | Regulator | Status |
|--------|-----------|--------|
| 🇺🇸 USA | FinCEN | ✅ Compliant |
| 🇪🇺 EU | AMLD5/6 | ✅ Compliant |
| 🇬🇧 UK | FCA | ✅ Compliant |
| 🇨🇦 Canada | FINTRAC | ✅ Compliant |
| 🇰🇷 South Korea | PFSO | ✅ Compliant |

---

## 🚀 Getting Started

### Prerequisites

```bash
# Required tools
Flutter SDK >= 3.24.0
Dart SDK >= 3.5.0
Docker (optional)
Git
```

### Installation

```bash
# Clone the repository
git clone https://github.com/softwareprosdev/flutterwebapplication.git
cd flutterwebapplication

# Install dependencies
flutter pub get

# Run in development mode
flutter run

# Build for web
flutter build web --release --tree-shake-icons --wasm --web-renderer skwasm
```

### Environment Variables

Create `.env` file:

```env
# API Keys
COINGECKO_API_KEY=your_api_key
INFURA_PROJECT_ID=your_infura_id
ALCHEMY_API_KEY=your_alchemy_key

# RevenueCat (iOS/Android)
REVENUECAT_API_KEY=test_xxx

# Affiliate Links
LEDGER_AFFILIATE_ID=your_ledger_id
TREZOR_AFFILIATE_ID=your_trezor_id
```

---

## 📦 Build & Deployment

### Web Build

```bash
# Production build with all optimizations
flutter build web \
  --release \
  --tree-shake-icons \
  --wasm \
  --web-renderer skwasm \
  --no-source-maps

# Output: build/web/
```

### Docker Build

```bash
# Build Docker image
docker build -t crypto-mecca-wallet .

# Run container
docker run -d -p 8080:8080 crypto-mecca-wallet
```

### Deploy to Coolify

```mermaid
flowchart LR
    A[Git Push] --> B[GitHub Actions]
    B --> C[Build Flutter Web]
    B --> D[Build Docker]
    C --> E[Upload to Coolify]
    D --> E
    E --> F[Traefik SSL]
    F --> G[Cloudflare CDN]
```

1. **Create Coolify App** → Select "Docker" type
2. **Configure Domain** → `cal.zerodayinstitute.com`
3. **Set Environment** → Add API keys
4. **Deploy** → Connect GitHub repository

---

## 🖥️ Screenshots

<p align="center">
  <img src="https://via.placeholder.com/400x800/05070D/00E5FF?text=Dashboard" width="200" alt="Dashboard"/>
  <img src="https://via.placeholder.com/400x800/05070D/FF3DF2?text=Wallet" width="200" alt="Wallet"/>
  <img src="https://via.placeholder.com/400x800/05070D/8B5CF6?text=Mining" width="200" alt="Mining"/>
</p>

### UI Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| 🔵 Primary Neon | `#00E5FF` | Main accent, buttons |
| 🟣 Secondary Neon | `#FF3DF2` | Secondary actions |
| 🟢 Accent Lime | `#2DFF8F` | Success states |
| 🟠 Warning | `#FFB020` | Warnings |
| 🔴 Error | `#FF4757` | Errors |
| ⚫ Background | `#05070D` | Dark base |
| ⚪ Surface | `#0B1020` | Cards, panels |

---

## 🛠️ Tech Stack

### Framework & Language

<p align="left">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
</p>

### State Management

<p align="left">
  <img src="https://img.shields.io/badge/BLoC-6.1DFF?style=for-the-badge&logoColor=white" alt="BLoC"/>
  <img src="https://img.shields.io/badge/Riverpod-2.5.1?style=for-the-badge&logoColor=white" alt="Riverpod"/>
</p>

### Security

| Package | Purpose |
|---------|---------|
| `flutter_secure_storage` | Encrypted key storage |
| `bip39` / `bip32` | HD wallet derivation |
| `encrypt` | AES encryption |
| `otp` | 2FA TOTP |
| `crypto` | Hashing functions |

### Networking

| Package | Purpose |
|---------|---------|
| `dio` | HTTP client with interceptors |
| `http` | REST API calls |

### UI/UX

| Package | Purpose |
|---------|---------|
| `fl_chart` | Charts & graphs |
| `google_fonts` | Typography |
| `shimmer` | Loading effects |

---

## 📁 Project Structure

```
crypto_mecca_wallet/
├── lib/
│   ├── core/
│   │   ├── constants/       # Colors, configs
│   │   ├── theme/           # App theme
│   │   ├── security/         # Wallet, 2FA, encryption
│   │   ├── network/          # SSL pinning
│   │   └── compliance/       # VASP compliance
│   ├── data/
│   │   ├── models/          # Data models
│   │   ├── repositories/    # Data access
│   │   └── services/        # API services
│   └── presentation/
│       ├── screens/          # UI screens
│       ├── widgets/          # Reusable widgets
│       └── bloc/             # State management
├── assets/                   # Images, fonts
├── scripts/                  # Build scripts
├── docker/                   # Docker configs
└── .github/
    └── workflows/            # CI/CD pipelines
```

---

## 🤝 Contributing

1. **Fork** the repository
2. **Create** your feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- [CoinGecko API](https://www.coingecko.com) - Crypto price data
- [Flutter Team](https://flutter.dev) - Cross-platform framework
- [Ledger](https://www.ledger.com) - Hardware wallet partner
- [Trezor](https://www.trezor.io) - Hardware wallet partner

---

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=00E5FF&height=100&section=footer&animation=glow-pulse&text=Made+with+♥+by+Crypto+Mecca+Team" width="100%"/>
</p>

---

<p align="center">
  <sub>© 2026 Crypto Mecca Wallet. All rights reserved.</sub>
</p>