/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.vo
{
	import flash.geom.Rectangle;
	
	import com.myclient2.interfaces.IRectangle;
	
	/**
	 * 地图对象以及材质信息描述规范
	 * @author 王明凡
	 */			
	public class MObjectsVO implements IRectangle
	{
		/**
		 * 对象ID
		 * @default 
		 */			
		public var id:String;		
		/**
		 * 排序索编号
		 * @default 
		 */			
		public var index:int;
		/**
		 * 深度编号
		 * @default 
		 */			
		public var depth:int;
		/**
		 * x位置
		 * @default 
		 */			
		public var x:int;
		/**
		 * y位置
		 * @default 
		 */		
		public var y:int;
		/**
		 * 材质对象
		 * @default 
		 */			
		public var materialDefinition:MMaterialDefinitionVO;
		
		/**
		 * 返回当前(x,y,width,height)的矩形区域
		 * @return 
		 */	
		public function getRectangle():Rectangle
		{
			return new Rectangle(x,y,materialDefinition.width,materialDefinition.height);
		}
	}
}