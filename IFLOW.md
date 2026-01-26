# Comedot 项目上下文

## 项目概述

**Comedot** 是一个基于 **Godot 4.5** 的组件化游戏开发框架和项目模板，专注于 2D 游戏开发。

- **项目类型**: Godot 游戏开发框架
- **核心架构**: 组件化架构（Entity-Component 模式）
- **编程语言**: GDScript
- **引擎版本**: Godot 4.5+
- **项目状态**: 活跃开发中，个人项目，无向后兼容性保证

## 核心理念

Comedot 采用组件化架构，通过组合可重用的组件来构建游戏实体，而非传统的继承方式：

- **Entity（实体）**: 游戏角色或对象的"脚手架"，负责管理组件
- **Component（组件）**: 独立可重用的行为或属性，负责实际的游戏逻辑
- **组合优于继承**: 通过组合不同组件实现各种游戏玩法

## 项目结构

```
comedot/
├── AutoLoad/              # 9个全局自动加载脚本
│   ├── Global.gd          # 全局常量、工具函数、框架标志
│   ├── GameState.gd       # 游戏状态管理、玩家管理、存取档
│   ├── SceneManager.gd    # 场景管理和过渡
│   ├── GlobalInput.gd     # 输入动作管理
│   ├── GlobalUI.gd        # 全局UI层（暂停覆盖层等）
│   ├── GlobalSonic.gd     # 音频管理
│   ├── Settings.gd        # 系统设置、玩家偏好
│   ├── TurnBasedCoordinator.gd  # 回合制游戏协调器
│   └── Debug.gd           # 调试工具、日志系统
│
├── Components/           # 核心组件库（11个分类）
│   ├── AI/               # AI行为组件
│   ├── Combat/           # 战斗系统（15个组件）
│   ├── Control/          # 玩家控制
│   ├── Data/             # 数据管理组件
│   ├── Gameplay/         # 游戏玩法组件
│   ├── Interaction/      # 交互系统
│   ├── Movement/         # 移动系统（18个组件）
│   ├── Objects/          # 物体组件
│   ├── Physics/          # 物理系统
│   ├── TurnBased/        # 回合制组件
│   └── Visual/           # 视觉效果
│   ├── Component.gd      # 组件基类（核心）
│   └── DebugComponent.gd # 调试组件
│
├── Entities/             # 实体基类和模板
│   ├── Entity.gd         # 核心实体类（约700行）
│   └── Characters/
│       └── PlayerEntity.gd
│
├── Resources/            # 资源系统
│   ├── Stats/            # 属性系统
│   ├── Upgrades/         # 升级系统
│   ├── Actions/          # 动作定义
│   ├── Parameters/       # 参数配置
│   ├── Payloads/         # 载荷定义
│   ├── Shortcuts/        # 快捷键配置
│   ├── InventoryItem.gd  # 物品资源
│   └── TileMapCellData.gd # 瓦片地图单元格数据
│
├── Scripts/              # 工具脚本
│   ├── Tools.gd          # 核心工具函数库（1431行）
│   ├── Animations.gd     # 动画系统
│   └── Data/             # 数据处理脚本
│
├── UI/                   # UI组件库
│   ├── ModalUI.gd        # 模态窗口
│   ├── PauseOverlay.gd   # 暂停覆盖层
│   ├── TreeSearchBox.gd  # 树形搜索框
│   └── ChartWindow.tscn  # 实时图表窗口
│
├── Templates/            # 模板和示例
│   ├── Entities/         # 实体模板
│   ├── Examples/         # 示例场景
│   └── Scenes/           # 场景模板
│
├── Tests/                # 测试场景
│   ├── Combat/
│   ├── Inventory/
│   └── TurnBased/
│
└── Assets/               # 资源文件
    ├── Fonts/            # 字体（PixelOperator8.ttf）
    ├── Icons/            # 组件图标
    ├── Images/           # 图片资源
    ├── Materials/        # 材质
    ├── Shaders/          # 着色器
    ├── Themes/           # UI主题
    └── Tiles/            # 瓦片集
```

