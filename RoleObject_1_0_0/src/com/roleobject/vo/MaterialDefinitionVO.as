package com.roleobject.vo
{
	/**
	 * 材质定义对象
	 * @author 王明凡
	 */
	public class MaterialDefinitionVO
	{			
			
		/**
		 * 类型(1=无特效,2=特效)
		 * @default 
		 */
		public static const TYPE_1:String="1";
		public static const TYPE_2:String="2";
		/**
		 * 材质名
		 * @default 
		 */
		public var name:String;
		/**
		 * 材质类型
		 * @default 
		 */
		public var type:String;		
		/**
		 * 特效的类定义
		 * @default 
		 */
		public var diffuse:String;				
		/**
		 * 类定义对象集合(DiffuseVO)
		 * @default 
		 */
		public var diffuseVOArr:Array;
	}
}