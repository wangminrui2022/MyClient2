/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.business.map
{
	import com.mapfile.core.MOpenMap;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import com.consts.Msg;
	import com.pureMVC.controller.business.common.Message2Command;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.view.mediator.ProgressReportMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.common.MessageAlert2VO;
	import com.vo.common.ProgressReportVO;

	/**
	 * 加载地图
	 * @author Administrator
	 */
	public class LoaderMapCommand extends SimpleCommand
	{
		public static const LMC_LOADER_MAP:String="lmc_loader_map";
		
		public static const LMC_LOADER_MAP_COMPLETE:String="lmc_loader_map_complete";
		
		private var mapP:MapProxy;
		
		private var type:String;
		
		private var path:String;
		
		public function LoaderMapCommand()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
		}
		/**
		 * 
		 * @param note
		 */
		override public function execute(note:INotification):void
		{
			path=note.getBody().toString();
			type=note.getType();
			if(!mapP.mOpen)
				mapP.mOpen=new MOpenMap(path);
			//进度条
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS);				
			mapP.mOpen.addEventListener(Event.COMPLETE,onComplete);
			mapP.mOpen.addEventListener(ProgressEvent.PROGRESS,onProgress);
			mapP.mOpen.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
			mapP.mOpen.onOpen();			
		}
		/**
		 * 加载.map文件完成
		 * @param e
		 */
		private function onComplete(e:Event):void
		{
			mapP.map=mapP.mOpen.getMapVO();
			clearBasicOpen();
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS_COMPLETE); 
			this.sendNotification(LMC_LOADER_MAP_COMPLETE,path,type);
			mapP=null;
		}
		/**
		 * 加载.map文件过程
		 * @param e
		 */
		private function onProgress(e:ProgressEvent):void
		{
	  		var pgVO:ProgressReportVO=new ProgressReportVO();
	 		pgVO.descreption=Msg.Msg_12;
	  		pgVO.load=e.bytesLoaded;
	  		pgVO.total=e.bytesTotal;
	  		this.sendNotification(ProgressReportMediator.PRM_PROGRESS_LOAD,pgVO);
	  		pgVO=null;		
		}
		/**
		 * 加载.map文件错误
		 * @param e
		 */
		private function onIoError(e:IOErrorEvent):void
		{
			clearBasicOpen();
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS_COMPLETE); 
			errorAlert(Msg.Msg_13);	
			//清理地图模型层
			mapP.clear();				
			mapP=null;	
		}
		/**
		 * 清理基本打开类
		 */
		private function clearBasicOpen():void
		{
			mapP.mOpen.removeEventListener(Event.COMPLETE,onComplete);
			mapP.mOpen.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			mapP.mOpen.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
			mapP.mOpen.clear();			
		}
		/**
		 * 错误提示
		 * @param msg
		 */
		private function errorAlert(msg:String):void
		{
	  		var msgVO:MessageAlert2VO=new MessageAlert2VO();
	  		msgVO.msg=msg;
	  		this.sendNotification(Message2Command.MC2_MESSAGE,msgVO);			
		}		
	}
}