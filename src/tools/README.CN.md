# mORMot Development Tools

## 文件夹内容

此文件夹包含一些命令行或可视化工具，这些工具将与版本2的*mORMot*开源框架一起使用。

## 工具介绍

每个工具都将有其自己的专用子文件夹。

### ecc

[命令行工具`ecc`](./ecc)使用ECC-secp256r1管理基于证书的公钥密码学，具体功能如下：

- 使用`new`/`rekey`/`source`/`infopriv`生成公钥/私钥对；
- 使用`chain`/`chainall`进行安全的密钥链接；
- 使用`sign`/`verify`进行ECDSA数字签名；
- 使用`crypt`/`decrypt`/`infocrypt`进行ECIES加密；
- 通过`aeadcrypt`/`aeaddecrypt`进行对称加密；
- 通过`cheatinit`/`cheat`进行集中的密码管理。

### Angelize (agl)

[*Angelize*（`agl`）工具](./agl)能够以一个或多个可执行文件作为守护进程/服务运行，具体功能如下：

- 实现为主要的标准操作系统服务（Windows）或守护进程（Linux）；
- 启动和停止在JSON设置文件中定义的子进程；
- Watchdog可以定期检查子服务的可用性；
- 可以重定向控制台输出，在出现问题时重新启动，并通知问题；
- 命令行开关可用于状态列表或主要操作。

### mab

[命令行工具`mab`](./mab)可以从现有的`.map`或`.dbg`文件生成`.mab`文件，具体功能如下：

- 如果指定了某些`.map`文件名（您可以使用通配符），它将处理所有这些`.map`文件，然后创建相应的`.mab`文件；
- 如果指定了某些`.exe`/`.dll`文件名（您可以使用通配符），将使用关联的`.map`文件处理所有匹配的`.exe`/`.dll`文件，并将创建`.mab`文件，然后将`.mab`内容嵌入到`.exe`/`.dll`中；
- 如果没有指定文件名，将从当前目录中将`*.map`处理成`*.mab`；
- 使用FPC时，将使用DWARF调试信息而不是`.map`文件。

### mORMot GET (mget)

[*mORMot GET*（`mget`）命令行工具](./mget)可以使用HTTP或HTTPS检索文件，类似于著名的同名GNU WGet工具，但具有*mORMot 2*提供的一些独特功能：

- 可以使用`RANGE`标头恢复中断的下载；
- 可以计算和验证下载内容的哈希值；
- 可以从本地网络对等缓存中进行广播和下载。最后两个功能非常独特且高效。