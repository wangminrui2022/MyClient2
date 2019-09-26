/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.business.common
{
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 创建目录
	 * @author wangmingfan
	 */
	public class CreateDirectoryCommand extends SimpleCommand
	{
		//创建目录(通知)
		public static const CDC_CREATE_DIRECTORY:String="cdc_create_directory";		
		//创建目录结果(通知)
		public static const CDC_CREATE_DIRECTORY_RESULT:String="cdc_create_directory_result";			

		public function CreateDirectoryCommand()
		{
			
		}
		override public function execute(note:INotification):void
		{
			
			this.sendNotification(CDC_CREATE_DIRECTORY_RESULT,onCreateDirectory(note.getBody().toString()),note.getType());
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