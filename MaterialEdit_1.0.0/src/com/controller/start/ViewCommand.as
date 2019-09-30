package com.controller.start
{
	import com.view.mediator.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 注册应用程序所有Mediator
	 * @author 王明凡
	 */
	public class ViewCommand extends SimpleCommand
	{
		public function ViewCommand()
		{
			super();
		}

		override public function execute(note:INotification):void
		{
			this.facade.registerMediator(new MainMediator(note.getBody()));
			this.facade.registerMediator(new MaterialPanelMediator(note.getBody().materialPanel));
			this.facade.registerMediator(new MaterialEditorMediator(note.getBody().materialEditor));
			this.facade.registerMediator(new OpenMediator());
			this.facade.registerMediator(new ProgressReportMediator());			
		}
	}
}