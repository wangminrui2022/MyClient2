/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.vo.material
{
	/**
	 * 
	 * @author wangmingfan
	 */
	public class URMapMaterialVO
	{
		public static const UPDATE:String="update";
		
		public static const DELETE:String="delete";
		
		//操作类型(update/delete)
		public var operateType:String;
		//传递对象
		public var oj:Object;
	}
}