/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.map
{
	import com.mapfile.vo.MObjectsVO;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.map.Objects;
	import com.pureMVC.controller.business.bindable.SaveStateUpdateCommand;
	import com.pureMVC.model.MapProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.map.SaveMapVO;

	/**
	 * 保存地图.map文件
	 * @author 王明凡
	 */
	public class SaveMapCommand extends SimpleCommand
	{
		public static const SMC_SAVE_MAP:String="smc_save_map";
		
		private var mapP:MapProxy;
		
		private var smVO:SaveMapVO;
				
		private var count:int;
				
		public function SaveMapCommand()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
		}
		override public function execute(note:INotification):void
		{
			smVO=note.getBody() as SaveMapVO;
			if(smVO.operateType==SaveMapVO.SM_SAVE_MAP)
				onSave();
			else
				onSaveMaterial();
			//更新编辑状态和标题栏
			this.sendNotification(SaveStateUpdateCommand.SSUC_SAVE_STATE_UPDATE,false);							
		}
		/**
		 * 
		 */
		private function onSaveMaterial():void
		{
			var tm:Timer=new Timer(40, smVO.SWFByteArr.length);
			tm.addEventListener(TimerEvent.TIMER, onTimer);
			tm.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			tm.start();				
		}
		/**
		 * 过程
		 * @param e
		 */
		private function onTimer(e:TimerEvent):void
		{
			mapP.mSave.writeSWF(smVO.SWFByteArr[count]);
			count++;
		}
		/**
		 * 完成
		 * @param e
		 */
		private function onTimerComplete(e:TimerEvent):void
		{
			var tm:Timer=e.currentTarget as Timer;
			tm.removeEventListener(TimerEvent.TIMER,onTimer);
			tm.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);	
			tm=null;	
			//保存以及添加地图信息
			if(smVO.operateType==SaveMapVO.SM_SAVE_MAP_MATERIAL)
				onSave();	
			smVO.clear();
			smVO=null;	
		}	
		/**
		 * 保存以及添加地图信息
		 */
		private function onSave():void
		{
			mapP.map.info.floor=getFloor();
			mapP.map.info.mObjectsVOArr=getMObjectsVOArr();
			mapP.mSave.writeInfo(mapP.map.info);
			mapP.mSave.onSave();
			mapP.map.info.mObjectsVOArr.splice(0,mapP.map.info.mObjectsVOArr.length);
			mapP.map.info.mObjectsVOArr=null;
			mapP=null;
		} 
		/**
		 * 返回路点数组的路点字符串
		 * @return 
		 */			
		private function getFloor():String
		{
			var str:String="";
			for (var y:int=0; y <mapP.map.roadArr.length; y++)
			{
				for (var x:int=0; x < mapP.map.roadArr[0].length; x++)
				{
					str+=mapP.map.roadArr[y][x].type + ",";
				}
			}
			str=str.substring(0, str.lastIndexOf(","));
			return str;
		}
		/**
		 * 返回对象(MObjectsVO)集合
		 * @return 
		 */		
		private function getMObjectsVOArr():Array
		{
			var mObjectsVOArr:Array=new Array();
			//封装mObjectsVOArr对象集合
			for(var i:int=0;i<mapP.map.objectsArr.length;i++)
			{
				var oj:Objects=mapP.map.objectsArr[i] as Objects;
				var mojVO:MObjectsVO=new MObjectsVO();
				mojVO.x=oj.x;
				mojVO.y=oj.y;
				mojVO.id=oj.id;
				mojVO.index=oj.index;
				mojVO.depth=oj.depth;
				mojVO.materialDefinition=oj.mTileVO.mdVO;
				mObjectsVOArr.push(mojVO);
				oj=null;
				mojVO=null;				
			}			
			return mObjectsVOArr;
		}
	}
}