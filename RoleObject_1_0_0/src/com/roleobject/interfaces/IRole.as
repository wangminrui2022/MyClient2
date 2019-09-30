package com.roleobject.interfaces
{
	/**
	 * 
	 * @author 王明凡
	 */
	public interface IRole
	{
		/**
		 * 角色动画跑
		 * @param direct
		 */		
		function Run(direct:int=0):void;
		/**
		 * 角色动画站立
		 * @param direct
		 */		
		function Stand(direct:int=0):void;
		/**
		 * 垃圾清理
		 */			
		function clear():void;
	}
}