/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.interfaces
{
	/**
	 * ISprite接口统一定义了IMap中显示对象
	 * @author 王明凡
	 */
	public interface ISprite
	{
		/**
		 * 根据类定义名称搜索材质集合的类定义对象
		 * @param diffuse			类定义名称	
		 * @param SWFLoaderArr		索材质集合	
		 * @return					
		 */		
		function getMaterialClass(diffuse:String, SWFLoaderArr:Array):Class;
		/**
		 * 垃圾清理
		 */		
		function clear():void;
	}
}