## 核心系统详解

### 1. AutoLoad 全局系统

#### Global.gd
- **功能**: 框架核心常量、工具函数、全局标志
- **关键内容**:
  - `Groups` 类: 定义所有Godot组名称（components, entities, players, enemies等）
  - `AudioBuses` 类: 音频总线定义
  - `TileMapCustomData` 类: 瓦片地图自定义数据类型
  - 截图功能

#### GameState.gd
- **功能**: 游戏状态管理、全局事件总线
- **关键属性**:
  - `globalData`: 全局数据字典
  - `players`: 玩家实体数组
  - `hudStats`: HUD显示数据
- **关键信号**:
  - `playersChanged`: 玩家列表变化
  - `playerAdded/Removed`: 玩家添加/移除
  - `statUpdated`: 属性更新
  - `gameDidOver`: 游戏结束

#### SceneManager.gd
- **功能**: 场景加载、实例化、过渡
- **关键方法**:
  - `loadSceneAndAddInstance()`: 加载场景并添加实例
  - `transitionToScene()`: 场景过渡

#### Debug.gd
- **功能**: 调试日志、追踪、高亮显示
- **关键方法**:
  - `printLog()`: 普通日志
  - `printDebug()`: 调试日志
  - `printWarning()`: 警告
  - `printError()`: 错误
  - `printTrace()`: 堆栈追踪

### 2. 组件系统

#### Component.gd (基类)
- **核心功能**:
  - 组件生命周期管理（NOTIFICATION_PARENTED → _enter_tree() → _ready()）
  - 父实体注册和验证
  - 组件依赖检查（`getRequiredComponents()`）
  - 组件间通信（`coComponents` 字典）
  - 调试和日志系统

- **关键属性**:
  - `parentEntity`: 父实体引用
  - `coComponents`: 兄弟组件字典（通过class_name索引）
  - `debugMode`: 调试模式
  - `isLoggingEnabled`: 日志开关

- **关键方法**:
  - `registerEntity()`: 注册到父实体
  - `findCoComponent()`: 查找兄弟组件
  - `removeSiblingComponentsOfSameType()`: 移除同类型组件
  - `toggleEnabled()`: 启用/禁用组件

#### 组件分类统计
- **Combat (15个)**: 战斗系统
- **Movement (18个)**: 移动系统
- **Control**: 控制系统
- **AI**: AI行为
- **Interaction**: 交互系统
- **Physics**: 物理系统
- **TurnBased**: 回合制
- **Visual**: 视觉效果
- **Data**: 数据管理
- **Gameplay**: 游戏玩法
- **Objects**: 物体组件

### 3. 实体系统

#### Entity.gd (基类)
- **核心功能**:
  - 组件容器和管理器
  - 组件注册/注销/查找
  - 子节点管理
  - 延迟属性初始化（sprite, area, body）
  - 帧级函数调用管理（`callOnceThisFrame()`）

- **关键属性**:
  - `components`: 组件字典（{StringName: Component}）
  - `functionsAlreadyCalledOnceThisFrame`: 每帧调用一次的函数字典
  - `sprite/area/body`: 主要视觉/碰撞/物理节点

- **关键方法**:
  - `registerComponent()`: 注册组件
  - `getComponent()`: 获取组件
  - `addComponent()`: 添加现有组件
  - `createNewComponent()`: 创建新组件实例
  - `transferComponents()`: 转移组件到其他实体
  - `toggleComponents()`: 批量启用/禁用组件
  - `callOnceThisFrame()`: 帧级单次调用

### 4. 工具系统

#### Tools.gd (1431行)
- **功能**: 核心工具函数库，补充Godot内置功能不足
- **主要分类**:
  - **场景管理**: 节点操作、父子关系管理
  - **脚本工具**: 信号连接/断开、自定义调用、方法查找
  - **节点管理**: 查找子节点、替换节点、移除节点
  - **区域和形状几何**: 碰撞形状边界计算、矩形操作
  - **方向系统**: 8方向罗盘、方向向量
  - **距离计算**: 最近节点/区域查找

