/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core
{
	import flash.display.Loader;
	import flash.display.Sprite;
	
	import com.myclient2.interfaces.ISprite;

	/**
	 * MSprite统一定义了MMap中显示对象的父对象
	 * @author 王明凡
	 */
	public class MSprite extends Sprite implements ISprite
	{
		/**
		 * 构造函数
		 */
		public function MSprite()
		{
			
		}
		/**
		 * 根据类定义名称搜索材质集合的类定义对象
		 * @param diffuse			类定义名称	
		 * @param SWFLoaderArr		索材质集合	
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
		/**
		 * 垃圾清理
		 */	
		public function clear():void
		{
		
		}				
	}
}