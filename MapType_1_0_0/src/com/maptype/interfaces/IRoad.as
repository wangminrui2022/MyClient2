/**
 *  MapType - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.maptype.interfaces
{
	/**
	 * 该接口定义了绘制路点方法
	 */	
	public interface IRoad
	{
		/**
		 * 该方法绘制"交错排列"路点,并返回路点数组
		 * @param createType 创建类型(1.新建,2.打开)		
		 * @param tileH
		 * @param roadArr
		 * @param mapW
		 * @param mapH
		 * @return 
		 */
		function onStaggered(createType:int,tileH:int,roadArr:Array=null,mapW:int=0,mapH:int=0):Array;
		
		/**
		 * 该方绘制"等角"路点,并返回路点数组
		 * @param createType 创建类型(1.新建,2.打开)
		 * @param tileH
		 * @param roadArr
		 * @param mapW
		 * @param mapH
		 * @return 
		 */		 
		function onIsometric(createType:int,tileH:int,roadArr:Array=null,mapW:int=0,mapH:int=0):Array;	
	}
}