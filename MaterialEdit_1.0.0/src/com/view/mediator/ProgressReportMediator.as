package com.view.mediator
{
	import com.controller.business.PageClearCommand;
	import com.model.UIProxy;
	import com.view.ui.ProgressReport;
	import com.vo.ProgressReportVO;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 	ProgressReport.mxml
	 * 【使用方式】
	 * 		//显示
	 * 		this.facade.sendNotification(AppConstants.PROGRESS);
	 * 		//加载
	 * 		var pgVO:ProgressReportVO=new ProgressReportVO();
	 * 		pgVO.descreption="加载中";
	 * 		pgVO.load=50;
	 * 		pgVO.total=100;
	 * 		this.facade.sendNotification(AppConstants.PROGRESS_LOAD,pgVO);
	 * 		//完成
	 * 		this.facade.sendNotification(AppConstants.PROGRESS_COMPLETE); 
	 * @author 王明凡
	 */
	public class ProgressReportMediator extends Mediator
	{
		public var uiP:UIProxy;
		
		public static const NAME:String="ProgressReportMediator";
		//(通知)
		public static const	PRM_PROGRESS:String="prm_progress";
		//(通知)
		public static const	PRM_PROGRESS_LOAD:String="prm_progress_load";
		//(通知)
		public static const	PRM_PROGRESS_COMPLETE:String="prm_progress_complete";
		
		public function ProgressReportMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		/**
		 * 当前通知集合
		 * @return
		 */
		override public function listNotificationInterests():Array
		{
			return [
			PRM_PROGRESS, 
			PRM_PROGRESS_LOAD, 
			PRM_PROGRESS_COMPLETE];
		}

		/**
		 * 当前通知处理
		 * @param note
		 */
		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case PRM_PROGRESS:
					onProgress();
					break;
				case PRM_PROGRESS_LOAD:
					onProgressLoad(note.getBody() as ProgressReportVO);
					break;
				case PRM_PROGRESS_COMPLETE:
					onComplete();
					break;
			}
		}
		/**
		 * 显示进度条
		 */
		private function onProgress():void
		{		
			var progress:ProgressReport=ProgressReport(PopUpManager.createPopUp(uiP.app, ProgressReport, true));
			PopUpManager.centerPopUp(progress);
			this.viewComponent=progress;
		}
		/**
		 * 加载中
		 * @param pgVO
		 */
		public function onProgressLoad(pgVO:ProgressReportVO):void
		{
			progress.pg.label=pgVO.descreption + " " + Math.round((pgVO.load / pgVO.total) * 100) + "%";
			progress.pg.setProgress(pgVO.load, pgVO.total);
			pgVO=null;
		}

		/**
		 * 加载完成
		 */
		public function onComplete():void
		{
			this.facade.sendNotification(PageClearCommand.PAGECLEAR, progress, "1");
			PopUpManager.removePopUp(progress);
		}		
		/**
		 * 返回ProgressReport
		 * @return
		 */
		public function get progress():ProgressReport
		{
			return this.viewComponent as ProgressReport;
		}
	}
}