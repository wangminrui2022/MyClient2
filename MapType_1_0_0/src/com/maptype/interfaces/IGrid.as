/**
 *  MapType - Copyright (c) 2010 王明凡
 */
package com.maptype.interfaces
{
	/**
	 * 该接口定义了绘制网格方法
	 * @author 王明凡
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