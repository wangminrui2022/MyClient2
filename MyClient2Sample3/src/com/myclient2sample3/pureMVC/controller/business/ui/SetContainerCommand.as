package com.myclient2sample3.pureMVC.controller.business.ui
{
	import com.myclient2sample3.pureMVC.model.UIProxy;
	
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 设置容器
	 * @author 王明凡
	 */
	public class SetContainerCommand extends SimpleCommand
	{
		public static const SCC_SET_CONTAINER_COMMAND:String="scc_set_container_command";
		
		private var uiP:UIProxy;
		
		public function SetContainerCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		override public function execute(note:INotification):void
		{
			//地图引擎显示容器(No.1)
			uiP.engineContainer=new UIComponent();
			uiP.app.addChild(uiP.engineContainer);
			//地图操作对象显示容器(No.2)
			uiP.mapOperateContainer=new UIComponent();
			uiP.app.addChild(uiP.mapOperateContainer);
			//地图角色显示容器(No.3)
			uiP.roleConatainer=new UIComponent();
			uiP.app.addChild(uiP.roleConatainer);
			//地图组件显示容器(No.4)
			uiP.componetContainer=new UIComponent();
			uiP.app.addChild(uiP.componetContainer);
			uiP=null;		
		}		
	}
}