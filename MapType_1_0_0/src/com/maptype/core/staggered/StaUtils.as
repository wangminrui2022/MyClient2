/**
 *  MapType - Copyright (c) 2010 王明凡
 */
package com.maptype.core.staggered
{
	import com.maptype.vo.PointVO;
	import com.maptype.vo.RoadVO;
	
	/**
	 * 交错排列工具类
	 * @author 王明凡
	 */
	public class StaUtils
	{
		//通过路点颜色 0
		public static const PASS:int=0xade68f;
		//障碍路点颜色 1
		public static const OBSTACLE:int=0xe34935;
		//阴影路点颜色 2
		public static const SHADOW:int=0xa7a4a3;
		//地图类型
		public static const STAGGERED:String="staggered";					
		/**
		 * 产生二维数组网格
		 * @param row
		 * @param column
		 * @return
		 */
		public static function getRoadArray(row:int, column:int,tileW:int,tileH:int):Array
		{
			var arr:Array=new Array();
			for (var y:int=0; y < row; y++)
			{
				arr.push(new Array());
				for (var x:int=0; x < column; x++)
				{
					var rVO:RoadVO=new RoadVO();
					rVO.index=new PointVO(x, y);
					rVO.point=StaUtils.getStaggeredPoint(new PointVO(x, y), tileW, tileH);
					rVO.type=0;
					rVO.shape=rVO.drawRoad(PASS,tileH,rVO.point);
					arr[y][x]=rVO;
				}
			}
			return arr;
		}
		/**
		 * 交错排列"索引" → 交错排列"坐标"(路点中心点坐标)
		 * @param pt
		 * @param tileW
		 * @param tileH
		 * @return
		 */
		public static function getStaggeredPoint(pt:PointVO, tileW:int, tileH:int):PointVO
		{
			var tileCenter:Number=(pt.x * tileW) + (tileW >>1);
			var xPixel:Number=tileCenter + ((pt.y & 1) * tileW >>1);
			var yPixel:Number=(pt.y + 1) * tileH >>1;
			pt=null;
			return new PointVO(xPixel, yPixel);
		}
		/**
		 * 交错排列"坐标"(任意坐标) → 交错排列"索引"
		 * @param pt
		 * @param tileW
		 * @param tileH
		 * @return
		 * 
		 */
		public static function getStaggeredIndex(pt:PointVO, tileW:int, tileH:int):PointVO
		{
			var cx:int=int(pt.x / tileW) * tileW + (tileW >>1); 
			var cy:int=int(pt.y / tileH) * tileH + (tileH >>1); 
			var rx:int=(pt.x - cx) * tileW >>1;
			var ry:int=(pt.y - cy) * tileH >>1;
			var xtile:int=0;
			var ytile:int=0;
			if (Math.abs(rx) + Math.abs(ry) <= tileW * tileH >>2)
			{
				xtile=int(pt.x / tileW);
				ytile=int(pt.y / tileH) <<1;
			}
			else
			{
				pt.x=pt.x - (tileW >>1);
				xtile=int(pt.x / tileW) + 1;
				pt.y=pt.y - (tileH >>1);
				ytile=(int(pt.y / tileH) <<1) + 1;
			}
			pt=null;
			return new PointVO(xtile - (ytile & 1), ytile);
		}				
	}
}