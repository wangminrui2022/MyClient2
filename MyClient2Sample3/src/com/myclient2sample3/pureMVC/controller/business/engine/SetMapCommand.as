package com.myclient2sample3.pureMVC.controller.business.engine
{
	import com.myclient2.core.engine.MMap;
	import com.myclient2sample3.pureMVC.model.EngineProxy;
	import com.myclient2sample3.pureMVC.view.mediator.ProgressReportMediator;
	import com.myclient2sample3.vo.MapConvertVO;
	import com.myclient2sample3.vo.ProgressReportVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 设置地图
	 * @author 王明凡
	 */
	public class SetMapCommand extends SimpleCommand
	{
		public static const SMC_SET_MAP_COMMAND:String="smc_set_map_command";

		private var engineP:EngineProxy;

		private var mcVO:MapConvertVO;

		public function SetMapCommand()
		{
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
		}
		override public function execute(note:INotification):void
		{
			mcVO=note.getBody() as MapConvertVO;
			if (!mcVO)
				return;
			this.sendNotification(ProgressReportMediator.PRM_START);
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
			this.sendNotification(InitEngineCommand.IEC_INIT_ENGINE_COMMAND_COMPLETE, mcVO);
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
			this.sendNotification(ProgressReportMediator.PRM_COMPLETE);
			clearMMap();
		}

		/**
		 * 清理地图事件
		 */
		private function clearMMap():void
		{
			engineP.map.removeEventListener(Event.COMPLETE, onComplete);
			engineP.map.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			engineP.map.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			engineP=null;
		}
	}
}