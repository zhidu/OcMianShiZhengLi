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
    
8.属性关键字



