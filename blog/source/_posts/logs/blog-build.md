---
title: 个人博客搭建过程随手笔记
date: 2017-05-20 02:50:38
tags: Hexo,github
category: logs
---
个人博客的搭建日志，记录博客搭建过程的中的一些心得，由衷感谢Grok的博客对我的指导。

<!--more-->

## 系统环境

开发平台：Windows
开发工具：[Hexo](https://hexo.io/)
博客主题：[Next](http://theme-next.iissnan.com/)

## Hexo 环境搭建
搭建过程主要参考 [Grok](http://lowrank.science/)的博客
[知行合一 | 用 Hexo 搭建博客](http://lowrank.science/Hexo-Github/)
[Hexo 搭建博客教程补遗](http://lowrank.science/Hexo-Addendum/)

主要步骤如下：
1、[git](https://git-scm.com/downloads)工具安装
2、[wget](https://jaist.dl.sourceforge.net/project/gnuwin32/wget/1.11.4-1/wget-1.11.4-1-setup.exe)工具安装
   将下载的wget.exe文件放入 C:\Windows\System32 目录即可使用wget密令
3、[node.js](https://nodejs.org)工具安装
4、[Hexo](https://hexo.io/)工具安装

实用工具 npm install -g cnpm --registry=https://registry.npm.taobao.org
安装模块时只要用 cnpm 替换 npm 即可，会直接从淘宝 NPM 安装，安装命令形如：cnpm install [name]

## Hexo 博客压缩优化

Hexo主程序并不对生成的页面进行优化，致使页面内容稀疏，由于网面大小的会直接影响网页打开的速度，因此对页面进行压缩是有必要的。简单来说有两种可选方式进行生成网页的压缩优化。
方式一：使用gulp插件，自行编写优化脚本，如[hexo博客－性能优化](http://www.cnblogs.com/jarson-7426/p/5660424.html)
方式二：使用Hexo软件的配套插件，如：[hexo-neat](https://github.com/rozbo/hexo-neat) 、[hexo-all-minifier](https://github.com/chenzhutian/hexo-all-minifier)、[hexo-filter-cleanup](https://github.com/mamboer/hexo-filter-cleanup)

本博客采用的是[hexo-neat](https://github.com/rozbo/hexo-neat)插件

1、插件有两种下载方式
方式一：使用密令行
 ``` bash
$ npm install hexo-neat --save
 ```
方式二：登录插件的commit分支页面（如[hexo-neat](https://github.com/rozbo/hexo-neat/commits/master)），手工下插件并将其解压到 "blog根目录\node_modules" 目录下, 注意插件前缀是"hexo-..."

2、下载完插件后，修改站点的配置文件 _config.yml ,加入相关的压缩配置
``` bash
## Hexo-neat config
neat_enable: true
neat_html:
  enable: true
  exclude:
neat_css:
  enable: true
  exclude:
    - '*.min.css'
neat_js:
  enable: true
  mangle: true
  output:
  compress:
  exclude:
    - '*.min.js'
```

值得注意的是：由于Hexo版本升级等原因，在插件的使用说明里并没有说明需要在配置文件里 package.json 增加插件依赖
如下增加了"hexo-neat": "^1.0.4",依赖项
 ``` bash
    "dependencies": {
    "hexo": "^3.2.0",
    "hexo-deployer-git": "^0.3.0",
    "hexo-generator-archive": "^0.1.4",
    "hexo-generator-category": "^0.1.3",
    "hexo-generator-index": "^0.2.1",
    "hexo-generator-tag": "^0.2.0",
    "hexo-neat": "^1.0.4",
    "hexo-renderer-ejs": "^0.2.0",
    "hexo-renderer-marked": "^0.2.10",
    "hexo-renderer-stylus": "^0.3.1",
    "hexo-server": "^0.2.0",
    "stream-to-array": "^2.3.0"
  }
 ```
如果增加依赖后，使用 hexo generate 指令生成页面时报错找不到 stream-to-array 等依赖，使用cnpm直接安装即可
``` bash
$ cnpm install stream-to-array --save
```


## git管理博客

使用git工具对blog文件进行管理有两个必要性
其一：当修改博客出错时可以用来恢复。
其二：使用 hexo deploy 发布的博客，有许多内容并不会上传到github上面，而仅仅存储在本地，因此只能在同一台主机上编辑博客。

使用git管理博客步骤如下：
由于hexo也是使用git工具进行部署的，因此如果在博客根目录下使用 git init 来创建Repository，会和hexo创建的Repository发生冲突，因此可采用 父-子 目录的方式进行规避，将Hexo创建的博客作为子目录，至于git管理的父目录下，结构示意如下：
 ``` bash
+--myblog     			#git 文件管理目录
|	|
|	+ --blog			#Hexo 博客目录
|	|	|
|	|	source
|	|	_config.yml
|	|	...
|	|
|	+ --.git			#git参数文件
|	|	|
|	|	index
|	|
 ```
1、打开git bush，进入git根目录/myblog执行git init
 ``` bash
$ git init
 ```
2、修改博客根目录下的 myblog/bolg/.gitignore 文件，仅保留public/，该文件是hexo生成的博客页面文件，不必要使用git管理（经过测试，这个步不做也是可行的）
 ``` bash
#.DS_Store
#Thumbs.db
#db.json
#*.log
#node_modules/
public/
#.deploy_git/
 ```
3、使用git add . 添加所有文件，如果 git 报错 Filename too long ，执行 git config --global core.longpaths true 修改git配置即可，如果有依赖文件目录添加失败，检查该目录下是否存在 .git文件夹，如果存在则说明该目录下的文件是属于另外一个repository仓库的，一种可行的解决方式是直接删除该目录，登录github直接下载该依赖文件，将其替换掉即可。（凡是使用 git clone https://github.com/iissnan/hexo-theme-next themes/next 等密令下载的插件都包含 .git文件夹，均需登录 githut 直接下压缩包文件进行替换）
4、使用git commit -m "first commmit"计较
5、登录github，为博客的源文件创建一个空的仓库，按照github提示，将文件上传到github
5、其他主机登录步骤
	一：搭建好Hexo环境，创建博客根目录
	二：使用git使用git clone https://github.com/xxx/myblog.git 命令下载git上传的文件即可。
	注意：整个过程都无需再次使用 hexo init 指令，来初始化文件夹，安装好hexo后只需执行 npm install 密令安装来安装hexo server



## Markdown 编辑工具[Typora](https://www.typora.io/)

由于Hexo不能够在页面上实时显示正在编写的文档，每次查看编写效果都需要执行如下指令，繁琐而不直观。

``` codes
$ hexo clean
$ hexo generate
$ hexo server
```


## Hexo 页面底部注释
由hexo的模板自动生成的页面，在底部默认会有版权和主体的注释，如图：
![](http://oqaxv1vwu.bkt.clouddn.com//image/blog/logs/blog_build/blog_copyright_orignal.PNG)
容易暴露个人智商，作为强迫症患者，简直无法忍受。经过查找，底框代码是在：blog\themes\next\layout\_partials\目录下的footer.swig文件里说明的，修改文件内容如下：
``` codes
<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}                
  &copy; {% if theme.since and theme.since != current %} <i> {{ theme.since }} - <\i> {% endif %}
  <span itemprop="copyrightYear"><i>{{ current }}</i></span>
  <span class="with-love"> <i class="fa fa-{{ theme.authoricon }}"> </i> </span>
  <span class="author" itemprop="copyrightHolder"> <i>Powered By - {{ config.author }} </i> </span>
</div>

{% if theme.copyright %}
<div class="copyright">
  <i>Contact Me&nbsp&nbsp&nbsp|&nbsp&nbsp&nbsp</i>
  <i><a target="_blank" rel="external" href="https://github.com/timior">https://github.com/timior</a></i>
</div>
{% endif %}
```
额外添加<i>标签，让其显示为斜体字，在 "|" 字符两边添加多个&nbsp，插入空格让其看上去更加简洁，最后显示效果如下:
![](http://oqaxv1vwu.bkt.clouddn.com//image/blog/logs/blog_build/blog_copyright_new.PNG)

## 评论系统插件
Hexo的Neat主体里面已经集成了几种评论工具[插件](http://theme-next.iissnan.com/third-party-services.html)，个人先尝试了网易云跟帖，整体感觉并不好，因为网易留言回复采用的是”楼上楼“方式，可经过几轮回复留言区会变得一片混乱，跟本找不到谁是谁的留言，之后尝试了[来必力](https://livere.com/)，使用感觉还不错，留言回复采用的是“楼中楼”方式，直观清晰，具体可浏览本博客的留言区域。不过有个缺点，这个插件貌似不支持留言导入导出的功能，这意味着，一旦上了船就别想再跑了，此外这个插件是韩国的，我电脑所在电信网络，注册登录总是出现出现网络故障，无赖最后使用手机网络来注册登录，感觉手机网络还是很给力的。
![](http://oqaxv1vwu.bkt.clouddn.com//image/blog/logs/blog_build/blog_qiniu_add7.PNG)

## 博客图床-七牛云
由于博客托管在github上面，加载速度本来就慢，如果还需加载大量的图片，那就更加无法忍受了，所以图床是必须要有的，见大家都推荐使用[七牛云](https://www.qiniu.com/)，尝试了下，加载速度还不错，步骤如下：
### 一：注册七牛云，新建对象存储空间
![](http://oqaxv1vwu.bkt.clouddn.com//image/blog/logs/blog_build/blog_qiniu_add6.PNG)
![](http://oqaxv1vwu.bkt.clouddn.com//image/blog/logs/blog_build/blog_qiniu_add2.PNG)

### 二：进入存储空间-内容管理-上传文件
![](http://oqaxv1vwu.bkt.clouddn.com//image/blog/logs/blog_build/blog_qiniu_add3.PNG)

在右边可以添加文件的前缀（先填写右侧的文件路径，再添加文件，就会给文件自动加上前缀）
![](http://oqaxv1vwu.bkt.clouddn.com//image/blog/logs/blog_build/blog_qiniu_add5.PNG)

### 三：图片的使用
七牛云上上传的图片，可以在页面里直接使用，无需添加任何设置，复制图片路径，哪里要引用就粘哪，在Hexo的markdown里引用方式之一：```![](粘入复制的链接)```
![](http://oqaxv1vwu.bkt.clouddn.com//image/blog/logs/blog_build/blog_qiniu_add4.PNG)


## To be Continued...
