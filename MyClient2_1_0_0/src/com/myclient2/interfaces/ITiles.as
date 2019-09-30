/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.interfaces
{
	import flash.display.BitmapData;
	
	/**
	 * ITiles接口定义显示到IMap中的平铺地砖对象，平铺整个IMap
	 * @author 王明凡
	 */	
	public interface ITiles
	{
		/**
		 * 平铺整个IMap
		 * @param type			IMap类型"isometric"和"staggered"
		 * @param diffuse		IMap材质的类定义名称
		 * @param SWFLoaderArr	要搜索的材质集合
		 * @param row			IMap行
		 * @param column		IMap列
		 * @param tileH			地砖高
		 */		
		function onTiles(type:String,diffuse:String,SWFLoaderArr:Array,row:int,column:int,tileH:int):void;		
	}
}