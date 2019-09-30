/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.vo.material
{
	import flash.display.Loader;
	
	
	/**
	 * 材质对象-【临时对象,导入材质完成后将清空该对象】
	 * @author 王明凡
	 */
	public class MaterialVO
	{
		//材质xml
		public var xml:XML;	
		//材质对象集合(MaterialDefinitionVO)
		public var MaterialDefinitionVOArr:Array;
		//材质文件swf的Loader对象集合(Loader)
		public var LoaderArr:Array;
		//材质字节数组集合(MaterialByteArrayVO)
		public var byteVOArr:Array;
		
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			try
			{
				xml=null;
				MaterialDefinitionVOArr.splice(0,MaterialDefinitionVOArr.length);
				MaterialDefinitionVOArr=null;
				if(LoaderArr)
				{
					for each(var ld:Loader in LoaderArr)
					{
						ld.unloadAndStop(true);
						ld=null;
					}
					LoaderArr.splice(0,LoaderArr.length);
				}
				LoaderArr=null;
				byteVOArr=null;
			}catch(er:Error)
			{
			
			}
		}
	}
}