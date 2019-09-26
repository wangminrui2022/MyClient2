/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.business.material
{
	import com.mapfile.vo.MMaterialDefinitionVO;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.consts.MString;
	import com.map.Objects;
	import com.pureMVC.controller.business.bindable.SaveStateUpdateCommand;
	import com.pureMVC.controller.business.map.ObjectsToUI2Commmand;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.mediator.WaitAnimationMediator;
	import com.pureMVC.view.ui.as_.OnlyImage;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.map.ObjectsToUI2VO;
	import com.vo.material.MaterialTileVO;
	import com.vo.material.URMapMaterialVO;

	/**
	 * 更新材质在地图上的路点,"编辑材质"保存后要更新地图中所有用到的该材质对象
	 * 移除在地图上的材质,"删除材质"的也需要删除地图中使用的该材质
	 * @author Administrator
	 */
	public class URMapMaterialCommand extends SimpleCommand
	{
		public static const URMMC_MAP_MATERIAL:String="urmmc_map_material";
		
		public static const URMMC_MAP_MATERIAL_COMPLETE:String="urmmc_map_material_complete";

		private var urmmVO:URMapMaterialVO;
		 
		private var mTileVO:MaterialTileVO;
				
		private var onlyImage:OnlyImage;
		
		private var mapP:MapProxy;
		
		private var uiP:UIProxy;
		
		private var childArr:Array; 
		
		private var count:int;	
			
		public function URMapMaterialCommand()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;			
		}
		override public function execute(note:INotification):void
		{
			urmmVO=note.getBody() as URMapMaterialVO;
			if(urmmVO.operateType==URMapMaterialVO.DELETE)
			{
				onlyImage=urmmVO.oj as OnlyImage;
				onOperateType(onlyImage.mTileVO.mdVO);
			}
			else
			{
				mTileVO=urmmVO.oj as MaterialTileVO;
				onOperateType(mTileVO.mdVO);
			}
		}
		/**
		 * 更新、删除操作
		 * @param mdVO
		 */
		private function onOperateType(mdVO:MMaterialDefinitionVO):void
		{
			if(mdVO.used==MString.TILES && mapP.map.info.diffuse==mdVO.diffuse)
			{
				mapP.tiles.clear();
				mapP.map.info.diffuse="null";
				//更新编辑状态和标题栏
				this.sendNotification(SaveStateUpdateCommand.SSUC_SAVE_STATE_UPDATE,true);				
				clearAndComplete();				
			}
			else
			{
				childArr=uiP.getUI2ChildArr(mdVO.name);
				if(childArr.length>0)
				{
					//开始等待
					this.sendNotification(WaitAnimationMediator.WAM_WAITANIMATION);
					var tm:Timer=new Timer(200,childArr.length);
					tm.addEventListener(TimerEvent.TIMER,onTimer);
					tm.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
					tm.start();											
				}
				else
				{
					clearAndComplete();
				}
			}			
		}
		/**
		 * 删除中
		 * @param e
		 */
		private function onTimer(e:TimerEvent):void
		{
			var oj:Objects=childArr[count] as Objects;
			var otVO:ObjectsToUI2VO=new ObjectsToUI2VO();
			otVO.oj=oj;
			if(urmmVO.operateType==URMapMaterialVO.DELETE)
				otVO.operateType=ObjectsToUI2VO.DELETE;
			else
				otVO.operateType=ObjectsToUI2VO.UPDATE;
			this.sendNotification(ObjectsToUI2Commmand.OTUC_OBJECTSTOUI2,otVO);	
			otVO=null;			
			oj=null;	
			count++;			
		}
		/**
		 * 删除完成
		 * @param e
		 */
		private function onTimerComplete(e:TimerEvent):void
		{
			//结束等待
			this.sendNotification(WaitAnimationMediator.WAM_WAITANIMATION_COMPLETE);			
			var tm:Timer=e.currentTarget as Timer;
			tm.removeEventListener(TimerEvent.TIMER,onTimer);
			tm.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);	
			tm=null;
			clearAndComplete();
		}		
		/**
		 * 垃圾清理,并发送完成事件
		 */
		private function clearAndComplete():void
		{
			mTileVO=null;				
			mapP=null;
			uiP=null;
			if(childArr)
				childArr.splice(0,childArr.length);
			childArr=null;	
			if(urmmVO.operateType==URMapMaterialVO.DELETE)
				this.sendNotification(URMMC_MAP_MATERIAL_COMPLETE,onlyImage);
			urmmVO=null;
			onlyImage=null;	
						
		}		
	}
}