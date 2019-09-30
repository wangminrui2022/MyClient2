/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.ui
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.pureMVC.controller.business.map.BackgroundAndTilesCommand;
	import com.pureMVC.controller.business.map.GridAndRoadCommand;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.mediator.WaitAnimationMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 创建地图显示UI1
	 * @author 王明凡
	 */
	public class CreateMapUI1Command extends SimpleCommand
	{
		//创建UI1(通知)
		public static const CMUI1C_CREATE_MAP_UI1:String="cmui1c_create_map_ui1";
		
		private var mapP:MapProxy;
		
		private var uiP:UIProxy; 
		
		private var operateType:String;
				
		public function CreateMapUI1Command()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		override public function execute(note:INotification):void
		{
			//开始等待
			this.sendNotification(WaitAnimationMediator.WAM_WAITANIMATION);			
			//操作类型(新建,打开)
			operateType=note.getBody().toString();
			//开始创建
			getTimer(onTimerComplete_1);
		}
		/**
		 * timer1完成
		 * @param e
		 */
		private function onTimerComplete_1(e:TimerEvent):void
		{
			e.currentTarget.removeEventListener(TimerEvent.TIMER,onTimerComplete_1);
			//创建:网格和路点
			this.sendNotification(GridAndRoadCommand.GARC_GRID_AND_ROAD,operateType);				
			getTimer(onTimerComplete_2,1500);
		}	
		/**
		 * timer2完成
		 * @param e
		 */
		private function onTimerComplete_2(e:TimerEvent):void
		{
			e.currentTarget.removeEventListener(TimerEvent.TIMER,onTimerComplete_2);
			//创建:背景和平铺地砖
			this.sendNotification(BackgroundAndTilesCommand.BATC_BACKGROUND_AND_TILES,operateType);			
			//显示UI1成员
			uiP.ui1.addChild(mapP.tiles);
			uiP.ui1.addChild(mapP.grid);
			uiP.ui1.addChild(mapP.road);				
			//设置UI1属性(位图缓存策略,宽,高)
			uiP.setUIAttribute(uiP.ui1,mapP.grid.width,mapP.grid.height);		
			//设置mainUI属性(x,y,width,hegiht)		
			uiP.setMainUI(mapP.grid.width,mapP.grid.height);	
			//删除引用
			mapP=null;
			uiP=null;
			//完成等待
			this.sendNotification(WaitAnimationMediator.WAM_WAITANIMATION_COMPLETE);				
			//创建UI2
			this.sendNotification(CreateMapUI2Command.CMUI2C_CREATE_MAP_UI2,operateType);		
		}					
		/**
		 * 获得一个Timer
		 * @param fun
		 */
		private function getTimer(fun:Function,delay:int=200):void
		{
			var tm:Timer=new Timer(delay, 1);
			tm.addEventListener(TimerEvent.TIMER_COMPLETE, fun);
			tm.start();	
			tm=null;			
		}											
	}
}