/**
 *  MapType - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.maptype.core.isometric
{
	import flash.geom.Rectangle;
	
	import com.maptype.vo.PointVO;
	
	/**
	 * 等角工具类,它用来负责等角到屏幕间的坐标切换工作
	 * @author wangmingfan
	 */
	public class IsoUtils
	{
		//地图类型
		public static const ISOMETRIC:String="isometric";	
		//1.2247的精确计算
		public static const Y_CORRECT:Number = Math.cos(-Math.PI / 6) * Math.SQRT2;
		
		/**
		 * 等角空间中的3D坐标点转换成屏幕上的2D坐标点
		 * 由于屏幕坐标只是二维的,而我们需要一个三维的,但考虑大多数时候,转移是通过鼠标点击地图画面的位置来决定的。
		 * 因此,只要把屏幕上的x,y看作等角世界里的x,z,然后剩下的y,也可以说是高度,当作0处理(设y=0)
		 * @param pt3D
		 * @return 
		 */
		public static function isoToScreen(pt3D:IsoPoint3D):PointVO
		{
			var screenX:Number = pt3D.x - pt3D.z;
			var screenY:Number = pt3D.y * Y_CORRECT + ((pt3D.x + pt3D.z) >>1);
			pt3D=null;
			return new PointVO(screenX, screenY);
		}
		/**
		 * 等角空间中的3D坐标点转换成屏幕上的2D坐标点
		 * @param x
		 * @param y
		 * @param z
		 * @return 
		 */
		public static function isoToScreen2(x:int,y:int,z:int):PointVO
		{
			var vertex3D:IsoPoint3D=new IsoPoint3D(x, y, z);
			var vertex2D:PointVO=IsoUtils.isoToScreen(vertex3D);
			vertex3D=null;
			return vertex2D;
		}		
		/**
		 * 把屏幕上的2D坐标点转换成等角空间中的3D坐标点
		 * @param pt2D
		 * @return 
		 */
		public static function screenToIso(pt2D:PointVO):IsoPoint3D
		{
			var xpos:Number = pt2D.y + (pt2D.x >>1);
			var ypos:Number = 0;
			var zpos:Number = pt2D.y - (pt2D.x >>1);
			pt2D=null;
			return new IsoPoint3D(xpos, ypos, zpos);
		}
		/**
		 * 获得等角对象的移动3D坐标
		 * @param row
		 * @param column
		 * @param tileH
		 * @return 
		 */
		public static function getMove3D(row:int,column:int,tileH:int):IsoPoint3D
		{
			//获得等角矩形
			var isoRect:Rectangle=IsoUtils.getIsoRect(row,column,tileH);
			//获得右顶点2D坐标
			var right2D:PointVO=IsoUtils.isoToScreen2(column * tileH, 0, 0);
			//计算等角矩形显示完全包含等角对象，等角对象需要移动多少3D坐标
			return IsoUtils.screenToIso(new PointVO(isoRect.width - right2D.x, tileH >>1));				
		}
		/**
		 * 获得等角对象的等角矩形
		 * @param row
		 * @param column
		 * @param tileH
		 * @return 
		 */
		public static function getIsoRect(row:int,column:int,tileH:int):Rectangle
		{
			//创建等角对象的4个顶点,转换4个顶点的3D坐标到2D坐标
			var top2D:PointVO=isoToScreen2(0 * tileH, 0, 0 * tileH);
			var bottom2D:PointVO=isoToScreen2(column * tileH, 0, row * tileH);
			var left2D:PointVO=isoToScreen2(0, 0, row * tileH);
			var right2D:PointVO=isoToScreen2(column * tileH, 0, 0);	
			//根据4个顶点的2D坐标计算等角矩形的宽高
			var rectW:int=right2D.x - left2D.x;
			var rectH:int=bottom2D.y - top2D.y;
			top2D=null;
			bottom2D=null;
			left2D=null;
			right2D=null;
			return new Rectangle(0, 0,rectW,rectH);			
		}
		/**
		 * 等角"坐标"(屏幕2D任意坐标) → 等角"索引"
		 * @param pt2D
		 * @param tileH
		 * @param move3D
		 * @return 
		 */
		public static function getIsometricIndex(pt2D:PointVO,tileH:int,move3D:IsoPoint3D):PointVO
		{
			//转换当前屏幕2D任意坐标到3D坐标
			var pt3D:IsoPoint3D=IsoUtils.screenToIso(pt2D);	
			//减去路点被移动的3D坐标
			var mx:Number=pt3D.x - move3D.x;
			var my:Number=pt3D.y - move3D.y;
			var mz:Number=pt3D.z - move3D.z;	
			pt2D=null;
			pt3D=null;
			move3D=null;		
			//获得路点实际的3D坐标
			var Npt3D:IsoPoint3D=new IsoPoint3D(mx,my,mz);	
			//转换路点实际的3D坐标成索引					
			var nx:Number=Math.abs(Npt3D.x + (tileH>>1));
			var nz:Number=Math.abs(Npt3D.z + (tileH>>1));
			var ix:int = Math.floor(nx / tileH);
			var iy:int = Math.floor(nz / tileH);	
			Npt3D=null;
			return new PointVO(ix,iy);			
		}	
		/**
		 *  等角"索引" → 等角"坐标"(屏幕2D中心点坐标)
		 * @param ix
		 * @param iy
		 * @param tileH
		 * @param move3D	
		 * @return 
		 */
		public static function getIsometricPoint(ix:int,iy:int,tileH:int,move3D:IsoPoint3D):PointVO
		{
			//加上路点被移动的3D坐标
			var mx:Number=move3D.x+(ix*tileH);
			var my:Number=move3D.y+0;
			var mz:Number=move3D.z+(iy*tileH);
			var pt3D:IsoPoint3D=new IsoPoint3D(mx,my,mz);
			move3D=null;	
			return IsoUtils.isoToScreen(pt3D);				
		}	
	}
}