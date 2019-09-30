/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.map
{
	import com.mapfile.vo.MObjectsVO;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.consts.Msg;
	import com.map.Objects;
	import com.pureMVC.controller.business.common.Message2Command;
	import com.pureMVC.controller.business.ui.CreateMapUI2Command;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.MaterialProxy;
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.mediator.ProgressReportMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.common.MessageAlert2VO;
	import com.vo.common.ProgressReportVO;
	import com.vo.material.MaterialTileVO;

	/**
	 * 添加Objects显示集合到UI2显示列表
	 * @author 王明凡
	 */
	public class AddObjectsArrayCommand extends SimpleCommand
	{
		public static const AOAC_ADD_OBJECTS_ARRAY:String="aoac_add_objects_array";
		//UI模型层
		private var uiP:UIProxy; 
		//地图模型层
		private var mapP:MapProxy;
		//材质模型层
		private var materialP:MaterialProxy;		
		//加载个数
		public var load:int;
		//总加载个数
		public var total:int;		
		
		private var operateType:String;
				
		public function AddObjectsArrayCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}
		override public function execute(note:INotification):void
		{
			//操作类型(新建,打开)
			operateType=note.getBody().toString();			
			//当前最大对象的索引
			mapP.map.objectIndex=getMaxIndex(mapP.map.info.mObjectsVOArr);	
			//总加载数
			total=mapP.map.info.mObjectsVOArr.length;
			//进度条
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS);	
			//开始加载
			onLoaderObjectsVOArr();			
		}
		/**
		 * 开始加载 ObjectsVO,间隔24fps/s=1000/40		 
		 */
		private function onLoaderObjectsVOArr():void
		{
			var tm:Timer=new Timer(40,total);
			tm.addEventListener(TimerEvent.TIMER,onTimer);
			tm.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
			tm.start();			
		}	
		/**
		 * Timer 过程
		 * @param e
		 */
		private function onTimer(e:TimerEvent):void
		{
			try
			{			
				var ojVO:MObjectsVO=mapP.map.info.mObjectsVOArr[load] as MObjectsVO;
				var mTileVO:MaterialTileVO=materialP.getMaterialTileVO(ojVO.materialDefinition.name);
				if(mTileVO)
				{		
					var oj:Objects=new Objects(mTileVO,ojVO.index);
					oj.extendsDraws(mapP.map.info.tileHeight);
					oj.x=ojVO.x;
					oj.y=ojVO.y;
					oj.depth=ojVO.depth;
					uiP.ui2.addChild(oj);
					mapP.map.objectsArr.push(oj);	
					//删除引用	
					oj=null;
				}
				ojVO=null;
				mTileVO=null;
				load++;	
		  		//加载中
		  		onProgressLoad(load,total);	
			}
			catch (er:Error)
			{
				this.sendNotification(ProgressReportMediator.PRM_PROGRESS_COMPLETE);
				this.sendNotification(CloseMapCommand.CMC_CLOSE_MAP);
				clearTimer(e.currentTarget as Timer);
				errorAlert(Msg.Msg_17);
				clear();
			}			
		}	
		/**
		 * Timer 完成
		 * @param e
		 */
		private function onTimerComplete(e:TimerEvent):void
		{
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS_COMPLETE);
			var tm:Timer=e.currentTarget as Timer;
			clearTimer(tm);
			tm=null;
			//移除ObjectsVOArr
			mapP.map.info.mObjectsVOArr.splice(0,mapP.map.info.mObjectsVOArr.length);
			mapP.map.info.mObjectsVOArr=null;
			//垃圾清理
			clear();
			//创建完成
			this.sendNotification(CreateMapUI2Command.CREATE_MAP_UI_COMPLETE,operateType);					
		}		
		/**
		 * 加载进度
		 * @param msg
		 */
		private function onProgressLoad(load:Number,total:Number):void
		{
			var pgVO:ProgressReportVO=new ProgressReportVO();
			pgVO.descreption=Msg.Msg_12;
			pgVO.load=load;
			pgVO.total=total;
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS_LOAD, pgVO);			
		}		
		/**
		 * 清理Timer
		 * @param tm
		 */
		public function clearTimer(tm:Timer):void
		{
			tm.stop();
			tm.removeEventListener(TimerEvent.TIMER,onTimer);
			tm.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);	
			tm=null;		
		}				
		/**
		 * 获得objectIndex的最大ID
		 */
		public function getMaxIndex(objectsVOArr:Array):int
		{
			var arr:Array=new Array();
			for each(var ojVO:MObjectsVO in objectsVOArr)
			{
				arr.push(ojVO.index);
			}
			arr.sort(Array.NUMERIC);
			var max:int=arr[arr.length-1];
			arr.splice(0,arr.length);
			arr=null;
			objectsVOArr=null;
			return max;			
		}
		/**
		 * 错误消息提示
		 * @param msg
		 */
		private function errorAlert(msg:String):void
		{
			var msgVO:MessageAlert2VO=new MessageAlert2VO();
			msgVO.msg=msg;
			this.sendNotification(Message2Command.MC2_MESSAGE, msgVO);
		}		
		/**
		 * 垃圾清理,删除引用
		 */
		private function clear():void
		{
			uiP=null;
			mapP=null;
			materialP=null;	
		}					
	}
}