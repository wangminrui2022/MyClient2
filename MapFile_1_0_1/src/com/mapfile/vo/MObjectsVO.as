package com.mapfile.vo
{
	/**
	 * 地图对象
	 * @author wangmingfan
	 */			
	public class MObjectsVO
	{
		/**
		 * 对象ID
		 * @default 
		 */			
		public var id:String;		
		/**
		 * 排序索编号
		 * @default 
		 */			
		public var index:int;
		/**
		 * 深度编号
		 * @default 
		 */			
		public var depth:int;
		/**
		 * x位置
		 * @default 
		 */			
		public var x:int;
		/**
		 * y位置
		 * @default 
		 */		
		public var y:int;
		/**
		 * 材质对象
		 * @default 
		 */			
		public var materialDefinition:MMaterialDefinitionVO;

	}
}