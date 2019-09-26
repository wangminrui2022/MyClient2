package com.myclient2sample1.pureMVC.controller.business.role
{
	import com.myclient2.core.MIsoPoint3D;
	import com.myclient2.core.vo.MRoadVO;
	import com.myclient2.util.MIsoUtils;
	import com.myclient2.util.MStaUtils;
	import com.myclient2sample1.pureMVC.model.EngineProxy;
	import com.myclient2sample1.pureMVC.model.RoleProxy;
	import com.myclient2sample1.pureMVC.model.UIProxy;
	import com.myclient2sample1.pureMVC.view.mediator.MapNavigateMediator;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 角色移动
	 * @author wangmingfan
	 */
	public class RoleMoveCommand extends SimpleCommand
	{
		public static const RMC_ROLE_MOVE:String="rmc_role_move";
		
		private var uiP:UIProxy;
		private var roleP:RoleProxy;
		private var engineP:EngineProxy;
		
		public function RoleMoveCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;	
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;	
		}

		override public function execute(note:INotification):void
		{
			if(note.getBody())
			{
				var roadArr:Array=note.getBody() as Array;
//				//画路
//				drawRoad(roadArr);
				//指定角色移动时候的移动回调函数
				roleP.roleMove.moveCall=onMoveCall;
				//移动角色
				roleP.roleMove.onRoleMove(roadArr, new Point(roleP.role.x, roleP.role.y), roleP.role);
				roadArr.splice(0, roadArr.length);
				roadArr=null;
			}
			else
			{
				//停止移动角色
				roleP.roleMove.clearRoad();
				uiP=null;
				roleP=null;
				engineP=null;
			}
		}

		/**
		 * 角色移动时候的移动回调函数
		 */
		private function onMoveCall():void
		{
			//1.移动摄像机
			engineP.engine.moveCamera(new Point(roleP.role.x,roleP.role.y));	
			//2.将移动摄像机的信息(矩形区域)给地图操作对象容器
			uiP.mapOperateContainer.scrollRect=engineP.camera.getRectangle();	
			//3.将移动摄像机的信息(矩形区域)给地图角色容器
			uiP.roleConatainer.scrollRect=engineP.camera.getRectangle();	
			//4.移动地图导航
			this.sendNotification(MapNavigateMediator.MNM_MOVE_MAP_NAVIGATE);
			//透明角色
			engineP.engine.onShadow(roleP.role);
		}

//		/**
//		 * 画路
//		 */
//		private function drawRoad(roadArr:Array):void
//		{
//			engineP.lineSP.graphics.clear();
//			engineP.lineSP.graphics.lineStyle(1, 0xdc143c, 1);
//			engineP.lineSP.graphics.moveTo(roleP.role.x, roleP.role.y);
//			for (var j:int=0; j < roadArr.length; j++)
//			{
//				var rVO:MRoadVO=roadArr[j] as MRoadVO;
//				var pt:Point=getPoint(engineP.map.info.mapType, rVO.rhombusX, rVO.rhombusY, engineP.map.info.tileWidth, engineP.map.info.tileHeight, engineP.map.move3D);
//				engineP.lineSP.graphics.lineTo(pt.x, pt.y);
//				pt=null;
//			}
//			roadArr=null;
//		}
//
//		/**
//		 * 交错排列/等角"索引" → 交错排列/等角"坐标"(路点中心点坐标)
//		 * @param mapType
//		 * @param rhombusX
//		 * @param rhombusY
//		 * @param tileW
//		 * @param tileH
//		 * @param move3D
//		 * @return
//		 */
//		private function getPoint(mapType:String, rhombusX:int, rhombusY:int, tileW:int, tileH:int, move3D:MIsoPoint3D):Point
//		{
//			var pt:Point;
//			if (mapType == MStaUtils.STAGGERED)
//				pt=MStaUtils.getStaggeredPoint(new Point(rhombusX, rhombusY), tileW, tileH);
//			else
//				pt=MIsoUtils.getIsometricPoint(rhombusX, rhombusY, tileH, move3D);
//			move3D=null;
//			return pt;
//		}
	}
}