## 支持的游戏类型

1. **平台跳跃**: PlatformerPhysicsComponent + JumpComponent
2. **射击游戏**: GunComponent + BulletModifierComponent
3. **RPG**: OverheadPhysicsComponent + InteractionComponent
4. **回合制游戏**: TurnBasedEntity + TurnBasedComponent
5. **基于瓦片的策略游戏**: TileBasedControlComponent + TileBasedPositionComponent
6. **益智游戏**: 各种交互和收集组件

## 编码规范

### 命名约定
- **无下划线**: 尽可能避免使用下划线
- **camelCase**: 所有命名都使用驼峰命名法（包括常量）
- **类型名大写**: 类名首字母大写
- **短首字母缩写可全大写**: 如 `UI`, `HUD`

### 函数命名
- **动作/命令**: `doSomething()`, `checkValidity()`
- **快速检索**: `getComponent()` (使用`get`)
- **搜索操作**: `findComponent()` (使用`find`)
- **添加现有**: `addText()` (使用`add`)
- **创建新对象**: `createLabel()` (使用`create`)

### 信号命名
- **对象聚焦**: `{object}{tense}{event}` 如 `healthDidDecrease`
- **动作聚焦**: `{action}{object}` 如 `didSpawnEntity`
- **对象聚焦**: `{object}{action}` 如 `entityDidSpawn`
- **时态**: 使用 `did` 或 `will` 表示过去/将来

### 信号处理函数命名
- `on[ObjectThatEmittedSignal]_[signal]`
- 如果是自身发出的信号，简化为 `on[Signal]`

### 缩进和格式
- **使用Tab而非空格**
- **函数间空2行**
- **代码区域间空2行**

### 注释规范
- **不使用BBCode**: 等待Godot实现Markdown
- **标签系统**:
  - `TODO`: 待办事项
  - `FIXME`: 需要修复
  - `TBD`: 待决定
  - `CHECK`: 需要检查
  - `DESIGN`: 设计决策说明
  - `DEBUG`: 调试代码
  - `FIXED/SOLVED/DONTTOUCH`: 已解决，勿动
  - `WORKAROUND`: 临时解决方案
  - `CREDIT`: 致谢
  - `THANKS`: 感谢启发

## 使用方式

### 创建游戏步骤

1. **初始化**:
   - 复制Comedot项目或创建新分支
   - 主场景根节点附加`Start.gd`脚本

2. **创建玩家实体**:
   - 创建`CharacterBody2D`节点
   - 附加`PlayerEntity.gd`脚本
   - 添加`Sprite2D`/`AnimatedSprite2D`, `CollisionShape2D`, `Camera2D`
   - 设置物理碰撞层和遮罩

3. **添加组件**:
   - 使用"实例化子场景"（SHIFT+Control/Command+A）
   - 拖拽`.tscn`场景文件到实体节点
   - **不要**拖拽`.gd`脚本文件
   - **不要**使用"添加子节点"（Control/Command+A）

4. **组件顺序**:
   - `InputComponent`必须在其他组件之后
   - `CharacterBodyComponent`必须是最后一个物理组件

### 自定义方式（从易到难）
1. **启用可编辑子节点**: 修改特定实例的内部节点
2. **继承场景**: 创建新场景继承现有组件
3. **子类化脚本**: `extends Component`并重写方法
4. **修改原始场景/脚本**: 永久修改默认功能
5. **创建全新组件**: 从零开始

## 游戏运行后的场景加载顺序

### 启动流程

当游戏启动时，Godot 引擎按照以下顺序加载和初始化系统：

#### 1. Godot 引擎初始化
- 加载项目配置（project.godot）
- 初始化渲染器、音频系统等核心引擎组件

#### 2. AutoLoad 脚本加载（按顺序）
Godot 按照在 project.godot 中定义的顺序加载 9 个全局自动加载脚本：

