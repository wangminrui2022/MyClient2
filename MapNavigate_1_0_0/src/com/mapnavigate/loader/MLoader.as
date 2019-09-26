package com.mapnavigate.loader
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * 基本加载类
	 * @author wangmingfan
	 */
	public class MLoader extends EventDispatcher
	{
		protected var urlLD:URLLoader;
		protected var LD:Loader;
		protected var byte:ByteArray;
		
		public function MLoader()
		{
			
		}
		/**
		 * 根据指定加载方式加载指定的URL
		 * @param url
		 * @param format
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
		 * 加载指定的字节数组
		 * @param byte
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
		 * onLoaderURL()加载完成
		 * @param e
		 */
		protected function onURLLoaderComplete(e:Event):void
		{	
			byte=urlLD.data;		
			this.dispatchEvent(e);
		}		
		/**
		 * onLoaderByte()加载完成
		 * @param e
		 */
		protected function onLoadByteComplete(e:Event):void
		{
			this.dispatchEvent(e);
		}		
		/**
		 * 返回onLoaderURL()加载完成的字节数组
		 * @return 
		 */
		public function getByte():ByteArray
		{
			return this.byte;
		}				
		/**
		 * 返回onLoaderByte()加载完成的加载对象
		 * @return 
		 */
		public function getLoader():Loader
		{
			return this.LD;
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
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			try
			{
				if(urlLD)
				{
					urlLD.addEventListener(Event.COMPLETE, onURLLoaderComplete);
					urlLD.addEventListener(ProgressEvent.PROGRESS, onProgress);
					urlLD.addEventListener(IOErrorEvent.IO_ERROR, onIoError);					
					urlLD.close();
					urlLD=null;
				}
				if(LD)
				{
					LD.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadByteComplete);
					LD.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
					LD.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);					
					LD=null;
				}
				byte=null;
			}catch(er:Error)
			{
				throw er;
			}			
		}		
	}
}