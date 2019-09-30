package com.roleobject.loader
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	import com.roleobject.interfaces.ILoader;

	/**
	 * 
	 * @author 王明凡
	 */
	public class BasicLoader extends EventDispatcher implements ILoader
	{
		protected var urlLD:URLLoader;
		protected var LD:Loader;
		protected var byte:ByteArray;
				
		public function BasicLoader()
		{
			
		}
		public function onLoaderURL(url:String, format:String):void
		{
			urlLD=new URLLoader();
			urlLD.addEventListener(Event.COMPLETE, onURLLoaderComplete);
			urlLD.addEventListener(ProgressEvent.PROGRESS, onProgress);
			urlLD.addEventListener(IOErrorEvent.IO_ERROR, onIoError);			
			urlLD.dataFormat=format;
			urlLD.load(new URLRequest(url));				
		}
		public function getByte():ByteArray
		{
			return byte;
		}
		public function onLoaderByte(byte:ByteArray):void
		{
			LD=new Loader();			
			LD.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadByteComplete);
			LD.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			LD.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);		
			LD.loadBytes(byte);				
		}
		public function getLoader():Loader
		{
			return LD;
		}
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