# mORMot 核心单元

## 文件夹内容

此文件夹包含*mORMot*开源框架版本2的核心单元。

## 核心单元

“核心单元”指的是实现我们框架共享基础功能的单元：

- 解耦的可重用模块，用于处理文件、文本、JSON、压缩、加密、网络、RTTI（运行时类型信息），可能包含优化的汇编代码；
- 其他更高级的功能，如ORM（对象关系映射）、SOA（面向服务的架构）或数据库访问，都是建立在这些基础模块之上的，并位于父文件夹中；
- 跨平台和跨编译器：确保相同的代码可以在FPC（Free Pascal Compiler）和Delphi上编译，适用于任何支持的平台，无论运行时库、操作系统或CPU如何。

## 单元介绍

### mormot.core.base

所有框架单元共享的基本类型和可重用的独立函数

- 框架版本和信息
- 用于编译器和CPU之间兼容性的通用类型
- 数字（浮点数和整数）的低级定义
- 整数数组操作
- `ObjArray`、`PtrArray`、`InterfaceArray` 包装函数
- 低级类型映射二进制或位结构
- 缓冲区（例如哈希和SynLZ压缩）原始函数
- 日期/时间处理
- 高效的`Variant`值转换
- 排序/比较函数
- 一些方便的`TStream`后代和文件访问函数
- RTL标准函数的更快替代方案
- 原始共享类型定义

这些类型和函数的目的是跨平台和跨编译器，除了主要的FPC/Delphi RTL之外，没有任何依赖关系。它还可以检测它运行的Intel/AMD类型，以适应可用的最快汇编版本。它是包含x86_64或i386汇编存根的主要单元。

### mormot.core.os

所有框架单元共享的跨平台函数

- 一些跨系统类型和常量定义
- 收集操作系统信息
- 操作系统特定类型（例如`TWinRegistry`）
- Unicode、时间、文件、控制台、库处理
- 跨平台字符集和代码页支持
- 通过`vmtAutoTable`槽进行每类属性的O(1)查找（例如用于RTTI缓存）
- `TSynLocker`/`TSynLocked`和低级线程功能
- Unix守护进程和Windows服务支持

此单元的目的是集中最常用的操作系统特定API调用，就像一个增强的`SysUtils`单元，以避免在“uses”子句中出现`$ifdef/$endif`。

实际上，一旦包含了`mormot.core.os`，就不需要再引用“Windows”或“Linux/Unix”了。

### mormot.core.os.mac

为FPC注入的MacOS API调用，用于`mormot.core.os.pas`

- 收集MacOS特定操作系统信息

此单元使用MacOSAll并链接多个工具包，因此没有包含在`mormot.core.os.pas`中以减小可执行文件的大小，而是在运行时注入这些方法：只需在需要它的程序中包含“`uses mormot.core.os.mac`”即可。

### mormot.core.unicode

此单元包含框架中所有单元共享的高效Unicode转换类。

- 高效的UTF-8编码/解码
- UTF-8、UTF-16和Ansi之间的转换类
- 支持BOM/Unicode的文本文件加载
- 低级字符串转换函数
- 文本大小写转换和比较功能
- UTF-8字符串处理函数
- `TRawUtf8DynArray`处理函数
- 操作系统无关的Unicode处理

这个单元的目的是提供一种高效且与系统无关的Unicode字符串处理方法，确保文本数据在各种平台和编译器之间的一致性和兼容性。

### mormot.core.text

此单元包含框架中所有单元共享的文本处理函数。

- 类似CSV的文本缓冲区迭代
- `TTextWriter`父类用于文本生成
- 数字（整数或浮点数）和变量到文本的转换
- 文本格式化函数
- 资源和时间函数
- `ESynException`类
- 十六进制文本和二进制转换

这个单元提供了处理文本数据的各种实用函数，从简单的文本格式化到复杂的CSV解析，使得文本数据的处理变得简单而高效。

### mormot.core.datetime

此单元包含框架中所有单元共享的日期和时间定义及处理功能。

- 符合ISO-8601的日期/时间文本编码
- `TSynDate`、`TSynDateTime`、`TSynSystemTime`高级对象
- 符合POSIX Epoch的`TUnixTime`、`TUnixMSTime` 64位日期/时间
- 高效的自定义64位日期/时间编码`TTimeLog`

此单元的目的是提供一种兼容且高效的日期和时间处理方法，以确保时间戳的准确性和跨平台的兼容性。

### mormot.core.rtti

此单元包含框架中所有单元共享的跨编译器RTTI定义。

- 低级跨编译器RTTI定义
- 枚举类型的RTTI
- 发布的`class`属性和方法的RTTI
- `IInvokable`接口的RTTI
- 高效动态数组和记录的处理
- 托管类型的终结或复制
- 用于JSON解析的RTTI值类型
- 基于RTTI的自定义JSON解析注册
- 高级`TObjectWithID`和`TObjectWithCustomCreate`类类型
- 将最常用的FPC RTL函数重定向到优化的x86_64汇编代码

