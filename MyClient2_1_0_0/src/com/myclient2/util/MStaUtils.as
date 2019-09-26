/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.util
{
	import flash.geom.Point;
	
	/**
	 * MIsoUtils是"交错排列"地图的工具类,它用来负责"交错排列"地图坐标换算工作
	 * @author 王明凡
	 */
	public class MStaUtils
	{
		/**
		 * "交错排列"地图类型
		 * @default 
		 */
		public static const STAGGERED:String="staggered";					

		/**
		 * 交错排列"索引" → 交错排列"坐标"(路点中心点坐标)
		 * @param pt
		 * @param tileW
		 * @param tileH
		 * @return
		 */
		public static function getStaggeredPoint(pt:Point, tileW:int, tileH:int):Point
		{
			var tileCenter:Number=(pt.x * tileW) + (tileW >>1);
			var xPixel:Number=tileCenter + ((pt.y & 1) * tileW >>1);
			var yPixel:Number=(pt.y + 1) * tileH >>1;
			pt=null;
			return new Point(xPixel, yPixel);
		}
		/**
		 * 交错排列"坐标"(任意坐标) → 交错排列"索引"
		 * @param pt
		 * @param tileW
		 * @param tileH
		 * @return
		 * 
		 */
		public static function getStaggeredIndex(pt:Point, tileW:int, tileH:int):Point
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
			return new Point(xtile - (ytile & 1), ytile);
		}	
		/**
		 * "交错排列"索引 → "直角"坐标
		 * @param ix
		 * @param iy
		 * @param row
		 * @return
		 */
		public static function getDirectPoint(ix:int, iy:int, row:int):Point
		{
			var dpt:Point=new Point();
			if (iy & 1)
				dpt.x=Math.floor((ix - (iy>>1)) + 1 + ((row - 1) >>1));
			else
				dpt.x=(ix - (iy >>1)) + Math.ceil((row - 1) / 2);
			dpt.y=Math.floor((iy >>1) + ix + (iy & 1));
			return dpt;
		}					
	}
}