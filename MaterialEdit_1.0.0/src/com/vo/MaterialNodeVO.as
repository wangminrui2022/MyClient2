package com.vo
{
	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;
	
	/**
	 * 材质节点
	 * 类前插入该元数据标签,可启动此类在序列化和反序列化保持类型信息和属性值
	 * @author 王明凡
	 */
	[RemoteClass]
	public class MaterialNodeVO
	{
		//节点名
		public var label:String;
		//节点LoaderInfo
		public var loaderInfo:LoaderInfo;
		//字节数组(写入到本地用)
		public var byte:ByteArray;
	}
}