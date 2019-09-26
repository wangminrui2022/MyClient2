package com.maptype.interfaces
{
	import flash.display.BitmapData;
	
	public interface ITiles
	{
		/**
		 * 平铺位图地图
		 * @param type		地图类型"isometric"和"staggered"
		 * @param data		平铺位图
		 * @param row		地图行
		 * @param column	地图列
		 * @param tileH		地砖高
		 */		
		function onTiles(type:String,data:BitmapData,row:int,column:int,tileH:int):void;
	}
}