1. **Global.gd** - 全局常量、工具函数、框架标志
2. **Settings.gd** - 系统设置、玩家偏好
3. **SceneManager.gd** - 场景管理和过渡
4. **GlobalInput.gd** - 输入动作管理
5. **GameState.gd** - 游戏状态管理
6. **GlobalUI.tscn** - 全局 UI 层（暂停覆盖层等）
7. **GlobalSonic.tscn** - 音频管理
8. **TurnBasedCoordinator.tscn** - 回合制游戏协调器
9. **Debug.tscn** - 调试工具

**注意**: AutoLoad 脚本在主场景加载之前就已经完全初始化，可以在任何场景中直接访问。

#### 3. 主场景加载
- Godot 加载 `run/main_scene` 中指定的主场景
- 主场景根节点必须附加 `Start.gd` 脚本

#### 4. Start.gd 初始化流程

**第一阶段：_enter_tree()**
```
Start._enter_tree()
  └─> setupGameState()
       ├─> 将 mainGameScenePath 设置到 Settings.mainGameScenePath
       ├─> 合并 initialGlobalData 到 GameState.globalData
       └─> 为 GameState 创建 gameStateNodes 中指定的子节点
```

**第二阶段：_ready()**
```
Start._ready()
  └─> startComedot()
       ├─> 设置 Global.hasStartScript = true
       ├─> 执行 Debug.performFrameworkChecks()
       └─> applyGlobalFlags()
            ├─> 应用调试标志（Debug 相关）
            ├─> 应用游戏状态（已在 _enter_tree 中设置）
            ├─> 应用音乐设置（GlobalSonic）
            │    ├─> 加载音乐文件夹
            │    ├─> 播放指定音乐或随机音乐
            │    └─> 设置音乐索引
            └─> 应用回合制设置（TurnBasedCoordinator）
                 ├─> 如果是回合制游戏，设置延迟参数
                 └─> 如果不是回合制游戏，禁用并移除 TurnBasedCoordinator
```

### 场景过渡流程

#### 基本场景过渡
```
SceneManager.transitionToScene(nextScene)
  ├─> 禁用暂停快捷键（GlobalInput.isPauseShortcutAllowed = false）
  ├─> 检查是否正在过渡到同一场景（防止重复调用）
  ├─> 发出 willTransitionToScene 信号
  ├─> 暂停场景树（sceneTree.paused = true）
  ├─> 淡入覆盖层（如果 animate = true）
  ├─> 切换场景（sceneTree.change_scene_to_packed）
  ├─> 重新暂停场景树
  ├─> 等待 0.1 秒（给新场景一点呼吸时间）
  ├─> 取消暂停（开始游戏运动）
  ├─> 淡出覆盖层（如果 animate = true）
  ├─> 清除过渡跟踪器
  ├─> 发出 didTransitionToScene 信号
  └─> 重新启用暂停快捷键
```

#### 场景栈导航
Comedot 支持类似浏览器的前进后退功能：

**压栈并跳转**（前进到新场景）
```
SceneManager.pushCurrentSceneAndTransition(nextScene)
  ├─> pushCurrentSceneToStack()
  │    └─> 将当前场景路径添加到 sceneStack
  └─> transitionToScene(nextScene)
```

**出栈并返回**（返回上一场景）
```
SceneManager.popSceneFromStack()
  ├─> 发出 willPopScene 信号
  ├─> 从 sceneStack 顶部获取上一场景路径
  ├─> 从 sceneStack 中移除该路径
  ├─> 加载上一场景
  ├─> transitionToScene(previousScene)
  └─> 发出 didPopScene 信号
```

**场景栈特点**:
- 后进先出（LIFO）结构
- 数组末尾是栈顶（上一个场景）
- 新场景从末尾添加（push_back）
- 旧场景从末尾移除（pop_back）
- 性能优化：避免使用 push_front/pop_front

### 暂停/恢复流程

