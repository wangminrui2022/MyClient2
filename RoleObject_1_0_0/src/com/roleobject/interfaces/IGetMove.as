package com.roleobject.interfaces
{
	import flash.geom.Point;
	
	import com.roleobject.core.RoleObjectIsoPoint3D;
	/**
	 * 
	 * @author 王明凡
	 */	
	public interface IGetMove
	{
		/**
		 * 获得移动数组
		 * @param roadArr
		 * @param first
		 * @param move3D
		 * @return 
		 */
		function getMoveArr(roadArr:Array, first:Point,move3D:RoleObjectIsoPoint3D):Array;
	}
}