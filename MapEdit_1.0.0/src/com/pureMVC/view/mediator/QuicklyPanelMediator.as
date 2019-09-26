package com.pureMVC.view.mediator
{

	import com.consts.MString;
	import com.pureMVC.controller.business.other.MenuItemSelectCommand;
	import com.pureMVC.model.*;
	import com.pureMVC.view.ui.QuicklyPanel;
	import com.vo.map.SetRoadVO;
	
	import flash.events.MouseEvent;
	import flash.geom.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 快捷键
	 * @author wangmingfan
	 */
	public class QuicklyPanelMediator extends Mediator
	{
		public static const NAME:String="QuicklyPanelMediator";
		
		public static const QPM_QUICKLYPANEL:String="qpm_quicklypanel";
		
		public static const QPM_REGISTERSETROAD:String="qpm_registersetroad";
		
		public static const QPM_SELECT_ROADS:String="qpm_select_roads";
		
		//数据绑定模型层
		private var bindableP:BindableProxy;
		//地图模型层
		private var mapP:MapProxy;
		//UI模型层 
		private var uiP:UIProxy;

		public function QuicklyPanelMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			//显示单击
			quickly.maps.addEventListener(MouseEvent.CLICK, onClick);
			quickly.grids.addEventListener(MouseEvent.CLICK, onClick);
			quickly.roads.addEventListener(MouseEvent.CLICK, onClick);
			quickly.objects.addEventListener(MouseEvent.CLICK, onClick);
			//其他
			quickly.newCreateBtn.addEventListener(MouseEvent.CLICK,onOtherClick);
			quickly.saveBtn.addEventListener(MouseEvent.CLICK,onOtherClick);
			quickly.closeBtn.addEventListener(MouseEvent.CLICK,onOtherClick);
			//鼠标移动位置
			uiP.mainUI.addEventListener(MouseEvent.MOUSE_MOVE,onMainUIMouseMove);
		}
		override public function listNotificationInterests():Array
		{
			return [
			QPM_REGISTERSETROAD,
			QPM_QUICKLYPANEL,
			QPM_SELECT_ROADS];
		}

		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case QPM_QUICKLYPANEL:
						onQuicklyPanel();
						onRegisterSetRoad();	
					break;
				case QPM_REGISTERSETROAD:
						onRegisterSetRoad();
					break;
				case QPM_SELECT_ROADS:
					onSelectRoad(note.getBody() as Boolean);
					break;
			}
		}
		/**
		 * 地图设置路点的时候启动路点和网格显示(如果路点未显示的话)
		 */
		private function onSelectRoad(bol:Boolean):void
		{
			if(bol)
			{
				bindableP.CheckBox_Roads=bol;
				mapP.road.visible=bol;		
				quickly.roads.selected=bol;	
				
				bindableP.CheckBox_Grids=bol;
				mapP.grid.visible=bol;
				mapP.grid.alpha=0;
				quickly.grids.selected=bol;
			}
			else
			{
				mapP.grid.alpha=1;
			}
		}
		/**
		 * 注册SetRoadMediator,并发送路点设置通知
		 * 移除材质编辑面板中的SetRoadMediator
		 */
		private function onRegisterSetRoad():void
		{
			if(this.facade.hasMediator(SetRoadMediator.NAME))
				this.sendNotification(SetRoadMediator.SRM_CLEAR);	
			this.facade.registerMediator(new SetRoadMediator(quickly.setRoad));
			var srVO:SetRoadVO=new SetRoadVO();
			srVO.setRoadType=1;
			srVO.roadArr=mapP.map.roadArr;
			srVO.tileH=mapP.map.info.tileHeight;			
			srVO.tileW=mapP.map.info.tileWidth;
			srVO.UI=uiP.ui1;
			this.sendNotification(SetRoadMediator.SRM_SETROAD,srVO);
		}
		/**
		 * 场景快捷操作
		 */
		private function onQuicklyPanel():void
		{
			quickly.maps.selected=bindableP.CheckBox_Maps;
			quickly.grids.selected=bindableP.CheckBox_Grids;
			quickly.roads.selected=bindableP.CheckBox_Roads;
			quickly.objects.selected=bindableP.CheckBox_Objects;
		}		
		/**
		 * 单击复选框
		 * @param e
		 */
		private function onClick(e:MouseEvent):void
		{
			//取消路点设置
			this.sendNotification(SetRoadMediator.SRM_SETROAD_CANCEL);
			//取消拖动材质
			this.sendNotification(UseMaterialMediator.UMM_CANCEL);
			var select:Boolean;
			//反判断CheckBox选中和未选中
			if (e.currentTarget.selected)
				select=true;
			else
				select=false;
			switch (e.currentTarget)
			{
				case quickly.maps:
					bindableP.CheckBox_Maps=select;
					mapP.tiles.visible=select;
					break;
				case quickly.grids:
					bindableP.CheckBox_Grids=select;
					mapP.grid.visible=select;
					break;
				case quickly.roads:
					bindableP.CheckBox_Roads=select;
					mapP.road.visible=select;
					break;
				case quickly.objects:
					bindableP.CheckBox_Objects=select;
					uiP.ui2.visible=select;
					break;
			}
		}
		/**
		 * 其他按钮
		 * @param e
		 */
		private function onOtherClick(e:MouseEvent):void
		{
			//取消路点设置
			this.sendNotification(SetRoadMediator.SRM_SETROAD_CANCEL);	
			//取消拖动材质
			this.sendNotification(UseMaterialMediator.UMM_CANCEL);		
			var str:String;		
			switch (e.currentTarget.id)
			{
				case "newCreateBtn":
					str=MString.CREATEFILEBAR;
					break;
				case "saveBtn":     
					str=MString.SAVEFILEBAR;
					break;
				case "closeBtn":   
					str=MString.CLOSEFILEBAR;  
					break;
			}	
			this.sendNotification(MenuItemSelectCommand.MSC_MENUITEM_SELECT,str);		
		}	
		/**
		 * 鼠标移动位置
		 * @param e
		 */
		private function onMainUIMouseMove(e:MouseEvent):void
		{
			quickly.mouseXYLab.text="  鼠标="+e.currentTarget.mouseX+":"+e.currentTarget.mouseY;
		}			
		/**
		 * 返回QuicklyPanel
		 * @return
		 */
		public function get quickly():QuicklyPanel
		{
			return this.viewComponent as QuicklyPanel;
		}
	}
}