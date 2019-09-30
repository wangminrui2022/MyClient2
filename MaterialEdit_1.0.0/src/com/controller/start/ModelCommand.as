package com.controller.start
{
	import com.model.*;
	import com.view.mediator.OpenMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 注册应用程序所有Proxy
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
			this.facade.registerProxy(new BindableProxy());
			this.facade.registerProxy(new StateProxy());
			this.facade.registerProxy(new MaterialProxy());
			this.facade.registerProxy(new AssetProxy());
		}
	}
}