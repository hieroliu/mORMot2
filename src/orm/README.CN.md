# mORMot REST 对象关系映射（ORM）单元

## 文件夹内容

这个文件夹包含*mORMot*开源框架版本2的*RESTful ORM*高级功能。

## ORM/ODM 特性

*mORMot* 实现了一个简单且非常高效的对象关系映射：

- 父类 `TOrm` 提供了对象级别的 ORM 方法访问；
- `IRestOrm`, `IRestOrmServer`, `IRestOrmClient` 接口可以在业务代码中使用，以实现抽象和持久化无关的数据访问；
- 从头到尾都使用 UTF-8 和 JSON，以使我们的 ORM 易于以 REST 方式使用，如在 `/src/rest` 文件夹中定义；
- 它可以利用 *SQLite3* 作为其核心，通过虚拟表访问多个数据源；
- 可以使用一个高性能的内存引擎，该引擎在磁盘上使用 JSON 或二进制，可以代替 *SQLite3*；
- 可以切换到像 *MongoDB* 这样的 *NoSQL* 数据库，将我们的 ORM 转换为 ODM - 即*对象文档映射*。

## 单元介绍

### mormot.orm.base

RESTful ORM 的低级别基本类型和定义

- 共享的 ORM/JSON 字段和值定义
- ORM 就绪的 UTF-8 比较函数
- `TOrmWriter` 类用于 `TOrm` 序列化
- `TOrmPropInfo` ORM / RTTI 类
- 抽象 `TOrmTableAbstract` 父类
- `TOrmTableRowVariant` 自定义变体类型
- `TOrmLocks` 和 `TOrmCacheTable` 基本结构

这个单元提供了ORM的基础设施。它定义了如何处理ORM中的基本数据类型，如何序列化和反序列化数据，以及如何处理数据行的变体类型。此外，它还包含了一些用于比较UTF-8字符串的辅助函数，这对于多语言环境下的数据处理至关重要。

TOrmWriter 类是一个关键组件，它负责将ORM对象序列化为JSON或其他格式，以便通过网络传输或存储在数据库中。

### mormot.orm.core

RESTful ORM 的主要共享类型和定义

- ORM 特定的 `TOrmPropInfoRtti` 类
- `IRestOrm`, `IRestOrmServer`, `IRestOrmClient` 定义
- `TOrm` 定义
- `RecordRef` 包装器定义
- `TOrmTable`, `TOrmTableJson` 定义
- `TOrmMany` 定义
- `TOrmVirtual` 定义
- `TOrmProperties` 定义
- `TOrmModel`, `TOrmModelProperties` 定义
- `TOrmCache` 定义
- `TRestBatch`, `TRestBatchLocked` 定义
- `TSynValidateRest`, `TSynValidateUniqueField` 定义
- `TOrmAccessRights` 定义
- `TOrm` 高级父类

这个单元不依赖于 `mormot.rest.core`，因此可以作为您项目的纯 ORM 层使用。

`IRestOrm` 接口是所有 ORM 进程的主要 SOLID 入口点。

这个单元是ORM的核心，它定义了ORM的主要结构和行为。TOrm 类是ORM的主要类，它代表了数据库中的一个表，并提供了对该表进行操作的方法。此外，这个单元还定义了一些接口，如 IRestOrm, IRestOrmServer, 和 IRestOrmClient，这些接口为客户端和服务器之间的通信提供了标准的方法。

TOrmProperties 和 TOrmModelProperties 类提供了对ORM属性的元数据处理和访问，这对于动态地处理数据库表和列非常有用。

### mormot.orm.rest

`IRestOrm` 的实现，如 `TRest` 所用

- `TRestOrm` 实现使用的一些定义
- `TRestOrm` 父类用于抽象的 REST 客户端/服务器

这个单元实现了 IRestOrm 接口，将ORM与RESTful服务相结合。TRestOrm 类是这个实现的核心，它提供了将ORM对象暴露为RESTful服务的方法，以及从RESTful服务中获取ORM对象的方法。这使得mORMot能够轻松地与其他RESTful服务进行交互。

### mormot.orm.client

客户端对象关系映射（ORM）进程

- `TRestOrmClient` 抽象客户端
- `TRestOrmClientURI` 来自 URI 的 REST 客户端

这个单元提供了客户端对象关系映射（ORM）的实现。TRestOrmClient 是一个抽象类，它定义了客户端应该实现的基本方法，以便与RESTful服务进行交互。TRestOrmClientURI 是 TRestOrmClient 的一个具体实现，它使用URI来指定要与之交互的RESTful服务的地址。

