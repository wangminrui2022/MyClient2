/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.vo
{
	/**
	 *  材质定义对象描述规范
	 * @author 王明凡
	 */	
	public class MMaterialDefinitionVO
	{
		/**
		 * 材质名字
		 * @default 
		 */		
		public var name:String;
		/**
		 * 材质类型(tile,object)
		 * @default 
		 */			
		public var type:String;
		/**
		 * 材质使用方式(tiles,only,null,operate)
		 * @default 
		 */			
		public var used:String;
		/**
		 * 材质宽
		 * @default 
		 */			
		public var width:int;
		/**
		 * 材质高
		 * @default 
		 */			
		public var height:int;
		/**
		 * 元件类型(BitmapData,MovieClip)
		 * @default 
		 */		
		public var elementType:String;
		/**
		 * 材质类定义名
		 * @default 
		 */		
		public var diffuse:String;
	}
}