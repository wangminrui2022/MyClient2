/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.business.other
{
	import com.consts.MString;
	import com.map.Objects;
	import com.maptype.core.Tiles;
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import com.pureMVC.model.BindableProxy;
	import com.pureMVC.model.MaterialProxy;
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.mediator.MapEditPanelMediator2;
	import com.pureMVC.view.mediator.MaterialPanelMediator;
	import com.pureMVC.view.mediator.SetRoadMediator;
	import com.pureMVC.view.mediator.UseMaterialMediator;
	import com.pureMVC.view.ui.MaterialPanel;
	import com.pureMVC.view.ui.as_.OnlyImage;
	
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 *
	 * @author 王明凡
	 */
	public class ContextMenuSelectCommand extends SimpleCommand
	{
		//上下文选择(通知)
		public static const CMSC_CONTEXTMENU_SELECT:String="cmsc_contextmenu_select";
		//UI模型层
		private var uiP:UIProxy;
		//状态模型层
		private var bindableP:BindableProxy;
		
		private var materialP:MaterialProxy;
		//上下文菜单
		private var contextM:ContextMenu;

		public function ContextMenuSelectCommand()
		{
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
			contextM=ContextMenu(uiP.app.contextMenu);
		}

		override public function execute(note:INotification):void
		{
			var e:ContextMenuEvent=note.getBody() as ContextMenuEvent;
//			trace(e.mouseTarget);
//			trace(e.mouseTarget.parent);
//			trace(e.mouseTarget.parent.parent);
//			trace(e.mouseTarget.parent.parent.parent);
//			trace(e.mouseTarget.parent.parent.parent.parent);
			//清空上下问菜单
			contextM.customItems.splice(0);
			//如果是主程序
			if (e.mouseTarget is MapEdit)
				return;
			try
			{
				//取消路点设置
				this.sendNotification(SetRoadMediator.SRM_SETROAD_CANCEL);						
				//如果是材质库
				if (e.mouseTarget.parent is MaterialPanel)
				{
					//取消拖动材质
					this.sendNotification(UseMaterialMediator.UMM_CANCEL);
					contextM.customItems.push(getContextMenuItem(MString.IMPORT_MATERIAL, true, onContextMenuSelect));
					contextM.customItems.push(getContextMenuItem(MString.USE_MATERIAL, false, null, true));
					contextM.customItems.push(getContextMenuItem(MString.EDIT_MATERIAL, false));
					contextM.customItems.push(getContextMenuItem(MString.DELETE_MATERIAL, false));
				}
				//如果是材质显示对象
				else if (e.mouseTarget is OnlyImage || e.mouseTarget.parent is OnlyImage ||e.mouseTarget.parent.parent is OnlyImage)
				{
					//取消拖动材质
					this.sendNotification(UseMaterialMediator.UMM_CANCEL);
					contextM.customItems.push(getContextMenuItem(MString.IMPORT_MATERIAL, false));
					contextM.customItems.push(getContextMenuItem(MString.USE_MATERIAL, true, onContextMenuSelect, true));
					contextM.customItems.push(getContextMenuItem(MString.EDIT_MATERIAL, true, onContextMenuSelect));
					contextM.customItems.push(getContextMenuItem(MString.DELETE_MATERIAL, true, onContextMenuSelect));
				}
				//如果是材质对象
				else if (e.mouseTarget is Objects || e.mouseTarget.parent is Objects || e.mouseTarget.parent.parent is Objects || e.mouseTarget.parent.parent.parent is Objects)
				{
					if (bindableP.SP_IsDragMaterial)
					{
						contextM.customItems.push(getContextMenuItem(MString.OBJECTINFO, false, null));
						contextM.customItems.push(getContextMenuItem(MString.DEPTH_1, false, null));
						contextM.customItems.push(getContextMenuItem(MString.DEPTH_2, false));					
						contextM.customItems.push(getContextMenuItem(MString.DISPLAY_ROAD, false,null,true));
						contextM.customItems.push(getContextMenuItem(MString.HIDE_ROAD, false));
						contextM.customItems.push(getContextMenuItem(MString.REMOVE, false, null, true));
						contextM.customItems.push(getContextMenuItem(MString.RESET, false));
						contextM.customItems.push(getContextMenuItem(MString.CANCEL, true, onContextMenuSelect, true));
					}
					else
					{
						
						if(materialP.getMapObjects(e).mTileVO.mdVO.type==MString.OBJECT)
						{
							contextM.customItems.push(getContextMenuItem(MString.OBJECTINFO, true, onContextMenuSelect));
							contextM.customItems.push(getContextMenuItem(MString.DEPTH_1, true, onContextMenuSelect));
							contextM.customItems.push(getContextMenuItem(MString.DEPTH_2, true, onContextMenuSelect));				
							contextM.customItems.push(getContextMenuItem(MString.DISPLAY_ROAD, true, onContextMenuSelect,true));
							contextM.customItems.push(getContextMenuItem(MString.HIDE_ROAD, true, onContextMenuSelect));
							contextM.customItems.push(getContextMenuItem(MString.REMOVE, true, onContextMenuSelect, true));
							contextM.customItems.push(getContextMenuItem(MString.RESET, true, onContextMenuSelect));
							contextM.customItems.push(getContextMenuItem(MString.CANCEL, false, null, true));
						}
						else
						{
							contextM.customItems.push(getContextMenuItem(MString.OBJECTINFO, true, onContextMenuSelect));
							contextM.customItems.push(getContextMenuItem(MString.DEPTH_1, true, onContextMenuSelect));
							contextM.customItems.push(getContextMenuItem(MString.DEPTH_2, true, onContextMenuSelect));			
							contextM.customItems.push(getContextMenuItem(MString.DISPLAY_ROAD, false, null,true));
							contextM.customItems.push(getContextMenuItem(MString.HIDE_ROAD, false, null));
							contextM.customItems.push(getContextMenuItem(MString.REMOVE, true, onContextMenuSelect, true));
							contextM.customItems.push(getContextMenuItem(MString.RESET, true, onContextMenuSelect));
							contextM.customItems.push(getContextMenuItem(MString.CANCEL, false, null, true));							
						}
					}
				}
				//如果是地图平铺对象
				else if(e.mouseTarget is Tiles)
				{
						contextM.customItems.push(getContextMenuItem(MString.OBJECTINFO, false));
						contextM.customItems.push(getContextMenuItem(MString.DEPTH_1, false));
						contextM.customItems.push(getContextMenuItem(MString.DEPTH_2, false));			
						contextM.customItems.push(getContextMenuItem(MString.DISPLAY_ROAD, false, null,true));
						contextM.customItems.push(getContextMenuItem(MString.HIDE_ROAD, false, null));
						contextM.customItems.push(getContextMenuItem(MString.REMOVE, true, onContextMenuSelect, true));
						contextM.customItems.push(getContextMenuItem(MString.RESET, false));
						contextM.customItems.push(getContextMenuItem(MString.CANCEL, false, null, true));						
				}
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}

		/**
		 * 上下文菜单项选择事件
		 * @param txt				文本
		 * @param enabled			是否启用
		 * @param fun				处理函数
		 * @param separatorBefore	是否分割线条
		 * @return
		 */
		private function getContextMenuItem(txt:String, enabled:Boolean, fun:Function=null, separatorBefore:Boolean=false):ContextMenuItem
		{
			var item:ContextMenuItem=new ContextMenuItem(txt, separatorBefore);
			item.enabled=enabled;
			if (fun != null)
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fun);
			return item;
		}

		/**
		 * 选择上下文菜单
		 * @param e
		 */
		private function onContextMenuSelect(e:ContextMenuEvent):void
		{
			switch (e.currentTarget.caption)
			{
				case MString.IMPORT_MATERIAL:
					this.sendNotification(MaterialPanelMediator.MPM_IMPORT_MATERIAL);
					break;
				case MString.USE_MATERIAL:
					this.sendNotification(UseMaterialMediator.UMM_USE, e);
					break;
				case MString.EDIT_MATERIAL:
					this.sendNotification(MaterialPanelMediator.MPM_EDIT_MATERIAL, e);
					break;
				case MString.DELETE_MATERIAL:
					this.sendNotification(MaterialPanelMediator.MPM_DELETE_MATERIAL, e);
					break;
				case MString.DEPTH_1:
					this.sendNotification(MapEditPanelMediator2.MEPM_DEPTH, e);
					break;
				case MString.DEPTH_2:
					this.sendNotification(MapEditPanelMediator2.MEPM_DEPTH, e);
					break;				
				case MString.DISPLAY_ROAD:
					this.sendNotification(MapEditPanelMediator2.MEPM_DISPLAY_HIDE_ROAD,e);
					break;
				case MString.HIDE_ROAD:
					this.sendNotification(MapEditPanelMediator2.MEPM_DISPLAY_HIDE_ROAD,e);
					break;									
				case MString.REMOVE:
					this.sendNotification(MapEditPanelMediator2.MEPM_REMOVE,e);
					break;
				case MString.RESET:
					this.sendNotification(MapEditPanelMediator2.MEPM_RESET,e);
					break;
				case MString.CANCEL:
					this.sendNotification(UseMaterialMediator.UMM_CANCEL);
					break;
				case MString.OBJECTINFO:
					this.sendNotification(MapEditPanelMediator2.MEPM_OBJECTINFO,e);
					break;
			}
			e.currentTarget.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuSelect);
		}	
	}
}