package com.roleobject.core
{
	/**
	 * 等角的3D坐标点的类
	 * @author 王明凡
	 */
	public class RoleObjectIsoPoint3D
	{
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		
		public function RoleObjectIsoPoint3D(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		/**
		 * 设置3D坐标的x位置
		 * @param x
		 */
		public function set x(x:Number):void
		{
			_x=x;
		}
		/**
		 * 返回3D坐标的x位置
		 * @return 
		 */
		public function get x():Number
		{
			return _x;
		}
		/**
		 * 设置3D坐标的y位置
		 * @param y
		 */
		public function set y(y:Number):void
		{
			_y=y;
		}
		/**
		 * 返回3D坐标的y位置
		 * @return 
		 */
		public function get y():Number
		{
			return _y;
		}
		/**
		 * 设置3D坐标的z位置
		 * @param z
		 */
		public function set z(z:Number):void
		{
			_z=z;
		}
		/**
		 * 返回3D坐标的z位置
		 * @return 
		 */
		public function get z():Number
		{
			return _z;
		}				
	}
}