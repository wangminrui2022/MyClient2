package com.vo
{
	/**
	 * 材质信息
	 * @author wangmingfan
	 */
	public class MaterialInfoVO
	{
		//材质名
		public var name:String;		
		//材质保存路径
		public var savePath:String;
		//序列化文件路径
		public var serializablePath:String;
		//材质文件路径
		public var materialPath:String;
		//材质文件
		public var materialXML:XML;
		//材质节点对象集合
		public var MaterialDefinitionVOArr:Array;
	}
}