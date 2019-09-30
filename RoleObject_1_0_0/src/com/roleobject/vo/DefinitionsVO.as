package com.roleobject.vo
{
	import flash.display.Loader;
	
	/**
	 * 材质文件对象
	 * @author 王明凡
	 */
	public class DefinitionsVO
	{
		/**
		 * 材质src地址集合
		 * @default 
		 */
		public var mediaArr:Array
		/**
		 * 材质定义对象集合
		 * @default 
		 */
		public var materialDefinitionVOArr:Array;
		/**
		 * 角色loader对象集合(Loader)
		 * @default 
		 */
		public var loaderArr:Array;	
		
		/**
		 * 根据name获得材质定义对象
		 * @param name
		 * @return 
		 */
		public function getMaterialDefinitionVO(name:String):MaterialDefinitionVO
		{
			var mdVO:MaterialDefinitionVO;			
			for each(var i:MaterialDefinitionVO in materialDefinitionVOArr)
			{
				if(i.name==name)
				{
					mdVO=i;
				}
				i=null;
			}	
			return mdVO;
		}
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			if(mediaArr)
				mediaArr.splice(0,mediaArr.length);
			mediaArr=null;
			if(materialDefinitionVOArr)
				materialDefinitionVOArr.splice(0,materialDefinitionVOArr.length);
			materialDefinitionVOArr=null;
			if(loaderArr)
			{
				for each(var i:Loader in loaderArr)
				{
					i.unloadAndStop();
					i=null;
				}
				loaderArr.splice(0,loaderArr.length);
			}
			loaderArr=null;
		}		
	}
}