/**
 *  MapType - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.maptype.interfaces
{
	/**
	 * 该接口定义了绘制网格方法
	 */
	public interface IGrid
	{
		/**
		 *该方法绘制"交错排列"网格
		 */
		function onStaggered():void;

		/**
		 * 该方法绘制"等角"网格
		 */
		function onIsometric():void;
	}
}