```
SceneManager.setPause(shouldPause)
  ├─> 发出 willSetPause 信号
  ├─> 设置 sceneTree.paused
  ├─> GlobalUI.showPauseVisuals(sceneTree.paused)
  └─> _notification() 处理 NOTIFICATION_PAUSED/UNPAUSED
       └─> 发出 didSetPause 信号
```

### 场景实例化流程

当需要动态创建场景实例时：

```
SceneManager.loadSceneAndAddInstance(path, parent, position)
  ├─> 加载场景文件（load(path)）
  └─> addSceneInstance(scene, parent, position)
       ├─> 实例化场景（scene.instantiate()）
       ├─> 设置位置（如果是 Node2D 或 Control）
       └─> 添加到父节点并设置 owner（确保持久化）
```

### 完整的游戏启动流程示例

```
1. 玩家启动游戏
   ↓
2. Godot 加载 AutoLoad 脚本（9个全局单例）
   ↓
3. Godot 加载主场景（附加 Start.gd）
   ↓
4. Start._enter_tree() → setupGameState()
   - 设置主游戏场景路径
   - 初始化全局数据
   - 创建 GameState 子节点
   ↓
5. Start._ready() → startComedot() → applyGlobalFlags()
   - 应用调试设置
   - 应用音乐设置
   - 应用回合制设置（如果需要）
   ↓
6. 显示主菜单场景
   ↓
7. 玩家选择"开始游戏"
   ↓
8. SceneManager.pushCurrentSceneAndTransition(mainGameScene)
   - 主菜单路径压入 sceneStack
   - 过渡到主游戏场景
   ↓
9. 主游戏场景加载
   - 创建玩家实体
   - 添加组件
   - 初始化游戏逻辑
   ↓
10. 游戏运行
    - 玩家操作
    - 场景内跳转
    - 暂停/恢复
    ↓
11. 玩家选择"返回菜单"
    ↓
12. SceneManager.popSceneFromStack()
    - 从 sceneStack 弹出主菜单路径
    - 过渡回主菜单
    ↓
13. 循环...
```

### 重要注意事项

1. **Start.gd 必须在主场景根节点**: 否则框架不会正确初始化
2. **AutoLoad 脚本顺序很重要**: 某些 AutoLoad 依赖其他 AutoLoad
3. **场景栈管理**: 确保压栈和出栈成对使用，避免栈溢出
4. **暂停期间禁用快捷键**: 场景过渡期间会自动禁用暂停快捷键
5. **异步操作**: 场景过渡是异步的，使用 `await` 等待动画完成
6. **调试信息**: 使用 Debug AutoLoad 查看详细的场景加载日志

### 调试场景加载

在开发过程中，可以使用以下方法调试场景加载：

- 启用 `Debug.shouldPrintDebugLogs` 查看详细日志
- 监听 SceneManager 的信号（willTransitionToScene, didTransitionToScene 等）
- 使用 `SceneManager.sceneStack` 查看当前场景栈状态
- 使用 `GlobalInput.isPauseShortcutAllowed` 检查快捷键状态
- 使用 `GlobalUI` 的覆盖层可视化场景过渡效果

## 开发工作流

### 项目组织方式
1. **方案A**: 为每个游戏创建Comedot项目的完整副本
2. **方案B**: 在同一项目中使用不同分支
3. **方案C**: 在`/Game/`子文件夹中创建多个游戏项目

### 调试技巧
- 启用 `debugMode` 属性查看详细调试信息
- 使用 `Debug.printTrace()` 显示堆栈追踪
- 使用 `ChartWindow` 实时监控变量
- 使用 `DebugComponent` 可视化调试

## 特色功能

### 1. 智能组件通信
- `coComponents`字典提供O(1)访问速度
- 支持子类查找（`findFirstComponentSubclass()`）
- 组件依赖验证（`getRequiredComponents()`）

### 2. 高级调试系统
- `debugMode`启用详细调试信息
- `printTrace()`显示堆栈追踪
- `ChartWindow`实时变量监控
- `DebugComponent`可视化调试
- 随机调试颜色区分不同组件

