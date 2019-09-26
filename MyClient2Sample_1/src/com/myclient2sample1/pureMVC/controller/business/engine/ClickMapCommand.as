package com.myclient2sample1.pureMVC.controller.business.engine
{
	import com.myclient2.core.engine.MObjects;
	import com.myclient2sample1.consts.MapOperates;
	import com.myclient2sample1.pureMVC.controller.business.role.RoleMoveCommand;
	import com.myclient2sample1.pureMVC.model.EngineProxy;
	import com.myclient2sample1.pureMVC.model.MapOperateProxy;
	import com.myclient2sample1.pureMVC.model.RoleProxy;
	import com.myclient2sample1.pureMVC.model.UIProxy;
	import com.myclient2sample1.vo.MapConvertVO;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 单击地图
	 * @author wangmingfan
	 */
	public class ClickMapCommand extends SimpleCommand
	{
		public static const CMC_CLICK_MAP:String="cmc_click_map";

		private var engineP:EngineProxy;
		private var roleP:RoleProxy;
		private var mapOperateP:MapOperateProxy;
		private var uiP:UIProxy;
		private var isConvert:Boolean=false;//是否已经单击切换场景

		public function ClickMapCommand()
		{
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;
			mapOperateP=this.facade.retrieveProxy(MapOperateProxy.NAME) as MapOperateProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			if (engineP.map)
			{
//				//线条
//				engineP.lineSP=new Shape();
//				engineP.map.addChild(engineP.lineSP);					
				//1.地图单击事件监听
				engineP.map.addEventListener(MouseEvent.CLICK, onMapClick);
				//2.地图切换对象单击事件监听	
				for each (var oj:MObjects in mapOperateP.MapOperateMObjectsArr)
				{
					switch (oj.ojVO.id)
					{
						case MapOperates.Spring_MapConvert_object_258:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
						case MapOperates.Spring_MapConvert_object_256:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
						case MapOperates.Spring_MapConvert_object_490:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
						case MapOperates.Spring_MapConvert_object_533:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;		
												

						case MapOperates.Summer_MapConvert_object_86:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
						case MapOperates.Summer_MapConvert_object_1165:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
						case MapOperates.Summer_MapConvert_object_1169:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
						case MapOperates.Summer_MapConvert_object_1167:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;	
													

						case MapOperates.Autumn_MapConvert_object_982:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
						case MapOperates.Autumn_MapConvert_object_939:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
						case MapOperates.Autumn_MapConvert_object_1158:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;	
						case MapOperates.Autumn_MapConvert_object_931:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;	
																				
							
						case MapOperates.Winter_MapConvert_object_401:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
						case MapOperates.Winter_MapConvert_object_403:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;	
						case MapOperates.Winter_MapConvert_object_573:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;	
						case MapOperates.Winter_MapConvert_object_565:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;	
																					
							
						case MapOperates.Room1_MapConvert_object_27:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
							
						case MapOperates.Room2_MapConvert_object_18:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;		
							
						case MapOperates.Room3_MapConvert_object_49:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;
							
						case MapOperates.Room4_MapConvert_object_210:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;			
							
						case MapOperates.Room5_MapConvert_object_19:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;		
							
						case MapOperates.Room6_MapConvert_object_9:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;	
							
						case MapOperates.PictureMap_MapConvert_object_25:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;	
						case MapOperates.PictureMap_MapConvert_object_27:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;								
							
						case MapOperates.Room8_MapConvert_object_5:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;	
						case MapOperates.Room8_MapConvert_object_30:
							oj.addEventListener(MouseEvent.CLICK,onMapConvertClick);
							break;																																																																																					
					}
				}
				//3.地图其他对象单击事件监听	
			}
		}
		/**
		 * 单击地图寻路
		 * @param e
		 */
		private function onMapClick(e:MouseEvent):void
		{
			if(isConvert)
				return;
			//停止正在移动的路
			this.sendNotification(RoleMoveCommand.RMC_ROLE_MOVE);
			//重新训练
			var start:Point=new Point(roleP.role.x, roleP.role.y);
			var end:Point=new Point(e.currentTarget.mouseX,e.currentTarget.mouseY);
			var roadArr:Array=engineP.engine.searchRoad(start, end);
			if (roadArr)
				this.sendNotification(RoleMoveCommand.RMC_ROLE_MOVE,roadArr);
			start=null;
			end=null;			
		}
		/**
		 * 单击地图切换
		 * @param e
		 */
		private function onMapConvertClick(e:MouseEvent):void
		{
			isConvert=true;	
			var oj:MObjects;
			var roleRect:Rectangle;
			var ojRect:Rectangle;
			var mcVO:MapConvertVO;
			try
			{
				oj=e.currentTarget as MObjects;
				roleRect=roleP.role.getBounds(uiP.roleConatainer);
				ojRect=oj.getBounds(uiP.mapOperateContainer); 
				//如果角色和地图切换对象相交	
				if(roleRect.intersects(ojRect))
				{
					engineP.map.removeEventListener(MouseEvent.CLICK, onMapClick);
					oj.removeEventListener(MouseEvent.CLICK, onMapConvertClick);
					mcVO=uiP.getMapConvertVO(engineP.map.info.name,oj.ojVO.id);	
					this.sendNotification(ConvertClearMapCommand.CCMC_CONVERT_CLEAR_MAP);
					this.sendNotification(InitEngineCommand.IEC_INIT_ENGINE_COMMAND,mcVO);
				}	
				else
				{
					isConvert=false;
				}
			}catch(er:Error)
			{
				
			}
			oj=null;
			roleRect=null;
			ojRect=null;
			mcVO=null;
		}	
	}
}