此单元的目的是提供一种与编译器无关的RTTI解决方案，以便在不同平台和编译器之间实现一致的反射功能。

### mormot.core.buffers

此单元包含框架中所有单元共享的低级内存缓冲区处理函数。

- *可变长度整数*的编码/解码
- `TAlgoCompress`压缩/解压缩类 - 带`AlgoSynLZ`、`AlgoRleLZ`等算法
- `TFastReader`/`TBufferWriter`二进制流
- Base64、Base64URI、Base58和Baudot的编码/解码
- URI编码的文本缓冲区处理
- 基本的MIME内容类型支持
- 文本内存缓冲区和文件处理
- 标记（如HTML或Emoji）处理
- 通过`TRawByteStringGroup`聚合`RawByteString`缓冲区

此单元提供了一系列用于处理内存缓冲区的低级函数，从简单的编码/解码操作到复杂的压缩/解压缩算法，都旨在提供高效且灵活的数据处理能力。

### mormot.core.data

此单元包含框架中所有单元共享的低级数据处理函数。

- 带有自定义构造函数的RTL `TPersistent` / `TInterfacedObject`
- `TSynPersistent*` / `TSyn*List`类
- 具有适当二进制序列化的`TSynPersistentStore`
- INI文件和内存访问
- 高效的RTTI值二进制序列化和比较
- `TDynArray`和`TDynArrayHashed`包装器
- `Integer`数组扩展处理
- `RawUtf8`字符串值实习和`TRawUtf8List`
- 抽象基数树类

此单元提供了一套用于处理各种数据的工具和类，从基本的持久化存储到高效的数据结构和算法，都旨在使数据处理更加灵活和高效。

### mormot.core.json

此单元包含框架中所有单元共享的JSON函数。

- 低级JSON处理函数
- 具有适当JSON转义和`WriteObject()`支持的`TTextWriter`类
- 支持JSON的`TSynNameValue` `TSynPersistentStoreJson`
- 支持JSON的`TSynDictionary`存储
- 任何类型值的JSON反序列化
- JSON序列化包装函数
- 具有自动创建字段的抽象类

这个单元为处理JSON数据提供了一套完整的工具，从简单的序列化和反序列化到更复杂的数据结构映射，都使得JSON数据的处理变得简单而直接。

### mormot.core.collections

此单元包含框架中所有单元使用的泛型集合。

- 支持JSON的`IList<>`列表存储
- 支持JSON的`IKeyValue<>`字典存储
- `IList<>`和`IKeyValue<>`实例的集合工厂

与Delphi或FPC RTL中的`generics.collections`相比，此单元使用`interface`作为变量持有者，并利用它们来尽可能减少生成的代码量，类似于*Spring4D 2.0框架*的做法，但适用于Delphi和FPC。因此，编译的单元（`.dcu`/`.ppu`）和可执行文件更小，编译速度更快。

它发布了`TDynArray`和`TSynDictionary`的高级功能，如索引、排序、JSON/二进制序列化或线程安全，作为泛型强类型。

使用`Collections.NewList<T>`和`Collections.NewKeyValue<TKey, TValue>`工厂作为这些高效数据结构的主要入口点。

### mormot.core.variants

此单元包含框架中所有单元共享的`Variant` / `TDocVariant`功能。

- 低级`Variant`包装器
- 支持JSON的自定义`Variant`类型
- 支持JSON的`TDocVariant`对象/数组文档持有者
- 将JSON解析为`Variant`

这个单元提供了一种灵活的方式来处理变量类型的数据，包括JSON数据的解析和生成，使得数据的表示和处理更加多样化和灵活。

### mormot.core.search

此单元包含框架中使用的几种索引和搜索引擎。

- 文件夹中的文件搜索
- ScanUtf8、GLOB和SOUNDEX文本搜索
- 使用RTTI进行高效的CSV解析
- 多功能表达式搜索引擎
- *Bloom Filter*概率索引
- 二进制缓冲区的增量压缩
- `TDynArray`低级二进制搜索
- `TSynFilter`和`TSynValidate`处理类
- 跨平台的`TSynTimeZone`时区

此单元提供了一套强大的搜索和索引工具，从简单的文本搜索到复杂的表达式搜索和概率索引，都旨在提高数据检索的效率和准确性。

### mormot.core.log

此单元包含框架中所有单元共享的日志记录函数。

- 从Delphi .map或FPC/GDB DWARF处理调试符号
- 通过`TSynLogFamily` `TSynLog` `ISynLog`进行日志记录
- 高级日志和异常相关功能
- 通过`TSynLogFile`高效访问`.log`文件
- RFC 5424定义的SysLog消息支持

