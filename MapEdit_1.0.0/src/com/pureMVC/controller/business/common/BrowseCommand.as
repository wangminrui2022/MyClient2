/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.business.common
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.common.BrowseVO;

	/**
	 * 浏览目录
	 * 返回选择的目录
	 * var bVO:BrowseVO=new BrowseVO();
	 * bVO.browseType="1";
	 * bVO.fFilter=new FileFilter(".xml", "*.xml");
	 * this.sendNotification(BrowseCommand.BC_BROWSE_DIRECTORY,BrowseVO,"1/2");
	 * @author wangmingfan
	 */
	public class BrowseCommand extends SimpleCommand
	{
		//浏览目录(通知)
		public static const BC_BROWSE_DIRECTORY:String="bc_browse_directory";		
		//选择的目录(通知)
		public static const BC_BROWSE_DIRECTORY_RESULT:String="bc_browse_directory_result";		
		//类型
		private var type:String;
		
		public function BrowseCommand()
		{
			super();
		}
		override public function execute(note:INotification):void
		{
			var bVO:BrowseVO=note.getBody() as BrowseVO;
			type=note.getType();
			var file:File=new File(bVO.path);
			file.addEventListener(Event.SELECT, onSelect);
			if(bVO.browseType=="1")
				file.browseForOpen("浏览文件", [bVO.fFilter]);
			else
				file.browseForDirectory("选择保存目录");	
			bVO=null;	
		}
		/**
		 * 选择保存目录
		 * @param e
		 */
		private function onSelect(e:Event):void
		{
			var file:File=e.currentTarget as File;
			var path:String=file.nativePath;
			file.removeEventListener(Event.SELECT, onSelect);
			file=null;
			this.sendNotification(BC_BROWSE_DIRECTORY_RESULT,path,type);
		}		
	}
}