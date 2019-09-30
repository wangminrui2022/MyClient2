/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.interfaces
{
	/**
	 * IMap接口定义了用于创建一个地图对象，将显示对象添加到地图对象中显示
	 * @author 王明凡
	 */		
	public interface IMap
	{
		/**
		 * 根据地图路径RUL，创建一个地图，注意地图文件格式为(.mcmap)
		 * @param path	地图路径
		 */
		 function createMap(url:String):void;		
		/**
		 * 清理当前地图所有显示对象以及地图信息数据
		 */		 
		 function clear():void;		 
	}
}