这个单元为记录和跟踪应用程序的运行状态和错误提供了一种灵活且强大的机制，从而确保应用程序的可观察性和可调试性。

### mormot.core.perf

此单元包含所有框架单元共享的性能监控功能。

- 性能计数器：记录和监控应用程序的性能指标。
- `TSynMonitor` 进程信息类：提供获取和处理系统进程信息的类和方法。
- `TSynMonitorUsage` 进程信息数据库存储：记录并管理进程使用情况的数据库存储。
- 操作系统监控：提供对操作系统性能和资源使用情况的监控功能。
- `DMI`/`SMBIOS` 二进制解码器：能够解码DMI（Desktop Management Interface）和SMBIOS（System Management BIOS）提供的信息，以获取硬件相关数据。
- `TSynFPUException` 浮点单元异常包装器：用于保存和恢复浮点单元标志，以避免在处理浮点运算时丢失状态。

这个单元主要用于监控和优化程序的性能，以及收集和分析系统和进程的运行数据。

### mormot.core.threads

此单元包含所有框架单元共享的高级多线程功能。

- 线程安全的 `TSynQueue` 和 `TPendingTaskList`：提供线程安全的队列和任务列表实现。
- 线程安全的 `ILockedDocVariant` 存储：允许在多线程环境中安全地存储和访问 `DocVariant` 数据。
- 后台线程处理：支持在后台线程中执行任务，以避免阻塞主线程。
- 线程池中的并行执行：允许在线程池中并行执行任务，以提高处理效率。
- 面向服务器进程的线程池：为服务器进程提供优化的线程池管理。

这个单元旨在简化多线程编程，提供高效的并发处理机制。

### mormot.core.zip

此单元包含所有框架单元共享的Zip/Deflate高级压缩功能。

- `TSynZipCompressor` 流类：提供对Zip压缩文件的读写功能。
- GZ 读写支持：支持读写GZIP（.gz）格式的压缩文件。
- `.zip` 归档文件支持：允许创建、读取和管理ZIP归档文件。
- `TAlgoDeflate` 和 `TAlgoDeflate` 高级压缩算法：提供Deflate压缩算法的实现，用于数据的压缩和解压缩。

这个单元使得在应用程序中轻松处理压缩文件成为可能，无论是为了节省存储空间还是为了网络传输。

### mormot.core.mustache

此单元提供逻辑较少的 `{{Mustache}}` 模板渲染功能。

- *Mustache* 执行数据上下文类型：定义用于模板渲染的数据上下文类型。
- `TSynMustache` 模板处理：提供Mustache模板的解析和渲染功能。

这个单元允许使用Mustache模板语言来动态生成HTML、文本或其他格式的文档。

### mormot.core.interfaces

此单元通过接口类型实现SOLID原则。

- `IInvokable` 接口方法和参数的RTTI提取：允许在运行时获取接口方法和参数的类型信息。
- `TInterfaceFactory` 生成运行时实现类：能够根据接口定义动态生成实现类。
- `TInterfaceResolver` `TInjectableObject` 用于IoC / 依赖注入：支持控制反转（IoC）和依赖注入（DI）的设计模式。
- `TInterfaceStub` `TInterfaceMock` 用于依赖模拟：允许创建接口的模拟实现，以便于单元测试。
- `TInterfaceMethodExecute` 用于从JSON执行方法：允许根据JSON数据动态调用接口方法。
- `SetWeak` 和 `SetWeakZero` 弱接口引用函数：提供对接口引用的弱引用管理，以避免循环引用和内存泄漏。

这个单元通过接口和依赖注入等设计模式，提高了代码的可测试性、可维护性和可扩展性。

### mormot.core.test

此单元包含所有框架单元共享的测试功能。

- 单元测试类和函数：提供用于编写和执行单元测试的工具和框架。

这个单元有助于确保代码的质量和正确性，通过自动化的单元测试来验证代码的功能和性能。

### mormot.core.fpcx64mm

此单元是一个可选的、为FPC编写的、多线程友好的内存管理器，专门针对x86_64架构。

- 面向Linux（和Windows）多线程服务的目标：优化在多线程环境中的内存管理性能。
- 仅适用于x86_64目标的FPC：不适用于Delphi或ARM架构；在这些平台上，应使用RTL内存管理器。
- 基于FastMM4的成熟算法：利用Pierre le Riche开发的FastMM4内存管理器的经过验证的算法。
- 代码已简化为仅用于生产的功能集：去除不必要的特性，专注于提高性能和稳定性。
- 为跨平台、紧凑性和效率进行了深入的汇编重构：优化汇编代码以适应不同平台，并提高内存管理的效率和紧凑性。
- 可以报告详细的统计信息（包括线程争用和内存泄漏）：提供强大的监控和调试功能。

