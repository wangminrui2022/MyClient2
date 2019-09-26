package com.myclient2sample3.pureMVC.controller.start
{
	import com.myclient2sample3.pureMVC.model.EngineProxy;
	import com.myclient2sample3.pureMVC.model.MapOperateProxy;
	import com.myclient2sample3.pureMVC.model.RoleProxy;
	import com.myclient2sample3.pureMVC.model.UIProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 模型层(proxy)注册
	 * @author wangmingfan
	 */
	public class ModelCommand extends SimpleCommand
	{
		public function ModelCommand()
		{
			
		}
		override public function execute(note:INotification):void
		{
			this.facade.registerProxy(new UIProxy(note.getBody()));
			this.facade.registerProxy(new EngineProxy());
			this.facade.registerProxy(new RoleProxy());
			this.facade.registerProxy(new MapOperateProxy());
		}
	}
}