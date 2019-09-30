package com.myclient2sample1.pureMVC.controller.business.engine
{
	import com.myclient2.core.engine.MMap;
	import com.myclient2sample1.pureMVC.model.EngineProxy;
	import com.myclient2sample1.pureMVC.view.mediator.ProgressReportMediator;
	import com.myclient2sample1.vo.MapConvertVO;
	import com.myclient2sample1.vo.ProgressReportVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 加载地图
	 * @author 王明凡
	 */
	public class LoaderMapCommand extends SimpleCommand
	{
		public static const LMC_LOADER_MAP:String="lmc_loader_map";
		
		private var engineP:EngineProxy;
		
		private var mcVO:MapConvertVO;
		
		public function LoaderMapCommand()
		{
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
		}

		override public function execute(note:INotification):void
		{
			this.sendNotification(ProgressReportMediator.PRM_START);
			mcVO=note.getBody() as MapConvertVO;
			engineP.map=new MMap();
			engineP.map.addEventListener(Event.COMPLETE, onComplete);
			engineP.map.addEventListener(ProgressEvent.PROGRESS, onProgress);
			engineP.map.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			engineP.map.createMap(mcVO.url);
		}
		/**
		 * 地图加载完成
		 * @param e
		 */
		private function onComplete(e:Event):void
		{
			this.sendNotification(ProgressReportMediator.PRM_COMPLETE);
			clearMMap();
			engineP=null;		
			this.sendNotification(InitEngineCommand.IEC_INIT_ENGINE_COMMAND_COMPLETE,mcVO);
		}
		/**
		 * 地图加载过程
		 * @param e
		 */
		private function onProgress(e:ProgressEvent):void
		{
			var pgVO:ProgressReportVO=new ProgressReportVO();
			pgVO.descreption="加载地图中";
			pgVO.load=e.bytesLoaded;
			pgVO.total=e.bytesTotal;
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS, pgVO);
			pgVO=null;			
		}
		/**
		 * 地图加载错误
		 * @param e
		 */
		private function onIoError(e:IOErrorEvent):void
		{
//			Alert.show("添加到舞台的时候，启动程序_3_地图加载错误"+e.text+" \n"+e.toString());	
			this.sendNotification(ProgressReportMediator.PRM_COMPLETE);
			clearMMap();
			engineP=null;				
		}
		private function clearMMap():void
		{
			engineP.map.removeEventListener(Event.COMPLETE, onComplete);
			engineP.map.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			engineP.map.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);		
		}
	}
}