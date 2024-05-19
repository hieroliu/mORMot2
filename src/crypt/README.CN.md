# mORMot 加密单元

## 文件夹内容

此文件夹包含*mORMot*开源框架版本2的加密单元。

## 加密技术

这些单元实现了散列、消息摘要、加密和不对称加密技术。

它们在编写时考虑了跨平台性，具有非常高效的独立版本（使用优化的帕斯卡代码和汇编语言），或者通过外部OpenSSL库。

法律声明：根据[我们的许可条款](../../LICENCE.md)，请确保您遵守您所在国家关于使用加密软件的任何限制。

## 单元介绍

### mormot.crypt.core

所有框架单元共享的高性能加密特性

- 低级内存缓冲区辅助函数
- 用于ECC的256位BigInt低级计算
- 带有优化的汇编语言和AES-NI/CLMUL支持的AES编码/解码
- AES-256加密伪随机数生成器(CSPRNG)
- SHA-2 SHA-3安全散列
- 基于SHA和CRC32C的HMAC认证
- 基于SHA-2和SHA-3的PBKDF2安全密钥派生
- 摘要/散列到十六进制文本转换
- 已弃用的MD5 RC4 SHA-1算法
- 已弃用的弱AES/SHA进程

此单元已通过OpenSSL验证其正确性。
优化的汇编代码位于单独的`mormot.crypt.core.asmx64.inc`和`mormot.crypt.core.asmx86.inc`文件中。
它是完全独立的，并且在x86_64上比OpenSSL更快（但AES-GCM除外）。

### mormot.crypt.secure

所有框架单元共享的身份验证和安全类型。

- `TSyn*Password`和`TSynConnectionDefinition`类
- 可重用的身份验证类
- 高层`TSynSigner`/`TSynHasher`多算法包装器
- 客户端和服务器摘要访问身份验证
- 64位`TSynUniqueIdentifier`及其高效生成器
- 使用单边或双向身份验证的`IProtocol`安全通信
- `TBinaryCookieGenerator`简单的Cookie生成器
- `Rnd`/`Hash`/`Sign`/`Cipher`/`Asym`/`Cert`/`Store`高层算法工厂
- 最小的`PEM`/`DER`编码/解码
- 基本的ASN.1支持
- Windows可执行数字签名填充

### mormot.crypt.ecc256r1

高性能的*secp256r1/NISTP-256/prime256v1*椭圆曲线加密技术

- 低级的ECC *secp256r1* ECDSA和ECDH函数
- 中级的基于证书的公钥加密技术

如果调用了`mormot.crypt.openssl.RegisterOpenSsl`，将使用更快的*OpenSSL*库。

### mormot.crypt.ecc

基于证书的公钥加密类

- 高层的基于*secp256r1*证书的公钥加密技术
- 使用公钥加密技术实现的`IProtocol`
- 将我们的ECC引擎注册到`TCryptAsym`/`TCryptCert`工厂中

### mormot.crypt.rsa

Rivest-Shamir-Adleman (RSA)公钥加密技术

- 面向RSA的大整数计算
- RSA低层加密函数
- 将我们的RSA引擎注册到`TCryptAsym`工厂中

### mormot.crypt.x509

X.509证书实现 - 参见RFC 5280
- X.509字段逻辑
- X.509证书和证书签名请求（CSR）
- X.509证书吊销列表（CRL）
- X.509私钥基础设施（PKI）
- 将我们的X.509引擎注册到`TCryptCert`/`TCryptStore`工厂

该单元提供了X.509证书的处理功能，包括证书的生成、解析、验证以及吊销等操作。它是公钥基础设施（PKI）的重要组成部分，支持基于证书的公钥加密和身份验证。

### mormot.crypt.jwt

JSON Web令牌（JWT）实现 - 参见RFC 7797
- 抽象的JWT解析和计算
- JWT实现的`HS*`和`S3*`对称算法
- JWT实现的`ES256`非对称算法
- JWT实现的`RS256`/`RS384`/`RS512`非对称算法
- 通过`ICryptPublicKey`/`ICryptPrivateKey`工厂实现的`TJwtCrypt`

此单元提供了JSON Web令牌（JWT）的创建、解析和验证功能。JWT是一种用于在网络之间安全传输信息的开放标准（RFC 7519），这些信息可以用于验证、授权、信息交换等。

### mormot.crypt.openssl

使用*OpenSSL* 1.1 / 3.x的高性能加密功能
- *OpenSSL*加密伪随机数生成器（CSPRNG）
- 各种模式下的AES加密/解密
- 哈希器和签名器的OpenSSL包装器
- *OpenSSL*非对称加密
- 使用任何OpenSSL算法的JWT实现
- 将*OpenSSL*注册到我们的通用加密目录中

该单元利用OpenSSL库提供了一系列高性能的加密功能，包括随机数生成、AES加密、哈希、签名以及非对称加密等。同时，它还支持JWT的实现，并能够将OpenSSL的功能集成到mORMot框架中。

### mormot.crypt.pkcs11

通过PKCS#11访问硬件安全模块（HSM）
- 与框架类型的高级别*PKCS#11*集成
- 将*PKCS#11*引擎注册到`TCryptAsym`/`TCryptCert`工厂

此单元允许mORMot框架通过PKCS#11接口与硬件安全模块（HSM）进行交互。HSM是一种用于安全存储和管理密钥的硬件设备，通过PKCS#11标准接口，可以访问HSM中存储的密钥和证书，并执行加密、解密、签名等安全操作。该单元将PKCS#11引擎集成到mORMot的加密体系中，提供了硬件级别的安全保障。

TL;DR（太长不读）：在x86_64架构上，对于大多数算法，mORMot的`mormot.crypt.pas`中的汇编代码是独立的，并且比*OpenSSL*更快；仅在`AES-GCM`方面稍慢（比*OpenSSL*慢20%，但比*OpenSSL* 3.0快）。对于`ECC`或`RSA`算法，mORMot的`mormot.crypt.ecc256r1`和`mormot.crypt.rsa`单元虽然比*OpenSSL*慢一些，但它们是完全独立的实现。
