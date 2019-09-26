package com.pureMVC.view.mediator
{
	import com.maptype.core.Tiles;
	
	import flash.events.ContextMenuEvent;
	
	import com.consts.MString;
	import com.map.Objects;
	import com.pureMVC.controller.business.bindable.SaveStateUpdateCommand;
	import com.pureMVC.controller.business.map.GetDragObjectsCommand;
	import com.pureMVC.controller.business.map.ObjectsToUI2Commmand;
	import com.pureMVC.model.*;
	import com.pureMVC.view.ui.MapEditPanel;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.vo.map.InfoPanelVO;
	import com.vo.map.ObjectsToUI2VO;

	/**
	 * 
	 * @author wangmingfan
	 */
	public class MapEditPanelMediator2 extends Mediator
	{
		public static const NAME:String="MapEditPanelMediator2";
		//对象信息(通知)
		public static const MEPM_OBJECTINFO:String="mepm_objectinfo";
		//显示隐藏路点(通知)
		public static const MEPM_DISPLAY_HIDE_ROAD:String="mepm_display_hide_road";
		//深度+-1(通知)
		public static const MEPM_DEPTH:String="mepm_depth";
		//移除(通知)
		public static const MEPM_REMOVE:String="mepm_remove";		
		//重置(通知)
		public static const MEPM_RESET:String="mepm_reset";
		//地图模型层
		private var mapP:MapProxy;
		//UI模型层
		private var uiP:UIProxy;
		
		private var materialP:MaterialProxy;
							
		public function MapEditPanelMediator2(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;		
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}
		override public function listNotificationInterests():Array
		{
			return [			
			MEPM_OBJECTINFO, 
			MEPM_DISPLAY_HIDE_ROAD, 
			MEPM_DEPTH, 
			MEPM_REMOVE,
			MEPM_RESET];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case MEPM_OBJECTINFO:
					onObjectInfo(note.getBody() as ContextMenuEvent);
					break;	
				case MEPM_DISPLAY_HIDE_ROAD:
					onDisplayHideRoad(note.getBody() as ContextMenuEvent);
					break;
				case MEPM_DEPTH:
					onDepth(note.getBody() as ContextMenuEvent);
					break;
				case MEPM_REMOVE:
					onRemoveMT(note.getBody() as ContextMenuEvent);
					break;
				case MEPM_RESET:
					onReset(note.getBody() as ContextMenuEvent);
					break;										
			}
		}
		/**
		 *  显示/隐藏路点【选项】
		 * @param e
		 */
		private function onDisplayHideRoad(e:ContextMenuEvent):void
		{
			var oj:Objects=materialP.getMapObjects(e);
			if(oj.mTileVO.mdVO.type==MString.OBJECT)
			{
				if (e.currentTarget.caption == MString.DISPLAY_ROAD)
				{
					oj.visibleRoad(true);
					oj.visibleBorder(true);
				}
				else
				{
					oj.visibleRoad(false);
					oj.visibleBorder(false);
				}
			}
			oj=null;
		}
		/**
		 * 材质深度+-1【选项】
		 * 1.交互显示对象的层次
		 * 2.更新所有层次
		 * 3.修改材质对象在集合中的顺序位置(在地图渲染引擎中使用该数组顺序加载地图中的各种对象的深度问题)
		 * @param e
		 */
		private function onDepth(e:ContextMenuEvent):void
		{
			var oj:Objects=materialP.getMapObjects(e);
			var index:int=uiP.ui2.getChildIndex(oj);
			var sum:int=uiP.ui2.numChildren;
			if (e.currentTarget.caption == MString.DEPTH_1 && index < (sum - 1))
			{
				uiP.ui2.setChildIndex(oj, index + 1);
				mapP.switchPosition(oj, 1);
			}
			else if (e.currentTarget.caption == MString.DEPTH_2 && index > 0)
			{
				uiP.ui2.setChildIndex(oj, index - 1);
				mapP.switchPosition(oj, -1);
			}
			else
			{
				oj=null;
				return;
			}
			mapP.updateDepth();
			oj=null;		
			//更新编辑状态和标题栏
			this.sendNotification(SaveStateUpdateCommand.SSUC_SAVE_STATE_UPDATE,true);	
		}
		/**
		 * 移除材质【选项】
		 * @param e
		 */
		private function onRemoveMT(e:ContextMenuEvent):void
		{
			if(e.mouseTarget is Tiles)
			{
				mapP.tiles.clear();
				mapP.map.info.diffuse="null";		
				//更新编辑状态和标题栏
				this.sendNotification(SaveStateUpdateCommand.SSUC_SAVE_STATE_UPDATE,true);								
			}
			else
			{
				var oj:Objects=materialP.getMapObjects(e);
				var otVO:ObjectsToUI2VO=new ObjectsToUI2VO();
				otVO.oj=oj;
				otVO.operateType=ObjectsToUI2VO.DELETE;
				this.sendNotification(ObjectsToUI2Commmand.OTUC_OBJECTSTOUI2,otVO);	
				otVO=null;			
				oj=null;
			}
		}		
		/**
		 * 重置材质【选项】
		 * @param e
		 */
		private function onReset(e:ContextMenuEvent):void
		{
			var oj:Objects=materialP.getMapObjects(e);
			var otVO:ObjectsToUI2VO=new ObjectsToUI2VO();
			otVO.oj=oj;
			otVO.operateType=ObjectsToUI2VO.RESET;
			this.sendNotification(ObjectsToUI2Commmand.OTUC_OBJECTSTOUI2,otVO);	
			this.sendNotification(GetDragObjectsCommand.GDOC_GET_DRAG_OBJECTS_RESULT,oj);
			otVO=null;
			oj=null;	
		} 			
		/**
		 * 打开地图中对象信息
		 * @param e
		 */
		private function onObjectInfo(e:ContextMenuEvent):void
		{
			var oj:Objects=materialP.getMapObjects(e);
			var info:String=
			"对象索引:"+oj.index+
			"<br/>对象ID:"+oj.id+
			"<br/>对象深度:"+oj.depth+
			"<br/>对象x:"+oj.x+
			"<br/>对象y:"+oj.y+
			"<br/>材质名字:"+oj.mTileVO.mdVO.name+
			"<br/>材质类型:"+oj.mTileVO.mdVO.type+			
			"<br/>材质使用方式:"+oj.mTileVO.mdVO.used+
			"<br/>材质宽:"+oj.mTileVO.mdVO.width+
			"<br/>材质高:"+oj.mTileVO.mdVO.height+
			"<br/>元件类型:"+oj.mTileVO.mdVO.elementType+
			"<br/>材质类定义名:"+oj.mTileVO.mdVO.diffuse;
			var ipVO:InfoPanelVO=new InfoPanelVO();
			ipVO.title="地图信息";
			ipVO.info=info;		
			this.sendNotification(MapEditPanelMediator.MEPM_DISPLAY_INFO_PANEL,ipVO);
			ipVO=null;	
			oj=null;
		}					
		/**
		 * 
		 * @return 
		 */
		private function get mapEdit():MapEditPanel
		{
			return this.viewComponent as MapEditPanel;
		}				
	}
}