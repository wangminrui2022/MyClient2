package com.myclient2sample1.pureMVC.view.mediator
{
	import com.myclient2sample1.pureMVC.controller.business.common.PageClearCommand;
	import com.myclient2sample1.pureMVC.model.UIProxy;
	import com.myclient2sample1.pureMVC.view.ui.ProgressReport;
	import com.myclient2sample1.vo.ProgressReportVO;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 	ProgressReport.mxml
	 * 【使用方式】
	 * 		//显示
	 * 		this.facade.sendNotification(ProgressReportMediator.PRM_START);
	 * 		//加载
	 * 		var pgVO:ProgressReportVO=new ProgressReportVO();
	 * 		pgVO.descreption="加载中";
	 * 		pgVO.load=50;
	 * 		pgVO.total=100;
	 * 		this.facade.sendNotification(ProgressReportMediator.PRM_PROGRESS,pgVO);
	 * 		//完成
	 * 		this.facade.sendNotification(ProgressReportMediator.PRM_COMPLETE); 
	 * @author 王明凡
	 */
	public class ProgressReportMediator extends Mediator
	{
		public static const NAME:String="ProgressReportMediator";
		//开始进度条(通知)
		public static const PRM_START:String="prm_start";
		//进度条加载(通知)
		public static const PRM_PROGRESS:String="prm_progress";
		//进度条完成(通知)
		public static const PRM_COMPLETE:String="prm_complete";	
			
		public var uiP:UIProxy;
		
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
			PRM_START, 
			PRM_PROGRESS, 
			PRM_COMPLETE];
		}

		/**
		 * 当前通知处理
		 * @param note
		 */
		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case PRM_START:
					onStart();
					break;
				case PRM_PROGRESS:
					onProgress(note.getBody() as ProgressReportVO);
					break;
				case PRM_COMPLETE:
					onComplete();
					break;
			}
		}
		/**
		 * 显示进度条
		 */
		private function onStart():void
		{			
			var progress:ProgressReport=ProgressReport(PopUpManager.createPopUp(uiP.app, ProgressReport, true));
			PopUpManager.centerPopUp(progress);
			this.viewComponent=progress;
		}
		/**
		 * 加载中
		 * @param pgVO
		 */
		public function onProgress(pgVO:ProgressReportVO):void
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
			this.facade.sendNotification(PageClearCommand.PCC_PAGECLEAR, progress, "1");
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