### 3. 帧级优化
- `callOnceThisFrame()`确保每帧只调用一次
- `functionsAlreadyCalledOnceThisFrame`字典管理
- 避免重复物理计算（如`move_and_slide`）

### 4. 灵活的组件管理
- 运行时添加/移除组件
- 组件转移（`transferComponents()`）
- 批量启用/禁用（`toggleComponents()`）
- 同类型组件替换

## 技术栈

### 核心技术
- **引擎**: Godot 4.5
- **语言**: GDScript
- **架构**: 组件化架构（Entity-Component模式）
- **渲染**: 2D渲染器
- **物理**: Godot 2D物理系统

### 设计模式
- **组合优于继承**: 核心设计理念
- **观察者模式**: 信号系统
- **策略模式**: 不同组件实现不同行为
- **工厂模式**: 组件创建
- **单例模式**: AutoLoad系统
- **管理器模式**: 各类管理器组件

## 重要注意事项

### 版本兼容性
- **无向后兼容性保证**: API可能频繁变化
- 个人项目性质: 可能包含实验性功能
- 需要Godot 4.5+

### 学习曲线
- 需要理解组件化架构
- 组件依赖关系需要管理
- 组件顺序可能影响功能

### 性能考虑
- 大量组件可能影响性能
- 组件间通信有开销
- 需要合理使用组件数量

## 常见问题

### 组件添加失败
- 使用"实例化子场景"而非"添加子节点"
- 拖拽`.tscn`文件而非`.gd`脚本
- 检查组件依赖关系

### 组件间通信失败
- 检查组件是否正确注册到实体
- 使用`coComponents`字典访问兄弟组件
- 检查组件顺序

### 性能问题
- 使用Godot Profiler追踪性能瓶颈
- 考虑合并多个小组件为一个大组件
- 使用`callOnceThisFrame()`避免重复计算

## 文档资源

- **README.md**: 项目概述和快速开始
- **HowTo.md**: 详细使用指南
- **Conventions.md**: 编码规范和设计原则
- **ToDo.md**: 待办事项列表
- **Templates/Examples/**: 示例场景
- **Tests/**: 测试场景

## 项目特点

✅ **架构清晰**: 职责分离明确，易于理解和扩展
✅ **功能丰富**: 80+预置组件，覆盖多种游戏类型
✅ **文档完善**: 详细的代码注释和使用指南
✅ **灵活性强**: 支持多种自定义方式，可与其他架构混用
✅ **性能优化**: 帧级优化、对象重用、高效查找

⚠️ **注意事项**:
- 无向后兼容性保证（个人项目，API可能变化）
- 需要Godot 4.5+
- 需要理解组件化架构
- 存取档系统较基础

## 适用场景

**最适合**:
- 2D游戏开发（平台跳跃、射击、RPG等）
- 快速原型开发
- 学习Godot
- 中小型项目

**不太适合**:
- 3D游戏（专注于2D）
- 超大型项目（可能需要更深度的定制）
- 性能极致要求（组件化架构有一定开销）
- 传统架构团队（需要适应组件化思维）

## 贡献指南

- 查看 `ToDo.md` 了解可以贡献的领域
- 遵循 `Conventions.md` 中的编码规范
- 如果创建了可复用的组件，可以考虑添加到Comedot库中
- 通过 GitHub Issues 或 Pull Requests 贡献

## 项目成熟度

- **架构设计**: ⭐⭐⭐⭐⭐ (5/5)
- **功能完整性**: ⭐⭐⭐⭐☆ (4/5)
- **文档质量**: ⭐⭐⭐⭐⭐ (5/5)
- **代码质量**: ⭐⭐⭐⭐☆ (4/5)
- **稳定性**: ⭐⭐⭐☆☆ (3/5 - 个人项目，API可能变化)

这是一个值得学习和使用的优秀Godot框架，特别适合2D游戏开发和快速原型制作。