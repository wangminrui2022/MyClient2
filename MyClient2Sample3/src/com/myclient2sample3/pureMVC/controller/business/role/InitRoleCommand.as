package com.myclient2sample3.pureMVC.controller.business.role
{
	import com.myclient2sample3.consts.MString;
	import com.myclient2sample3.pureMVC.model.RoleProxy;
	import com.myclient2sample3.pureMVC.view.mediator.ProgressReportMediator;
	import com.myclient2sample3.vo.MapConvertVO;
	import com.myclient2sample3.vo.ProgressReportVO;
	import com.roleobject.loader.RoleLoader;
	
	import flash.events.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 初始化用户模型层
	 * @author 王明凡
	 */
	public class InitRoleCommand extends SimpleCommand
	{
		public static const IRC_INIT_ROLE:String="irc_init_role";
		
		public static const IRC_INIT_ROLE_COMPLETE:String="irc_init_role_complete";
		
		private var roleP:RoleProxy;
		
		private var mcVO:MapConvertVO;
		
		public function InitRoleCommand()
		{
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;
		}
		override public function execute(note:INotification):void
		{	
			mcVO=note.getBody() as MapConvertVO;
			if(mcVO.state==MapConvertVO.CONVERT)	
			{
				roleP=null;
				this.sendNotification(SetRoleCommand.SRC_SET_ROLE,mcVO);
				return;
			}
			this.sendNotification(ProgressReportMediator.PRM_START);
			var rl:RoleLoader=new RoleLoader();
			rl.addEventListener(Event.COMPLETE, onComplete);
			rl.addEventListener(ProgressEvent.PROGRESS, onProgress);
			rl.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			rl.onLoader(MString.ROLE_XML);		
		}
		private function onComplete(e:Event):void
		{
			this.sendNotification(ProgressReportMediator.PRM_COMPLETE);
			var rl:RoleLoader=e.currentTarget as RoleLoader;
			roleP.definitions=rl.definitionsVO;
			clearRoleLoader(rl);
			rl=null;	
			roleP=null;
			this.sendNotification(SetRoleCommand.SRC_SET_ROLE,mcVO);
		}
		private function onProgress(e:ProgressEvent):void
		{
			var pgVO:ProgressReportVO=new ProgressReportVO();
			pgVO.descreption="加载角色中";
			pgVO.load=e.bytesLoaded;
			pgVO.total=e.bytesTotal;
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS, pgVO);
			pgVO=null;				
		}
		private function onIoError(e:IOErrorEvent):void
		{
			this.sendNotification(ProgressReportMediator.PRM_COMPLETE);			
			clearRoleLoader(e.currentTarget as RoleLoader);
		}
		private function clearRoleLoader(rl:RoleLoader):void
		{
			rl.removeEventListener(Event.COMPLETE, onComplete);
			rl.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			rl.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			rl.clear();
			rl=null;
		}		
	}
}