package com.pureMVC.view.mediator
{
	import com.maptype.core.staggered.StaUtils;
	import com.maptype.vo.PointVO;
	
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	
	import com.consts.MString;
	import com.map.Objects;
	import com.pureMVC.controller.business.common.*;
	import com.pureMVC.controller.business.map.GetDragObjectsCommand;
	import com.pureMVC.controller.business.map.MapDragCommand;
	import com.pureMVC.controller.business.map.ObjectsToUI2Commmand;
	import com.pureMVC.model.*;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.vo.map.ObjectsToUI2VO;
	import com.vo.material.*;

	/**
	 * 使用材质
	 * @author 王明凡
	 */
	public class UseMaterialMediator extends Mediator
	{
		public static const NAME:String="UseMaterialMediator";
		//使用材质(通知)
		public static const UMM_USE:String="umm_use";
		//取消使用材质(通知)
		public static const UMM_CANCEL:String="umm_cancel";
		
		private var materialP:MaterialProxy;
		//地图模型层
		private var mapP:MapProxy;
		//UI模型层
		private var uiP:UIProxy;
		//状态模型层
		private var bindableP:BindableProxy;
		//使用材质类型(tile/object);
		private var useType:String;
		//当前拖动场景对象
		private var oj:Objects;

		public function UseMaterialMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;	
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
		}

		override public function listNotificationInterests():Array
		{
			return [
			UMM_USE,
			GetDragObjectsCommand.GDOC_GET_DRAG_OBJECTS_RESULT,
			UMM_CANCEL];
		}

		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case UMM_USE:
						onUse(note.getBody() as ContextMenuEvent);
					break;
				case GetDragObjectsCommand.GDOC_GET_DRAG_OBJECTS_RESULT:
						if(note.getBody()!=null)
							onObjects(note.getBody() as Objects);
					break;
				case UMM_CANCEL:
						onCancel();
					break;
			}
		}

		/**
		 * 使用材质【选项】
		 * @param e
		 */
		private function onUse(e:ContextMenuEvent):void
		{
			//如果正在拖动材质,则移除
			if (isDrag())
				onCancel();
			this.sendNotification(GetDragObjectsCommand.GDOC_GET_DRAG_OBJECTS,e);
		}	
		/**
		 * 取消【选项】
		 */
		private function onCancel():void
		{
			if (!bindableP.SP_IsDragMaterial)
				return;		
			mapP.displayRoadAndBorder(false);		
			removeObjects();
			clearDrag();	
		}
		/**
		 * 场景拖动对象
		 * @param oj
		 */
		private function onObjects(oj:Objects):void
		{
			//停止路点设置
			this.sendNotification(SetRoadMediator.SRM_SETROAD_CANCEL);			
			//清除地图拖动
			this.sendNotification(MapDragCommand.MDC_SCENE_DRAG,MapDragCommand.MDC_CLEAR);
			this.oj=oj;
			this.oj.visible=false;
			this.useType=this.oj.mTileVO.mdVO.type;	
			bindableP.SP_IsDragMaterial=true;
			uiP.ui2.addChild(this.oj);	
			//监听UI1,因为UI2没有可显示的东西
			uiP.mainUI.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			uiP.mainUI.addEventListener(MouseEvent.CLICK, onMouseClick);				
			oj=null;	
		}
		/**
		 * 鼠标移动
		 * @param e
		 */
		private function onMouseMove(e:MouseEvent):void
		{
			var pt:PointVO=uiP.getDragPoint(oj,useType);
			if(e.ctrlKey && useType==MString.OBJECT)
			{
				//获得oj在UI2中最大的x,y位置
				var maxPT:PointVO=uiP.getMaxPoint(oj.mTileVO.obstacleRect.width,oj.mTileVO.obstacleRect.height);
				if(mapP.map.info.mapType==StaUtils.STAGGERED)
					pt=mapP.getSitePoint(oj, mapP.map.info.mapType, mapP.map.info.tileHeight,maxPT);
				else
					pt=mapP.getSitePoint(oj, mapP.map.info.mapType, mapP.map.info.tileHeight,maxPT,mapP.getMove3D());
				maxPT=null;
				oj.visibleRoad(true);
				oj.visibleBorder(true);
				mapP.displayRoadAndBorder(true);
				
			}
			else
			{
				if(useType==MString.OBJECT)
				{
					oj.visibleRoad(false);
					oj.visibleBorder(false);
					mapP.displayRoadAndBorder(false);
				}
			}
			oj.visible=true;
			oj.x=pt.x;
			oj.y=pt.y;			
			pt=null;
		}
		/**
		 * 鼠标单击
		 * @param e
		 */
		private function onMouseClick(e:MouseEvent):void
		{
			if(e.ctrlKey && useType==MString.OBJECT)
				sendAddObjectToUI2();
			if(useType==MString.TILE)
				sendAddObjectToUI2();
		}
		/**
		 * 发送添加对象到UI2通知
		 */
		private function sendAddObjectToUI2():void
		{
			var tileH:int=mapP.map.info.tileHeight;
			var otVO:ObjectsToUI2VO=new ObjectsToUI2VO();
			otVO.oj=oj;
			otVO.operateType=ObjectsToUI2VO.ADD;
			if(useType==MString.OBJECT)
			{
				var rectW:int=oj.mTileVO.obstacleRect.width;
				var rectH:int=oj.mTileVO.obstacleRect.height;
				//获得oj在UI2中最大的x,y位置
				var maxPT:PointVO=uiP.getMaxPoint(rectW,rectH);				
				if(mapP.map.info.mapType==StaUtils.STAGGERED)				
				{
					otVO.roadPoint=mapP.getStaggeredRoadPoint(uiP.getMaxPoint(rectW,rectH),tileH);	
					otVO.sitePoint=mapP.getSitePoint(oj,mapP.map.info.mapType,tileH,maxPT);
				}
				else
				{
					otVO.roadPoint=mapP.getIsometricRoadPoint(uiP.getMaxPoint(rectW,rectH),tileH,mapP.getMove3D());
					otVO.sitePoint=mapP.getSitePoint(oj,mapP.map.info.mapType,tileH,maxPT,mapP.getMove3D());
				}
				maxPT=null;
			}
			else
			{
				otVO.sitePoint=uiP.getDragPoint(oj,useType);
			}		
			this.sendNotification(ObjectsToUI2Commmand.OTUC_OBJECTSTOUI2,otVO);			
			//如果是"等角"类型地图,放置对象时放到空白区域(左下或右下)那么就oj对象就会被清空,材质名字(连续拖动显示)
			var mName:String=null;
			if(oj.mTileVO)
				mName=oj.mTileVO.mdVO.name;	
			//清除拖拽
			clearDrag();				
			//删除引用
			otVO=null;
			oj=null;					
			//连续拖动显示	
			if(mName)
				this.sendNotification(GetDragObjectsCommand.GDOC_GET_DRAG_OBJECTS,materialP.getMaterialTileVO(mName));					
		}
		/**
		 * 是否正在拖动材质
		 * @return
		 */
		private function isDrag():Boolean
		{
			if (oj)
				return true;
			else
				return false;
		}
		/**
		 * 从场景中移除对象
		 */
		private function removeObjects():void
		{
			uiP.ui2.removeChild(oj);
			oj.clear();
			oj=null;
		}
		/**
		 * 清理拖动
		 */
		private function clearDrag():void
		{
			bindableP.SP_IsDragMaterial=false;
			useType=null;
			uiP.mainUI.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			uiP.mainUI.removeEventListener(MouseEvent.CLICK, onMouseClick);	
			//启动拖动场景
			this.sendNotification(MapDragCommand.MDC_SCENE_DRAG,MapDragCommand.MDC_START);			
		}		
	}
}