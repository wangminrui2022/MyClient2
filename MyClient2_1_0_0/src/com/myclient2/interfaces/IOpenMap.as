/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.interfaces
{
	/**
	 * IOpenMap接口定义了采用二进制方式打开一个地图文件(.mcmap),并返回地图的材质对象集合和地图信息
	 * @author 王明凡
	 */
	public interface IOpenMap
	{
		/**
		 * 打开一个地图地图
		 * @return
		 */		
		function onOpen():void;
		
		/**
		 * 垃圾清理
		 */		
		function clear():void;
	}
}