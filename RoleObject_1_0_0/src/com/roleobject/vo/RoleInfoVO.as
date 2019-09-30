package com.roleobject.vo
{
	/**
	 * 角色信息
	 * @author 王明凡
	 */
	public class RoleInfoVO
	{
		/**
		 * 角色类型(1当前角色/2其他角色)
		 * @default 
		 */
		public var roleType:int;
		/**
		 * 角色状态(1.正常)
		 * @default 
		 */
		public var uState:int;
		/**
		 * 名字颜色
		 * @default 
		 */
		public var nameColor:String;
		/**
		 * 角色ID
		 * @default 
		 */
		public var uID:int;
		/**
		 * 角色名
		 * @default 
		 */
		public var roleName:String;
		/**
		 * 材质定义名
		 * @default 
		 */
		public var materialDefinition_name:String;
		/**
		 * 移动对象
		 * @default 
		 */
		public var moveVO:MoveVO;
	}
}