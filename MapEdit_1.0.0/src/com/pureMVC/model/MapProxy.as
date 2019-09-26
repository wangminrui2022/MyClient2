/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.model
{
	import com.consts.MString;
	import com.map.Background;
	import com.map.Objects;
	import com.mapfile.core.MOpenMap;
	import com.mapfile.core.MSaveMap;
	import com.mapfile.vo.MapVO;
	import com.maptype.core.Grids;
	import com.maptype.core.Roads;
	import com.maptype.core.Tiles;
	import com.maptype.core.isometric.IsoPoint3D;
	import com.maptype.core.isometric.IsoUtils;
	import com.maptype.core.staggered.StaUtils;
	import com.maptype.vo.PointVO;
	import com.maptype.vo.RoadVO;
	import com.vo.map.InfoPanelVO;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 地图模型层
	 * @author wangmingfan
	 */
	public class MapProxy extends Proxy
	{
		public static const NAME:String="MapProxy";
		//白色背景层(1)
		public var background:Background;
		//平铺地砖显示层(2)
		public var tiles:Tiles;
		//网格(3)
		public var grid:Grids;
		//路点(4)
		public var road:Roads;
		//地图信息		
		public var map:MapVO;
		//保存地图数据
		public var mSave:MSaveMap;
		//打开地图数据
		public var mOpen:MOpenMap;
		//当前路点偏移的3D坐标
		private var currentMove3D:IsoPoint3D;
		
		public function MapProxy(data:Object=null)
		{
			super(NAME, data);
		}
		/**
		 * 显示场景对象类型为Objects的路点和边框
		 */
		public function displayRoadAndBorder(bol:Boolean):void
		{
			for each(var oj:Objects in map.objectsArr)
			{
				if(oj.mTileVO.mdVO.type==MString.OBJECT)
				{
					oj.visibleRoad(bol);
					oj.visibleBorder(bol);
				}
				oj=null;
			}
		}
		/**
		 * 获得地图字符串信息
		 * @return 
		 */
		public function getInfo():InfoPanelVO
		{
			var tileW:int;
			var tileH:int;
			if(map.info.mapType==IsoUtils.ISOMETRIC)
			{
				var rect:Rectangle=IsoUtils.getIsoRect(map.info.row,map.info.column,map.info.tileHeight);
				tileW=rect.width;
				tileH=rect.height;
				rect=null;
			}
			else
			{
				tileW=tiles.width;
				tileH=tiles.height;				
			}
			var info:String=
			"地图名称:"+map.info.name+
			"<br/>地图类型:"+map.info.mapType+
			"<br/>地图宽:"+map.info.mapwidth+
			"<br/>地图高:"+map.info.mapheight+
			"<br/>地图平铺宽:"+tileW+
			"<br/>地图平铺高:"+tileH+
			"<br/>网格宽:"+map.info.tileWidth+
			"<br/>网格高:"+map.info.tileHeight+			
			"<br/>路点行:"+map.info.row+
			"<br/>路点列:"+map.info.column+
			"<br/>地图路径:"+map.mapPath;	
			var ipVO:InfoPanelVO=new InfoPanelVO();
			ipVO.title="地图信息";
			ipVO.info=info;	
			return ipVO						
		}	
		/**
		 *拖动材质在地图路点上的摆放位置坐标 
		 * @param oj
		 * @param mapType
		 * @param tileH
		 * @param maxPT
		 * @param move3D
		 * @return 
		 */
		public function getSitePoint(oj:Objects,mapType:String,tileH:int,maxPT:PointVO,move3D:IsoPoint3D=null):PointVO
		{
			//获得拖动鼠标在材质上位置，靠得最近的障碍点(鼠标障碍点)
			var rVO:RoadVO=getMouseObstacleRoad(oj,tileH);			
			if (mapType == StaUtils.STAGGERED)
			{
				//根据任意坐标获得路点的中心点坐标("staggered")
				maxPT=getStaggeredRoadPoint(maxPT,tileH);
				//位置路点-鼠标障碍点
				maxPT.x=maxPT.x-rVO.point.x;
				maxPT.y=maxPT.y-rVO.point.y;		
			}
			else
			{
				//根据任意坐标获得路点的中心点坐标("isometric")
				maxPT=getIsometricRoadPoint(maxPT,tileH,move3D);
				//位置路点-鼠标障碍点
				maxPT.x=maxPT.x-rVO.point.x;
				maxPT.y=maxPT.y-rVO.point.y;				
				move3D=null;
			}	
			rVO=null;
			oj=null;
			return maxPT;		
		}	
		/**
		 * 获得拖动鼠标在材质上位置，靠得最近的障碍点(鼠标障碍点)
		 * @param oj
		 * @param tileH
		 * @return 
		 */
		public function getMouseObstacleRoad(oj:Objects,tileH:int):RoadVO
		{
			var mx:int=oj.mTileVO.obstacleRect.x+(oj.mTileVO.obstacleRect.width>>1);
			var my:int=oj.mTileVO.obstacleRect.y+(oj.mTileVO.obstacleRect.height>>1);	
			var msIndex:PointVO=StaUtils.getStaggeredIndex(new PointVO(mx,my), tileH <<1, tileH);
			return oj.mTileVO.roadArr[msIndex.y][msIndex.x] as RoadVO;			
		}	
		/**
		 * 根据任意坐标获得路点的中心点坐标("staggered")
		 * @param pt
		 * @param tileH
		 */
		public function getStaggeredRoadPoint(pt:PointVO,tileH:int):PointVO
		{
			var npt:PointVO;
			//计算相对于地图的索引以及坐标
			var staggeredIndex:PointVO=StaUtils.getStaggeredIndex(pt, tileH <<1, tileH);
			npt=StaUtils.getStaggeredPoint(staggeredIndex, tileH <<1, tileH);	
			staggeredIndex=null;
			pt=null
			return npt;		
		}	
		/**
		 * 根据任意坐标获得路点的中心点坐标("isometric")
		 * @param pt
		 * @param tileH
		 * @param move3D
		 * @return 
		 */
		public function getIsometricRoadPoint(pt:PointVO,tileH:int,move3D:IsoPoint3D):PointVO
		{
			var npt:PointVO;
			var isometricIndex:PointVO=IsoUtils.getIsometricIndex(pt,tileH,move3D);
			npt=IsoUtils.getIsometricPoint(isometricIndex.x,isometricIndex.y,tileH,move3D);
			isometricIndex=null;
			pt=null;
			move3D=null;
			return npt;
		}
		/**
		 * 更新所有成员深度 map.info.totalArr
		 * @param obj
		 */
		public function updateDepth():void
		{
			for each (var oj:Objects in map.objectsArr)
			{
				//设置对象在场景的深度属性	
				oj.depth=oj.parent.getChildIndex(oj);	
				oj=null;
			}			
		}
		/**
		 * 移除指定成员
		 * @param obj
		 */
		public function removeobjectsArr(oj:Objects):void
		{
			for (var i:int=0; i < map.objectsArr.length; i++)
			{
				if (map.objectsArr[i].id == oj.id)
				{
					map.objectsArr.splice(i, 1);
					oj=null;
					return;
				}
			}			
		}	
		/**
		 * 交换成员在数组中的位置
		 * @param oj
		 * @param position
		 */
		public function switchPosition(oj:Objects,position:int):void
		{
			for (var i:int=0; i < map.objectsArr.length; i++)
			{
				if (map.objectsArr[i].id == oj.id)
				{
					if (position == 1)
					{
						var add:Object=map.objectsArr[i + 1];
						map.objectsArr[i + 1]=map.objectsArr[i];
						map.objectsArr[i]=add;
					}
					else if (position == -1)
					{
						var reduce:Object=map.objectsArr[i - 1];
						map.objectsArr[i - 1]=map.objectsArr[i];
						map.objectsArr[i]=reduce;
					}
					oj=null;
					return;
				}
			}			
		}	
		/**
		 * 设置当前路点偏移的3D坐标
		 * @param currentMove3D
		 */
		public function setMove3D(currentMove3D:IsoPoint3D):void
		{
			this.currentMove3D=null;
			this.currentMove3D=currentMove3D;
			currentMove3D=null;
		}
		/**
		 * 获得当前路点偏移的3D坐标
		 * @return 
		 */
		public function getMove3D():IsoPoint3D
		{
			return this.currentMove3D;
		}																								
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			if(background)
				background.clear();
			if(tiles)
			{
				tiles.visible=true;
				tiles.clear();
			}
			if(grid)
			{
				grid.visible=true;
				grid.clear();
			}
			if(road)
			{
				road.visible=true;
				road.clear();
			}		
			if(map)
				map.clear();
			if(mSave)	
				mSave.clear();
			if(mOpen)
				mOpen.clear();
			background=null;
			tiles=null;
			grid=null;
			road=null;
			map=null;
			mSave=null;
			mOpen=null;
		}
	}
}