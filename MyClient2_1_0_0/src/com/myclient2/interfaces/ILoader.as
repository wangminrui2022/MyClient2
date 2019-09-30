/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.interfaces
{
	import flash.display.Loader;
	import flash.utils.ByteArray;
	
	/**
	 * ILoader接口定义了加载外部文件的方法，可以采用二进制或URL方式加载jpg,png,swf或其他文件
	 * @author 王明凡
	 */	
	public interface ILoader
	{
		/**
		 * 根据二进制方式加载，加载指定的URL，返回字节数组
		 * @param url		
		 * @param format	加载格式为"URLLoaderDataFormat.BINARY"
		 */		
		function onLoaderURL(url:String,format:String):void;
		
		/**
		 * 返回加载的字节数组
		 * @return
		 */			
		function getByte():ByteArray;
		
		/**
		 * 加载指定的字节数组，返回Loader对象
		 */			
		function onLoaderByte(byte:ByteArray):void;
		
		/**
		 * 返回Loader对象
		 * @return
		 */			
		function getLoader():Loader;
		
		/**
		 * 垃圾清理
		 */			
		function clear():void;
	}
}