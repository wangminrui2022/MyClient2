package com.myclient2sample1.pureMVC.controller.business.role
{
	import com.myclient2.util.MStaUtils;
	import com.myclient2sample1.pureMVC.model.EngineProxy;
	import com.myclient2sample1.pureMVC.model.RoleProxy;
	import com.myclient2sample1.pureMVC.view.mediator.ProgressReportMediator;
	import com.myclient2sample1.vo.ProgressReportVO;
	import com.roleobject.core.Role;
	import com.roleobject.core.RoleMove;
	import com.roleobject.core.RoleObjectIsoPoint3D;
	import com.roleobject.loader.RoleLoader;
	import com.roleobject.vo.MoveVO;
	import com.roleobject.vo.RoleInfoVO;
	
	import flash.events.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 加载角色
	 * @author wangmingfan
	 */
	public class RoleLoaderCommand extends SimpleCommand
	{
		public static const RLC_ROLE_LOADER:String="rlc_role_loader";
		
		public static const RLC_ROLE_LOADER_COMPLETE:String="rlc_role_loader_complete";
		
		private var roleP:RoleProxy;
		
		private var engineP:EngineProxy;
		
		public function RoleLoaderCommand()
		{
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
		}
		override public function execute(note:INotification):void
		{
			this.sendNotification(ProgressReportMediator.PRM_START);
			var rl:RoleLoader=new RoleLoader();
			rl.addEventListener(Event.COMPLETE, onComplete);
			rl.addEventListener(ProgressEvent.PROGRESS, onProgress);
			rl.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			rl.onLoader(note.getBody().toString());	
		}
		private function onComplete(e:Event):void
		{
			this.sendNotification(ProgressReportMediator.PRM_COMPLETE);
			var rl:RoleLoader=e.currentTarget as RoleLoader;
			roleP.definitions=rl.definitionsVO;
			clearRoleLoader(rl);
			rl=null;	
			roleP=null;
			this.sendNotification(RLC_ROLE_LOADER_COMPLETE);		
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