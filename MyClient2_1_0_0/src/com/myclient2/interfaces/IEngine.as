/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.interfaces
{
	import com.myclient2.core.engine.MViewPort;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * IEngine接口定义了用于渲染地图显示对象(也可以称作贴图)，以及操作地图显示对象
	 * @author 王明凡
	 */
	public interface IEngine
	{

		/**
		 * 通过给定的"地图","观察口"以及"摄像机",进行地图渲染
		 * @param map		地图
		 * @param viewPort	观察口
		 * @param camera	摄像机
		 */
		function renderMap(map:IMap,viewPort:MViewPort,camera:IRectangle):void;
		
		/**
		 * 根据给定的移动坐标移动摄像机，移动范围是当前摄像机记录的"矩形"信息
		 * @param move		要移动的坐标(通常是当前角色坐标)
		 * @return 			是否移动
		 * @param easing	移动时的缓动系数0-1之间
		 */
		function moveCamera(move:Point,easing:Number=1):void;
		
		/**
		 * 根据给定的移动坐标移动摄像机，移动范围是当前摄像机记录的"矩形"信息
		 * @param x			要移动的坐标x
		 * @param y			要移动的坐标y
		 * @param min		最小范围移动，如果为null，则不根据最大范围移动
		 * @param max		最大范围移动，如果为null，则不根据最大范围移动
		 * @param easing	移动时的缓动系数0-1之间
		 */
		function moveCamera2(x:int,y:int,min:Rectangle,max:Rectangle,easing:Number=0.6):void;
				
		/**
		 * 根据起点和终点搜索当前地图的路径
		 * @param start		起点
		 * @param end		终点
		 * @return 			搜索的结果
		 */		
		function searchRoad(start:Point,end:Point):Array;
		
		/**
		 * 从当前显示容器中移除当前引擎渲染的地图,包含清理该地图中所有的显示对象以及地图信息数据
		 */		
		function removeMap():void;
		
		/**
		 * 添加某个显示对象在地图中的阴影点透明
		 * @param shadow	当前显示对象(一般是移动角色)
		 */		
		function onShadow(shadow:DisplayObject):void;			
	}
}