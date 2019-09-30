package com.mapfile.vo
{
	/**
	 *  材质定义对象
	 * @author 王明凡
	 */
	[RemoteClass]		
	public class MMaterialDefinitionVO
	{
		/**
		 * 材质名字
		 * @default 
		 */		
		[Bindable]
		public var name:String;
		/**
		 * 材质类型(tile,object)
		 * @default 
		 */			
		[Bindable]
		public var type:String;
		/**
		 * 材质使用方式(tiles,only,null,operate)
		 * @default 
		 */			
		[Bindable]
		public var used:String;
		/**
		 * 材质宽
		 * @default 
		 */			
		[Bindable]
		public var width:int;
		/**
		 * 材质高
		 * @default 
		 */			
		[Bindable]
		public var height:int;
		/**
		 * 元件类型(BitmapData,MovieClip)
		 * @default 
		 */		
		[Bindable]
		public var elementType:String;
		/**
		 * 材质类定义名
		 * @default 
		 */		
		[Bindable]
		public var diffuse:String;
	}
}