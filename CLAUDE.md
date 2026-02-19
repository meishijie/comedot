# Comedot 项目 - Claude AI 专属配置

## 项目概述
Comedot 是基于 Godot 4.5+ 的组件式游戏框架和项目模板，专为 2D 游戏设计（平台游戏、射击游戏、RPG、回合制、策略等）。采用 **Entity-Component (实体-组件)** 架构，使用组合而非继承。

## 项目结构
```
/Volumes/meiMacMedia/app/github/comedot/
├── Components/     # 组件目录 (21类，约150+组件)
├── Entities/       # 实体目录
├── Scenes/         # 场景目录 (216个场景)
├── Tests/          # 测试场景 (Combat/TurnBased/Interaction等)
├── AutoLoad/       # 全局单例 (9个核心脚本)
├── Templates/      # 模板
├── Resources/      # 资源文件
└── Scripts/        # 脚本工具
```

## 核心架构

### Entity-Component 系统
- **Entity** (`Entity.gd`): 游戏对象容器，Node2D 子类
- **Component** (`Component.gd`): 可复用行为模块
- 通过 `coComponents` Dictionary 访问同级组件
- 使用 `NOTIFICATION_PARENTED` 自动注册

### 9 个全局 AutoLoad
| 脚本 | 功能 |
|------|------|
| `Global.gd` | 常量、Groups、工具 |
| `GameState.gd` | 游戏状态、玩家数据 |
| `SceneManager.gd` | 场景加载、过渡 |
| `GlobalInput.gd` | 输入动作管理 |
| `Settings.gd` | 玩家设置 |
| `TurnBasedCoordinator.gd` | 回合制协调 |
| `Debug.gd` | 日志系统 |
| `GlobalUI.tscn` | UI 层 |
| `GlobalSonic.tscn` | 音频管理 |

## 代码规范 (严格遵守)

### 命名规范
- ❌ **禁止使用下划线**
- ✅ 使用 `camelCase` 命名变量和函数
- ✅ 使用 `PascalCase` 仅限类型/类名
- ✅ Tab 缩进（2空格宽度）

### 函数命名
- `doSomething()` - 动作函数
- `getComponent()` - 获取组件
- `findComponent()` - 查找组件
- `createLabel()` - 创建对象

### 信号命名
- `{object}{tense}{event}` 格式
- 使用 `did/will` 前缀
- 处理器: `on[ObjectName]_[signalName]`

## 组件分类

### 战斗系统 (15 组件)
- `GunComponent` - 射击 (需重构解耦 InputComponent)
- `HealthComponent` - 生命值
- `DamageComponent` - 伤害计算
- `FactionComponent` - 阵营判定
- `KnockbackOnHitComponent` - 击退
- `BulletModifierComponent` - 子弹修饰
- `DamageOverTimeComponent` - 持续伤害
- `DamageRayComponent` - 射线伤害

### 移动系统 (18 组件)
- `CharacterBodyComponent` - 物理身体
- `TileBasedPositionComponent` - 瓦片定位
- `PlatformerPatrolComponent` - 平台巡逻
- `NavigationComponent` - 导航
- `ChaseComponent` - 追击
- `PathFollowComponent` - 路径跟随

### AI 系统
- `TurretBehaviorComponent` - 炮塔行为 (近期开发)
- `TimerAgentComponentBase` - 计时器代理
- `ChaseComponent` - 追击 AI
- `RandomMovementComponent` - 随机移动

### 回合制系统
- `TurnBasedCoordinator` - 回合协调
- `TurnBasedEntity` - 回合制实体
- `TurnBasedComponent` - 回合组件
- `TurnBasedCounterComponent` - 回合计数器

### 交互系统
- `InteractionComponent` - 交互
- `CollectibleComponent` - 收集品
- `PortalInteractionComponent` - 传送门
- `MineableComponent` - 可采集

## ToDo 优先级

### 紧急任务 (Sisyphus 标记)
- [ ] **重构 GunComponent** - 解耦 InputComponent，AI 需要 dummy InputComponent
- [ ] **修复 Camera 抖动** - reattaching 时
- [ ] **修复 GunComponent 速度 bug** - 反向射击子弹加速

### 主要任务
- [ ] 标准游戏状态和存档系统
- [ ] UI 架构 (菜单、窗口)
- [ ] Save/Load 实现

### 已完成
- [x] 导航组件
- [x] 玩家设置
- [x] 区域随机填充
- [x] 调试断点快捷键

## 当前开发重点

### 战斗系统重构
1. GunComponent 与 InputComponent 解耦
2. 射击方向速度计算修正
3. 支持 AI 原生控制

### AI 行为完善
1. Turret 炮塔目标追踪
2. 预测射击算法
3. 目标优先级排序

### 回合制系统
1. 存档/读档
2. UI 集成
3. 速度计算优化

## 测试场景

| 路径 | 用途 |
|------|------|
| `Tests/Combat/` | 战斗系统测试 |
| `Tests/TurnBased/` | 回合制测试 |
| `Tests/InteractionTest.tscn` | 交互测试 |
| `Tests/PathfindingTest.tscn` | 寻路测试 |
| `Tests/Upgrades/` | 升级系统测试 |

## 常用调试工具

### Debug.gd 日志
```gdscript
Debug.printLog()      # 普通日志
Debug.printWarning()  # 警告
Debug.printError()    # 错误
Debug.printHighlight() # 高亮
Debug.printTrace()    # 堆栈追踪
```

### DebugComponent
- 实时变量监控
- ChartWindow 图表
- `../ComponentName:property:x` 格式引用

## 启动流程
1. `project.godot` → `IOLogoScene.tscn`
2. `IOLogoScene.gd` → `setupGameState()`
3. 显示 Logo → 过渡到主菜单
4. 点击 Start → 加载 `Settings.mainGameScenePath`

## 注意事项

1. **AreaCollisionComponent 信号**
   - 不会自动连接碰撞信号
   - 必须手动调用 `connectSignals()` 或设置 `shouldConnectSignalsOnReady = true`

2. **CharacterBodyComponent**
   - 必须是 Entity 的 **最后一个子节点**

3. **组件依赖顺序**
   - 检查 `getRequiredComponents()` 返回顺序
   - 缺失依赖会导致崩溃

4. **GunComponent 依赖**
   - 当前硬依赖 InputComponent
   - AI 实体需添加 `isPlayerControlled = false` 的 InputComponent

## 项目路径
- **根目录**: `/Volumes/meiMacMedia/app/github/comedot`
- **Godot 版本**: 4.6.stable.official
- **框架**: Comedot Entity-Component
