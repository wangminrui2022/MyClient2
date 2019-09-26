package com.myclient2sample3.pureMVC.controller.start
{
	import com.myclient2sample3.pureMVC.view.mediator.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 视图层(mediator)注册
	 * @author wangmingfan
	 */
	public class ViewCommand extends SimpleCommand
	{
		public function ViewCommand()
		{

		}
		override public function execute(note:INotification):void
		{
			this.facade.registerMediator(new ProgressReportMediator());
			this.facade.registerMediator(new WaitAnimationMediator());
			this.facade.registerMediator(new EngineMediator());
			this.facade.registerMediator(new MapNavigateMediator());
			this.facade.registerMediator(new MoveKeyboardMediator());
		}
	}
}