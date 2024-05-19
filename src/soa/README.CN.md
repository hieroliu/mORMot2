# mORMot REST 面向服务的架构单元

## 文件夹内容

此文件夹包含*mORMot*开源框架版本2的*RESTful SOA*高级功能。

## 基于接口的服务导向架构

该框架提供两种实现SOA的方式：

- 在`TRest`级别定义*类方法*；
- 定义一个`接口`和相关的实现`类`。

基于方法的服务：

- 充分利用服务器端对HTTP请求的输入/输出的完全访问权限；
- 提供最佳性能；
- 但需要手动编写客户端代码。

基于`接口`的服务：

- 更便于在常规代码中定义服务合约；
- 可以在客户端生成一个伪实现`类`；
- 从对象Pascal代码中调用时更为自然；
- 通过在合约中定义`接口`参数，提供通过WebSockets进行的自然双向通信；
- 具有内置的授权/安全、线程能力、JSON/XML编组的选项。

简而言之，在构建RESTful服务时，使用这些`mormot.soa.*`单元提供的基于`接口`的服务。但你可以将两者混合使用，因此一些专用的端点可以使用方法来实现。

## 单元介绍

### mormot.soa.core

基于接口的面向服务架构(SOA)的共享进程

- `TOrmServiceLog TOrmServiceNotifications` 类
- `TServiceFactory` 抽象服务提供商
- `TServiceFactoryServerAbstract` 抽象服务提供商
- `TServiceContainer` 抽象服务持有者
- SOA相关接口
- `TServicesPublishedInterfacesList` 服务目录

### mormot.soa.client

客户端基于接口的面向服务架构(SOA)进程

- `TServiceFactoryClient` 服务提供商
- `TServiceContainerClientAbstract` 服务提供商
- `TServiceContainerClient` 服务持有者

### mormot.soa.server

服务器端基于接口的面向服务架构(SOA)进程

- `TInjectableObjectRest` 服务实现父类
- `TServiceFactoryServer` 服务提供商
- `TServiceContainerServer` 服务持有者
- 异步REST同步类

### mormot.soa.codegen

SOA API代码和文档生成

- 从RTTI中提取ORM和SOA逻辑
- 从源代码注释中提取文档
- 服务器端的Doc/CodeGen包装函数
- FPC专用生成器
- 从同步接口计算异步代码
- 从命令行生成代码和文档