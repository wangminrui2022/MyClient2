# MyClient2

Flash ActionScript3 2D游戏引擎，基于四叉树数据结构实现，支持格斗类ACT游戏和角色扮演类ARGP游戏，诞生于2010年，作者王明凡
MyClient2产品包含以下几个方面：


	1.MyClient2 引擎，(以下简称MC2引擎)

	一个AS3的"等角(45°)"和"交错排列(90°)"的编程引擎，重点用于2D游戏开发的地图或场景渲染。

	该项目的主要目的是提供一个强大的开发平台，在这里编程人员可忽略游戏开发中地图或场景渲染的工作，将重点放在逻辑以及其他方面

	2.MyClient2 地图编辑器，(以下简称MC2地图编辑器)
		
	制作MC2引擎需要的.map地图文件

	3.MyClient2 材质编辑器，(以下简称MC2材质编辑器)
	
	制作MC2地图编辑器需要的.xml材质文件
	
	
MyClient2 引擎特点：

1.采用四叉树数据结构进行地图分块渲染，降低大地图的内存的消耗和CPU计算。

2.独有的地图文件格式(.map)，包含整个地图需要的地图信息以及地图素材(以下简称"材质")。

3.对材质进行分类，按类型进行swf格式封装，单个材质,达到多次重复使用，进一步减少了因为材质大，而加载时间长，占用内存多的缺点。

 ![image](https://github.com/mingfanwang/MyClient2/blob/master/ARGP%E6%BC%94%E7%A4%BA.jpg)
 
  ![image](https://github.com/mingfanwang/MyClient2/blob/master/ACT%E6%BC%94%E7%A4%BA.jpg)

温馨提示：
目前的版本的adobe flash和adobe air是无法运行该项目，需要2012年以前的旧版本才能运行该项目


