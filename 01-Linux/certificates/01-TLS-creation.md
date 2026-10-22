### 1. How a Certificate Signing Request (CSR) is Generated

1. **Private Key Generation**: 
   * The client or server generates an asymmetric **private key** (e.g., using `openssl` or `ssh-keygen`). 
   * This private key remains strictly confidential on the local machine and is never transmitted across the network.
2. **CSR Assembly**: 
   * A **Certificate Signing Request (CSR)** file is created using the newly generated private key.
   * The CSR packages the applicant's **public key** alongside identity metadata, including the **Common Name (CN)** (e.g., domain name or username), organization details, expiration constraints, and Subject Alternative Names (SANs).
3. **CSR Submission**: 
   * The applicant submits this base64-encoded CSR to a Certificate Authority (CA) or creates a `CertificateSigningRequest` object inside Kubernetes.

---

### 2. How the Signed Certificate is Generated

1. **Identity & Ownership Verification**: 
   * The Certificate Authority inspects the submitted CSR and validates domain ownership or requires administrative approval (such as running `kubectl certificate approve` in Kubernetes).
2. **Signing with the CA's Private Key**: 
   * Once approved, the CA extracts the applicant's public key and metadata from the CSR.
   * The CA signs this bundle using the **CA's own private key** to issue a digital certificate (`.crt` / `.pem`).
3. **Certificate Contents**: 
   * The final issued certificate contains the applicant's public key, subject identity details, issuance/expiration dates, and the CA's digital signature.

---

### 3. How the Client Connects to the Server

1. **Connection Request**: 
   * The client (e.g., web browser or `kubectl` CLI) initiates an HTTPS/TLS connection request to the server.
2. **Server Certificate Presentation**: 
   * The server responds by presenting its CA-signed digital certificate. *(In Mutual TLS / mTLS, both the client and server present their respective signed certificates to each other).*
3. **CA Signature Verification**: 
   * The client checks the server's certificate against the **CA's public key** pre-installed in its browser trust store or stored in the `kubeconfig` file (`certificate-authority-data`).
   * If the signature verifies successfully, the client confirms the server's authentic identity.

---

### 4. How Key Exchange Takes Place (ECDHE)

1. **Ephemeral Parameter Exchange**: 
   * In modern TLS (TLS 1.3 or TLS 1.2 using ECDHE), key exchange is handled via **Elliptic Curve Diffie-Hellman Ephemeral (ECDHE)**.
   * The client and server exchange temporary (ephemeral) public key parameters over the network connection.
2. **Independent Local Key Derivation**: 
   * Using Diffie-Hellman algorithms, both the client and server independently compute the exact same **symmetric session key** locally.
3. **Zero Transmission of Secret Keys**: 
   * Because both parties derive the session key independently on their own systems, the symmetric key itself is **never transmitted over the network**. This ensures that even if a server's long-term private key were ever leaked, past encrypted sessions cannot be decrypted.

---

### 5. How Communication Happens in TLS

1. **Shared Secret Activation**: 
   * Both client and server now share an identical symmetric session key.
2. **Bulk Symmetric Encryption**: 
   * All subsequent application traffic (HTTP request/response bodies, API commands, banking payloads) is encrypted and decrypted using fast **symmetric encryption** (such as AES 256-bit).
3. **Combined Efficiency**: 
   * Asymmetric cryptography successfully completes identity verification and safe session key derivation, allowing high-speed symmetric encryption to handle all ongoing data transfer.