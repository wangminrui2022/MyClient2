package com.vo
{
	/**
	 *  材质节点对象
	 * @author wangmingfan
	 */
	public class MaterialDefinitionVO
	{
		//材质名字
		public var name:String;
		//材质类型(tile,object)
		public var type:String;
		//材质使用方式(平铺tiles,单独only)
		public var used:String;
		//材质宽
		public var width:String;
		//材质高
		public var height:String;
		//元件类型(BitmapData,MovieClip)
		public var elementType:String;
		//材质类定义名
		public var diffuse:String;

	}
}