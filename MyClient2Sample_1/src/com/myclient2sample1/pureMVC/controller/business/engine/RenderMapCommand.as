package com.myclient2sample1.pureMVC.controller.business.engine
{
	import com.myclient2sample1.pureMVC.controller.business.mapoperate.InitMapOperateCommand;
	import com.myclient2sample1.pureMVC.model.EngineProxy;
	import com.myclient2sample1.pureMVC.model.RoleProxy;
	import com.myclient2sample1.pureMVC.model.UIProxy;
	
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 渲染地图
	 * @author 王明凡
	 */
	public class RenderMapCommand extends SimpleCommand
	{
		public static const RMC_RENDER_MAP:String="rmc_render_map";

		private var engineP:EngineProxy;

		private var roleP:RoleProxy;

		private var uiP:UIProxy;

		public function RenderMapCommand()
		{
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			//开始渲染场景
			engineP.engine.renderMap(engineP.map, engineP.viewPort, engineP.camera);
			
			//1.将移动摄像机的信息(矩形区域)给"操作对象容器"
			uiP.mapOperateContainer.scrollRect=engineP.camera.getRectangle();
			//2.将移动摄像机的信息(矩形区域)给"角色容器"
			uiP.roleConatainer.scrollRect=engineP.camera.getRectangle();	
			
			//1.同步"操作对象容器"和地图坐标x,y
			uiP.mapOperateContainer.x=engineP.map.x;
			uiP.mapOperateContainer.y=engineP.map.y;
			//2.同步"角色容器"和地图坐标x,y
			uiP.roleConatainer.x=engineP.map.x;	
			uiP.roleConatainer.y=engineP.map.y;						
									
			//初始化地图操作对象模型层
			this.sendNotification(InitMapOperateCommand.IMOC_INIT_MAP_OPERATE);
			engineP=null;
			roleP=null;
			uiP=null;
		}
	}
}