package com.myclient2sample1.pureMVC.controller.start
{
	import com.myclient2sample1.pureMVC.model.*;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 模型层(proxy)注册
	 * @author 王明凡
	 */
	public class ModelCommand extends SimpleCommand
	{
		public function ModelCommand()
		{
			super();
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