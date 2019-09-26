package com.mapfile.interfaces
{
	/**
	 * 打开一个地图文件
	 * @author wangmingfan
	 */
	public interface IOpenMap
	{
		/**
		 * 打开地图
		 */		
		function onOpen():void;
		
		/**
		 * 垃圾清理
		 */		
		function clear():void;
	}
}