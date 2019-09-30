
/**
 *  MapType - Copyright (c) 2010 王明凡
 */
package com.maptype.vo
{
	import flash.display.Shape;
	

	/**
	 * 路点对象
	 * @author 王明凡
	 */
	[RemoteClass]
	public class RoadVO
	{
		//路点索引
		public var index:PointVO;
		//路点坐标
		public var point:PointVO;
		//绘制路点
		public var shape:Shape;
		//路点数组索引类型
		public var type:int;

		/**
		 * 绘制路点
		 * @param color
		 * @param tileH
		 * @param point
		 * @return
		 */
		public function drawRoad(color:int, tileH:int, point:PointVO):Shape
		{
			var shape:Shape=new Shape();
			shape.graphics.beginFill(color, 0.7);
			shape.graphics.drawCircle(point.x, point.y, tileH >>2);
			shape.graphics.endFill();
			return shape;
		}
	}
}