package com.controller.business
{
	import com.vo.BrowseVO;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 浏览目录
	 * 返回选择的目录
	 * @author 王明凡
	 */
	public class BrowseCommand extends SimpleCommand
	{
		//浏览目录(通知)
		public static const BROWSE_DIRECTORY:String="browse_directory";		
		//选择的目录(通知)
		public static const BROWSE_DIRECTORY_RESULT:String="browse_directory_result";		
		//浏览VO
		private var bVO:BrowseVO;
		//类型
		private var type:String;
		//路径
		private var path:String;
		
		public function BrowseCommand()
		{
			super();
		}
		override public function execute(note:INotification):void
		{
			bVO=note.getBody() as BrowseVO;
			type=note.getType();
			var file:File=new File(bVO.path);
			file.addEventListener(Event.SELECT, onSelect);
			if(bVO.browseType=="1")
				file.browseForOpen("浏览文件", [bVO.fFilter]);
			else
				file.browseForDirectory("选择保存目录");		
		}
		/**
		 * 选择保存目录
		 * @param e
		 */
		private function onSelect(e:Event):void
		{
			var file:File=e.currentTarget as File;
			path=file.nativePath;
			file.removeEventListener(Event.SELECT, onSelect);
			file=null;
			this.sendNotification(BROWSE_DIRECTORY_RESULT,path,type);
		}		
	}
}