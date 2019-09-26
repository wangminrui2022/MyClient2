package com.core.basic
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.*;

	/**
	 * 基本Loader类
	 * @author wangmingfan
	 */
	public class MBasicLoader extends EventDispatcher
	{
		private var urlLD:URLLoader;
		private var ld:Loader;
		private var context:LoaderContext;
		//位图
		private var bm:Bitmap;
		//影片剪辑
		private var mc:MovieClip;
		//字节数组
		private var byte:ByteArray;		
		//加载类型(1.字节数组,2.显示对象)
		private var type:int;
		//加载URL
		private var url:String;
		
		public function MBasicLoader()
		{			

		}		
		/**
		 *  URLLoade 加载
		 * @param url		地址
		 * @param type		加载字节数组=1,加载内容信息=2
		 * @param format	加载方式
		 */
		public function onLoadFile(url:String,type:int,format:String="binary"):void
		{
			this.urlLD=new URLLoader();
			this.type=type;
			this.url=url;
			this.urlLD.addEventListener(Event.COMPLETE, onURLLoaderComplete);
			this.urlLD.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this.urlLD.addEventListener(IOErrorEvent.IO_ERROR, onIoError);			
			this.urlLD.dataFormat=format;
			this.urlLD.load(new URLRequest(url));			
		}
		/**
		 * URLLoade 加载完成
		 * @param e
		 */
		private function onURLLoaderComplete(e:Event):void
		{	
			byte=this.urlLD.data;		
			if(type==1)
			{
				this.dispatchEvent(e);
				return;
			}
			onLoadByte(this.byte);	
		}
		/**
		 * 二进制数据加载
		 * @param byte
		 */
		public function onLoadByte(byte:ByteArray):void
		{
			ld=new Loader();
			context=new LoaderContext();			
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadByteComplete);
			ld.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			context.allowLoadBytesCodeExecution=true;			
			ld.loadBytes(byte,context);
		}
		/**
		 * 二进制数据加载完成
		 * @param e
		 */
		public function onLoadByteComplete(e:Event):void
		{
			var li:LoaderInfo=e.currentTarget as LoaderInfo;
			if (li.content is Bitmap)
			{
				bm=li.content as Bitmap;
			}
			else if (li.content is MovieClip)
			{
				mc=li.content as MovieClip;
			}
			this.dispatchEvent(e);
		}
		/**
		 * 加载过程
		 * @param e
		 */
		public function onProgress(e:ProgressEvent):void
		{
			this.dispatchEvent(e);
		}
		/**
		 * 加载错误
		 * @param e
		 */
		public function onIoError(e:IOErrorEvent):void
		{
			this.dispatchEvent(e);	
		}	
		/**
		 * Bitmap
		 * @return
		 */
		public function getBitmap():Bitmap
		{
			return bm;
		}
		/**
		 * MovieClip
		 * @return
		 */
		public function getMovieClip():MovieClip
		{
			return mc;
		}
		/**
		 * 加载的字节数组
		 * @return
		 */
		public function getByte():ByteArray
		{
			return byte;
		}				
		/**
		 * LoaderInfo
		 * @return 
		 */
		public function getLoaderInfo():LoaderInfo
		{
			return ld.contentLoaderInfo;
		}
		/**
		 * URL地址
		 * @return 
		 */
		public function getURL():String
		{
			return url;
		}
		/**
		 * 垃圾清理
		 * @throws er
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
				if(ld)
				{
					ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadByteComplete);
					ld.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
					ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);					
					ld=null;
				}
				if(context)
					context=null
				bm=null;
				mc=null;	
				byte=null;
				type=0;
				url=null;	
			}catch(er:Error)
			{
				throw er;
			}
		}						
	}
}