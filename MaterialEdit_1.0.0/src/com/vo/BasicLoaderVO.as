package com.vo
{
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	
	/**
	 * 基本加载类 VO
	 * @author wangmingfan
	 */
	public class BasicLoaderVO
	{
		//加载路径
		public var url:String;
		//加载类型(加载字节数组=1,加载内容信息=2)
		public var type:int;
		//文件名字
		public var name:String;
		//位图
		public var bm:Bitmap;
		//影片剪辑
		public var mc:MovieClip;
		//字节数组
		public var byte:ByteArray;	
		//加载信息
		public var loaderInfo:LoaderInfo;		
	}
}