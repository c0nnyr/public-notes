tag:gitlab CI lerna devops

- [前言](#%e5%89%8d%e8%a8%80)
- [现状](#%e7%8e%b0%e7%8a%b6)
- [lerna](#lerna)
- [gitlab CI](#gitlab-ci)

## 前言

近期在一家创业公司做架构师。然而由于测试负责人出走，我也就负责起devops相关的工作。何谓devops？简而言之就是打破开发（development）和运维（operation）的隔阂，让开发介入到运维中，一套流水工具链，谁开发谁部署。开发懂得了运维环境，也会帮助开发调优程序，提高开发效率。

![](../../asset/2019-11-22-11-28-18.png)

开发掌控整套体系是很有价值的。整个过程中都有开发需要去了解的东西，辅助我们打造高质量的软件系统。

- 规划：设计代码（开发本职）
- 代码：编写代码（开发本职）
- 构建：代码规范、编译环境、静态检查、增量构建（辅助编写pretty code）
- 测试：自动化单元测试、模块测试（辅助编写bugfree code）
- 发布：二进制发布、源码发布（对发布结果做恰当的版本控制）
- 部署：部署环境、分布式、带宽、防火墙（软件运行真实环境）
- 运营：日志管理、私有命令（如何有效定位bug、高效恢复业务）
- 监控：内存、CPU、日志异常（如何在异常中恢复，有效利用有限的资源）

与devops相似的一个概念是CI（持续集成）。所谓持续集成，便是在合入代码或者周期性地执行devops的整个流程，保证时刻都有最新的符合最低质量要求的产品。

选择怎样的工具来支撑呢？我接触过的工具有TeamCity、Jenkins、GitlabCI，当然还有一些自研的或者其他部署工具扩展出来的CI（比如容器编排工具rancher这种。）。

TeamCity社区版本免费可用，界面好看，配置也方便，支持的最大并发数有限。Jenkins完全开源，插件丰富，用心搞可以支撑任意你想做的东西。GitlabCI是gitlab自带，文档丰富，用心挖掘也能做很多事情。相似的还有Github的Action。

## 现状

我司使用gitlab做代码仓库，使用TeamCity做CI。方便吗？一般般。使用持续集成的时候，一个很大的困难是：如何版本控制CI的配置？因为CI复杂后，一不注意改错一个配置就可能导致CI失效，难查bug。CI配置的那些环境参数也是，最后部署出去用的是什么环境变量，如何管理这些环境变量，使用Jenkins或者Teamcity会有些头疼（TeamCity也有记录修改记录，不过没有特别直观，综合）。我希望的是，所有控制CI的参数、逻辑都可以用git来管理。一切影响devops的参数或者逻辑都可以版本控制。这也是我最终选择直接使用gitlab CI的原因。

另外一个问题，面对不断增长的代码仓库（尤其是微服务、前端模块化后），改如何选择管理代码的方式。尤其是微服务模块，虽然一个微服务单独可以运行起来，但是没有其他微服务的配合是没有价值的。整个后端是一个整体。合成一个仓库，不仅能清晰管理整个后端的逻辑变更，也可以轻松维护代码工程的完整性。前端lerna提供了一种整合不同模块的思路和工具。结合CI感知具体的变更模块，调用合适的自动化逻辑，就能做到媲美拆库后的CI执行效率。最终直观的感觉就是：

- 提MR方便多了（有限的几个MR就可以把业务从dev合并到alpha/master这些阶段）
- 观察业务代码的变更也方便多了（可以根据需要决定看整个库还是具体的模块）
- CI的配置也简单多了（不至于新增加一个模块就折腾一番CI，即便容易复制和部署也不要经常感知CI的逻辑）
- 代码部署也方便多了（轻松构建和部署所有的模块）


## lerna

lerna本来是设计来配合npm/yarn使用的，尤其是开发和调试相互有依赖的那些库，方便自动化高效下载依赖包和创建包符号链接。通常的目录结构是这样的

执行`lerna init`就可以创建一个lerna的默认管理结构：（前提是npm install lerna -g安装了lerna）

```
$ find . -name .git -prune -or -name '*'
.
./.git
./lerna.json
./package.json
./packages
```

不同的模块放在packages里面。

如果是js项目，还可以执行`lerna bootstrap`来安装和链接项目的包，使之处于随时准备运行的阶段。

如果不是js项目，目前的lerna是不太支持的。这方面还需要有lerna类似的管理工具出现。不过lerna给出了一个很成功的示范。可以有一个统一的工具来支撑一下这种结构。


## gitlab CI

gitlab CI