通过这个客户端，应用程序可以轻松地CRUD（创建、读取、更新、删除）操作中的记录，而无需直接处理SQL语句或数据库连接细节。

### mormot.orm.server

服务器端对象关系映射（ORM）进程

- `TRestOrmServer` 抽象服务器
- `TRestOrmServerBatchSend` 用于 `TRestBatch` 服务器端进程

服务器端ORM的实现，TRestOrmServer处理来自客户端的请求，与数据库进行交互，并返回结果。此外，还提供了批处理功能，支持高效处理多个记录的操作。

总的来说，mORMot的REST对象关系映射（ORM）单元提供了一个强大而灵活的工具集，用于在客户端和服务器之间实现高效、可扩展的数据交互。这些单元通过抽象出数据库和网络的复杂性，使开发人员能够专注于实现业务逻辑，从而提高了开发效率和代码质量。

### mormot.orm.storage

服务器端存储过程，使用JSON或二进制持久化
- **Virtual Table ORM支持**:为了满足更灵活的数据处理需求，此单元支持虚拟表ORM，这意味着可以在不直接对应物理表的情况下，通过ORM方式操作数据。
- `TRestStorage`：用于ORM/REST存储的抽象类，这是一个为ORM/REST存储设计的核心抽象类，它定义了存储操作的基本接口，如保存、加载、删除等，为后续的具体实现提供了标准。
- `TRestStorageInMemory`：作为独立的JSON/二进制存储，这是一个具体的存储实现，它将所有数据保存在内存中，以JSON或二进制格式。这种存储方式非常适合于需要快速响应且数据量不大的场景。
- `TOrmVirtualTableJSON`/`TOrmVirtualTableBinary`：虚拟表，这两种虚拟表分别支持以JSON和二进制格式存储数据，为数据的灵活性和高效性提供了双重保障。
- `TRestStorageRemote`：用于CRUD重定向其他存储或服务器上，为分布式数据处理提供了可能。
- `TRestStorageShard`：作为抽象的分片存储引擎，这是一个分片存储引擎的抽象，它支持将数据分散到多个物理存储上，以提高数据处理能力和容错性。

### mormot.orm.sql

使用`mormot.db.sql`单元的ORM SQL数据库访问
- `TRestStorageExternal`：用于SQL上的ORM/REST存储，从而利用了SQL数据库的强大功能和稳定性。
- `TOrmVirtualTableExternal`：用于外部SQL虚拟表，使得ORM操作可以无缝地与SQL数据库集成。
- **外部SQL数据库引擎注册功能**：这个功能允许用户轻松地注册和使用不同的SQL数据库引擎，从而增加了框架的灵活性和可扩展性。

### mormot.orm.sqlite3

使用`mormot.db.raw.sqlite3`单元的ORM SQLite3数据库访问
- `TOrmTableDB`：作为高效的ORM感知TOrmTable，这是一个高效的ORM感知的表类，它针对SQLite3的特性进行了优化，提供了更快速和更直接的数据访问方式。
- `TOrmVirtualTableModuleServerDB`：用于SQLite3虚拟表，这个类支持在SQLite3数据库中创建和管理虚拟表，使得SQLite3能够更灵活地处理复杂的数据结构。
- `TRestStorageShardDB`：用于在SQLite3文件上进行分片的REST存储，这个类支持在多个SQLite3数据库文件上进行数据的分片存储，提高了数据处理的并行度和容错性。
- `TRestOrmServerDB`：SQLite3上的REST服务器ORM引擎
- `TRestOrmClientDB`：SQLite3上的REST客户端ORM引擎

TRestOrmServerDB 和 TRestOrmClientDB：这两个类分别为SQLite3提供了REST服务器和客户端的ORM引擎，使得数据的远程访问和操作变得简单而高效。

### mormot.orm.mongodb

使用`mormot.db.nosql.mongodb`单元的ORM/ODM MongoDB数据库访问
- `TRestStorageMongoDB`：MongoDB上的REST存储，这个类允许将ORM/REST的数据存储在MongoDB数据库中，从而利用了MongoDB作为NoSQL数据库的灵活性和可扩展性。
- 高级函数来初始化MongoDB ORM：这些函数提供了简洁而强大的方式来初始化和配置MongoDB的ORM映射，使得开发者能够更快速地开始工作。

这些单元共同构成了mORMot框架的存储和数据库访问层，提供了与多种数据库系统集成的能力，同时还支持虚拟表、分片存储等高级功能。通过这些功能，mORMot能够灵活地满足不同的数据存储需求，并为开发者提供了一套强大的工具来构建高效、可扩展的数据驱动应用程序。
