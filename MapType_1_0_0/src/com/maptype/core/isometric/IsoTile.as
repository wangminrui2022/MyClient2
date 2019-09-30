/**
 *  MapType - Copyright (c) 2010 王明凡
 */
package com.maptype.core.isometric
{
	import com.maptype.core.Grids;
	import com.maptype.vo.PointVO;
	
	import flash.display.Shape;

	/**
	 * 等角对象
	 * @author 王明凡
	 */
	public class IsoTile extends Shape
	{
		private var tileH:int;
		
		public function IsoTile(tileH:int,pt3D:IsoPoint3D,color:int)
		{
			//等角比例为 2(宽):1(高)
			this.tileH=tileH;
			//将等角3D坐标转换成屏幕2D坐标
			var pt2D:PointVO = IsoUtils.isoToScreen(pt3D);
			this.x = pt2D.x;
			this.y = pt2D.y;
			graphics.lineStyle(1,color,Grids.gridsAlpha);
			//必须填充，用户等角类型地图，充当鼠标单击触发事件的条件
			graphics.beginFill(0xffffff,0);
		}
		public function drawTile():void
		{
			graphics.moveTo(-tileH,0);
			graphics.lineTo(0,tileH>>1);
			graphics.lineTo(tileH,0);
			graphics.lineTo(0,-tileH>>1);
			graphics.lineTo(-tileH,0);	
			graphics.endFill();
		}
	}
}