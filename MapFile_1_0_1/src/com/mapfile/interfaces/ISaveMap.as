package com.mapfile.interfaces
{
	/**
	 * 保存一个地图文件
	 * @author wangmingfan
	 */	
	public interface ISaveMap
	{
		/**
		 * 保存地图
		 * @return
		 */			
		function onSave():void;
		
		/**
		 * 垃圾清理
		 */			
		function clear():void;		
	}
}