# mORMot 数据库单元

## 文件夹内容

这个文件夹存放了 mORMot 开源框架版本 2 的 SQL 和 NoSQL 数据访问层。

我们重新定义了一个真正的数据库引擎直接访问的 DB 类层次结构。它并非基于 Delphi/FPC 的常规 DB 类，从而避免了 `DB.pas` 单元的复杂性，特别是 `TDataSet` 组件和所有低级别的支持类型，这些类型根植于上个世纪数据库的局限性。

这些类的重点在于：

- 易于使用，通过一小套类型、类和接口实现；
- 与我们的 RESTful ORM/ODM 完美集成，特别是通过直接支持 JSON；
- 尽可能高的性能。

请注意，这些单元可以独立于我们的 ORM 使用，当 `DB.pas` 不是一个选项时，例如在以下情况下：

- 使用 Delphi Community Edition 时，
- 或者如果你不需要/喜欢 RAD 方法，但期望高效的 SQL 执行时。

除了常规的 SQL 数据源外，我们还支持 NoSQL 数据库，如 MongoDB。某些 SQL 到 NoSQL 的转换层是可用的，并由 `mormot.core.orm` 使用，将大多数简单的 SELECT 语句转换为相应的 MongoDB 管道。

## 访问数据库

有多种方式可以使用我们的框架来访问您的数据：

- `mormot.db.core.pas` 用于 SQL 和 NoSQL 的高级共享定义；
- `mormot.db.raw.*.pas` 单元定义了对数据库服务器的直接访问；
- `mormot.db.sql.*.pas` 单元提供对 SQL 数据库的访问；
- `mormot.db.rad.*.pas` 单元与 TDataSet 第三方 SQL 库（如 FireDac）进行接口；
- `mormot.db.nosql.*.pas` 单元提供对 NoSQL 数据库的访问，如 MongoDB。

为了支持跨数据库，`mormot.db.sql.zeos.pas` 是首选方式。但是，你也可以通过 ODBC/OleDB 直接访问 MSSQL，通过 OCI 访问 Oracle，或通过 libpq 访问 PostgreSQL，以减少依赖链。

例如，`mormot.db.raw.postgres.pas` 定义了用于 libpq 提供程序的低级 PostgreSQL 客户端，而 `mormot.db.sql.postgres.pas` 将使用它来实现与 `mormot.db.sql.pas` 兼容的 SQL 请求。

抽象的 `mormot.db.core.pas` 单元与所有这些单元以及 `mormot.orm.core` 共享。

## 单元介绍

### mormot.db.core

数据库访问的共享类型和定义

- 共享的数据库字段和值定义
- 存储为变体的可空值
- SQL 编码的日期/时间
- SQL 参数的内联和处理
- 专用于数据库导出的 `TResultsWriter`
- SQL SELECT 解析器 `TSelectStatement`
- JSON 对象解码器和 SQL 生成
- `TID` 处理函数

此单元被 `mormot.db.*` 单元和 `mormot.orm.*` 单元使用。

### mormot.db.sql

SQL 数据库访问的共享类型和定义
- SQL 字段和列定义
- 定义数据库引擎的特定行为（如我们的 ORM 所使用的）
- 通用 SQL 处理函数
- 抽象的 SQL 数据库类和接口
- 线程安全和参数化连接的父类

以及为 ODBC、OleDB、Zeos/ZDBC 提供程序以及 Oracle、PostgreSQL、SQLite3、FireBird/IBX 数据库直接客户端提供的相关 `mormot.db.sql.*.pas` / `mormot.db.raw.*.pas` 单元。

### mormot.db.rad

`TDataSet` / `DB.pas` 数据库访问的父类
- `DB.pas` 类和函数的共享包装器
- 支持数据库感知的 BCD 值
- `mormot.db.sql` 为 `DB.pas TDataSet` 提供的抽象连接

以及为 FireDac、UniDac、BDE、NexusDB 提供的相关 `mormot.db.rad.*.pas` 单元。

### mormot.db.rad.ui

为 VCL/LCL/FMX UI 提供高效只读抽象 `TDataSet`
- 跨编译器的 `TVirtualDataSet` 只读数据访问
- 支持 JSON 和变体的 `TDataSet`

### mormot.db.rad.ui.sql

与 `mormot.db.sql` 协同工作的高效只读 `TDataSet`
- 从 `TSqlDBStatement` 结果集中填充的 `TBinaryDataSet`
- 用于直接执行 `TSqlDBConnection` Sql 的 `TSqlDataSet`

### mormot.db.rad.ui.orm

用于 ORM 和 JSON 处理的高效只读 `TDataSet`
- `TOrmTableDataSet` 用于 `TOrmTable`/JSON 访问
- JSON/ORM 到 `TDataSet` 的包装函数

### mormot.db.rad.ui.cds

用于 SQL、ORM 和 JSON 处理的高效读写 `TClientDataSet`
- 从 `TOrmTable`/`TOrmTableJson` 数据中填充只读的 `TClientDataset`
- 继承自 `TClientDataSet` 的可写 Delphi `TSqlDBClientDataSet`

### mormot.db.nosql.bson

为 MongoDB 客户端提供高效的 BSON 支持
- BSON Decimal128 值
- BSON ObjectID 值
- `TBSONVariantData` / `TBSONVariant` 自定义变体存储
- 用于 BSON 解码的 `TBSONElement` / `TBSONIterator`
- 用于 BSON 编码的 `TBSONWriter`
- 高级 BSON/JSON 函数助手

### mormot.db.nosql.mongodb

MongoDB 客户端用于 NoSQL 数据访问
- MongoDB 线协议定义
- MongoDB 协议类
- MongoDB 客户端类

### mormot.db.proxy

通过中继允许对任何 `mormot.db.sql` 连接进行远程 HTTP 访问
- 共享的代理信息
- 服务器端代理远程协议
- 客户端代理远程协议
- 用于远程访问的 HTTP 服务器类
- 用于远程访问的 HTTP 客户端类

这些单元提供了丰富的功能和灵活性，使开发人员能够根据需要与各种类型的数据库进行交互，并利用 mORMot 框架的强大功能。无论是传统的 SQL 数据库还是 NoSQL 数据库，如 MongoDB，该框架都提供了相应的工具和类来简化和优化数据访问操作。
