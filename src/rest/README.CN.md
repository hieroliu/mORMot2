# mORMot REST Client-Server Units

## 文件夹内容概述

这个文件夹包含了mORMot开源框架第二版中与RESTful服务相关的功能。

## mORMot框架中的REST

REST，即“表述性状态转移”（Representational State Transfer），是客户端和服务器之间进行通信的一种方式。在本框架中，我们使用JSON作为数据在两端之间传输的格式。在实际应用中，HTTP/HTTPS或WebSockets等协议常被用作REST服务的通信层。不过，我们的基础类`TSQLRest`在设计上是通信方式无关的，它甚至可以用于处理直接的进程内调用。

本框架支持REST风格的服务，但并不严格遵循RESTful的所有原则。虽然mORMot可以通过REST公开其ORM层，但出于安全和设计的考虑，通常不建议在生产环境中这样做。因此，框架提供了一系列REST服务，这些服务可以基于方法或接口来定义，后者是定义服务端点的更高效、更清晰的方式。根据服务的定义方式，它们可能更偏向于远程过程调用（RPC）风格，而不是严格的REST资源风格。

JSON已被证明是一种简单而强大的数据表示格式，我们的框架致力于在各种平台上以最低的资源消耗利用JSON，包括JavaScript环境。

## 组合优于继承的设计原则

mORMot 2.0版的一个设计目标是遵循SOLID原则。

我们的REST实现包括一个`TRest`基类，以及继承自该类的客户端和服务端类。这些类提供了以下功能：

- 通过`ORM: IRestORM`接口支持对象关系映射；
- 通过`Services`属性支持面向服务的架构；
- 通过`Run`属性支持多线程功能；
- 在`TRest`类中隔离了REST特定的功能，如URI路由、执行、认证、授权和会话支持等。

## 单元模块介绍

### mormot.rest.core

该模块包含了REST处理过程中共享的类型和定义。

- 允许自定义REST执行逻辑；
- `TRestBackgroundTimer`类用于支持多线程处理；
- `TRestRunThreads`类管理REST实例的多线程处理；
- `TRest`作为抽象的父类，提供了REST服务的基础功能；
- 支持RESTful认证机制；
- `TRestURIParams`类用于定义REST URI；
- `TRestThread`类代表REST实例中的一个后台处理线程；
- `TOrmHistory`和`TOrmTableDeleted`类支持对修改进行追踪和持久化。

### mormot.rest.client

该模块负责客户端的REST处理。

- 实现了客户端的认证和授权逻辑；
- 提供了`TRestClientRoutingREST`和`TRestClientRoutingJSON_RPC`两种路由方案；
- `TRestClientURI`是实际客户端的基类，用于构建和发起REST请求；
- `TRestClientLibraryRequest`类用于处理由`TRestServer.ExportServerGlobalLibraryRequest`导出的请求。

### mormot.rest.server

服务器端REST处理

- `TRestServerURIContext`：服务器端执行的访问
- `TRestServerRoutingREST`/`TRestServerRoutingJSON_RPC`：请求解析方案
- `TAuthSession`：用于内存中的用户会话
- `TRestServerAuthentication`：实现认证方案
- `TRestServerMonitor`：REST服务器的高级统计数据
- `TRestRouter`：基于高效基数树URI多路复用
- `TInterfacedCallback`/`TBlockingCallback`类
- `TRestServer`：抽象REST服务器
- `TRestHttpServerDefinition`：HTTP服务器的设置

### mormot.rest.memserver

使用JSON或二进制持久化的独立内存REST服务器

- `TRestOrmServerFullMemory`：独立REST ORM引擎
- `TRestServerFullMemory`：独立REST服务器

### mormot.rest.sqlite3

使用嵌入式SQLite3数据库引擎的REST服务器和客户端

- `TRestServerDB`：直接访问SQLite3数据库的REST服务器
- `TRestClientDB`：直接访问SQLite3数据库的REST客户端

### mormot.rest.http.client

通过HTTP/WebSockets进行客户端REST处理

- `TRestHttpClientGeneric`和`TRestHttpClientRequest`：父类
- `TRestHttpClientWinSock`：基于套接字的REST客户端类
- `TRestHttpClientWebsockets`：基于WebSockets的REST客户端类
- `TRestHttpClientWinINet`和`TRestHttpClientWinHTTP`：Windows REST客户端类
- `TRestHttpClientCurl`：基于LibCurl的REST客户端类

### mormot.rest.http.server

通过HTTP/WebSockets进行服务器端REST处理

- `TRestHttpServer`：RESTful服务器
- `TRestHttpRemoteLogServer`：接收远程日志流

### mormot.rest.mvc

使用Model-View-Controller（MVC）模式和Mustache的Web服务器

- 使用`mormot.core.mustache`实现Web视图
- 使用Cookie的ViewModel/Controller会话
- 返回Mustache HTML5视图或JSON的Web渲染器
- 使用`Interface`的应用程序ViewModel/Controller
当然可以，以下是更自然的翻译以及对Mustache的扩展解释：

### mormot.rest.mvc

使用Model-View-Controller（MVC）设计模式和Mustache模板引擎的Web服务器

- **Web视图实现**：通过集成`mormot.core.mustache`，我们实现了基于Mustache模板引擎的Web视图。Mustache是一种简单、逻辑较少的模板语法，它允许你使用双大括号（例如：`{{variableName}}`）在HTML中插入变量或执行简单的逻辑。
- **ViewModel/Controller会话管理**：我们利用Cookie来管理用户的ViewModel和Controller会话，确保用户状态的持续性和个性化体验。
- **Web渲染器**：服务器能够返回基于Mustache的HTML5视图或JSON数据，为用户提供丰富的界面和数据交互。
- **应用程序的ViewModel/Controller**：我们通过使用`Interface`来定义和实现应用程序的ViewModel和Controller，确保代码的清晰度和可维护性。

**Mustache扩展解释**：

Mustache是一种简单、轻量级的模板引擎，经常用于Web开发中动态生成HTML内容。它的语法简洁明了，主要通过双大括号来进行数据绑定和展示，例如`{{name}}`会被替换为与`name`对应的数据值。除了简单的数据展示，Mustache还支持条件判断、列表渲染等基本逻辑。由于其简单易学且性能良好，Mustache在Web开发领域有着广泛的应用。在mORMot框架中，Mustache被用于动态生成Web视图，与MVC设计模式相结合，为用户提供了高效、灵活的Web开发体验。