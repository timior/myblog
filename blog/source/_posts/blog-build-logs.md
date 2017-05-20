---
title: 个人博客搭建过程随手笔记
date: 2017-05-20 02:50:38
tags:
---
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

本博客才用的是[hexo-neat](https://github.com/rozbo/hexo-neat)插件

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
1、打开git bush，进入博客根目录执行git init
 ``` bash
$ git init
```
2、修改博客根目录下的 .gitignore 文件，仅保留public/，该文件是hexo生成的博客页面文件，不必要使用git管理
 ``` bash
#.DS_Store
#Thumbs.db
#db.json
#*.log
#node_modules/
public/
#.deploy_git/
```
3、使用git add .添加所有文件，如果 git 报错 Filename too long ，执行 git config --global core.longpaths true 修改git配置即可

4、如果有文件目录添加失败，检查该目录下是否存在 .git 文件夹如下所示，删除该.git文件夹，只保留博客根目录下的.git文件夹即可。
 ``` bash
$ git add G:\\GitTools\\Blog\\blog\\themes\\next\\_config.yml
fatal: Pathspec 'G:\GitTools\Blog\blog\themes\next\_config.yml' is in submodule 'themes/next'
```




