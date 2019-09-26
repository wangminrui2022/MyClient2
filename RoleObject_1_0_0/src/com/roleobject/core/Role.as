package com.roleobject.core
{
	import com.roleobject.interfaces.IRole;
	import com.roleobject.vo.*;
	
	import flash.display.MovieClip;
	import flash.display.Shape;

	/**
	 * 角色类
	 * @author wangmingfan
	 */
	public class Role extends BasicSprite implements IRole
	{
		protected var roleMC:MovieClip;
		protected var materialDefinition:MaterialDefinitionVO;
		protected var SWFLoaderArr:Array;
		protected var info:RoleInfoVO;
		
		public function Role(info:RoleInfoVO,materialDefinition:MaterialDefinitionVO,SWFLoaderArr:Array)
		{
			this.info=info;
			this.materialDefinition=materialDefinition;			
			this.SWFLoaderArr=SWFLoaderArr;
		}
		/**
		 * 角色动画跑
		 * @param direct
		 */
		public function Run(direct:int=0):void
		{
			setRoleMC(direct);
			roleMC.gotoAndPlay("Run");
		}
		
		/**
		 * 角色动画站立
		 * @param direct
		 */
		public function Stand(direct:int=0):void
		{
			setRoleMC(direct);
			roleMC.gotoAndPlay("Stand");
		}
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			if(roleMC)
				roleMC.stop();
			roleMC=null;
			materialDefinition=null;
			SWFLoaderArr=null;
			info=null;
		}	
		/**
		 * 设置角色动画
		 * @param SWFLoaderArr
		 */
		protected function setRoleMC(direct:int):void
		{
			if(direct==-1)
				return;
			var cls:Class=getMaterialClass(getDiffuseVO(direct).diffuse,SWFLoaderArr);
			if(!cls)
				return;			
			if(roleMC)
			{
				this.removeChild(roleMC);
				roleMC.stop();
				roleMC=null;				
			}
			roleMC=new cls() as MovieClip;	
			this.addChild(roleMC);	
			cls=null;	
		}
		/**
		 * 返回角色动画方向
		 * @param direct
		 * @return 
		 */
		protected function getDiffuseVO(direct:int):DiffuseVO
		{	
			for each(var dVO:DiffuseVO in materialDefinition.diffuseVOArr)
			{
				if(dVO.direct==direct)
					return dVO;
			}
			return null;
		}			
	}
}