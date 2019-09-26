package com.roleobject.vo
{
	/**
	 * 角色移动对象
	 * @author wangmingfan
	 */
	public class MoveVO
	{
		/**
		 * 角色方向
		 * @default 
		 */
		public var direct:int;
		/**
		 * 速度向量X
		 * @default 
		 */
		public var velocityX:Number=0;
		/**
		 * 速度向量Y
		 * @default 
		 */
		public var velocityY:Number=0;
		/**
		 * 一段路的终点X坐标
		 * @default 
		 */
		public var endX:Number;
		/**
		 * 一段路的终点Y坐标
		 * @default 
		 */
		public var endY:Number;

	}
}