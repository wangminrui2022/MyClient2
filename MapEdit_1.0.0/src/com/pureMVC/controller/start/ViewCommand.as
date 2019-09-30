/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.start
{
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import com.pureMVC.view.mediator.*;
	
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
			try
			{
				this.facade.registerMediator(new MainMediator(note.getBody()));
				this.facade.registerMediator(new QuicklyPanelMediator(note.getBody().quickly));
				this.facade.registerMediator(new MaterialPanelMediator(note.getBody().material));
				this.facade.registerMediator(new MapEditPanelMediator(note.getBody().mapEdit));
				this.facade.registerMediator(new MapEditPanelMediator2(note.getBody().mapEdit));
				this.facade.registerMediator(new ProgressReportMediator());
				this.facade.registerMediator(new WaitAnimationMediator());
				this.facade.registerMediator(new UseMaterialMediator());
				this.facade.registerMediator(new OpenMapMediator());
				this.facade.registerMediator(new SetMapMediator());
			}
			catch (er:Error)
			{
				this.facade.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
	}
}