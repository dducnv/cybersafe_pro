# CYBERSAFE PRO ENCRYPTION SYSTEM DOCUMENTATION

## 1. Overview

`EncryptAppDataService` is the central service managing all encryption and decryption processes within the CyberSafe Pro application. This service is designed to protect sensitive information such as passwords, account details, and TOTP codes.

### Key Features:
- Implements a Singleton pattern with a globally accessible instance
- Deploys multiple encryption layers for different data types
- Supports in-memory key protection mechanism (Orchestration Key)
- Features an efficient key caching system
- Provides backup creation and restoration capabilities
- Supports data migration from legacy versions

## 2. Structure and Configuration

### EncryptionConfig
Configuration class containing essential constants:
- `PBKDF2_ITERATIONS`: 20,000 (iterations for PBKDF2 algorithm)
- `KEY_SIZE_BYTES`: 32 (key size)
- `MIN_PIN_LENGTH`: 6 (minimum PIN length)
- `MAX_BACKUP_SIZE_MB`: 50 (maximum backup file size)
- `RETRY_DELAY`: 1 second (delay between retry attempts)
- `MAX_RETRY_ATTEMPTS`: 3 (maximum retry attempts)
- `KEY_CACHE_DURATION`: 15 minutes (key caching duration)

### KeyType Enum
Defines different encryption key types:
- `info`: For general information encryption
- `password`: For password encryption
- `totp`: For TOTP code encryption
- `pinCode`: For PIN code encryption

## 3. Operational Mechanism

### 3.1 Key Initialization and Management

#### Device Key
- Root key, randomly generated during app installation
- Securely stored in SecureStorage
- Used as the foundation for generating other encryption keys

#### Orchestration Key
- Generated based on device information, timestamp, and app signature
- Not stored persistently, exists only in memory while app is running
- Used to protect (XOR) encryption keys in memory
- Cleared when app enters background mode

#### Encryption Keys
- Generated from Device Key using PBKDF2 algorithm
- Types: info key, password key, TOTP key, pinCode key
- Stored in SecureStorage and cached in memory (with protection)

### 3.2 Initialization Flow

1. **Orchestration Key Initialization**: Create key to protect other keys in memory
2. **Legacy/New User Check**: Determine if user is from legacy or new version
3. **Device Key Check**: Check if Device Key already exists
4. **Device Key Generation** (if needed): Create new Device Key if not present
5. **Legacy Data Migration** (if applicable): Convert data from old to new format
6. **Key Preloading**: Generate and cache encryption keys for use

## 4. Main Methods

### 4.1 Key Initialization and Management

#### `initialize()`
- **Purpose**: Initialize the entire encryption system at app startup
- **Operation**: Initialize orchestration key, check and create device key, migrate legacy data if needed

#### `_initializeOrchestrationKey()`
- **Purpose**: Create orchestration key based on device information
- **Operation**: Combine device info, timestamp, and app signature to create key

#### `_generateOrchestrationKey()`
- **Purpose**: Generate the orchestration key
- **Operation**: Combine device information with timestamp and app signature, hash using SHA-256

#### `_getDeviceKey()`
- **Purpose**: Retrieve device key from storage or cache
- **Operation**: Check cache first, if not available read from SecureStorage

#### `_generateEncryptionKey()`
- **Purpose**: Create or retrieve encryption key based on type
- **Operation**: Check cache, if not available generate new key from device key using PBKDF2

#### `clearOrchestrationKey()`
- **Purpose**: Clear orchestration key when app enters background
- **Operation**: Mark key as uninitialized, helping protect keys from memory reading

### 4.2 Key Protection

#### `_protectKey()`
- **Purpose**: Protect keys when stored in memory
- **Operation**: Perform XOR between key and orchestration key

#### `_unprotectKey()`
- **Purpose**: Restore protected key
- **Operation**: Perform reverse XOR to retrieve original key

### 4.3 Encryption and Decryption

#### `encryptInfo()` / `decryptInfo()`
- **Purpose**: Encrypt/decrypt general information (name, email, notes)
- **Operation**: Use info key and perform in isolate to avoid UI blocking

#### `encryptPassword()` / `decryptPassword()`
- **Purpose**: Encrypt/decrypt passwords
- **Operation**: Use password key and Fernet algorithm

#### `encryptTOTPKey()` / `decryptTOTPKey()`
- **Purpose**: Encrypt/decrypt TOTP keys
- **Operation**: Use TOTP key and Fernet algorithm

#### `encryptPinCode()` / `decryptPinCode()`
- **Purpose**: Encrypt/decrypt PIN codes
- **Operation**: Use pinCode key and Fernet algorithm

### 4.4 Backup and Restoration

#### `createBackup()`
- **Purpose**: Create data backup encrypted with PIN
- **Operation**: Decrypt data, create JSON, encrypt with PIN, add checksum

#### `restoreBackup()`
- **Purpose**: Restore data from backup
- **Operation**: Decrypt data with PIN, verify validity, re-encrypt and save to DB

### 4.5 Key Rotation

#### `rotateKeys()`
- **Purpose**: Change all encryption keys to enhance security
- **Operation**: 
  1. Create new Device Key and new Encryption Keys
  2. Decrypt data with old keys
  3. Re-encrypt with new keys
  4. Verify data after re-encryption
  5. Save new keys and re-encrypted data

## 5. Supporting Classes

### `_CachedKey`
- **Purpose**: Store keys in memory with expiration time
- **Operation**: Save key and expiration time, provide method to check expiration

### `_LRUCache`
- **Purpose**: Cache keys using Least Recently Used algorithm
- **Operation**: Remove least used keys when cache is full

### `_TempEncryptionService`
- **Purpose**: Temporary service for encrypting data during key rotation
- **Operation**: Use new keys for encryption/decryption without affecting main keys

## 6. Security Mechanisms

1. **Multi-layer Encryption**: Each data type is encrypted with its own key
2. **In-memory Key Protection**: Use orchestration key to protect keys when cached
3. **Key Clearing**: Clear orchestration key when app enters background
4. **Isolates for Heavy Tasks**: Use isolates for encryption/decryption to avoid UI blocking
5. **Retry Mechanism**: Retry system with increasing delay
6. **Integrity Verification**: Use checksums for backup/restore
7. **Smart Caching**: Cache keys using LRU with expiration time

## 7. Notes and Best Practices

- **Smart Caching**: Keys are only temporarily stored in memory with protection
- **Exception Handling**: The entire system has comprehensive exception handling
- **Logging**: Detailed error logging system
- **Flexibility**: Easy to change algorithms and encryption configuration
- **Performance**: Use isolates and caching to optimize performance

## 8. Data Flow

```
Input Data → Encryption (encryptXXX) → Store in Database → Read from Database → Decryption (decryptXXX) → Display
```

The Orchestration Key protects encryption keys when stored in memory, ensuring that even if an attacker could access the application's memory dump, they cannot easily read the encryption keys.
