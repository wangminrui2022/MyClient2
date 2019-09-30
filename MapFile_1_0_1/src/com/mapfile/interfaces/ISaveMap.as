package com.mapfile.interfaces
{
	/**
	 * 保存一个地图文件
	 * @author 王明凡
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