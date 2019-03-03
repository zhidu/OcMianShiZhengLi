OC面试整理
一.简历
1.技能要求：
初级工程师： 精通Objective-C语言基础（能够熟练并正确使用oc的分类扩展kvo kvc等）
           精通UIKit等Cocoa Framework（能够正确使用自定义控件）
           熟悉网络通信机制以及常用的数据传输协议
           具备主流开源框架的使用经验
中级工程师： 扎实的编程、数据结构、算法基础
           深入理解语言机制，内存管理、网络、多线程、GUI
           精通常用的设计模式、框架、架构
           良好的分析、解决问题的能力（看源码）
高级工程师： 解决研发过程中的关键问题和技术难题
           调优设备流量、性能、电量、feed流性能优化
           较强的软件设计能力
           对ios内部原理有深刻理解
资深工程师： 精通高性能编程及性能调优（对象创建用多线程解决，字符串遍历选择最优算法）
           灵活运用数据结构、算法解决算法程序设计问题
           提供性能优化、日志搜集、统计分析等方案
           架构、模块设计
2.表达宗旨
简洁性：  排版清晰
         有亮点、优势突出
         2-3页
         挑重要的突出的表达
真实性：  可以包装，但不能伪造
         量化指标说明，比如前后crash量变化，线上bug数，开发成本节约（维护简单，同等条件下，对比安卓，安卓需要2天，我们需要1.5天）

全面性：  邮箱联系方式
        履历公司要全面

3.内容四要素
基本信息：姓名、现居住地、工作年限、学校、学历、专业、邮箱、电话
工作经历：时间 + 任职公司 + 职位（角色变化要有梯度）
        如：2014.07 - 至今      任职公司AAA ios技术负责人
           2011.07 - 2014.07   任职公司BBB ios高级工程师
           2009.07 - 2011.07    任职公司CCC ios初级工程师
项目经验： 列举比较有亮点的2-3个项目
         体现自己承担的角色 （主导-参与-核心研发者）
         项目背景+技术方案+效果
擅长技能

二 UI视图
1.UITableView相关
重用机制：
   dequeueReusableCellWithIdentifier:和dequeueReusableCellWithIdentifier:forIndexPath:的区别：
        如果你注册过Cell，在没有可用的cell时，前者会返回nil；而后者永远都会从注册的nib或者class中替你创建一个可用的Cell。也就是说，前者调用你需要手动检查nil，而后者不需要；
        如果你从没有注册过cell，在没有可用的cell时，前者会返回nil，后者……直接崩溃！也就是说，调用后者你 必须确保注册过cell 。
数据源同步：多线程环境下访问数据源(解决方案):
          并发访问、数据拷贝的方式
          串行访问的方式
2.事件传递&视图响应
UIView和CALayer关系：
         UIView为其提供内容，以及负责处理触摸等事件，参与响应链
         CALayer负责显示内容contents
         这样设计体现单一设计原则,职责分离
         用途：用贝塞尔画图/绘制文字，如我项目中的身边事扇形图
              直接给layer.contents赋值图片做背景图，如视频直播工具栏的背景图
事件传递：
         倒序遍历子视图，后加入的view先被判断是否是响应的view
         pointInside 判断是否在当前view的frame内
         hitTest 判断当前view能否响应点击（以下都不能响应）：
            - 不接收用户交互: userInteractionEnabled = NO
            - 隐藏: hidden = YES
            - 透明: alpha = 0.0 ~ 0.01
         用途：扩大按钮点击区域
              指定响应的view
         坑：如果确定最终父控件是最合适的view，那么该父控件的子控件的hitTest:withEvent:方法也是会被调用的，whiteView有redView和greenView两个子控件。redView先添加，greenView后添加。如果要求无论点击那里都要让redView作为最合适的view（把事件交给redView来处理）那么只能在whiteView的hitTest:withEvent:方法中return self.subViews[0];这种情况下在redView的hitTest:withEvent:方法中return self;是不好使的！
        技巧：想让谁成为最合适的view就重写谁自己的父控件的hitTest:withEvent:方法返回指定的子控件，或者重写自己的hitTest:withEvent:方法 return self。但是，建议在父控件的hitTest:withEvent:中返回子控件作为最合适的view！

响应链：
   事件的传递是从上到下（父控件到子控件），事件的响应是从下到上（顺着响应者链条向上传递：子控件到父控件）
   UIResponder的子类对象才能响应事件
3.图像显示原理
   CPU 计算好显示内容提交到 GPU，GPU 渲染完成后将渲染结果放入帧缓冲区，随后视频控制器会按照 VSync 信号逐行读取帧缓冲区的数据，经过可能的数模转换传递给显示器显示。
