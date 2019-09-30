package com.roleobject.interfaces
{
	import flash.display.Loader;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author 王明凡
	 */	
	public interface ILoader
	{
		/**
		 * 根据指定加载方式加载指定的URL
		 * @param url
		 * @param format
		 */		
		function onLoaderURL(url:String,format:String):void;
		
		/**
		 * 返回加载的字节数组
		 * @return
		 */			
		function getByte():ByteArray;
		
		/**
		 *  加载指定的字节数组
		 * @param scene
		 */			
		function onLoaderByte(byte:ByteArray):void;
		
		/**
		 * 返回加载对象
		 * @return
		 */			
		function getLoader():Loader;
		
		/**
		 * 垃圾清理
		 */			
		function clear():void;
	}
}