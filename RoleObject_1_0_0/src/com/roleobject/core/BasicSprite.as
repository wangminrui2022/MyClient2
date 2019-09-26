package com.roleobject.core
{
	import flash.display.Loader;
	import flash.display.Sprite;

	/**
	 * 基本显示对象
	 * @author wangmingfan
	 */
	public class BasicSprite extends Sprite
	{
		public function BasicSprite()
		{
			
		}
		/**
		 * 根据材质加载对象集合,返回类定义
		 * @param diffuse
		 * @param SWFLoaderArr
		 * @return 
		 */
		public function getMaterialClass(diffuse:String, SWFLoaderArr:Array):Class
		{
			for each (var ld:Loader in SWFLoaderArr)
			{
				try
				{
					if (ld.contentLoaderInfo.applicationDomain.getDefinition(diffuse))
					{
						var cls:Class=ld.contentLoaderInfo.applicationDomain.getDefinition(diffuse) as Class;
						SWFLoaderArr=null;
						return cls;
					}
				}
				catch (er:Error)
				{
					continue;
				}
			}
			SWFLoaderArr=null;
			return null;
		}		
	}
}