package com.myclient2sample3.pureMVC.controller.business.role
{
	import com.myclient2sample3.pureMVC.model.*;
	import com.myclient2sample3.vo.MapConvertVO;
	import com.roleobject.core.Role2;
	import com.roleobject.vo.MoveVO;
	import com.roleobject.vo.RoleInfoVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 *
	 * @author 王明凡
	 */
	public class SetRoleCommand extends SimpleCommand
	{
		public static const SRC_SET_ROLE:String="src_set_role";
		
		private var roleP:RoleProxy;

		private var uiP:UIProxy;
		
		private var engineP:EngineProxy;

		public function SetRoleCommand()
		{
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
		}

		override public function execute(note:INotification):void
		{
			var mcVO:MapConvertVO=note.getBody() as MapConvertVO;
			//判断初始化引擎的类型(启动/切换)
			if (mcVO.state == MapConvertVO.START)
			{
				//创建角色
				onCreateRole(mcVO.x, mcVO.y);
				//添加角色到地图的顶层
				uiP.roleConatainer.addChild(roleP.role2);
			}
			else
			{
				//设置角色位置
				roleP.role2.x=mcVO.x;
				roleP.role2.y=mcVO.y;
			}
			mcVO=null;
			engineP=null;
			roleP=null;
			uiP=null;
			this.sendNotification(InitRoleCommand.IRC_INIT_ROLE_COMPLETE);	
		}

		/**
		 * 创建角色
		 */
		private function onCreateRole(x:int, y:int):void
		{
//			var info:RoleInfoVO=new RoleInfoVO();
//			info.roleType=1;
//			info.uState=1;
//			info.nameColor="#3c140b";
//			info.uID=1;
//			info.roleName="张三";
//			info.materialDefinition_name="role1";
//			var mVO:MoveVO=new MoveVO();
//			mVO.direct=-1;
//			mVO.endX=x;
//			mVO.endY=y;
//			mVO.velocityX=0;
//			mVO.velocityY=0;
//			info.moveVO=mVO;
			roleP.role2=new Role2(null, roleP.definitions.getMaterialDefinitionVO("role1"), roleP.definitions.loaderArr);
			roleP.role2.onPlay(1);
			roleP.role2.x=x;
			roleP.role2.y=y;
		}
	}
}