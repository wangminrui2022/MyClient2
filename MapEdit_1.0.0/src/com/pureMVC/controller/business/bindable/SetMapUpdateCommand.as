package com.pureMVC.controller.business.bindable
{
	import com.pureMVC.model.BindableProxy;
	import com.pureMVC.model.UIProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 设置地图绑定更新,需要重新设置地图参数,必须移除地图上所有的显示对象
	 * @author wangmingfan
	 */
	public class SetMapUpdateCommand extends SimpleCommand
	{
		public static const SMUC_SET_MAP_UPDATE:String="sumc_set_map_update";

		private var bindableP:BindableProxy;

		private var uiP:UIProxy;

		public function SetMapUpdateCommand()
		{
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			if (uiP.ui2.numChildren > 0)
				bindableP.setMapMenuEnabled=false;
			else
				bindableP.setMapMenuEnabled=true;
			bindableP=null;
			uiP=null;
		}
	}
}