4.UI掉帧&卡顿
  在规定的16.7ms时间内，在下一帧vsync的信号到来之前，并没有完成cpu和gpu画面的合成
  (在 VSync 信号到来后，系统图形服务会通过 CADisplayLink 等机制通知 App，App 主线程开始在 CPU 中计算显示内容，比如视图的创建、布局计算、图片解码、文本绘制等。随后 CPU 会将计算好的内容提交到 GPU 去，由 GPU 进行变换、合成、渲染。随后 GPU 会把渲染结果提交到帧缓冲区去，等待下一次 VSync 信号到来时显示到屏幕上。由于垂直同步的机制，如果在一个 VSync 时间内，CPU 或者 GPU 没有完成内容提交，则那一帧就会被丢弃，等待下一次机会再显示，而这时显示屏会保留之前的内容不变。这就是界面卡顿的原因。)
  滑动优化方案：cpu--对象的创建、调整、销毁在子线程中完成
                  预排版（布局计算、文本计算在子线程中完成）
                  预渲染（文本等异步绘制、图片解码器等）
              gpu--纹理渲染（避免离屏渲染）
                   视图混合 （视图复杂性）
 对象的创建、调整、销毁：
            尽量用轻量的对象代替重量的对象，可以对性能有所优化。比如 CALayer 比 UIView 要轻量许多，那么不需要响应触摸事件的控件，用 CALayer 显示会更加合适
            通过 Storyboard 创建视图对象时，其资源消耗会比直接通过代码创建对象要大非常多
            对象的调整也经常是消耗 CPU 资源的地方。这里特别说一下 CALayer：CALayer 内部并没有属性，当调用属性方法时，它内部是通过运行时 resolveInstanceMethod 为对象临时添加一个方法，并把对应属性值保存到内部的一个 Dictionary 里，同时还会通知 delegate、创建动画等等，非常消耗资源。UIView 的关于显示相关的属性（比如 frame/bounds/transform）等实际上都是 CALayer 属性映射来的，所以对 UIView 的这些属性进行调整时，消耗的资源要远大于一般的属性。对此你在应用中，应该尽量减少不必要的属性修改。当视图层次调整时，UIView、CALayer 之间会出现很多方法调用与通知，所以在优化性能时，应该尽量避免调整视图层次、添加和移除视图。
           对象的销毁虽然消耗资源不多，但累积起来也是不容忽视的。通常当容器类持有大量对象时，其销毁时的资源消耗就非常明显。同样的，如果对象可以放到后台线程去释放，那就挪到后台线程去。这里有个小 Tip：把对象捕获到 block 中，然后扔到后台队列去随便发送个消息以避免编译器警告，就可以让对象在后台线程销毁了。
            NSArray *tmp = self.array;
            self.array = nil;
            dispatch_async(queue, ^{
                [tmp class];
            });
  tableview：
        提前计算并缓存好高度（布局），因为heightForRowAtIndexPath:是调用最频繁的方法；
        异步绘制，遇到复杂界面，遇到性能瓶颈时，可能就是突破口；
        滑动时按需加载，这个在大量图片展示，网络加载的时候很管用！（SDWebImage已经实现异步加载，配合这条性能杠杠的）。
5.UIVIew绘制原理
        首先CALayer会在内部创建一个backing store(CGContextRef),我们一般在drawRect中可以通过上下文堆栈当中拿到当前栈顶的context.然后layer判断是否有代理,如果没有代理会调用layer的drawInContext方法,如果实现了代理就会调用delegete的drawLayer:inContext方法,这是在发生在系统内部当中的,然后在合适的时机给予回调方法,也就是View的drawRect方法.可以通过drawRect方法做一些其他的绘制工作.然后无论哪两个分支,都有calayer上传backing store (最终的位图)到CPU.然后结束系统的绘制流程.
6.离屏渲染
在屏渲染（on-screen renfering）:意为当前屏幕渲染，指的是gpu的渲染操作是在当前用于显示的屏幕缓冲区中进行
离屏渲染 (off-screen rendering): 指的是gpu在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作
当我们指定了UI视图的某些属性，标记为它在未预合成之前不能用于当前屏幕上面直接显示的时候，就会触发离屏渲染
何时触发：设置圆角（当和masktobounds一起使用时）
        图层蒙版
        阴影
        光栅化
为何避免：(高级/资深)在触发离屏渲染的会增加gpu的工作量，而增加gpu的工作量可能导致cpu和gpu工作耗时加起来的总耗时超过16.7毫秒，可能导致UI卡顿和掉帧
        （初中）离屏渲染会创建新的渲染缓冲区，会有内存上的开销，包括对于上下文切换，因为有多通道渲染管线，最终需要把多通道渲染结果的合成，需要上下文的切换，会有gpu的额外开销
7.异步绘制
 基于系统给我们开的口子layer.delegate,如果遵从或者实现了displayLayer方法,我们就可以进入到异步绘制流程当中,在异步绘制的过程当中

就由delegete去负责生成bitmap位图
设置改bitmap作为layer.content属性的值

三 Objective_c语言特性相关
1.分类
   分类做了哪些事：
          申明私有方法
          分解体积庞大的文件
          把framework的私有方法公开化
          特点：
          运行时决议
          可以为系统类添加分类
   分类添加哪些内容：
          添加实例方法
          添加类方法
          添加协议
          添加属性（没有实例变量）
      总结：分类添加的方法可以“覆盖”原类的方法
           同名分类方法谁能生效取决于编译顺序（最后被编译的分类，会被优先被生效）
           名字相同的分类会引起编译报错
      注意： category的方法没有“完全替换掉”原来类已经有的方法，也就是说如果category和原来类都有methodA，那么category附加完成之后，类的方法列表里会有两个methodA
            category的方法被放到了新方法列表的前面，而原来类的方法被放到了新方法列表的后面，这也就是我们平常所说的category的方法会“覆盖”掉原来类的同名方法，这是因为运行时在查找方法的时候是顺着方法列表的顺序查找的，它只要一找到对应名字的方法，就会罢休，殊不知后面可能还有一样名字的方法。
      问题： 在类的+load方法调用的时候，我们可以调用category中声明的方法么？
            这么些个+load方法，调用顺序是咋样的呢？
            1)、可以调用
            2)、+load的执行顺序是先类，后category，而category的+load执行顺序是根据编译顺序决定的。 目前的编译顺序是这样的：后编译的执行

2.关联对象
  关联对象的本质：
      关联对象由AssociationsManager管理并在AssociationsMapHash中储存。所有对象的关联内容都在统一的全局容器中
              AssociationsHashMap -> key : (obj分类对象)
                                    value:ObjectAssociationMap
              ObjectAssociationMap -> key:@selector(text)
                                    value:ObjectAssociation
              ObjectAssociation(对象) -> OBJC_ASSOCIATION_COPY_NONATOMIC（策略） 、@“hello”（值）
              例子：
                    {
                    "Ox49333333" : {
                        "@selector(text)":{
                            "value"  : "hello"
                            "policy" :  "copy"
                        },
                        "@selector(color)":{
                            "value"  : "[uicolor whitecolor]"
                            "policy" :  "retain"
                        }
                    },
                    "Ox49444444" : {
                        "@selector(---)":{
                            "value"  : "---"
                            "policy" :  "---"
                        }
                    },
                    }
