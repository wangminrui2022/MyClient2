package com.controller.start
{
	import com.controller.business.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 注册应用程序所有通知命令
	 * @author wangmingfan
	 */
	public class ControlCommand extends SimpleCommand
	{
		public function ControlCommand()
		{
			super();
		}

		override public function execute(note:INotification):void
		{
			this.facade.registerCommand(FileCommand.FILE,FileCommand);
			this.facade.registerCommand(PageClearCommand.PAGECLEAR,PageClearCommand);
			this.facade.registerCommand(Message2Command.MESSAGE2,Message2Command);
			this.facade.registerCommand(ExceptionCommand.EXCEPTION,ExceptionCommand);
			this.facade.registerCommand(MenuItemSelectCommand.MENUITEM_SELECT,MenuItemSelectCommand);	
			this.facade.registerCommand(BrowseCommand.BROWSE_DIRECTORY, BrowseCommand);
			this.facade.registerCommand(CreateDirectoryCommand.CREATE_DIRECTORY, CreateDirectoryCommand);
			this.facade.registerCommand(SerializableCommand.SERIALIZABLE,SerializableCommand);	
			this.facade.registerCommand(BasicLoaderCommand.BLC_BASICLOADER,BasicLoaderCommand);			
			this.facade.registerCommand(SizeCommand.SIZE,SizeCommand);
			this.facade.registerCommand(InitDataCommand.INIT_DATA,InitDataCommand);
			this.facade.registerCommand(SaveCommand.SC_SAVE,SaveCommand);
			this.facade.registerCommand(EditStateCommand.ESC_EDITSTATE,EditStateCommand);
			this.facade.registerCommand(CloseCommand.CC_CLOSE,CloseCommand);
			this.facade.registerCommand(ValidateCommand.VC_VALIDATA,ValidateCommand);
			this.facade.registerCommand(QuickKeyboardCommand.QKC_QUICK_KEYBOARD,QuickKeyboardCommand);
			this.facade.registerCommand(SaveImageCommand.SIC_SAVE_IMAGE,SaveImageCommand);
		}
	}
}