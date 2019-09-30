package com.vo
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	/**
	 * 文件读取
	 * @author 王明凡
	 */
	public class FileVO
	{
		//文件
		public var file:File;
		//大小
		public var size:int=1024;
		//字节数组
		public var byte:ByteArray;
		//文件当前工作类型:(read/write)
		public var workType:String="read";
	}
}