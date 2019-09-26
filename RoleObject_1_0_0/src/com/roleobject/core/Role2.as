package com.roleobject.core
{
	import com.roleobject.vo.DiffuseVO;
	import com.roleobject.vo.MaterialDefinitionVO;
	import com.roleobject.vo.RoleInfoVO;

	import flash.display.Loader;
	import flash.display.MovieClip;

	/**
	 * 角色类2
	 * @author 王明凡
	 */
	public class Role2 extends Role
	{
		private var diffuseVO:DiffuseVO;

		public function Role2(info:RoleInfoVO,materialDefinition:MaterialDefinitionVO, SWFLoaderArr:Array)
		{
			super(info,materialDefinition, SWFLoaderArr);
		}

		/**
		 * 开始播放
		 * @param direct
		 */
		public function onPlay(direct:int):void
		{
			if(!roleMC)
				setRoleMC(-1);
			if(diffuseVO)
			{
				if(diffuseVO.direct!=direct)
				{
					diffuseVO=null;
					diffuseVO=getDiffuseVO(direct);
				}
			}
			else
			{
				diffuseVO=getDiffuseVO(direct);		
			}
			roleMC.gotoAndPlay(diffuseVO.diffuse);
		}
		/**
		 * 设置角色动画
		 * @param SWFLoaderArr
		 */
		override protected function setRoleMC(direct:int):void
		{
			var cls:Class=getMaterialClass(materialDefinition.diffuse,SWFLoaderArr);
			roleMC=new cls() as MovieClip;	
			this.addChild(roleMC);		
			cls=null;	
		}		
		/**
		 * 重写父类垃圾清理
		 */
		override public function clear():void
		{
			diffuseVO=null;
			super.clear();
		}
	}
}