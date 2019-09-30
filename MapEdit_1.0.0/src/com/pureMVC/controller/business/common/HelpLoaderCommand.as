/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.common
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	
	import mx.managers.PopUpManager;
	
	import com.basic.BasicLoader;
	import com.consts.Msg;
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.mediator.HelpMediator;
	import com.pureMVC.view.ui.Help;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.common.HelpVO;
	import com.vo.common.MessageAlert2VO;

	/**
	 * 加载帮助
	 * @author 王明凡
	 */
	public class HelpLoaderCommand extends SimpleCommand
	{
		public static const HLC_HELPLOADER:String="hlc_helploader";
		
		public static const HLC_HELPLOADER_COMPLETE:String="hlc_helploader_complete";
		
		private var uiP:UIProxy;
		
		public function HelpLoaderCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		override public function execute(note:INotification):void
		{
			var bl:BasicLoader=new BasicLoader();
			bl.addEventListener(Event.COMPLETE,onComplete);
			bl.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			bl.onLoaderURL("com/asset/file/help.xml",URLLoaderDataFormat.BINARY);
			bl=null;
		}
		/**
		 * 加载完成
		 * @param e
		 */
		private function onComplete(e:Event):void
		{
			var bl:BasicLoader=e.currentTarget as BasicLoader;
			var xml:XML=XML(bl.getByte());
			clearBasicLoader(bl);
			bl=null;
			
			//创建帮助
			var hp:Help=Help(PopUpManager.createPopUp(uiP.app,Help,true));
			PopUpManager.centerPopUp(hp);
			this.facade.registerMediator(new HelpMediator(hp));
			this.sendNotification(HLC_HELPLOADER_COMPLETE,getHelpVOArr(xml));
			uiP=null;	
		}
		/**
		 * 加载错误
		 * @param e
		 */
		private function onIOError(e:IOErrorEvent):void
		{
			clearBasicLoader(e.currentTarget as BasicLoader);
	  		var msgVO:MessageAlert2VO=new MessageAlert2VO();
	  		msgVO.msg=Msg.Msg_19;
	  		this.sendNotification(Message2Command.MC2_MESSAGE,msgVO);	
	  		msgVO=null;	
	  		uiP=null;	
		}
		/**
		 * 清理BasicLoader
		 * @param bl
		 */
		private function clearBasicLoader(bl:BasicLoader):void
		{
			bl.removeEventListener(Event.COMPLETE,onComplete);
			bl.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);	
			bl.clear();	
			bl=null;	
		}
		/**
		 * 获得帮助集合
		 * @param xml
		 * @return 
		 */
		private function getHelpVOArr(xml:XML):Array
		{
			var tmp:Array=new Array();
			for each(var i:XML in xml.helpTheme)
			{
				var hVO:HelpVO=new HelpVO();
				hVO.label=i.@label;
				hVO.content=i.content;
				tmp.push(hVO);
			}
			return tmp;
		}
	}
}