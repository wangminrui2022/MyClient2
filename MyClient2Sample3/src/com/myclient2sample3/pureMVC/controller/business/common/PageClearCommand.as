package com.myclient2sample3.pureMVC.controller.business.common
{
	
	import flash.display.*;
	
	import mx.controls.*;
	import mx.core.*;
	import mx.modules.Module;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 页面垃圾清理
	 * 
	 * 清理Container
	 * this.sendNotification(PageClearCommand.PAGECLEAR,this,"1");
	 * 清理UIComponent
	 * this.sendNotification(PageClearCommand.PAGECLEAR,this,"2");
	 * 
	 * @author 王明凡
	 */
	public class PageClearCommand extends SimpleCommand
	{
		//页面垃圾清理(通知)
		public static const PCC_PAGECLEAR:String="pcc_pageClear";
				
		public function PageClearCommand()
		{
			super();
		}

		/**
		 * 1.清理页面
		 * 2.清理UIComponent
		 * @param note
		 */
		override public function execute(note:INotification):void
		{
			try
			{
				switch (note.getType())
				{
					case "1":
						this.clear(note.getBody() as Container);
						break;
					case "2":
						this.clearUIComponent(note.getBody() as UIComponent);
						break;
				}
			}
			catch (er:Error)
			{
				
			}
		}

		/**
		 * UIComponent 垃圾清理
		 * @param ui
		 */
		public function clearUIComponent(ui:UIComponent):void
		{
			var num:int=ui.numChildren;
			for (var i:int=0; i < num; i++)
			{
				var dis:DisplayObject=ui.getChildAt(0);
				if (dis is Bitmap)
					clearBitmap(dis as Bitmap);
				else if (dis is MovieClip)
					clearMovieClip(dis as MovieClip);
				else
					dis=null;
				ui.removeChildAt(0);				
			}
			ui.parent.removeChild(ui);
			ui=null;
		}

		/**
		 * 清理影片剪辑
		 * @param mc
		 */
		public function clearMovieClip(mc:MovieClip):void
		{
			if (mc)
			{
				mc.stop();
				mc=null;
			}
		}

		/**
		 * 清理位图
		 * @param btm
		 */
		public function clearBitmap(btm:Bitmap):void
		{
			if (btm)
			{
				if (btm.bitmapData)
				{
					btm.bitmapData.dispose();
					btm.bitmapData=null;
				}
				btm=null;
			}
		}

		/**
		 * 清除页面中所有的控件
		 * @param container
		 */
		public function clear(container:Container):void
		{
			if (!container)
				return;
			clearChildComponent(container);
			container.deleteReferenceOnParentDocument(container.parentDocument as UIComponent);
			if (container.parent)
				container.parent.removeChild(container);
			container=null;
		}

		/**
		 * 清理容器中的组件,包含控件中的子控件
		 * @param container
		 */
		public function clearChildComponent(container:Container):void
		{
			if (!container)
				return;
			var num:int=container.numChildren;
			for (var i:int; i < num; i++)
			{
				var child:Object=container.getChildAt(0);
				if (child.hasOwnProperty("unloadAndStop"))
				{ //如果是swf,Image
					clearSWF(child);
				}
				else if (child is Module)
				{ //如果是模块
					clearModule(child);
				}
				else if (child is Container && child.numChildren > 0)
				{ //如果是容器,有子节点	
					clearChildComponent(child as Container);
					clearComponent(child);
				}
				else
				{
					clearComponent(child);
				}
				child=null;
				container.removeChildAt(0);
			}
		}

		/**
		 * 清理组件
		 * @param ui
		 */
		public function clearComponent(child:Object):void
		{
			child.deleteReferenceOnParentDocument(child.parentDocument);
			child=null;
		}

		/**
		 * 清理swf
		 * @param child
		 */
		public function clearSWF(child:Object):void
		{
			child.source=null;
			child.unloadAndStop(true);
			child=null;
		}

		/**
		 * 清理Module
		 * @param child
		 */
		public function clearModule(child:Object):void
		{
			child.deleteReferenceOnParentDocument(child.parentDocument);
			child.parent.unloadModule();
			child.parent.url=null;
			child=null;
		}
	}
}