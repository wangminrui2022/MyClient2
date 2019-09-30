/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.map
{
	import com.pureMVC.model.UIProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * MapEdit 地图拖动启动和停止
	 * @author 王明凡
	 */
	public class MapDragCommand extends SimpleCommand
	{
		public static const MDC_SCENE_DRAG:String="mdc_scene_drag";
		
		public static const MDC_START:String="mdc_start";
		
		public static const MDC_CLEAR:String="mdc_clear";
		
		private var uiP:UIProxy;
				
		public function MapDragCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		override public function execute(note:INotification):void
		{
			var command:String=note.getBody().toString();
			if(command==MDC_START)
				uiP.app.mapEdit.startDragging();
			else
				uiP.app.mapEdit.clearDragging();
			uiP=null;
		}
	}
}