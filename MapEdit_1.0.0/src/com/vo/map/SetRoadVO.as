/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.vo.map
{
	import mx.core.UIComponent;
	
	/**
	 * 设置路点
	 * @author wangmingfan
	 */
	public class SetRoadVO
	{
		//设置类型(1=场景设置路点/2=材质设置路点)
		public var setRoadType:int;
		//设置路点的容器
		public var UI:UIComponent;
		//设置路点的路点数组
		public var roadArr:Array;
		//地砖宽
		public var tileW:int;
		//地砖高
		public var tileH:int;		
	}
}