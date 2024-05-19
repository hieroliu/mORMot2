# mORMot User Interface Units

## 文件夹内容

这个文件夹中存放的是与*mORMot*开源框架第2版相关的用户界面（UI）功能组件。

## 各单元详细介绍

### mormot.ui.core

这个单元提供了用于VCL（Visual Component Library）和LCL（Lazarus Component Library）用户界面支持的核心类型和函数，它们可以被重复使用：

- **LCL/VCL跨兼容性定义**：这些定义确保了代码可以在不同的图形库（如VCL和LCL）之间轻松移植和兼容。
- **高级UI包装函数**：提供了一系列高级功能，简化了用户界面开发的复杂性。

### mormot.ui.controls

这个单元包含了一些自定义的视觉控件，用于增强用户界面的功能和外观：

- **THintWindowDelayed**：这是一个`THintWindow`的子类，它可以自动隐藏，为用户提供更友好的提示和反馈信息。
- **TSynLabeledEdit**：扩展了标准的`TLabeledEdit`控件，提供了更多的自定义选项和功能。
- **TUIComponentsPersist**：这个类允许你将用户界面组件的状态保存为JSON格式，便于存储和恢复界面状态。

### mormot.ui.grid.orm

此单元专为与数据网格相关的操作设计：

- **TOrmTableToGrid**：这是一个包装器类，它允许你轻松地将`TOrmTable`（一个表示数据库表的类）的内容展示在`TDrawGrid`中，无需复杂的编程。
- **从ORM结果填充TStringGrid**：提供了一种便捷的方式，将ORM（对象关系映射）查询的结果直接填充到`TStringGrid`中，简化了数据展示的流程。

### mormot.ui.gdiplus

这个单元提供了对Windows GDI+（图形设备接口加）的支持，使得VCL和LCL应用程序能够利用先进的图形功能：

- **TSynPicture和相关类**：这些类允许你轻松处理和展示GIF、PNG、TIFF和JPG等图像格式。
- **高级函数包装器**：提供了一系列函数，简化了对图像的操作和管理，如加载、保存和转换等。

### mormot.ui.pdf

这个单元为Windows平台提供了一个高性能的PDF引擎：

- **共享类型和函数**：提供了一系列基础类型和功能，用于处理和生成PDF文件。
- **内部类**：这些类表示PDF文档中的各种对象，如页面、文本、图像等，使得生成复杂的PDF文档变得更加简单。
- **TPdfDocument和TPdfPage类**：这两个类是PDF引擎的核心，负责文档的创建、编辑和保存等操作。
- **TPdfDocumentGdi类**：这个类提供了与GDI（图形设备接口）的集成，允许你使用`TCanvas`对象在PDF文档中绘制图形和文本。

### mormot.ui.report

这个单元提供了一个简单的报表引擎，支持用户界面预览和PDF导出功能：

- **共享函数**：提供了一系列在报表渲染过程中常用的功能，如计算、格式化等。
- **TGdiPages报表引擎**：这是一个强大的报表引擎，允许你创建复杂的报表布局和样式。
- **TRenderPages原型**：这是一个未完成的原型类，展示了如何扩展报表引擎以支持更多的渲染选项和功能。

请注意，`TPages`组件最初是由Angus Johnson在2003年开发的。mORMot框架对其进行了分叉并进行了大量的修补和改进，以适应现代应用程序的需求。这些用户界面单元为开发者提供了丰富的功能和灵活性，使他们能够轻松地创建出功能强大且用户友好的应用程序界面。

