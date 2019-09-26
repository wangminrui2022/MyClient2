package com.pureMVC.view.mediator
{
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import com.consts.MString;
	import com.consts.Msg;
	import com.pureMVC.controller.business.bindable.SaveStateUpdateCommand;
	import com.pureMVC.controller.business.common.Message2Command;
	import com.pureMVC.controller.business.common.PageClearCommand;
	import com.pureMVC.controller.business.common.ValidateCommand;
	import com.pureMVC.controller.business.map.BackgroundAndTilesCommand;
	import com.pureMVC.controller.business.map.GridAndRoadCommand;
	import com.pureMVC.model.BindableProxy;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.ui.SetMap;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.vo.common.MessageAlert2VO;
	import com.vo.common.ValidateErrorVO;
	import com.vo.common.ValidateVO;

	/**
	 * 设置地图
	 * @author Administrator
	 */
	public class SetMapMediator extends Mediator
	{
		public static const NAME:String="SetMapMediator";
		
		public static const TYPE:String="SetMapMediator_type";
		
		public static const SMM_SET_MAP:String="smm_set_map";
		
		public static const SMM_CLEAR:String="smm_clear";
		
		private var uiP:UIProxy;
		
		private var mapP:MapProxy;
		
		private var bindableP:BindableProxy;
				
		public function SetMapMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;			
		}
		override public function listNotificationInterests():Array
		{
			return [
			SMM_SET_MAP,
			SMM_CLEAR,
			ValidateCommand.VC_VALIDATA_RESULT];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case SMM_SET_MAP:
					onSetMap();
					break;
				case SMM_CLEAR:
					clear();
					break;
				case ValidateCommand.VC_VALIDATA_RESULT:
					if(note.getType()==TYPE)
						onValidataResult(note.getBody() as ValidateErrorVO);
					break;
			}
		}
		/**
		 * 
		 */
		private function onSetMap():void
		{
			var setMap:SetMap=SetMap(PopUpManager.createPopUp(uiP.app,SetMap,true));
			PopUpManager.centerPopUp(setMap);
			this.viewComponent=setMap;
			setMap.mapW.text=""+mapP.map.info.mapwidth; 
			setMap.mapH.text=""+mapP.map.info.mapheight;
			setMap.tileH.text=""+mapP.map.info.tileHeight;
			setMap.MapType.selectedIndex=getMapTypeIndex(mapP.map.info.mapType);
			setMap.confirmBtn.addEventListener(MouseEvent.CLICK,OnConfirmClick);
		}
		/**
		 * 确定按钮
		 * @param e
		 */
		private function OnConfirmClick(e:MouseEvent):void
		{
			var vArr:Array=new Array();
			vArr.push(getVlidateVO("地图宽", setMap.mapW.text,true,true,false));
			vArr.push(getVlidateVO("地图高", setMap.mapH.text,true,true,false));
			vArr.push(getVlidateVO("网格高", setMap.tileH.text,true,true,true));
			this.sendNotification(ValidateCommand.VC_VALIDATA, vArr, TYPE);						
		}	
		/**
		 * 空验证结果
		 * @param nvVO
		 */
		private function onValidataResult(veVO:ValidateErrorVO):void
		{
			if (veVO)
			{
				errorAlert(veVO.result+veVO.vVO.id,true,25,5,setMap);
				veVO=null;
			}
			else
			{
				//地图参数
				mapP.map.info.mapwidth=int(setMap.mapW.text);
				mapP.map.info.mapheight=int(setMap.mapH.text);
				mapP.map.info.tileHeight=int(setMap.tileH.text);
				mapP.map.info.tileWidth=mapP.map.info.tileHeight<<1;
				mapP.map.info.mapType=setMap.MapType.selectedLabel;
				//垃圾清理
				if(mapP.map.roadArr)
				{
					mapP.map.roadArr.splice(0,mapP.map.roadArr.length);
					mapP.map.roadArr=null;
				}			
				uiP.ui1.removeChild(mapP.grid);
				mapP.grid.clear();
				mapP.grid=null;
				uiP.ui1.removeChild(mapP.road);
				mapP.road.clear();
				mapP.road=null;
				//重新创建网格和路点并显示
				this.sendNotification(GridAndRoadCommand.GARC_GRID_AND_ROAD,MString.CREATEFILEBAR);
				uiP.ui1.addChild(mapP.grid);
				uiP.ui1.addChild(mapP.road);	
				//如果是创建交错排列类型地图，需要创建背景层
				this.sendNotification(BackgroundAndTilesCommand.BATC_BACKGROUND_AND_TILES,MString.CREATEFILEBAR);				
				//清除平铺地砖层
				mapP.tiles.clear();	
				mapP.map.info.diffuse="null";	
				//设置UI1,UI2属性(位图缓存策略,宽,高)
				uiP.setUIAttribute(uiP.ui1,mapP.grid.width,mapP.grid.height);	
				uiP.setUIAttribute(uiP.ui2,mapP.grid.width,mapP.grid.height);	
				//设置mainUI属性(x,y,width,hegiht)		
				uiP.setMainUI(mapP.grid.width,mapP.grid.height);					
				//重新初始化BindableProxy
				bindableP.init();
				//快捷导航键
				this.sendNotification(QuicklyPanelMediator.QPM_QUICKLYPANEL);							
				//更新编辑状态和标题栏
				this.sendNotification(SaveStateUpdateCommand.SSUC_SAVE_STATE_UPDATE,true);	
				//重新注册路点设置
				this.sendNotification(QuicklyPanelMediator.QPM_REGISTERSETROAD);								
				//移除
				clear();									
			}			
		}			
		/**
		 * 获得验证对象
		 * @param id
		 * @param text
		 * @param is_Null
		 * @param is_MaxZero
		 * @param is_Even
		 * @return 
		 */
		private function getVlidateVO(id:String, text:String,is_Null:Boolean,is_MaxZero:Boolean,is_Even:Boolean):ValidateVO
		{
			var vVO:ValidateVO=new ValidateVO();
			vVO.id=id;
			vVO.text=text;
			vVO.is_Null=is_Null;
			vVO.is_MaxZero=is_MaxZero;
			vVO.is_Even=is_Even;
			return vVO;
		}					
		/**
		 * 地图类型下拉框索引
		 * @param label
		 * @return 
		 */
		private function getMapTypeIndex(label:String):int
		{
			for each(var i:* in setMap.mapTypeArr)
			{
				if(i.label==label)
					return i.data;
			}
			return 0;
		}		
		/**
		 * 错误消息提示
		 * @param msg
		 * @param position
		 * @param x
		 * @param y
		 * @param appUI
		 */
		private function errorAlert(msg:String,position:Boolean=false,x:int=0,y:int=0,appUI:UIComponent=null):void
		{
	  		var msgVO:MessageAlert2VO=new MessageAlert2VO();
	  		msgVO.msg=msg;
	  		if(position)
	  		{
	  			msgVO.x=x;
	  			msgVO.y=y;
	  			msgVO.appUI=appUI;
	  		}
	  		this.sendNotification(Message2Command.MC2_MESSAGE,msgVO);		
	  		appUI=null;
	  		msgVO=null;
		}		
		/**
		 * 垃圾清理
		 */
		private function clear():void
		{
			setMap.confirmBtn.removeEventListener(MouseEvent.CLICK,OnConfirmClick);
			this.sendNotification(PageClearCommand.PC_PAGECLEAR, setMap, "1");
			PopUpManager.removePopUp(setMap);			
		}			
		/**
		 * 
		 * @return 
		 */
		private function get setMap():SetMap
		{
			return this.viewComponent as SetMap;
		}							
	}
}