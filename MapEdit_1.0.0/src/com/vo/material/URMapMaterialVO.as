/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.vo.material
{
	/**
	 * 
	 * @author 王明凡
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