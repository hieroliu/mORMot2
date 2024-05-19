# mORMot网络通信层

## 文件夹内容

这个文件夹为*mORMot*开源框架版本2所提供的*网络通信层*的访问权限。

## 网络通信

所有以`mormot.net.*.pas`命名的单元都定义了框架中客户端与服务器之间的通信方式，特别是通过套接字、HTTP和WebSockets实现的REST功能。

## 单元介绍

### mormot.net.sock

跨平台原始套接字API的定义：

- 高级套接字处理封装
- MAC和IP地址支持
- TLS/HTTPS加密抽象层
- 高效的多套接字轮询机制
- `TUri`，用于解析和生成URL的包装器
- `TCrtSocket`，提供缓冲套接字读写功能的类
- NTP/SNTP协议客户端实现

低级套接字API被封装成一组统一的函数，并通过`TNetSocket`抽象辅助类进行包装，这些细节并不直接对外公开。

### mormot.net.http

HTTP/HTTPS抽象处理类和相关定义：

- 共享的HTTP常量和功能函数
- `THttpSocket`类，实现在普通套接字上的HTTP通信
- 服务器端抽象类型，用于客户端-服务器协议等场景

### mormot.net.client

HTTP客户端类：

- `THttpMultiPartStream`类，支持multipart/formdata格式的HTTP POST请求
- `THttpClientSocket`类，在普通套接字上实现的HTTP客户端
- `THttpRequest`类，作为抽象的HTTP客户端类
- 实现特定功能的类：`TWinHttp`, `TWinINet`, `TWinHttpWebSocketClient`, `TCurlHTTP`
- `TSimpleHttpClient`类，作为包装器类简化HTTP客户端的使用
- 实现与远程服务器的缓存HTTP连接
- 使用`SMTP`协议发送电子邮件的功能
- 为`mormot.net.sock`中的`NewSocket()`函数提供`DNS`解析缓存

### mormot.net.server

HTTP/UDP服务器类：

- 抽象的UDP服务器实现
- 使用高效的基数树算法进行自定义URI路由
- 共享的服务器端HTTP处理流程
- `THttpServerSocket`/`THttpServer`类，实现HTTP/1.1协议的服务器
- `THttpApiServer`类，基于Windows的`http.sys`模块实现的HTTP/1.1服务器
- `THttpApiWebSocketServer`类，同样基于Windows的`http.sys`模块实现

### mormot.net.asynch

事件驱动的网络类和函数
- 低级非阻塞连接
- 客户端或服务器异步处理

这些类和函数被`mormot.net.relay`和`mormot.net.rtsphttp`等用于以跨平台的方式，使用最少的资源处理数千个并发流。

### mormot.net.ws.core

WebSocket客户端和服务器的抽象处理
- WebSocket帧定义
- WebSocket协议实现
- WebSocket客户端和服务器共享处理
- `TWebSocketProtocolChat`简单协议

### mormot.net.ws.client

WebSocket双向客户端
- `TWebSocketProcessClient`处理类
- `THttpClientWebSockets`双向REST客户端

### mormot.net.ws.server

WebSocket双向服务器
- `TWebSocketProcessServer`处理类
- `TWebSocketServerSocket`双向REST服务器

### mormot.net.ws.async

异步WebSocket双向服务器
- `TWebSocketAsyncServer`事件驱动的HTTP/WebSocket服务器
- `TWebSocketAsyncServerRest`双向REST服务器

### mormot.net.relay

通过WebSocket的安全隧道
- 低级共享定义
- 低级WebSocket中继协议
- 公共和私有中继处理

### mormot.net.rtsphttp

按照Apple在https://goo.gl/CX6VA3上定义的方式，通过HTTP隧道传输RTSP流
- 低级HTTP和RTSP连接
- 通过HTTP隧道传输RTSP

将RTSP TCP/IP双向视频流封装到两个HTTP链接中，一个POST用于上传命令，一个GET用于下载视频。

### mormot.net.tftp.client

支持RFC 1350/2347/2348/2349/7440的TFTP协议和客户端
- TFTP协议定义

当前限制：尚未定义客户端代码——只有原始的TFTP协议。

### mormot.net.tftp.server

支持RFC 1350/2347/2348/2349/7440的TFTP服务器处理
- TFTP连接线程和状态机
- `TTftpServerThread`服务器类

当前限制：目前仅支持/测试RRQ请求。

### mormot.net.acme

自动证书管理环境（ACME v2）客户端
- JWS HTTP客户端实现
- ACME客户端实现
- Let's Encrypt TLS/HTTPS加密证书支持
- 在80端口上运行的HTTP服务器，用于Let's Encrypt的HTTP-01挑战

### mormot.net.ldap

简单的LDAP协议客户端
- 基本的ASN.1支持
- LDAP协议定义
- LDAP响应存储
- CLDAP客户端功能
- LDAP客户端类

### mormot.net.dns

简单的DNS协议客户端
- 低级DNS协议定义
- 高级DNS查询
