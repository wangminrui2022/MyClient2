package com.myclient2sample3.pureMVC.model
{
	import com.roleobject.core.Role2;
	import com.roleobject.vo.DefinitionsVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class RoleProxy extends Proxy
	{
		public static const NAME:String="RoleProxy";
		
		public var role2:Role2;
		
		public var definitions:DefinitionsVO;
		//角色移动方向(x)
		public var moveDirection:int;
		
		public function RoleProxy(data:Object=null)
		{
			super(NAME, data);
		}
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			role2.onPlay(1);
		}
	}
}