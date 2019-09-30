package com.controller.business
{
	import com.core.basic.MBasicLoader;
	import com.vo.BasicLoaderVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 基本加载类
	 * @author 王明凡
	 */
	public class BasicLoaderCommand extends SimpleCommand
	{
		//(通知)
		public static const BLC_BASICLOADER:String="blc_basicloader";
		//(通知)
		public static const BLC_BASICLOADER_COMPLETE:String="blc_basicloader_complete";
		//(通知)
		public static const BLC_BASICLOADER_PROGRESS:String="blc_basicloader_progress";
		//(通知)
		public static const BLC_BASICLOADER_ERROR:String="blc_basicloader_error";
		
		private var blVO:BasicLoaderVO;
		
		private var type:String;
		
		public function BasicLoaderCommand()
		{
			super();
		}
		override public function execute(note:INotification):void
		{
			this.blVO=note.getBody() as BasicLoaderVO;
			this.type=note.getType();
			var bl:MBasicLoader=new MBasicLoader();
			bl.addEventListener(Event.COMPLETE,onComplete);
			bl.addEventListener(ProgressEvent.PROGRESS, onProgress);
			bl.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
			bl.onLoadFile(blVO.url,blVO.type);			
		}
		/**
		 * 加载完成
		 * @param e
		 */
		private function onComplete(e:Event):void
		{
			var bl:MBasicLoader=e.currentTarget as MBasicLoader;
			this.blVO.name=this.blVO.url.substring(this.blVO.url.lastIndexOf("\\")+1,this.blVO.url.length);
			this.blVO.byte=bl.getByte();
			if(blVO.type==2)
			{
				this.blVO.bm=bl.getBitmap();
				this.blVO.mc=bl.getMovieClip();
				this.blVO.loaderInfo=bl.getLoaderInfo();
			}
			this.sendNotification(BLC_BASICLOADER_COMPLETE,blVO,type);
			clearMBasicLoader(bl);
			bl=null;		
		}
		/**
		 * 加载过程
		 * @param e
		 */
		private function onProgress(e:ProgressEvent):void
		{
			this.sendNotification(BLC_BASICLOADER_PROGRESS,e,type);
		}
		/**
		 * 加载错误
		 * @param e
		 */
		private function onIoError(e:IOErrorEvent):void
		{
			this.sendNotification(BLC_BASICLOADER_ERROR,e,type);
	  		clearMBasicLoader(e.currentTarget as MBasicLoader);			
		}
		/**
		 * 加载清理
		 * @param bl
		 */
		private function clearMBasicLoader(bl:MBasicLoader):void
		{
			bl.removeEventListener(Event.COMPLETE,onComplete);
			bl.addEventListener(ProgressEvent.PROGRESS, onProgress);
			bl.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
			bl.clear();
			bl=null;		
			
			blVO=null;
			type=null;	
		}		
	}
}