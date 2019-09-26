package com.myclient2sample1.pureMVC.model
{
	import com.roleobject.core.Role;
	import com.roleobject.core.RoleMove;
	import com.roleobject.vo.DefinitionsVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class RoleProxy extends Proxy
	{
		public static const NAME:String="RoleProxy";
		
		public var definitions:DefinitionsVO;
		
		public var role:Role;
		
		public var roleMove:RoleMove;
		
		public function RoleProxy(data:Object=null)
		{
			super(NAME, data);
		}		
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			if(definitions)
				definitions.clear();
			definitions=null;
			if(role)
				role.clear();
			role=null;
			if(roleMove)
				roleMove.clear();
			roleMove=null;			
		}		
	}
}