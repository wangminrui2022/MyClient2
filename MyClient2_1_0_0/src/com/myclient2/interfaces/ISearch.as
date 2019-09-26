/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.interfaces
{
	import flash.geom.Point;
	
	/**
	 * ISearch定义了寻路,用于对直角路点数组进行寻路
	 * @author 王明凡
	 */	
	public interface ISearch
	{
		/**
		 * 根据起点和终点返回寻路结果
		 * @param start		起点
		 * @param end		终点
		 * @return			结果集合
		 */		
		function getRoad(start:Point,end:Point):Array;
	}
}