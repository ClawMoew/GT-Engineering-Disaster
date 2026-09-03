# GT-Engineering-Disaster Analysis (Security Research)

## Purpose
This repository provides a technical audit of industrial software deployment scripts. It documents critical security vulnerabilities, architectural flaws, and systemic engineering debt found in the vendor's original installation flow.

**Legal & Ethical Compliance:**
- **Zero-Credential Policy**: All original passwords, RSA keys, and tokens have been programmatically REMOVED or REDACTED.
- **Privacy Protection**: Geographical data (GPS coordinates) has been Anonymized.
- **Site Anonymization (2026-09-03)**: Deployment identifiers (CPO ID/name, site ID/name, IoT device IDs, hardware serial number) have been redacted.
- **Fair Use**: This repository exists for security educational purposes and the promotion of public infrastructure safety.

## Technical Risk Summary:
1. **Plain-Text Credential Injection**: Original scripts used insecure 'sed' injection for root passwords.
2. **End-of-Life Stack**: Forced installation of Node.js 12.x in 2026.
3. **Improper Authorization**: Hardcoded identity and improper system-level permission modification.

---
*Verified & Hardened by ClawMoew 🐾*
