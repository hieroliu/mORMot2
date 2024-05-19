# Synopse *mORMot 2* Framework

*An Open Source Client-Server ORM/SOA/MVC framework in modern Object Pascal*

![Happy mORMot](doc/happymormot.png)

(c) 2008-2024 Synopse Informatique - Arnaud Bouchez

https://synopse.info  - http://mORMot.net

Thanks to all [Contributors](CONTRIBUTORS.md)!

**NOTICE: This version 2 replaces [*mORMot 1.18*](https://github.com/synopse/mORMot) which is now in maintainance-only mode. Consider using *mORMot 2* for any new or maintainable project.**

## 资源

您可以在以下位置找到更多关于 *mORMot 2* 的信息：

- [官方文档](https://synopse.info/files/doc/mORMot2.html)（正在完善中）；
- [示例文件夹](ex)；
- [Thomas 教程](https://github.com/synopse/mORMot2/tree/master/ex/ThirdPartyDemos/tbo)；
- [Synopse 论坛](https://synopse.info/forum/viewforum.php?id=24)；
- [Synopse 博客](https://blog.synopse.info)；
- [源代码 `src` 子文件夹](src)；
- [旧版 mORMot 1 文档](https://synopse.info/files/html/Synopse%20mORMot%20Framework%20SAD%201.18.html)，其中大部分内容仍适用于新版本——尤其是设计和概念部分。

如果您觉得它值得使用，请考虑在能力范围内[赞助 mORMot 2 的开发](https://github.com/synopse/mORMot2/blob/master/DONATE.md)，或者通过[分享您自己的提交](https://github.com/synopse/mORMot2/pulls)来贡献，那就更好了。 :-)

## 简介

### mORMot 是什么？

Synopse *mORMot 2* 是一个开源的客户端-服务器 ORM SOA MVC 框架，适用于 Delphi 7 到 Delphi 11 Alexandria 以及 FPC 3.2/trunk，面向 Windows/Linux/BSD/MacOS 等服务器平台，以及任何客户端平台（包括移动或 AJAX）。

![mORMot map](doc/IamLost.png)

mORMot的主要特点包括：

- 优化的跨编译器和跨平台的JSON/UTF-8及RTTI内核；
- 直接的SQL和NoSQL数据库访问（如SQLite3、PostgreSQL、Oracle、MSSQL、OleDB、ODBC、MongoDB）；
- ORM/ODM：支持将对象持久化到几乎所有的数据库（SQL或NoSQL）；
- SOA：将业务逻辑组织为定义为`interface`的REST服务；
- 基于约定的REST/JSON路由器，支持本地或通过HTTP/HTTPS/WebSockets连接；
- 客户端：通过ORM/SOA API在任何平台上使用您的数据或服务；
- Web MVC：将ORM/SOA流程发布为响应式的Web应用程序；
- 许多其他可重复使用的组件（例如Unicode、密码学、网络、线程、字典、日志记录、二进制序列化、变体、泛型、跨平台等）。

mORMot强调速度和多功能性，利用现代Object Pascal本地代码和易于部署的解决方案的优势，降低部署成本并提高投资回报率。它可用于：

- 为爱好者向简单应用程序中添加基本的ORM或客户端-服务器功能，
- 让经验丰富的用户为他们的客户开发可扩展的基于服务（DDD）的项目，
- 利用FPC的跨平台能力与现有的Delphi代码库相结合，以适应未来数十年的发展，
- 体验乐趣，看到现代Object Pascal挑战最新的编程语言或框架。

### 子文件夹

*mORMOt 2* 仓库内容组织如下所示：

- [`src`](src) 是主要的源代码文件夹，您可以在这里找到实际的框架代码；
- [`packages`](packages) 包含设置开发环境所需的 IDE 包和工具；
- [`static`](static) 包含用于 FPC 和 Delphi 静态链接的原始库 `.o`/`.obj` 文件；
- [`test`](test) 定义了所有框架特性的回归测试；
- [`res`](res) 用于编译 `src` 中使用的一些资源，例如 `static` 中的第三方二进制文件；
- [`doc`](doc) 存放框架的文档；
- [`ex`](ex) 包含各种示例。

请随意探索源代码和内联文档。

### MPL/GPL/LGPL 三重许可证

该框架根据三种不同的自由软件/开源许可证条款中的一种进行许可，您可以选择其中一种：
- Mozilla Public License，版本 1.1 或更高版本；
- GNU General Public License，版本 2.0 或更高版本；
- GNU Lesser General Public License，版本 2.1 或更高版本。

这允许在尽可能广泛的软件项目中使用我们的代码，同时仍然对我们编写的代码保持版权保护。
请查看[完整的许可条款](LICENCE.md)。

## 快速开始

### 编译目标

框架源代码：
- 尽力保持与 FPC 稳定版和 Delphi 7 及更高版本的兼容性；
- 目前已验证通过 FPC 3.2.3 (fixes-3_2) 和 Lazarus 2.2.5 (fixes_2_2)，Delphi 7、2007、2009、2010、XE4、XE7、XE8、10.4 和 11.1。

请注意，[FPC 3.2.2 存在变体后期绑定的回归问题](https://gitlab.com/freepascal.org/fpc/source/-/issues/39438) - 请改用 FPC 3.2.2 fixes 分支。

请提交针对未经验证版本的拉取请求。


在 Delphi 上，*mORMot* 通用单元仅适用于 Windows 目标，但您可以在所有 Delphi 目标上使用跨平台客户端单元。FPC 是一个更好的和一致的跨平台编译器，我们很乐意支持。

请针对未经验证版本提交拉取请求。

### 安装

1. 获取源码，卢克！
  - 通过克隆仓库（首选）：
    - 将 `git clone https://github.com/synopse/mORMot2.git` 克隆到例如 `c:\github\mORMot2`，
    - 并下载并提取最新的 https://synopse.info/files/mormot2static.tgz 或 https://synopse.info/files/mormot2static.7z 到 `c:\github\mORMot2\static`。
  - 或直接下载特定版本的发布文件（例如用于构建脚本）：
    - 从 https://github.com/synopse/mORMot2/releases 下载 *Source code (zip)* 发布文件，并将其提取到例如 `d:\mormot2`，
    - 并将其相关的 `mormot2static.tgz` 或 `mormot2static.7z` 文件内容提取到 `d:\mormot2\static`。
2. 设置您喜欢的 IDE：
  - 在 Lazarus 上：
    - 打开并编译 [`/packages/lazarus/mormot2.lpk`](packages/lazarus/mormot2.lpk) 包；
    - 如果需要，还有 [`mormot2ui.lpk`](packages/lazarus/mormot2ui.lpk)。
  - 在 Delphi 上：
    - 创建一个名为 `mormot2` 的新环境变量，其值为您 *mORMot 2* 的 `src` 子文件夹的完整路径（*工具 - 选项 - IDE - 环境变量*），例如 `c:\github\mORMot2\src` 或 `d:\mormot2\src`，具体取决于步骤 1；
    - 将以下字符串添加到您的 IDE 库路径中（对所有目标平台，即 Win32 和 Win64）：`$(mormot2);$(mormot2)\core;$(mormot2)\lib;$(mormot2)\crypt;$(mormot2)\net;$(mormot2)\db;$(mormot2)\rest;$(mormot2)\orm;$(mormot2)\soa;$(mormot2)\app;$(mormot2)\script;$(mormot2)\ui;$(mormot2)\tools;$(mormot2)\misc`
    - 没有需要的 IDE 或 UI 包（尚未）。
3. 发现和享受：
  - 在 IDE 中打开并编译 [`test/mormot2tests.dpr`](test/mormot2tests.dpr)，并在您的计算机上运行回归测试。
  - 浏览[示例文件夹](/ex)（正在进行中） - 特别是[Thomas Tutorials](https://github.com/synopse/mORMot2/tree/master/ex/ThirdPartyDemos/tbo)，这些示例具有实际性和教育性。
  - 从一个示例开始，并按照[文档](https://synopse.info/files/doc/mORMot2.html)进行操作。
  - 欢迎通过发布增强和补丁来为这个快速发展的项目做出贡献。

## 从版本2迁移

### 为什么要重写一个已经工作的解决方案？

*mORMot*框架在1.18版本上停留了多年，是时候进行一次全面的重构了。

重构的主要点试图更好地遵循SOLID原则：
- 切换到更严格的版本控制策略，进行定期发布；
- 将主要的大单元（如`SynCommons.pas`、`mORMot.pas`）拆分为更小、范围更明确的单元；
- 将特定于操作系统或编译器的代码分离，以简化进化过程；
- 重命名令人困惑的类型，例如将`TSQLRecord`更改为`TOrm`，将`TSQLRest`更改为`TRest`等；
- 倾向于使用组合而不是继承，例如将`TRest`类拆分为适当的REST/ORM/SOA类和文件夹；
- 规避Delphi编译器内部错误，例如将未类型化的常量/变量更改为指针，或减小单元的大小；
- 重新编写整个RTTI、JSON和REST核心，以提高效率和可维护性；
- 优化框架的`asm`内核，如果可用则使用AVX2；
- 新增特性，如*OpenSSL*、*libdeflate*或*QuickJS*支持；
- 新的异步HTTP和WebSockets服务器，通过Let's Encrypt提供可选的HTTPS/TLS支持；
- 引入现代语法，如泛型或枚举器——但出于兼容性考虑，它们是可选的。

因此，我们创建了一个全新的项目和存储库，因为切换到版本2会引入一些向后不兼容的更改。我们使用了新的单元名称，以避免在迁移过程中或如果1.18版本需要保留用于兼容性项目时出现意外的冲突问题。

### 升级实践

从之前的1.18版本升级到新版本时的快速步骤：

1) 注意所有被拆分和重命名的单元，以及一些为了增强功能而引入的破坏性更改，因此直接更新是不可能的——也不建议这样做。

2) 切换到新文件夹，例如 #\lib2 而不是 #\lib。

3) 下载上面提到的最新2.#版本的文件。

4) 更改您对*mORMot*单元的引用：
- 所有单元名称已更改，以避免不同版本之间的冲突；
- 查看[示例](ex)以了解主要的有用单元。

5) 查阅关于从1.18版本开始的破坏性更改的文档，主要包括：
- 单元重构（参见上述第4点）；
- 在`PUREMORMOT2`模式下重命名类型；
- 移除了对Delphi 5-6和Kylix的兼容性；
- BigTable、LVCL、RTTI-UI已被弃用。

