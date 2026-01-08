# PassVault 🔐

<p align="center">
  <img src="assets/icons/logo.png" width="120" alt="PassVault Logo"/>
</p>

<p align="center">
  <strong>A secure, offline-first password manager built with Flutter.</strong>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#documentation">Documentation</a>
</p>

---

## ✨ Features

### 🔒 Security First
- **AES-256 Encryption** - All passwords encrypted locally via Hive CE
- **Biometric Authentication** - Face ID, Touch ID, fingerprint
- **Offline-Only** - Your data never leaves your device
- **Secure Key Management** - Master keys stored in system keychain (SecureStorage)

### 🎨 Modern Design
- **Material Design 3** - Beautiful, adaptive UI
- **Multiple Themes** - Light, Dark, and AMOLED modes
- **Smooth Animations** - Delightful micro-interactions

### ⚡ Powerful Features
- **Smart Password Generator** - Customizable strength settings
- **Encrypted Export/Import** - Backup data in secure `.pvault` format (AES-GCM)
- **JSON/CSV Support** - Standard formats for data portability
- **Quick Copy** - One-tap copy to clipboard
- **Search & Filter** - Quickly find credentials

---

## 📱 Screenshots

| Light Mode | Dark Mode | AMOLED Mode |
|:----------:|:---------:|:-----------:|
| ![Light](screenshots/light.png) | ![Dark](screenshots/dark.png) | ![AMOLED](screenshots/amoled.png) |

---

## 🚀 Quick Start

```bash
# Clone & setup
git clone https://github.com/dhruvanbhalara/passvault.git
cd passvault
flutter pub get
make generate
make setup_hooks

# Run
make run_dev
```

See [Development Guide](docs/DEVELOPMENT.md) for detailed setup.

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | Project structure & design principles |
| [Tech Stack](docs/TECH_STACK.md) | Dependencies & packages |
| [Development](docs/DEVELOPMENT.md) | Setup, Makefile, Git hooks |
| [Testing](docs/TESTING.md) | Test structure & coverage |
| [Security Details](docs/ENCRYPTED_STORAGE.md) | AES-256-GCM implementation |

---

## 🔐 Security

| Measure | Status |
|---------|--------|
| Zero Network Access | ✅ |
| Biometric Gating | ✅ |
| Secure Key Storage | ✅ |
| AES-256 Encrypted Storage | ✅ |
| Password-Protected Exports | ✅ |

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 👨‍💻 Author

**Dhruvan Bhalara** - [@dhruvanbhalara](https://github.com/dhruvanbhalara)

<p align="center">
  Made with ❤️ and Flutter
</p>
