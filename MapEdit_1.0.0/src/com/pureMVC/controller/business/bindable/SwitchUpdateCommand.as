package com.pureMVC.controller.business.bindable
{
	import com.pureMVC.model.BindableProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 深度交换按钮更新
	 * @author wangmingfan
	 */
	public class SwitchUpdateCommand extends SimpleCommand
	{
		public static const SUC_SWITCH_UPDATE:String="suc_switch_update";
		
		private var bindableP:BindableProxy;
		
		public function SwitchUpdateCommand()
		{
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
		}
		override public function execute(note:INotification):void
		{
			bindableP.switchMenuEnabled=note.getBody() as Boolean;
			bindableP=null;
		}
	}
}