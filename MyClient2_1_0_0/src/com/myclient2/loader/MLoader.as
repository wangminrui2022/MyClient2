/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.loader
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	import com.myclient2.interfaces.ILoader;

	/**
	 * MLoader用于加载外部文件的方法，可以采用二进制或URL方式加载jpg,png,swf或其他文件
	 * @author 王明凡
	 */
	public class MLoader extends EventDispatcher implements ILoader
	{
		protected var urlLD:URLLoader;
		protected var LD:Loader;
		protected var byte:ByteArray;
		
		/**
		 * 构造函数
		 */				
		public function MLoader()
		{
			
		}
		/**
		 * 根据二进制方式加载，加载指定的URL，返回字节数组
		 * @param url		
		 * @param format	加载格式为"URLLoaderDataFormat.BINARY"
		 */			
		public function onLoaderURL(url:String, format:String):void
		{
			urlLD=new URLLoader();
			urlLD.addEventListener(Event.COMPLETE, onURLLoaderComplete);
			urlLD.addEventListener(ProgressEvent.PROGRESS, onProgress);
			urlLD.addEventListener(IOErrorEvent.IO_ERROR, onIoError);			
			urlLD.dataFormat=format;
			urlLD.load(new URLRequest(url));				
		}
		/**
		 * 返回加载的字节数组
		 * @return
		 */			
		public function getByte():ByteArray
		{
			return byte;
		}
		/**
		 * 加载指定的字节数组，返回Loader对象
		 */			
		public function onLoaderByte(byte:ByteArray):void
		{
			LD=new Loader();			
			LD.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadByteComplete);
			LD.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			LD.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);		
			LD.loadBytes(byte);				
		}
		/**
		 * 返回Loader对象
		 * @return
		 */			
		public function getLoader():Loader
		{
			return LD;
		}
		/**
		 * 垃圾清理
		 */			
		public function clear():void
		{
			if (urlLD)
			{
				urlLD.addEventListener(Event.COMPLETE, onURLLoaderComplete);
				urlLD.addEventListener(ProgressEvent.PROGRESS, onProgress);
				urlLD.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				urlLD.close();
				urlLD=null;
			}
			if (LD)
			{
				LD.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadByteComplete);
				LD.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				LD.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
				LD=null;
			}
			byte=null;			
		}		
		/**
		 * URL加载方式加载完成
		 * @param e
		 */
		protected function onURLLoaderComplete(e:Event):void
		{	
			byte=urlLD.data;		
			this.dispatchEvent(e);
		}
		/**
		 * 字节数组加载方式加载完成
		 * @param e
		 */
		protected function onLoadByteComplete(e:Event):void
		{
			this.dispatchEvent(e);
		}			
		/**
		 * 加载进度
		 * @param e
		 */
		protected function onProgress(e:ProgressEvent):void
		{
			this.dispatchEvent(e);
		}
		/**
		 * 加载错误
		 * @param e
		 */
		protected function onIoError(e:IOErrorEvent):void
		{
			this.dispatchEvent(e);	
		}						
	}
}