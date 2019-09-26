package  com.myclient2sample3.pureMVC.controller.business.ui
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;

	/**
	 * 初始化UI模型层(只初始化一次)
	 * @author 王明凡
	 */
	public class InitUICommand extends MacroCommand
	{
		public static const IUC_INIT_UI_COMMAND:String="iuc_init_ui_command";

		public function InitUICommand()
		{
			
		}
		override protected function initializeMacroCommand():void
		{
			this.addSubCommand(SetContainerCommand);
			this.addSubCommand(SetMapConvertCommand);
		}
	}
}