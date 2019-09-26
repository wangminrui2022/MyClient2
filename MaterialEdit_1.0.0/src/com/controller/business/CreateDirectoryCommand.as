package com.controller.business
{
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 新建材质
	 * @author wangmingfan
	 */
	public class CreateDirectoryCommand extends SimpleCommand
	{
		//创建目录(通知)
		public static const CREATE_DIRECTORY:String="create_directory";		
		//创建目录结果(通知)
		public static const CREATE_DIRECTORY_RESULT:String="create_directory_result";			

		public function CreateDirectoryCommand()
		{
			super();
		}
		override public function execute(note:INotification):void
		{
			this.sendNotification(CREATE_DIRECTORY_RESULT,onCreateDirectory(note.getBody().toString()),note.getType());
		}
		/**
		 * 创建目录
		 * */
		private function onCreateDirectory(path:String):Boolean
		{
			var file:File;
			try
			{
				file=new File(path);
						
			}catch(er:Error)
			{
				return false;
			}
			if (file.exists)
			{
				file=null;
				return false;
			}
			else
			{
				file.createDirectory();
			}
			file=null;
			return true;
		}		
	}
}