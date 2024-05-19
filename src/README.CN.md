# mORMot Source Code

## 文件夹内容

此文件夹包含*mORMot*开源框架版本2的源代码。

## MPL 1.1/GPL 2.0/LGPL 2.1 三重许可

框架源代码在三种自由软件/开源许可条款中选择一种进行许可，为用户提供选择：

- *Mozilla Public License*，1.1版或更高版本（MPL）；
- *GNU General Public License*，2.0版或更高版本（GPL）；
- 带有*FPC修改的LGPL的*链接例外*的*GNU Lesser General Public License*，2.1版或更高版本（LGPL）。
  这使得我们的代码能够在尽可能多的软件项目中使用，同时仍然保持对我们编写的代码的左版复制权。

有关更多信息，请参阅此存储库根文件夹中的[完整许可条款](../LICENCE.md)。

## 子文件夹

源代码树分为以下子文件夹：

- [`core`](core)：用于文本、RTTI、JSON、压缩等底层共享组件；
- [`lib`](lib)：用于外部第三方库，如*zlib*或*openssl*；
- [`crypt`](crypt)：用于高效的对称/非对称加密；
- [`net`](net)：用于客户端/服务器通信层；
- [`db`](db)：用于我们的*SQLite3*内核，以及SQL/NoSQL直接访问；
- [`rest`](rest)：用于RESTful客户端/服务器处理；
- [`orm`](orm)：用于高级ORM功能；
- [`soa`](soa)：用于高级SOA功能；
- [`app`](app)：用于托管（微）服务和应用程序；
- [`ui`](ui)：用于VCL/LCL用户界面导向的组件；
- [`script`](script)：用于支持的（java）script引擎；
- [`ddd`](ddd)：用于*领域驱动设计*相关代码；
- [`misc`](misc)：用于各种可重用的单元；
- [`tools`](tools)：用于与我们框架相关的一些有用工具。

## 单元命名

按照惯例：

- 单元名称全部小写，以便在POSIX或Windows文件系统上简单访问；
- 单元名称以点分隔，并以`mormot.`为前缀；
- 单元名称遵循它们在`src`子文件夹中的位置，例如，`mormot.core.json.pas`位于`src/core`文件夹中。

## 类型命名

相较于*mORMot 1.18*，一些可能引起混淆的或被弃用的命名，如`TSQLRecord`或`TSQLRest`等以“SQL”为前缀的命名，现已更名为`TOrm`和`TRest`，这样的更改是因为mORMot不仅支持SQL数据库，还可以与其他类型的数据库（例如NoSQL引擎，像是MongoDB）协同工作。命名更改后更能准确地反映其功能和兼容性。

总的来说，我们遵循了[Kotlin的良好命名规则](https://kotlinlang.org/docs/reference/coding-conventions.html#choosing-good-names)：
> 当使用缩写作为声明名称的一部分时，如果缩写由两个字母组成，则将其大写（如IOStream）；如果缩写更长，则只大写第一个字母（如XmlFormatter, HttpInputStream）。

此外，我们还对一些类型进行了调整和优化：
- `TSQLRawBlob`重命名为`RawBlob`,以去除对SQL的特定引用，使其更通用。
- `RawUtf8`是`System.UTF8String`类型的别名，这意味着在编写代码时，您可以根据需要灵活使用这两个类型名称。

值得注意的是，我们引入了一个名为`PUREMORMOT2`的编译条件。当在项目中定义此条件时，将禁用为保持向后兼容性而设置的类型名称重定向。随着时间的推移，我们可能会逐步减少对旧命名的支持，因此建议尽早适应新的命名规范。


## 包含文件

为了提升代码的整洁性和可维护性，我们引入了一些`.inc`包含文件。这些文件的作用如下：
- **操作系统特定代码**：例如，`mormot.core.os.posix.inc`包含了专为POSIX兼容系统（非Windows系统）编写的代码，这些代码在`mormot.core.os.pas`中被引用。
- **编译器特定代码**：对于某些特定编译器的特性或优化，我们使用了如`mormot.core.rtti.fpc.inc`的文件来包含Free Pascal Compiler(FPC)的RTTI（运行时类型信息）相关代码。
- **CPU特定代码**：（asm）为了提高性能或实现特定功能，我们可能需要在汇编级别编写代码。例如，`mormot.crypt.core.asmx64.inc`包含了针对64位x86架构的汇编代码，这些代码被集成在`mormot.crypt.core.pas`中。

通过使用这些`.inc`文件，我们能够将特定于平台、编译器或CPU的代码从主单元中分离出来，从而提高代码的可读性和模块化程度。这种做法也使得针对不同环境的定制和优化变得更加简单直接。


