# mORMot外部库

## 文件夹内容

此文件夹提供了对*mORMot*开源框架版本2使用的*外部库*的访问。

## 外部库

所有`mormot.lib.*.pas`单元都定义了对外部库的直接访问，如zlib、lizard、curl或openssl。

我们将“外部”库定义为作为依赖项静态链接或动态链接到您的可执行文件中的代码，它们不是*mORMot*框架本身及其许可条款的一部分。

注意：

- 旨在成为操作系统一部分的强制性库（例如Windows API或`libc`/`pthread` API）在`mormot.core.os`中定义。
- 对SQL数据库客户端库的访问不会在此文件夹中，而是在`src/db`文件夹中定义为`mormot.db.raw.*`单元。

## 薄封装器

这些`mormot.lib.*.pas`单元只是库`c`/`stdcall`外部API的封装器。然后它们被封装在更高级别的单元中，这些单元旨在由框架使用。

例如：

- `mormot.lib.z.pas`/`mormot.lib.openssl11`包含对`zlib`/`OpenSSL` API的原始访问，
- 而`mormot.core.zip.pas`/`mormot.core.crypto.openssl`包含使用`OpenSSL`的高级`deflate`和`.zip`文件处理/加密和签名。

在Windows上，一些操作系统的高级功能，如Windows HTTP和WebSockets客户端/服务器API，或SSPI/SChannel API也在此文件夹中定义，以利用专注于跨平台核心功能的`mormot.core.os.pas`。

## 单元介绍

### mormot.lib.z

跨平台和跨编译器的`zlib` API。

- 低级ZLib流式访问。
- 用于Deflate/ZLib进程的简单包装函数。

### mormot.lib.lizard

跨平台和跨编译器的`Lizard` (LZ5) API。

- 低级Lizard API进程。
- `TAlgoLizard`, `TAlgoLizardFast`, `TAlgoLizardHuffman`等高级算法。

### mormot.lib.curl

跨平台和跨编译器的`libcurl` API。

- CURL低级常量和类型。
- CURL函数API。

注意：

CURL 在这里指的是 cURL 工具及其对应的库 libcurl。cURL 是一个常用的命令行工具，用于向 Web 服务器发送请求，支持多种协议，包括 HTTP、HTTPS、FTP 等。而 libcurl 是 cURL 的库版本，它允许开发者在自己的应用程序中集成这些网络功能。

在 mORMot 的上下文中，mormot.lib.curl 单元很可能是对 libcurl 的一个 Pascal/Delphi 封装，允许 mORMot 框架的用户能够轻松地在他们的应用程序中执行网络请求，如下载或上传文件，发送 HTTP POST 请求等。

简而言之，CURL/libcurl 在这里提供了一种在 mORMot 应用程序中进行网络通信的机制。

## mormot.lib.openssl11

该单元提供了跨平台和跨编译器的`OpenSSL` 1.1/3.x 版本的API接口。OpenSSL是一个非常流行的开源加密库，用于提供安全的通信层，支持多种加密算法，包括TLS和SSL协议。

- **动态或静态加载OpenSSL库**：根据配置和需求，可以选择动态链接或静态链接OpenSSL库。
- **OpenSSL库常量**：定义了一些常用的常量值，这些常量在调用OpenSSL函数时使用。
- **OpenSSL库类型和结构**：提供了OpenSSL中定义的数据类型和结构体的Pascal/Delphi版本。
- **OpenSSL库函数**：封装了OpenSSL提供的各种加密、解密、签名、验证等功能的函数。
- **OpenSSL辅助函数**：提供了一些辅助函数，简化OpenSSL库的使用。
- **为`mormot.net.sock` / `TCrtSocket`提供TLS / HTTPS加密层**：利用OpenSSL库为网络通信提供安全的加密层。

实现注意事项：

- 相对于OpenSSL 1.0.x，新的1.1/3.x API通过getter/setter函数隐藏了大多数结构，并且不需要复杂的初始化。
- OpenSSL 1.1支持TLS 1.3，并且是一个长期支持（LTS）版本（直到2023年9月11日）。
- 在某些平台上（目前为Windows和Linux）还支持OpenSSL的下一个主要版本3.x。
- OpenSSL 1.1/3.x API的适配是通过动态加载在运行时完成的。
- 如果设置了`OPENSSLFULLAPI`条件，则可以定义完整的OpenSSL 1.1 API。

**法律声明**：请确保您遵守所在国家/地区关于使用加密软件的任何限制。

### mormot.lib.winhttp

