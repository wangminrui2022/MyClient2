/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.vo.map
{
	import com.maptype.vo.PointVO;
	
	import com.map.Objects;
	
	/**
	 * 
	 * @author 王明凡
	 */
	public class ObjectsToUI2VO
	{
		public static const ADD:String="add";
		
		public static const DELETE:String="delete";
		
		public static const RESET:String="reset";
		
		public static const UPDATE:String="update";
		
		//拖动材质在地图路点上的摆放位置坐标
		public var sitePoint:PointVO;
		
		//拖动材质在地图路点上的路点坐标(object类型材质需要)
		public var roadPoint:PointVO;
		
		//显示对象
		public var oj:Objects;
		
		//操作类型(添加,删除,重置,更新)
		public var operateType:String;
	}
}