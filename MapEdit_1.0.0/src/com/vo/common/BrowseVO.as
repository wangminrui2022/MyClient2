/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.vo.common
{
	import flash.net.FileFilter;
	
	/**
	 * 浏览目录
	 * @author 王明凡
	 */
	public class BrowseVO
	{
		//原始路径
		public var path:String;
		//浏览类型(1.文件,2.目录)
		public var browseType:String;
		//浏览文件类型 new FileFilter(".swf", "*.swf");
		public var fFilter:FileFilter;	
	}
}