**Windows HTTP 和 WebSockets API 库**

- **`WinINet` API 附加包装器**：提供对 `WinINet` API 的额外封装，可能包括更便捷的函数调用或对特定功能的扩展。
- **`http.sys` / HTTP 服务器 API 低级直接访问**：允许开发者直接与 Windows 的 HTTP 服务进行底层交互，用于创建高效且可扩展的 HTTP 服务器应用程序。
- **`winhttp.dll` Windows API 定义**：包含与 `winhttp.dll` 交互所需的定义，该动态链接库提供了 Windows HTTP 服务（WinHTTP）的客户端 HTTP API。
- **`websocket.dll` Windows API 定义**：包含与 `websocket.dll` 交互的定义，这个库提供了对 WebSocket 协议的支持。

### mormot.lib.sspi

**Windows 上的安全支持提供者接口 (SSPI) 支持**

- **低级的 SSPI/SChannel 函数**：提供对 SSPI 和 SChannel（一个提供安全通信的 Windows 组件）的直接、底层访问。
- **中级的 SSPI 包装器**：为 SSPI 提供更易用的中级封装，简化复杂的 SSPI 调用。
- **高级客户端和服务器身份验证**：利用 SSPI 实现的高级身份验证机制，例如在 `mormot.core.rest` 中可能会用于增强 REST 服务的安全性。
- **Lan Manager 访问函数**：提供与 Windows Lan Manager 相关的功能，可能包括网络访问控制和身份验证等任务的函数。

### mormot.lib.gssapi

**POSIX/Linux 上的通用安全服务 API**

- **低级的 `libgssapi_krb5`/`libgssapi.so` 库访问**：允许直接访问 GSSAPI 库，特别是 Kerberos 5 身份验证协议的支持。
- **中级的 GSSAPI 包装器**：为 GSSAPI 提供更友好的封装，以简化其使用。
- **高级客户端和服务器身份验证**：使用 GSSAPI 实现的高级身份验证，类似于在 Windows 上使用 SSPI。

### mormot.lib.gdiplus

**Windows GDI+ 图形设备接口支持**

- **GDI+ 共享类型**：定义 GDI+ 使用的通用数据类型和结构。
- **GDI+ `TImageAttributes` 包装器**：对 GDI+ 中的 `TImageAttributes` 类进行封装，以提供更简便的操作方式。
- **`TGdiPlus` 类用于直接访问 GDI+ 库**：这个类允许开发者直接调用 GDI+ 库的函数，实现复杂的图形操作。
- **GDI MetaFile 的抗锯齿渲染**：提供对 GDI 元文件的高质量、抗锯齿渲染支持，以改善图像质量。

**查看 `mormot.ui.gdiplus.pas` 以获取高级 LCL/VCL 图片支持**：提示开发者查看另一个单元以获取与 Lazarus 组件库 (LCL) 或 Visual Component Library (VCL) 集成的高级图片支持功能。

### mormot.lib.quickjs

**跨平台和跨编译器的JavaScript解释器**

- **QuickJS**低级常量和类型：定义QuickJS引擎使用的各种常量和基础数据类型。
- **QuickJS**函数API：提供对QuickJS引擎功能的直接调用接口。
- **QuickJS**到Pascal的包装器：允许Pascal（或类似语言）代码更容易地与QuickJS引擎交互。

*QuickJS*是一个小巧且可嵌入的JavaScript引擎。它支持包括模块、异步生成器、代理和BigInt在内的ES2020规范。我们提供静态二进制引擎（无需外部`.dll`/`.so`文件），并进行了一些修复和扩展。

### mormot.lib.win7zip

**在Windows上访问7-Zip压缩/解压缩DLL**

- 低级7-Zip API定义：直接调用7-Zip DLL功能的底层接口。
- `I7zReader`/`I7zWriter`高级包装器：提供更为友好和高级的功能接口，用于读取和写入7z文件。

**我可以在商业应用中使用7-Zip的EXE或DLL文件吗？**

可以，但您必须在您的应用程序文档中说明：
- 您使用了7-Zip程序的部分内容；
- 7-Zip是在GNU LGPL许可下授权的；
- 您必须提供一个链接到www.7-zip.org，在那里可以找到源代码。

**直接调用7-Zip的公开DLL API会让我发疯吗？**

可能会。Igor（7-Zip的开发者）的API相当复杂且庞大：LCL单元为了基本的归档工作需要长达10,000行代码。所以不要发疯，使用我们的单元吧。安全第一，别让自己后悔。
