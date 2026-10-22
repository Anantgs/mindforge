### 1. Generating the SSH Key Pair

* **Tool & Algorithm**: The client generates an asymmetric key pair using utilities like `ssh-keygen`. Modern systems default to algorithms like **ED25519**, though **RSA** and **ECDSA** are also supported.
* **Private Key**: Stored securely on the local client machine (e.g., in `~/.ssh/`). It is kept strictly confidential and **never leaves the client machine or moves over the network**.
* **Public Key**: Named with a `.pub` extension (e.g., `id_ed25519.pub`). This key is non-confidential and can be freely distributed.

---

### 2. Placing the Public Key on the Server

* **Copying the Key**: The user transfers their public key to the destination server using commands like `ssh-copy-id`.
* **Authorized Keys File**: On the server, the client's public key is appended to `~/.ssh/authorized_keys` in the target user's home directory.

---

### 3. How the Client Connects to the Server (SSH Mutual Authentication Flow)

In SSH, encryption is established **at the very start of the session**, and both server and client authenticate each other (with the server proving its identity first).

#### Phase A: Session Encryption Setup (ECDH / Diffie-Hellman)
1. **Ephemeral Key Exchange**: The client and server exchange temporary (ephemeral) public parameters over the network using **ECDH (Elliptic Curve Diffie-Hellman)** or Diffie-Hellman algorithms.
2. **Independent Session Key Derivation**: Using Diffie-Hellman mathematics, both client and server independently compute the exact same **symmetric session key** locally.
3. **Zero Network Transmission**: Because the symmetric session key is derived independently on both machines, it is **never transmitted across the wire**, preventing eavesdroppers from capturing it. All subsequent authentication traffic flows inside this encrypted tunnel.

#### Phase B: Server Identity Authentication
1. **Host Fingerprint Presentation**: The server sends the fingerprint of its host public key (e.g., ED25519 or ECDSA) through the encrypted tunnel to the client.
2. **Verification via `known_hosts`**: 
   * The client checks this fingerprint against its local `~/.ssh/known_hosts` file.
   * On first connection (**Trust on First Use**), the client prompts the user to accept the fingerprint, saving it into `known_hosts` for future connections.

#### Phase C: Client Identity Authentication (Challenge-Response)
1. **Random Challenge**: The server generates a random text string (**challenge**) and sends it to the client.
2. **Client Signing**: The client signs the challenge using its local **private key** and sends the signed payload back to the server. *(The client's private key never leaves the client system)*.
3. **Server Signature Verification**: The server retrieves the client's public key from `~/.ssh/authorized_keys` and verifies the digital signature.

#### Phase D: Access Granted
* **Authorized Session**: Once the server verifies that the challenge was signed by the private key matching the public key in `authorized_keys`, access is granted.
* **Symmetric Communication**: The interactive SSH session proceeds using the high-speed symmetric session key established in Phase A.

---