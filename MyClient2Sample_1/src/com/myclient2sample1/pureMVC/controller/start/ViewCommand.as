package com.myclient2sample1.pureMVC.controller.start
{
	import com.myclient2sample1.pureMVC.view.mediator.AppMediator;
	import com.myclient2sample1.pureMVC.view.mediator.EngineMediator;
	import com.myclient2sample1.pureMVC.view.mediator.MapNavigateMediator;
	import com.myclient2sample1.pureMVC.view.mediator.ProgressReportMediator;
	import com.myclient2sample1.pureMVC.view.mediator.WaitAnimationMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 视图层(mediator)注册
	 * @author 王明凡
	 */
	public class ViewCommand extends SimpleCommand
	{
		public function ViewCommand()
		{

		}
		override public function execute(note:INotification):void
		{
			this.facade.registerMediator(new AppMediator(note.getBody()));
			this.facade.registerMediator(new EngineMediator());
			this.facade.registerMediator(new ProgressReportMediator());
			this.facade.registerMediator(new MapNavigateMediator());
			this.facade.registerMediator(new WaitAnimationMediator());
		}
	}
}