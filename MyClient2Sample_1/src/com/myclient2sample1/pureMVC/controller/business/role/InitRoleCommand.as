package com.myclient2sample1.pureMVC.controller.business.role
{
	import com.myclient2.util.MStaUtils;
	import com.myclient2sample1.pureMVC.model.EngineProxy;
	import com.myclient2sample1.pureMVC.model.RoleProxy;
	import com.myclient2sample1.pureMVC.model.UIProxy;
	import com.myclient2sample1.vo.MapConvertVO;
	import com.roleobject.core.Role;
	import com.roleobject.core.RoleMove;
	import com.roleobject.core.RoleObjectIsoPoint3D;
	import com.roleobject.vo.MoveVO;
	import com.roleobject.vo.RoleInfoVO;
	
	import flash.display.Shape;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 *  初始化Role模型层
	 * @author 王明凡
	 */
	public class InitRoleCommand extends SimpleCommand
	{
		public static const IRC_INIT_ROLE_COMMAND:String="irc_init_role_command";
		public static const IRC_INIT_ROLE_COMMAND_COMPLETE:String="irc_init_role_command_complete";
		
		private var roleP:RoleProxy;
		private var engineP:EngineProxy;
		private var uiP:UIProxy;
		
		public function InitRoleCommand()
		{
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		/**
		 * 
		 * @param note
		 */
		override public function execute(note:INotification):void
		{
			var mcVO:MapConvertVO=note.getBody() as MapConvertVO;
			//判断初始化引擎的类型(启动/切换)
			if(mcVO.state==MapConvertVO.START)
			{
				//创建角色
				onCreateRole(mcVO.x, mcVO.y);	
				//添加角色到地图的顶层
				uiP.roleConatainer.addChild(roleP.role);							
			}
			else
			{
				//设置角色位置
				roleP.role.x=mcVO.x;
				roleP.role.y=mcVO.y;
			}	
			//创建角色移动
			onCreateRoleMove();		
			mcVO=null;
			engineP=null;
			roleP=null;
			uiP=null;	
			this.sendNotification(IRC_INIT_ROLE_COMMAND_COMPLETE);							
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
//			mVO.mapName=engineP.map.info.name;
//			mVO.direct=5;
//			mVO.endX=x;
//			mVO.endY=y;
//			mVO.velocityX=0;
//			mVO.velocityY=0;
//			info.moveVO=mVO;
//			roleP.role=new Role(info, roleP.definitions.getMaterialDefinitionVO(info.materialDefinition_name), roleP.definitions.loaderArr);
//			roleP.role.Stand(3);
//			roleP.role.x=info.moveVO.endX;
//			roleP.role.y=info.moveVO.endY;

			roleP.role=new Role(null,roleP.definitions.getMaterialDefinitionVO("role1"), roleP.definitions.loaderArr);
			roleP.role.Stand(3);	
			roleP.role.x=x;
			roleP.role.y=y;
		}

		/**
		 * 创建角色移动
		 */
		private function onCreateRoleMove():void
		{
			if (engineP.map.info.mapType == MStaUtils.STAGGERED)
			{
				roleP.roleMove=new RoleMove(
				engineP.map.info.mapType, 
				engineP.map.info.tileWidth, 
				engineP.map.info.tileHeight, null);
			}
			else
			{
				var pt3D:RoleObjectIsoPoint3D=new RoleObjectIsoPoint3D(engineP.map.move3D.x, engineP.map.move3D.y, engineP.map.move3D.z);
				roleP.roleMove=new RoleMove(
				engineP.map.info.mapType, 
				engineP.map.info.tileWidth, 
				engineP.map.info.tileHeight, pt3D);
				pt3D=null;
			}
		}		
	}
}