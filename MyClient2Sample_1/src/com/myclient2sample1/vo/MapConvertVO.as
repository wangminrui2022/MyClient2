package com.myclient2sample1.vo
{
	/**
	 * 地图切换对象
	 * @author wangmingfan
	 */
	public class MapConvertVO
	{
		/**
		 * 
		 * @default 
		 */
		public static const START:String="start";
		
		/**
		 * 
		 * @default 
		 */
		public static const CONVERT:String="convert";
		
		/**
		 * 切换状态(启动/切换)
		 * @default 
		 */
		public var state:String;
		/**
		 * 当前地图名称
		 * @default 
		 */
		public var mapName:String;
		/**
		 * 当前地图切换地图对象的ID(地图显示对象)
		 * @default 
		 */
		public var id:String;	
		/**
		 * 要切换地图的url地址
		 * @default 
		 */
		public var url:String;
		/**
		 * 要切换地图入口x位置
		 * @default 
		 */
		public var x:int;
		/**
		 * 要切换地图入口y位置
		 * @default 
		 */
		public var y:int;
		/**
		 * 要切换地图的地图观察口x位置
		 * @default 
		 */
		public var mapViewPortX:int;
		/**
		 * 要切换地图的地图观察口y位置
		 * @default 
		 */
		public var mapViewPortY:int;
		/**
		 * 要切换地图的"摄像机"宽
		 * @default 
		 */
		public var CWidth:int;
		/**
		 * 要切换地图的"摄像机"高
		 * @default 
		 */
		public var CHeight:int;

	}
}