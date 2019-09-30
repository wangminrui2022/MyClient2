/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.map
{
	import com.maptype.core.isometric.IsoUtils;
	import com.maptype.core.staggered.StaUtils;
	import com.maptype.vo.PointVO;
	import com.maptype.vo.RoadVO;
	
	import com.consts.MString;
	import com.pureMVC.controller.business.bindable.SaveStateUpdateCommand;
	import com.pureMVC.controller.business.bindable.SetMapUpdateCommand;
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.UIProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.map.ObjectsToUI2VO;

	/**
	 * 显示对象到UI2的操作(添加,删除,重置,更新)
	 * @author 王明凡
	 */
	public class ObjectsToUI2Commmand extends SimpleCommand
	{
		public static const OTUC_OBJECTSTOUI2:String="otuc_ObjectsToUI2";
			
		private var mapP:MapProxy;
		
		private var uiP:UIProxy;
		
		private var mrVO:RoadVO;
		
		private var tileH:int;
				
		public function ObjectsToUI2Commmand()
		{	
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			tileH=mapP.map.info.tileHeight;		
		}
		override public function execute(note:INotification):void
		{
			var otVO:ObjectsToUI2VO=note.getBody() as ObjectsToUI2VO;
			try
			{
				if(otVO.operateType==ObjectsToUI2VO.ADD)
					onAdd(otVO);
				else if(otVO.operateType==ObjectsToUI2VO.UPDATE)
					onUpdate(otVO);
				else
					onDeleteAndReset(otVO);				
			}catch(er:Error)
			{
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
			//更新深度
			mapP.updateDepth();		
			//删除引用
			otVO=null;
			mapP=null;
			uiP=null;	
			mrVO=null;							
			//更新编辑状态和标题栏
			this.sendNotification(SaveStateUpdateCommand.SSUC_SAVE_STATE_UPDATE,true);
			//设置地图绑定更新
			this.sendNotification(SetMapUpdateCommand.SMUC_SET_MAP_UPDATE);
		}
		/**
		 * 添加
		 * @param otVO
		 */
		private function onAdd(otVO:ObjectsToUI2VO):void
		{
			otVO.oj.x=otVO.sitePoint.x;
			otVO.oj.y=otVO.sitePoint.y;	
			//添加到对象集合
			mapP.map.objectsArr.push(otVO.oj);	
			//更新地图路点数组中路点类型	
			if(otVO.oj.mTileVO.mdVO.type == MString.OBJECT)
			{
				//获得拖动鼠标在材质上位置，靠得最近的障碍点(鼠标障碍点)
				mrVO=mapP.getMouseObstacleRoad(otVO.oj,tileH);		
				if(!updateMapRoadArr(otVO.oj.mTileVO.roadArr,otVO.roadPoint))	
				{
					uiP.ui2.removeChild(otVO.oj);
					mapP.removeobjectsArr(otVO.oj);		
					otVO.oj.clear();								
				}
				otVO.oj.visibleRoad(false);	
				otVO.oj.visibleBorder(false);				
			}
			otVO=null;											
		}
		/**
		 * 更新
		 * @param otVO
		 */
		private function onUpdate(otVO:ObjectsToUI2VO):void
		{		
			//获得拖动鼠标在材质上位置，靠得最近的障碍点(鼠标障碍点)
			mrVO=mapP.getMouseObstacleRoad(otVO.oj,tileH);				
			//获得原始鼠标点击路点的中心点坐标
			var rx:int=otVO.oj.x+mrVO.point.x;
			var ry:int=otVO.oj.y+mrVO.point.y;	
			updateMapRoadArr(otVO.oj.mTileVO.roadArr,new PointVO(rx,ry),-1);
			//重新绘制对象显示路点
			otVO.oj.road.graphics.clear();
			otVO.oj.displayRoad(tileH);
			otVO=null;
		}
		/**
		 * 删除,重置
		 * @param otVO
		 */
		private function onDeleteAndReset(otVO:ObjectsToUI2VO):void
		{
			if(otVO.oj.mTileVO.mdVO.type==MString.OBJECT)
			{
				//获得拖动鼠标在材质上位置，靠得最近的障碍点(鼠标障碍点)
				mrVO=mapP.getMouseObstacleRoad(otVO.oj,tileH);				
				//获得原始鼠标点击路点的中心点坐标
				var rx:int=otVO.oj.x+mrVO.point.x;
				var ry:int=otVO.oj.y+mrVO.point.y;
				updateMapRoadArr(otVO.oj.mTileVO.roadArr,new PointVO(rx,ry),0);
			}
			//移除场景中显示的材质
			uiP.ui2.removeChild(otVO.oj);
			//场景集合中移除指定成员
			mapP.removeobjectsArr(otVO.oj);	
			if(otVO.operateType==ObjectsToUI2VO.DELETE)
			{
				otVO.oj.clear();
			}
			else
			{
				//将材质对象位置初始化为0
				otVO.oj.x=0;
				otVO.oj.y=0;				
			}	
			otVO=null;		
		}
		/**
		 * 更新地图路点数组中路点类型
		 * 遗留问题:如果是设置了障碍点和阴影点，将障碍点放到场景外，但是阴影点这时是在场景内被更新了，最后还是返回false
		 * @param materialRoadArr
		 * @param roadPoint
		 * @param uType
		 * @return 	路点更新结果
		 */
		private function updateMapRoadArr(materialRoadArr:Array,roadPoint:PointVO,uType:int=-1):Boolean
		{
			var result:Boolean=false;
			for (var y:int=0; y < materialRoadArr.length; y++)
			{
				for (var x:int=0; x < materialRoadArr[0].length; x++)	
				{
					var rVO:RoadVO=materialRoadArr[y][x] as RoadVO;
					var miPt:PointVO=validateRoad(roadPoint,rVO);
					if(!miPt)
						continue;
					updateRoadArr(miPt,rVO,uType);
					miPt=null;
					rVO=null;	
					result=true;				
				}
			}
			materialRoadArr=null;	
			roadPoint=null;	
			return result;
		}
		/**
		 * 验证路点
		 * @param roadPoint
		 * @param rVO
		 * @return 
		 */
		private function validateRoad(roadPoint:PointVO,rVO:RoadVO):PointVO
		{
			var miPt:PointVO;
			//计算当前路点在地图路点中的位置坐标
  			var tx:Number=(roadPoint.x + rVO.point.x) - mrVO.point.x;
			var ty:Number=(roadPoint.y + rVO.point.y) - mrVO.point.y;	
			//如果不是地图外的路点(地图左边)
			if(tx>0 && ty>0)
			{
				//计算当前路点在地图路点中的数组索引
				miPt=getMapRoadIndex(tx,ty);
				//如果是地图外的路点(地图右边)
				if(miPt.x>mapP.map.roadArr[0].length-1 || miPt.y>mapP.map.roadArr.length-1)		
					miPt=null;		
			}			
			roadPoint=null;					
			rVO=null;
			return miPt;
		}
		/**
		 * 更新材质路点在地图路点集合中的位置
		 * @param miPt
		 * @param rVO
		 * @param uType
		 */
		private function updateRoadArr(miPt:PointVO,rVO:RoadVO,uType:int=-1):void
		{
			if ((rVO.type == 1 || rVO.type == 2))
			{
				//更新路点数组(障碍/阴影,通过)
				if (uType == -1)
					mapP.map.roadArr[miPt.y][miPt.x].type=rVO.type;
				else
					mapP.map.roadArr[miPt.y][miPt.x].type=uType;
			}
			else
			{
				mapP.map.roadArr[miPt.y][miPt.x].type=0;
			}	
			miPt=null;
			rVO=null;		
		}
		/**
		 * 根据不同类型地图获得路点索引
		 * @param tx
		 * @param ty
		 * @return 
		 */
		private function getMapRoadIndex(tx:Number,ty:Number):PointVO
		{
			if(mapP.map.info.mapType==StaUtils.STAGGERED)	
				return StaUtils.getStaggeredIndex(new PointVO(tx,ty),tileH * 2,tileH);
			else		
				return IsoUtils.getIsometricIndex(new PointVO(tx,ty),tileH,mapP.getMove3D());								    					
		}											
	}
}