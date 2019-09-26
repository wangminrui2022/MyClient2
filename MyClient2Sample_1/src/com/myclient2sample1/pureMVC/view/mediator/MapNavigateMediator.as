package com.myclient2sample1.pureMVC.view.mediator
{
	import com.myclient2sample1.consts.MString;
	import com.myclient2sample1.pureMVC.model.EngineProxy;
	import com.myclient2sample1.pureMVC.model.RoleProxy;
	import com.myclient2sample1.pureMVC.model.UIProxy;
	import com.myclient2sample1.pureMVC.view.ui.MapNavigate;
	
	import flash.events.Event;
	import flash.system.System;
	
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MapNavigateMediator extends Mediator
	{
		public static const NAME:String="MapNavigateMediator";
		
		public static const MNM_SET_MAP_NAVIGATE:String="mnm_set_map_navigate";
		
		public static const MNM_MOVE_MAP_NAVIGATE:String="mnm_move_map_navigate";
		
		private var uiP:UIProxy;
		private var roleP:RoleProxy;
		private var engineP:EngineProxy;
		private var mapURL:String;
		
		public function MapNavigateMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
		}
		override public function listNotificationInterests():Array
		{
			return [
			MNM_SET_MAP_NAVIGATE,
			MNM_MOVE_MAP_NAVIGATE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case MNM_SET_MAP_NAVIGATE:
					onSetMapNavigate(note.getBody().toString());
					break;
				case MNM_MOVE_MAP_NAVIGATE:
					onMoveMapNavigate();
					break;
			}
		}
		/**
		 * 设置地图导航
		 * @param mapURL
		 */
		private function onSetMapNavigate(mapURL:String):void
		{		
			this.sendNotification(WaitAnimationMediator.WAM_WAITANIMATION);
			this.mapURL=mapURL;		
			if(!viewComponent)
			{
				viewComponent=MapNavigate(PopUpManager.createPopUp(uiP.componetContainer,MapNavigate));
				mapNavigate.navigate.addEventListener(Event.COMPLETE,onComplete);
				mapNavigate.addEventListener(FlexEvent.CREATION_COMPLETE,onCreateComplete);
			}
			else
			{
				mapNavigate.navigate.clear();
				setMapNavigateInfo();
				mapNavigate.navigate.addEventListener(Event.COMPLETE,onComplete);
				mapNavigate.navigate.setImage(mapURL.replace(MString.MCMAPS,"")+".jpg");
			}
		}
		/**
		 * 
		 * @param e
		 */
		private function onCreateComplete(e:FlexEvent):void
		{
			mapNavigate.removeEventListener(FlexEvent.CREATION_COMPLETE,onCreateComplete);
			setMapNavigateInfo();
			mapNavigate.title=getInfo();
			mapNavigate.navigate.setImage(mapURL.replace(MString.MCMAPS,"")+".jpg");		
		}
		/**
		 * 图片加载完成
		 * @param e
		 */
		private function onComplete(e:Event):void
		{
			mapNavigate.navigate.removeEventListener(Event.COMPLETE,onComplete);
			this.sendNotification(WaitAnimationMediator.WAM_WAITANIMATION_COMPLETE);
		}
		/**
		 * 设置地图导航信息
		 */
		private function setMapNavigateInfo():void
		{
			mapNavigate.navigate.maxW=engineP.map.info.mapwidth;
			mapNavigate.navigate.maxH=engineP.map.info.mapheight;
			mapNavigate.navigate.mX=roleP.role.x;
			mapNavigate.navigate.mY=roleP.role.y;			
		}
		/**
		 * 移动地图导航
		 */
		private function onMoveMapNavigate():void
		{	
			mapNavigate.title=getInfo();	
			mapNavigate.navigate.setFrame(roleP.role.x,roleP.role.y);				
		}
		/**
		 * 
		 * @return 
		 */
		private function getInfo():String
		{
			var memory:Number=Math.floor(System.totalMemory/1024)/1024;
			return "导航器(拖) 地图显示对象="+engineP.map.numChildren+"(个) 内存使用="+memory.toFixed(2)+"(m)";
		}
		/**
		 * 
		 * @return 
		 */
		private function get mapNavigate():MapNavigate
		{
			return viewComponent as MapNavigate;
		}
	}
}