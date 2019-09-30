/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.engine
{
	import com.myclient2.core.MRectangle;
	
	/**
	 * 摄像机用于记录地图信息(矩形区域)传给引擎渲染,可以指定摄像机拍摄地图的x,y位置以及摄像机拍摄地图的宽高
	 * 摄像机是地图的一个矩形区域
	 * @author 王明凡
	 */
	public class MCamera extends MRectangle
	{
		/**
		 * 构造函数
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 */
		public function MCamera(x:Number, y:Number, width:Number, height:Number)
		{
			super(x, y, width, height);
		}
	}
}