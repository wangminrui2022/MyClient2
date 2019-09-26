package com.vo
{
	import flash.net.FileFilter;
	
	/**
	 * 浏览目录
	 * @author wangmingfan
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