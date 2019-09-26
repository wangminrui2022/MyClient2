package com.pureMVC.view.mediator
{
	import com.consts.MString;
	import com.maptype.core.isometric.IsoPoint3D;
	import com.maptype.core.isometric.IsoUtils;
	import com.maptype.core.staggered.StaUtils;
	import com.maptype.vo.PointVO;
	import com.maptype.vo.RoadVO;
	import com.pureMVC.controller.business.bindable.SaveStateUpdateCommand;
	import com.pureMVC.controller.business.bindable.SwitchUpdateCommand;
	import com.pureMVC.controller.business.map.MapDragCommand;
	import com.pureMVC.controller.business.ui.SwitchDepthCommand;
	import com.pureMVC.model.*;
	import com.pureMVC.view.ui.SetRoad;
	import com.vo.map.SetRoadVO;
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 设置路点
	 * @author wangmingfan
	 */
	public class SetRoadMediator extends Mediator
	{
		public static const NAME:String="SetRoadMediator";
		//设置路点(通知)
		public static const SRM_SETROAD:String="srm_setroad";
		//取消路点设置(通知)
		public static const SRM_SETROAD_CANCEL:String="srm_setroad_cancel";
		//当前垃圾清理(通知)
		public static const SRM_CLEAR:String="srm_clear";
		//
		private var mapP:MapProxy;
		//状态模型层
		private var bindableP:BindableProxy;
		//资源模型
		private var assetP:AssetProxy;		
		//设置路点VO
		private var srVO:SetRoadVO;
		//路点类型
		private var type:int;
					
		public function SetRoadMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			assetP=this.facade.retrieveProxy(AssetProxy.NAME) as AssetProxy;
			//路点设置
			setRoad.obstacleBtn.addEventListener(MouseEvent.CLICK, onRoadClick);
			setRoad.shadowBtn.addEventListener(MouseEvent.CLICK, onRoadClick);
			setRoad.passBtn.addEventListener(MouseEvent.CLICK, onRoadClick);
		}
		override public function listNotificationInterests():Array
		{
			return [
			SRM_SETROAD,
			SRM_SETROAD_CANCEL,
			SRM_CLEAR];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case SRM_SETROAD:
					onSetRoad(note.getBody() as SetRoadVO);
					break;
				case SRM_SETROAD_CANCEL:
					onSetRoadCancel();
					break;
				case SRM_CLEAR:
					onSetRoadCancel();
					clear();
					break;
			}
		}
		/**
		 * 传递路点设置必须的参数
		 * @param srVO
		 */
		private function onSetRoad(srVO:SetRoadVO):void
		{
			this.srVO=srVO;	
			srVO=null;
		}
		/**
		 * 单击路点按钮
		 * @param e
		 */
		private function onRoadClick(e:MouseEvent):void
		{		
			//当前按钮按下被弹起时候
			if (!e.currentTarget.selected)
			{
				onSetRoadCancel();
				return;
			}
			//当前正在设置路点
			if (bindableP.SP_IsSetRoad)
			{
				onSetRoadCancel();
				e.currentTarget.selected=true;
			}
			switch (e.currentTarget.id)
			{
				case "obstacleBtn":
					type=1;
					setCursor(assetP.obstacle);
					setRoad.shadowBtn.selected=false;
					setRoad.passBtn.selected=false;
					break;
				case "shadowBtn":
					type=2;
					setCursor(assetP.shadow);
					setRoad.obstacleBtn.selected=false;
					setRoad.passBtn.selected=false;
					break;
				case "passBtn":
					type=0;
					setCursor(assetP.pass);
					setRoad.obstacleBtn.selected=false;
					setRoad.shadowBtn.selected=false;
					break;
			}
			bindableP.SP_IsSetRoad=true;
			
			//取消拖动材质
			this.sendNotification(UseMaterialMediator.UMM_CANCEL);				
			/**
			 * 如果是场景设置路点
			 * 1.清除场景拖动
			 * 2.交换UI1和UI2的深度
			 * 3.停止深度交换按钮以及快捷键
			 * */
			if(srVO.setRoadType==1)
			{
				this.sendNotification(QuicklyPanelMediator.QPM_SELECT_ROADS,true);
				this.sendNotification(MapDragCommand.MDC_SCENE_DRAG,MapDragCommand.MDC_CLEAR);	
				this.sendNotification(SwitchDepthCommand.SDC_SWITCH_DEPTH,"UI1=1,UI2=0");
				this.sendNotification(SwitchUpdateCommand.SUC_SWITCH_UPDATE,false);
			}				
			srVO.UI.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			srVO.UI.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);	
			srVO.UI.addEventListener(MouseEvent.RIGHT_CLICK, onMouseRightClick);	
		}
		/**
		 * 鼠标按下
		 * @param e
		 */
		private function onMouseDown(e:MouseEvent):void
		{
			//如果是场景设置路点,才更新编辑状态和标题栏
			if(srVO.setRoadType==1)
				this.sendNotification(SaveStateUpdateCommand.SSUC_SAVE_STATE_UPDATE,true);	
			srVO.UI.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			srVO.UI.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}	
		/**
		 * 鼠标离开UI时候
		 * @param e
		 */
		private function onRollOut(e:MouseEvent):void
		{
			onMouseUp();
		}
		/**
		 * 鼠标拖动
		 * @param e
		 */
		private function onMouseMove(e:MouseEvent):void
		{
			//如果是场景设置路点，两种类型
			if(srVO.setRoadType==1)
				if(mapP.map.info.mapType==StaUtils.STAGGERED)
					setStaggered(srVO.UI.mouseX, srVO.UI.mouseY);
				else
					setIsometric(srVO.UI.mouseX, srVO.UI.mouseY);
			else
				setStaggered(srVO.UI.mouseX, srVO.UI.mouseY);
		}
		/**
		 * 设置"等角"地图路点
		 * @param x
		 * @param y
		 */
		private function setIsometric(x:int,y:int):void
		{
			//获得路点本身被移动的3D坐标
			var move3D:IsoPoint3D=mapP.getMove3D();
			var ipt:PointVO=IsoUtils.getIsometricIndex(new PointVO(x,y),srVO.tileH,move3D);
			onChangRoadType(ipt);	
			move3D=null;	
			ipt=null;		
		}		
		/**
		 * 设置"交错排列"地图路点
		 * @param x
		 * @param y
		 */
		private function setStaggered(x:int,y:int):void
		{
			var ipt:PointVO=StaUtils.getStaggeredIndex(new PointVO(x,y), srVO.tileW, srVO.tileH);
			onChangRoadType(ipt);
			ipt=null;
		}
		/**
		 * 改变路点类型
		 * @param index
		 */
		private function onChangRoadType(index:PointVO):void
		{
			var rVO:RoadVO;
			try
			{
				rVO=srVO.roadArr[index.y][index.x];
			}catch(er:Error)
			{
				index=null;
				return;
			}	
			index=null;
			if(!rVO)
				return;
			if(rVO.type==type)
			{
				rVO=null;
				return;
			}
			rVO.type=type;
			rVO.shape.graphics.clear();
			if(type==0)
			{
				rVO.shape.graphics.beginFill(MString.PASS, 0.7);
				rVO.shape.graphics.drawCircle(rVO.point.x,rVO.point.y,srVO.tileH >>2);
			}
			else
			{
				rVO.shape.graphics.beginFill(type == 1 ? MString.OBSTACLE : MString.SHADOW, 0.7);
				rVO.shape.graphics.drawCircle(rVO.point.x,rVO.point.y,srVO.tileH >>2);				
			}
			rVO.shape.graphics.endFill();
			rVO=null;					
		}		
		/**
		 * 鼠标弹起
		 * */
		private function onMouseUp(e:MouseEvent=null):void
		{
			srVO.UI.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
			srVO.UI.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		/**
		 * 鼠标右击,取消设置
		 * @param e
		 */
		private function onMouseRightClick(e:MouseEvent):void
		{
			onSetRoadCancel();
		}							
		/**
		 * 取消路点设置
		 * @param e
		 */
		private function onSetRoadCancel():void
		{
			if (!bindableP.SP_IsSetRoad)
				return;				
			setRoad.cursorManager.removeAllCursors();
			onMouseUp();
			srVO.UI.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			srVO.UI.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			srVO.UI.removeEventListener(MouseEvent.RIGHT_CLICK, onMouseRightClick);	
			bindableP.SP_IsSetRoad=false;
			setRoad.obstacleBtn.selected=false;
			setRoad.shadowBtn.selected=false;
			setRoad.passBtn.selected=false;
			/**
			 * 如果是场景设置路点
			 * 1.则启动场景拖动
			 * 2.启动深度交换按钮以及快捷键
			 * 3.交换UI1和UI2的深度
			 * */			
			if(srVO.setRoadType==1)
			{
				this.sendNotification(QuicklyPanelMediator.QPM_SELECT_ROADS,false);
				this.sendNotification(MapDragCommand.MDC_SCENE_DRAG,MapDragCommand.MDC_START);
				this.sendNotification(SwitchUpdateCommand.SUC_SWITCH_UPDATE,true);
				this.sendNotification(SwitchDepthCommand.SDC_SWITCH_DEPTH);
			}
		}			
		/**
		 * 设置光标样式
		 * @param c
		 */
		private function setCursor(cls:Class):void
		{
			setRoad.cursorManager.removeAllCursors();
			setRoad.cursorManager.setCursor(cls);
		}	
		/**
		 * 垃圾清理
		 * @return 
		 */
		private function clear():void
		{
			setRoad.obstacleBtn.removeEventListener(MouseEvent.CLICK, onRoadClick);
			setRoad.shadowBtn.removeEventListener(MouseEvent.CLICK, onRoadClick);
			setRoad.passBtn.removeEventListener(MouseEvent.CLICK, onRoadClick);			
			type=0;
			this.facade.removeMediator(NAME);
		}							
		/**
		 * 
		 * @return 
		 */
		private function get setRoad():SetRoad
		{
			return this.viewComponent as SetRoad;
		}
		
	}
}