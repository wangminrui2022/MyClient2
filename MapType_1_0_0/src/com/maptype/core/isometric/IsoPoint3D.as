/**
 *  MapType - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.maptype.core.isometric
{
	/**
	 * 等角的3D坐标点的类
	 * @author wangmingfan
	 */
	public class IsoPoint3D
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function IsoPoint3D(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
	}
}