package com.myclient2sample3.vo
{
	/**
	 * 地图切换对象
	 * @author wangmingfan
	 */
	public class MapConvertVO
	{
		//启动
		public static const START:String="start";
		//切换
		public static const CONVERT:String="convert";
		//切换状态(启动/切换)
		public var state:String;
		//当前地图名称
		public var mapName:String;
		//当前地图切换地图对象的ID(地图显示对象)
		public var id:String;	
		//要切换地图的url地址
		public var url:String;
		//要切换地图入口x位置
		public var x:int;
		//要切换地图入口y位置
		public var y:int;
		//要切换地图的地图观察口x位置
		public var mapViewPortX:int;
		//要切换地图的地图观察口y位置
		public var mapViewPortY:int;
		//要切换地图的"摄像机"宽
		public var CWidth:int;
		//要切换地图的"摄像机"高
		public var CHeight:int;

	}
}