3.扩展
   做什么：
          申明私有属性
          申明私有方法
          申明成员变量
   特点：
          编译时决议
          只以声明的形式存在，多数情况下寄生在宿主类的.m中
          不能为系统类添加扩展

4.代理
   什么是代理：
     准确的说是一种软件设计模式
     ios中以@protocol形式体现
     一对一
   代理工作流程：
     协议  委托方（定义类） 代理方（遵循类）
     在协议里写委托方要求代代理方需要实现的接口
     代理方遵循协议实现方法，可能返回一个处理结果
     委托方调用代理方遵循的协议方法
   注意：
    一般在委托方中以weak以规避循环引用
5.通知
   特点：
     使用观察者模式来实现用于跨层传递消息（代理是用代理模式）
     传递方式一对多
  如何实现通知机制：
     Notification_Map -> key :notificationName
                        value:Observers_list(NSMutableArray< Observer>)
     Observer -> observer(观察者对象)、selector（执行的方法）、notificationName（通知名字）、object（携带参数）
     addObserver时新增observer将其存入Notification_Map的数据结构中
     removeObserver时将observer移除
     post在数据结构中寻找对应的观察者执行方法
6.kvo
   KVO是Key-value observing的缩写
   KVO是OC对观察者设计模式的一种实现
   苹果使用isa混写技术（isa-swizzling）来实现kvo（把isa的指针指向修改就是混写技术，当我们使用addobser时，系统会在运行时动态创建一个类NSKVONotifying_A,并将A的isa指针指向NSKVONotifying_A，NSKVONotifying_A是A的子类，之所以有这个继承关系是为了重写setter方法，在setter方法里通知所有通知者）
   //手动触发kvo
   [self willChangeValueForKey:@"XXX"];
   [super setXXX];
   [self didChangeValueForKey:@"XXX”];
  通过设置kvc设置属性能否使kvo生效?
  能，最终会调用set方法，系统已经重写了set方法
  通过成员变量赋值属性能否使kvo生效?
  不会，没有调用set方法
  总结：
    使用setter方法改变值，KVO才会生效
    使用KVCg改变值，KVO才会生效
    成员变量直接修改需要手动添加KVO才会生效
7.kvc
    KVC是Key-value coding缩写
    方法：valueforKey和setvalueforekey
    注意：
    面向对象破坏了面向对象编程思想（已知私有属性，通过kvc去修改）
    valueForkey流程:
    访问器方法是否存在 - YES : 直接调用
                    - NO :  同名或类似名称实例变量是否存在 - YES : 直接调用
                                                      - NO : valueForUndefinekey
    setValue流程:同valueForkey流程
    
    访问器是否存在规则 <getKey> <key> <isKey> ---存在
    同名或类似名称实例变量是否存在规则 _key _isKey key iskey ----存在
    
    在判断同名或类似名称实例变量是否存在时，若实现accessInstanceVariablesDirectly，会直接调用valueForUndefinekey
    用
    应用：
      动态地取值和设值
      用KVC来访问和修改私有变量
      Model和字典转换
      用KVC实现高阶消息传递,比如当对容器类使用KVC时，valueForKey:将会被传递给容器中的每一个对象，而不是容器本身进行操作。结果会被添加进返回的容器中，这样，开发者可以很方便的操作集合来返回另一个集合
      用KVC中的函数操作集合
8.属性关键字
    读写权限：
    readonly readwrite(默认)
    原子类：
    atomic  赋值和获取线程安全，添加对象和移除对象等别的操作不是线程安全的
    nonatomic
    引用计数：
    retain/strong
    assign/unsafe_unretained
    特点：
    修饰基本数据类型
    修饰对象类型师，不改变其引用计数
    会产生悬垂指针
    weak
    特点：
    不改变被修饰对象的引用计数
    所指对象在释放后会自动置为nil
    9.浅拷贝和深拷贝
    是否开辟新的内存空间
    是否影响了引用计数
    
    mutable对象（可变）        copy       不可变   深拷贝
    mutable对象（可变）     mutablecopy    可变    深拷贝
    immutable对象（不可变）    copy        不可变   浅拷贝
    immutable对象（不可变）  mutablecopy   可变    深拷贝
9.initialize和load的区别
  load:当类被引用进项目的时候就会执行load函数(在main函数开始执行之前）,与这个类是否被用到无关,每个类的load函数只会自动调用一次.由于load函数是系统自动加载的，因此不需要调用父类的load函数，否则父类的load函数会多次执行。
      1.当父类和子类都实现load函数时,父类的load方法执行顺序要优先于子类
      2.当子类未实现load方法时,不会调用父类load方法
      3.类中的load方法执行顺序要优先于类别(Category)
      4.当有多个类别(Category)都实现了load方法,这几个load方法都会执行,但执行顺序不确定(其执行顺序与类别在Compile Sources中出现的顺序一致)
      5.当然当有多个不同的类的时候,每个类load 执行顺序与其在Compile Sources出现的顺序一致
  initialize:
      文档：Initializes the class before it receives its first message.当类收到第一个消息时调用，通过阻塞线程的方式执行，线程安全，不要在改方法中添加可能需要的锁的代码或者复杂的代码，以免死锁
      1.父类优于子类调用
      2.子类未实现initialize时可能导致父类多次调用，官方推荐写法
      + (void)initialize {
         if (self == [ClassName self]) {
             // ... do the initialization ...
         }
      }
 10.NSDictionary底层实现原理
    NSDictionary（字典）是使用 hash表来实现key和value之间的映射和存储的， hash函数设计的好坏影响着数据的查找访问效率。
    NSMutableDictionary的KVC实现：
     - (void)setValue:(id)value forKey:(NSString*)key {
         if(value)
             [self setObject:value forKey:key];
         else
             [self removeObjectForKey:key];
     }
     setObject: ForKey:是NSMutableDictionary特有的；setValue: ForKey:是KVC的主要方法。
     (1) setValue: ForKey:的value是可以为nil的（但是当value为nil的时候，会自动调用removeObject：forKey方法）；
     setObject: ForKey:的value则不可以为nil。
     (2) setValue: ForKey:的key必须是不为nil的字符串类型；
    
    总结：
    MRC如何重写retain修饰变量的setter方法
    - (void)setObj:(id)Obj {
        if(_obj != obj)
            [obj release];
        _obj =  [obj retain];
    }
    请简述分类的实现原理
    KVO的实现原理
    能否为分类添加成员变量

四、内存管理
    内存布局
    顺序从stack到text，由高到低
            stack:方法调用
             heap:通过alloc等分配的对象
              bss:未初始化的全局变量等
             data:已经初始化的全局变量等
             text:程序代码
    内存管理方案
    小对象 ：TaggedPointer(NSNumber)
    64位架构：NONPointer_isa:
         64位架构下NONPointer_isa占64个比特位，实际上32或者40位就够了，剩余位数是浪费的，苹果为了提高内存利用率，苹果在剩余的比特位中存储了内存管理相关的数据内容，这个叫非指针型的isa
         arm64架构：
           第0二进制位:indexed(0 - 使用的isa指针只是代表当前对象地址  1- 表示isa不仅存储还存储内存管理相关数据内容)
           第1二进制位：has_assoc是否关联对象(0 - 没有  1 - 有)
           第2二进制位：has_cxx_dtor当前的对象是否使用了c++和arc
           第3-35二进制位：shiftcls当前对象类对象的指针地址
           第36-41:magic
           第43二进制位：weakly_referenced表示是否有弱引用指针
           第44二进制位：deallocating当前对象是否在进行delloc操作
           第45二进位：has_sidetable_rc当前这个isa的指针如果存储的引用计数已经达到上限，需要外挂一个sidetable数据结构存储相关内容
           第46-63二进制位：extra_rc额外的引用计数
    散列表（弱引用表/引用计数表）：
         side tables()结构
         side tables() = @[side Table,side Table...]
         side Table 结构: 自旋锁 spinlock_t
                         引用计数表 refcountMap
                         弱引用表  weak_table_t
         为什么不是一个side table ？而是由多个side table组成side tables()结构
          只有一个side table表，意味着所有的引用计数表和弱引用表都在一张表里，多线程安全需要给side table加锁，有效率问题，系统为了解决这个问题，引入了分离锁（8个表组成一个表）
         怎样实现快速分流？
         side tables 的本质是一张hash表
          对象指针（key） （通过hash函数）-> side tableside
         数据结构：
         spinlock_t是“忙等”的锁， 适用于轻量访问
         refcountMap 是一个hash表，通过传入对象的指针可以获取对象的引用计数，插入和获取用的同一个hash函数，避免了遍历，提高效率   指针 ( 通过hash函数)-> size_t
         size_t :
              第0二进制位：weakly_referenced表示是否有弱引用指针
              第1二进制位：deallocating当前对象是否在进行delloc操作
              第2-63二进制位：RC引用计数
         weak_table_t:是一个hash表
         weak底层实现：
         weak是Runtime维护了一个hash(哈希)表，用于存储指向某个对象的所有weak指针。weak表其实是一个hash（哈希）表，Key是所指对象的地址，Value是weak指针的地址（这个地址的值是所指对象指针的地址）数组。
    ARC和MRC
         MRC (手动引用计数):alloc retain release retainCount autorelease delloc
         ARC（自动引用计数 :arc是LLVM和Runtime协作的结果
                         禁止调用mrc手动调用 retain release retainCount autorelease delloc
                         arc新增weak、strong属性关键字
    引用计数管理
    alloc:经过一系列的调用，最终调用了C函数的calloc，此时并没有设置引用计数为1（通过retaincount获取是1）
    retain：
        sideTable& table = SideTable()[this]
        size_t & refcntStorage = table.refcnts[this]
        refcntStorage += SIDE_TABLE_RC_ONE
    release
        sideTable& table = SideTable[()[this]
        RefcountMap::iterator it & refcntStorage = table.refcnts.find(this)
        it - >second -= SIDE_TABLE_RC_ONE
    retainCount
        sideTable& table = SideTable()[this]
        size_t refcnt_result = 1
        RefcountMap::iterator it & refcntStorage = table.refcnts.find(this)
        refcnt_result += it -> second >> SIDE_TABLE_RC_SHIFT
        刚刚alloc的对象在引用计数表中的没有这个对象keyvalue的映射，所以引用计数表查出的值为0，加上局部变量 refcnt_result，就成了1
    delloc
        _objc_rootDealloc() -> rootDelloc - > 判断是否可以释放 -> yes - > c函数free()
                                                               no  - > objec_dispose()
        判断条件NONPointer_isa、weakly_referenced、has_assoc、has_cxx_dtor、has_sidetable_rc均为NO的情况下，判断条件的值为yes
        objec_dispose()函数实现：objc_destructInstance() - >c函数free()
        objc_destructInstance()函数实现： hasCxxDtor ->yes ->_object_cxxDestruct
                                                     no  ->hasAssociatedObjects -> yes ->_objc_remove_assocations() -> clearDeallocating()
                                                                                   no  ->clearDeallocating()
        clearDeallocating()函数实现：sidetable_clearDeallocating() -> weak_clear_no_lock()(将指向该对象的弱引用指针置为nil)->table.refcnts.erase()(从引用计数表中擦除该对象引用计数)
    弱引用
         创建：id __weak obj1 = obj ->(编译后){
             id obj1;
             objc_initWeak(&objt1,obj);
         }
         调用栈：objc_initWeak()->storeWeak()->weak_register_no_lock()
         创建过程：
        一个声明为__weak的对象指针经过编译器编译后，会调用 objc_initWeak方法，经过一系列的函数调用栈，最终会在weak_register_no_lock函数中进行弱引用变量的添加，添加的位置是通过哈希算法进行位置查找，如果查找位置已经有当前对象所对应弱引用数组，会把新的弱引用变量添加到数组中，如果没有，重新创建弱引用数组，将新的弱引用变量添加到数组的第0个位置
         销毁过程：（清楚weak变量，同时设置指向为nil）
         当一个对象被delloc后，delloc的内部实现中，会去调用弱引用清除的相关函数，在函数内部实现中，会根据当前对象指针查找弱引用表，把当前对象相对的弱引用拿出来，是一个数组，遍历数组所有的弱引用指针分别置为nil
    自动释放池
        编译器会将@autoreleasePool{}改写为：
         void *ctx = objc_autoreleasePoolPush() ->autoreleasePoolPage::push()
         {}中的代码->所有的对象会被加到释放池中，所以说一次pop相当于一次批量的pop操作，会给每一个对象发送release消息
         objc_autoreleasePoolPop(ctx) ->autoreleasePoolPage::pop(ctx)
         autoreleasePoolPage {
             id*next
             autoreleasePoolPage*const parent
             autoreleasePoolPage*const child
             pthread_t const thread
         }
         push：增加哨兵对象，next指针指向下一个空白区域
         pop: 从哨兵对象开始，给后面的对象发release消息
         [obj autorelease]:判断 next == 栈顶 -> yes -> 增加一个栈结点到链表上 --> add(obj)
                                              no   -> add(obj)
        数据结构：
          自动释放池是以栈为节点通过双向链表的形式组合而成
          自动释放池是和线程一一对应
          局部变量的释放时机:
           在每一次的runloop将要结束的时候调用autoreleasePoolPage::pop()，同时push一个新的autoreleasePoolPage
        autoreleasePool的实现原理:
           自动释放池是以栈为节点通过双向链表的形式组合而成的数据结构
        autoreleasePool为何可以嵌套使用:
           多层嵌套就是多次插入哨兵对象
        场景：
          在for循环中alloc图片数据等内存消耗较大的场景手动插入autoreleasePool
    循环引用
        分类
          自循环引用：
          相互循环引用：
          多循环引用：
        考点
          代理 -相互循环引用
          block
          NSTimer
          大环引用
       如何破除：
         避免产生循环引用
         在合适的时机解除循环引用
       具体解决方案：
          __weak 弱引用
          __block：
              在MRC下，__block修饰的对象不会增加其引用计数，避免了循环引用
              在ARC下，__block修饰对象会被强引用，无法避免循环引用，需手动解环
          __unsafe_unretained
             修饰的对象不会增加其引用计数，避免了循环引用
             可能产生悬垂指针
       引用示例：
          block示例看后面block
          NSTimer:
          在日常开发中遇到NSTimer弱引用问题，
            方法一：通过创建中间对象，让中间对象持有两个弱引用变量，分别为对象和NSTimer,然后在nstimer的分派回调是在中间对象中完成的，在中间对象实现的回调方法中对他持有的target值的判断，如果值存在，直接把nstimer给原对象，如果对象已经被释放了，就主动调用nstimer的销毁方法
            方法二：通过在分类中addtarget：self，此时的self是类对象而不是实例对象，对外提供block回调。之所以能解决内存泄漏的问题，关键在于把保留转移到了定时器的类对象身上，这样就避免了实例对象被保留。类对象在App杀死时才会释放,在实际开发中几乎不用关注类对象的内存管理。iOS10中，定时器的API新增了block方法，实现原理与此类似。
                                     
  总结：
       什么是ARC？
           arc是LLVM编译器和Runtime协作的结果
       为什么weak指针指向的对象废弃后会被自动置为nil？
           当一个对象被delloc后，delloc的内部实现中，会去调用弱引用清除的相关函数，在函数内部实现中，会根据当前对象指针查找弱引用表，把当前对象相对的弱引用拿出来，是一个数组，遍历数组所有的弱引用指针分别置为nil
       苹果是如何实现autoreleasePool?
           自动释放池是以栈为节点通过双向链表的形式组合而成的数据结构
 五、runtime
   runtime能给分类新建属性、动态添加方法创建类、交换方法、获得某个类的所有成员方法、所有成员变量、实现NSCoding的自动归档和自动解档（mj一个宏解决）、实现字典和模型的自动转换
  1.数据结构
     id = objc_objet { 对象-->类对象
         isa_t
         关于isa操作相关
         弱引用相关
         关联对象相关
         内存管理相关
     }
                                     
     class = objc_class {(继承自objc_objet) 类对象->元类对象
         Class superClass
         
         cache_t cache
         (方法缓存，1.用于快速查找方法执行函数 2.是可增量扩展的哈希表结构3.是局部性原理的最佳应用)
         ->@[bucket_t,bucket_t,bucket_t,bucket_t,bucket_t...]
         bucket_t (@selector(xxx):IMP)
         
         class_data_bits_t bits(变量、属性、方法)
         class_data_bits_t主要是对class_rw_t的封装
         class_rw_t代表类相关的读写信息、对class_ro_t的封装
         class_ro_t代表类相关的只读信息
         class_rw_t:class_ro_t
                    protocols
                    properties
                    methods
         protocols、properties、methods是list_array_tt(二维数组)
         class_ro_t： name
                     ivars
                     protocols
                     properties
                     methodList
         ivars、protocols、properties、methodList是一维数组
     }
     isa指针 分为指针型（isa的值代表class的地址）和非指针型（isa的值部分代表class的地址）
     函数四要素：名称、返回值、参数、函数体
     method_t : SEL name(名称)  const char* types(返回值、参数)  IMP imp(函数体)
     types是应用type Encodings技术的字符串，前几位代表返回值，后面代表参数，如 -(void)aMethod ->objc_msgSend(self, @selector(aMethod)) ->v@:(v - void @ - id  : - SEL)
  2.类对象和元类对象
    区别：类对象存储实例方法列表等信息，元类对象存储类方法列表等信息
    共同点：类对象和类对象都是objc_class ，继承自objc_objet，有isa指针
    isa方向 实例对象 -> 类对象 -> 元类对象 - >root class(meta)
    问题：
    如果类方法没有实现，但是有同名的实例方法实现，会不会发生崩溃和调用
      如果该类不是根类（NSObject）,崩溃 ，如果该类是根类NSObject，会调用，因为元类根类的superclass的指针指向了根类，系统会到根类里查找
  3.消息传递
    void objc_msgSend(id self , SEL)
    void objc_msgSendSuper(objc_super *super , SEL)
     struct objc_super {
         __unsafe_unretained id receiver
     }
    具体流程见资料runtime消息传递图
  4.消息转发流程(见图)
  5.method-swizzling
  6.动态添加方法
    在resolveInstanceMethod中用class_addMethod函数添加实现
    @dynamic 动态运行时将函数决议推迟到运行时，编译时语言j在编译期进行函数决议
  总结：
     [obj foo]和objc_msgSend()函数有什么关系？
       objc_msgSend(obj,@selector(foo))
     runtimeh如何通过Selector找到对应的IMP的地址的？
       见消息传递过程
     能否向编译后的类中增加实例变量？
      不能向编译后的类中添加实例变量,因为编译后的实例变量布局已经完成，可以向动态添加的类中添加实例变量
 五、block
    block介绍
       block是将函数及其上下文封装起来的对象
       编译成c++：
           block（TestBlock::dzblock）声明 -> _I_TestBlock_dzBlock函数，在_I_TestBlock_dzBlock函数中调用了TestBlock__dzBlock_block_impl_0结构体的构造函数，该构造函数实现了将代码块执行代码的函数TestBlock__dzBlock_block_func_0指针赋值给结构体的block_impl成员变量对应的属性，参数赋值给TestBlock__dzBlock_block_impl_0成员变量对应的属性
       数据结构：
          TestBlock__dzBlock_block_impl_0 ：block_impl 、TestBlock__dzBlock_block_desc_0、flags、同名参数、构造函数
          block_impl：isa、flags、reserved、funcPtr（函数指针）
          构造函数参数：函数指针（及花括号代码块的内容写成一个函数，函数名是TestBlock__dzBlock_block_func_0）、block描述、参数
    截获变量
      截获变量的本质是block（TestBlock::dzblock在被编译成_I_TestBlock_dzBlock函数中，创建了同名参数，并将参数通过构造函数赋值给了TestBlock__dzBlock_block_impl_0的参数成员变量。
     局部变量：基本数据类型
             对象类型
     静态局部变量
     全局变量
     静态全局变量
       对于基本数据类型的局部变量截获其值
       对于对象类型的局部变量连同所有权修饰符一起截获
       以指针形式截获局部静态变量（block外修改的值是有效的，因为构造函数中传递的是指针）
       不截获全局变量、静态全局变量
    __block
      一般情况下，对被截获变量进行赋值操作需要添加__block,赋值不等于使用
      __block修饰的对象会变成对象（栈上的__forwarding指向自己，通过__forwarding指针找到对象同名属性）
       比如block外定义局部变量 __block int a,会生成a的结构体，赋值取值过程 a->__forwarding->同名属性a -赋值取值
       注意mrc下，block在堆中时,不想对block进行retain操作,前面加__block,允许在 block 内访问和修改局部变量
    block的内存管理
      __NSConcreteStackBlock  -> 栈      ->copy->  堆，如果有__block,__forwarding指针会由指向自己的__block变量改成指向堆中的__block变量
      __NSConcreteMallocBlock -> 堆      ->copy->  引用计数增加
      __NSConcreteGlobalBlock -> 数据区   ->copy->  什么也不做
      栈中的__forwarding指针指向的是自己的__block变量，做了copy后，__forwarding指向堆中的__block变量，堆中的__forwarding指针指向的是堆中自己的__block变量
      __forwarding存在的意义：不论在内存任何位置，都可以顺利的访问同一个__block变量
    block的循环引用
         为什么会循环引用
           如果说当前block对某一个对象的属性有个强引用，当前对象又对block有一个强引用，加上__block也可能产生循环引用，但是是区分场景的，mrc没事，arc会循环引用
六、多线程
     1.死锁
        队列引起的持续等待
     2.栅栏函数dispatch_barrier_async
        如何用gcd实现多读单写
     3.NSOperation
        优势：
           可以添加依赖
           任务执行状态控制：
                  isReady isExecuting isFinished isCancelled
           最大并发量
         状态控制：
         如果只是重写main方法，底层控制变更任务执行完成状态，以及任务退出
         如果重写start方法，自行控制任务状态
       问题 系统怎么移除一个isfinished = yes的NSOperation？ 通过kvo
      4.NSThread
                                     
      5.ios中的锁
         @synthesize :一般在创建单例对象时使用
         @atomic:修饰属性的关键字，对被修饰的对象进行原子操作（不负责使用）
         osspinlock：循环等待询问，不释放当前资源，用于轻量级数据访问，简单的int+1/-1
         NSLock:
         NSRecursiveLock(递归锁):可以重路添加
         dispatch_semaphone_t:
              阻塞是一个主动行为，唤醒是被动行为
       总结：
         ios系统为我们提供的几种多线程技术各自的特点是怎样？
          ios系统中主要提供了三种多线程技术，分别为gcd、NSOperation、NSThread，我们一般使用gcd用来实现简单的线程同步，包括一些子线程的分派和多读单写的实现，对于NSOperation，第三方框架SD和AF都有涉及，由于它特点是我们可以对任务状态进行控制，包括可以控制它添加依赖和移除依赖，对于NSThread一般用来实现常驻线程
         你都用过哪过锁？结合实际谈谈你是怎样使用的？
                                     
 七、runloop
     概念：
        通过内部维护的事件循环来对事件/消息进行管理的一个对象
           没有消息需要处理时，休眠以避免资源占用：用户态（切换）-> mach_msg()->内核态
           有消息需要处理时，立刻被唤醒：内核态 （切换）-> 用户态
        问题：为什么main能保持不退出
              在main函数中，启用了一个runloop,....<概念>
     数据结构：
            NSRunLoop是CFRunLoop的封装，提供面向对象的API
                CFRunLoop：
                     pthread（一一对应线程）
                     currentMode
                     modes
                     commonModes-> NSMutableSet<NSString *>
                     commonModeItems ->集合包括observer/Timer/Source
                CFRunLoopMode：
                     name ->NSDefaultRunLoopMode(字符串)
                     sources0 ->NSMutableSet
                     sources1 ->NSMutableSet
                     observers ->NSMutableArray
                     timers ->NSMutableArray
                Source/Timer/Observer
                CFRunLoopSource：
                     sources0 ->需要手动唤醒线程，如点击和触摸
                     sources1 ->具备唤醒线程的能力
                CFRunLoopObserver：
                       观测时间点：
                         typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
                             kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
                             kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
                             kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
                             kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
                             kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
                             kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
                         };
                  CommonModes：
                     一个 Mode 可以将自己标记为”Common”属性（通过将其 ModeName 添加到 RunLoop 的 “commonModes” 中）。每当 RunLoop 的内容发生变化时，RunLoop 都会自动将 _commonModeItems 里的 Source/Observer/Timer 同步到具有 “Common” 标记的所有Mode里。
                  commonmode的特殊性：
                        commonmode不是一个实际存在的一种mode，是同步source/timer/observe到多个mode中的一种技术方案
                  runloop为什么有多个model？
                      一个 RunLoop 包含若干个 Mode，每个 Mode 又包含若干个 Source/Timer/Observer。每次调用 RunLoop 的主函数时，只能指定其中一个 Mode，这个Mode被称作 CurrentMode。如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 Source/Timer/Observer，让其互不影响。
                  线程被唤醒有哪些方式？souce1/timer事件/外部手动唤醒
                                     
     事件循环机制：
           app从点击图标到运行到退出程序，系统做了什么？
             程序启动会调用main函数后，会调用UIApplicationMain函数，在函数的内部会启动主线程的runloop，经过一系列的处理最终主线程的runloop会进入休眠状态，如果点击屏幕会产生mach_port，基于mach_port会转成一个source1，可以把主线程唤醒，运行，处理，后面杀死app，会发生runloop退出，发送通知退出runloop
     runloop和NSTimer：
         PerformSelecter
         当调用 NSObject 的 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。
         当调用 performSelector:onThread: 时，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效。
     runloop和多线程：
          一一对应，并且自己创建的线程默认没有runloop
          设计常驻线程：
             为当前线程开启一个runloop
             向该runloop中添加一个port/source得维持runloop的事件循环
             启动runloop
           怎么保证子线程数据回来更新UI的时候不打断用户滑动？
            把子线程提交的数据回来更新UI的逻辑包装起来提交到主线程的default模式下，这样滑动完，从tracking模式切换到default模式
 八、网络
           1.HTTP
                 HTTP是超文本传输协议
                  请求/响应报文：
                         请求方式有哪些：GET POST HEAD PUT DELETE OPTIONS
                         get和post区别：
                            初级答案：
                                 get请求参数以？分割拼接到url后面，post请求参数在body里面
                                 get请求参数长度限制2048个字符，post-般没有该限制
                                 get请求不安全，post请求安全
                             中高级答案（从语义角度，即协议定义规范）：
                                 get请求是获取资源，是安全的、幂等的、可缓存的
                                 post请求是处理资源，不安全的、非幂等的、不可缓存的
                                 安全是指不应该引起服务端热任何状态变化（get head options）
                                 幂等是指同一个请求方法执行多次和执行一次的效果完全相同（put delete）
                  连接建立流程：
                       三次握手四次挥手
                  HTTP的特点：
                       无连接（建立一条新的TCP链接连接，断开）
                       无状态（无法记住用户）
                  charles抓包原理：
                              中间人攻击
           2.https与网络安全
                  https = http(应用层) + ssl/tls（应用层之下、传输层之上（tcp））
                  https与http的区别？
                      https是安全的http，他的安全是由ssl/tls插在应用层之下、传输层之上来保证的
                  https都使用了哪些加密手段？
                      连接建立过程中使用非对称加密，非对称加密很耗时
                      后续通信过程中使用了对称加密
                   非对称加密/对称加密：（见图）
                  https建立流程（安全如何保障）：（见图）
                         客户端将自己支持的加密算法发送给服务器，请求服务器证书；
                         服务器选取一组加密算法，并将证书返回给客户端；
                         客户端校验证书合法性，生成随机对称密钥，用公钥加密后发送给服务器；
                         服务器用私钥解密出对称密钥，返回一个响应，HTTPS连接建立完成；
                         随后双方通过这个对称密钥进行安全的数据通信。
                                     
           3.tcp（传输控制协议，传输层）：
                    特点：面向连接（三次握手和四次挥手）、可靠传输、面向字节流、流量控制、拥塞控制
             udp（用户数据报协议，传输层）：
                    特点：无连接、尽最大努力交互、面向报文（既不合并也不拆分）
                    功能：多端口复用、分用、差错检测
           4.DNS解析
                域名到ip地址的映射，dns解析请求采用udp数据报，且明文
                查询方式：
                   递归查询：我去给你问一下
                   迭代查询：我告诉你谁可能知道
                常见问题：
                   劫持问题
                      怎么解决？
                      httpDNS
                      长链接
                      dns劫持和http关系？
                        无关，dns解析发生在http建立连接之前
                        dns解析请求采用udp数据报，端口号53
                   解析转发问题
             5.session和cookie
                 cookie主要用来记录用户状态、区分用户，状态保存在客户端
                 如何删除cookie，见图
                 怎么保证cookie安全
                       对cookie加密，只用https上携带cookie，设置cookie为httpOnly，防止跨站脚本攻击
                 session也是用来记录用户状态、区分用户，状态保存在服务端
  九、框架/架构
         模块化、解耦、分层、降低代码重合度
         1.图片缓存
              怎么设计一个图片缓存框架？
                 manager -> 内存/磁盘/网络->图片解码/解压缩
              图片通过什么方式进行读写，过程怎样的？
                 用图片url的单向hash值作为key，通过内存/磁盘查找，如果都找不到，下载。
              内存设计需要注意哪些问题？
                 存储size：队列，10kb以下存50张，50kb以下存20张 ，100kb以下存10张
                 淘汰策略：以队列先进先出淘汰
                         LRU算法（如果30分钟以内是否使用过）->(提高检查触发频率：每次读写/切换前后台)时间/内存警告
               磁盘设计需要考虑问题？
                   存储方式
                   大小限制
                   淘汰策略
               网络部分设计
                  图片请求并发量
                  请求超时策略
                  请求优先级
               对于不同格式的图片，解码采用什么方式？
                 应用策略模式对不同图片进行解码
               哪个阶段做解码？
                 磁盘读取后/网络请求后
               线程的处理
                                     
         2.阅读时长
               怎样设计一个时长统计框架？
                  记录器 -> 记录管理者
                  记录器：页面式、流式、自定义式（轮播图）
                  记录管理者：记录缓存：磁盘存储 - 防止存储在内存中因为app杀死、断电丢失情况
                            上传器
               为何要有不同类型的记录器？
                 基于不同分类的场景提供的关于记录的封装、适配
               记录数据由于某种原因丢失，你是怎么处理的？
                 定时写磁盘
                 限定内存缓存条数（10条），超过该条数，即写磁盘
                上传时机？
                      延时上传：前后台切换、无网到有网的变化
                      立刻上传
                      定时上传
         3.复杂页面
               整体架构
               数据流
               反向更新
                思想：mvvm框架思想 、 reactNative的数据流思想 、 系统UIView更新机制的思想、facebook开源框架ASyncDisplayKit关于预排版的设计思想
         4.客户端整体架构
                 业务解耦通信方式：
                     openurl
                     依赖注入
                                     
十、设计模式
     六大设计原则：
          单一职责原则：一个类只负责一件事，CALayer和UIView
             开闭原则：对修改关闭、对扩展开放
          接口隔离原则：使用多个专门的协议、而不是一个庞大臃肿的协议 （tabliew的代理）
          依赖倒置原则：抽象不应该依赖于具体实现，具体实现可以依赖于抽象（如增删改查提供的接口（.h里的方法）不依赖于.m里的实现，增删改查可以有多种实现）
          里氏替换原则：父类可以被子类无缝替换，且原有功能不受任何影响（kvo）
            迪米特法则：一个对象应当对其他对象有尽可能少的了解,这样可以高内聚、低耦合
        设计模式：
         责任链：一个类有他自己这个类的成员变量，就是责任链的主体
          桥接:在软件系统中，某些类型由于自身的逻辑，它具有两个或多个维度的变化，那么如何应对这种“多维度的变化”？如何利用面向对象的技术来使得该类型能够轻松的沿着多个方向进行变化，而又不引入额外的复杂度？这就要使用Bridge模式。
              定义一个抽象的父类A和抽象的父类B，把抽象父类b作为抽象父类a的成员值，这样就可以衍生出A1到B1、B2、B3，A2到B1、B2、B3的联系，两个父类其中持有一个就起到了桥梁的作用
         适配器
             对象适配器
             类适配器
         单例：
             // 命令管理者以单例方式呈现
             + (instancetype)sharedInstance
            {
                static CommandManager *instance = nil;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    instance = [[super allocWithZone:NULL] init];
                });
                return instance;
            }
             
             // 【必不可少】
             + (id)allocWithZone:(struct _NSZone *)zone{
                 return [self sharedInstance];
             }
             
             // 【必不可少】
             - (id)copyWithZone:(nullable NSZone *)zone{
                 return self;
             }

          命令模式：行为参数化，降低代码重合度
  十、算法
          字符串反转：
              @"abc" -> @"cba"
          链表算法
          有序数组合并
          hash算法
          求无序数组中的中位数
 十一框架
     
     AFNetworking:
         主要关系见图
         AFURLSessionManager:
            创建和管理NSURLSession、NSURLSessionTask
            实现NSURLSessionDelegate等协议的代理方法
            引入AFSecurityPolicy保证请求安全
            引入AFNetworkingReachabilityManager监控网络状态
     SDWebImage:
     ReactiveCocoa:
            信号是代表一连串的状态，在状态改变时，对应的订阅者RACSubscriber就会收到通知执行相应的指令
     AsyncDisplayKit：
             把大部分的事情都放到子线程中去做，如文本计算、视图布局计算、文本渲染、图片解码、图形绘制、对象创建销毁和调整
             原理：
                    针对ASNode的修改和提交，会对其进行封装并提交到一个全局容器中
                    ASDK在runloop注册一个观察者
                    在runloop进入休眠前，ASDk执行该runloop的提交的所有任务
