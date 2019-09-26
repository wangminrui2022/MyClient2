/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.business.other
{
	import com.consts.*;
	import com.pureMVC.controller.business.common.HelpLoaderCommand;
	import com.pureMVC.controller.business.map.CloseMapCommand;
	import com.pureMVC.controller.business.map.CopyMapImageCommand;
	import com.pureMVC.controller.business.map.SaveMapCommand;
	import com.pureMVC.controller.business.ui.SwitchDepthCommand;
	import com.pureMVC.model.*;
	import com.pureMVC.view.mediator.*;
	import com.pureMVC.view.ui.*;
	import com.vo.common.MessageAlert1VO;
	import com.vo.map.SaveMapVO;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 菜单选择命令
	 * @author wangmingfan
	 */
	public class MenuItemSelectCommand extends SimpleCommand
	{
		//菜单项选择(通知)
		public static const MSC_MENUITEM_SELECT:String="msc_menuitem_select";
		//选择的菜单项
		private var onSelectMenu:String;
		//状态模型层
		private var bindableP:BindableProxy;
		//UI模型层
		private var uiP:UIProxy;
		//地图模型层
		private var mapP:MapProxy;
		
		private var select:String;

		public function MenuItemSelectCommand()
		{
			super();
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
		}

		override public function execute(note:INotification):void
		{
			//取消路点设置
			this.sendNotification(SetRoadMediator.SRM_SETROAD_CANCEL);	
			//取消拖动材质
			this.sendNotification(UseMaterialMediator.UMM_CANCEL);	
			onSelect(note.getBody().toString());			
		}
		/**
		 * 选择
		 * @param str
		 */
		private function onSelect(str:String):void
		{
			//编辑状态
			if(bindableP.SP_editState)
			{
				//保存状态
				if(bindableP.SP_saveState && isOtherState(str))
				{
					select=str;
					onMessageAlert1();
				}
				else
				{
					EditStateTrue(str);
				}
			}
			else
			{
				EditStateFlase(str);
			}		
		}
		
		/**
		 * 消息提示
		 */
		private function onMessageAlert1():void
		{
			var mAlert1:MessageAlert1=MessageAlert1(PopUpManager.createPopUp(uiP.app, MessageAlert1, true));
			PopUpManager.centerPopUp(mAlert1);
			this.facade.registerMediator(new MessageAlert1Mediator(mAlert1));
			var msgVO:MessageAlert1VO=new MessageAlert1VO();
			msgVO.msg=Msg.Msg_18;
			msgVO.confirm=onConfirm;
			msgVO.cancel=onCancel;
			this.sendNotification(MessageAlert1Mediator.MA1M_MESSAGE1, msgVO);
			mAlert1=null;
			msgVO=null;
		}

		/**
		 * 确定选择
		 */
		private function onConfirm():void
		{
			this.sendNotification(MessageAlert1Mediator.MA1M_MESSAGE1_COMPLETE);
			onSaveFileBar();
			EditStateTrue(select);
		}
		/**
		 * 取消选择
		 */
		private function onCancel():void
		{
			this.sendNotification(MessageAlert1Mediator.MA1M_MESSAGE1_COMPLETE);
			EditStateTrue(select);
		}
				
		/**
		 * 编辑状态
		 */
		private function EditStateTrue(str:String):void
		{
			switch (str)
			{
				case MString.CREATEFILEBAR:
					onCloseFileBar();
					onCreateFileBar();
					break;
				case MString.SAVEFILEBAR:
					onSaveFileBar();
					break;
				case MString.CLOSEFILEBAR:
					onCloseFileBar();
					break;
				case MString.OPENFILEBAR:
					onCloseFileBar();
				    onOpenFileBar();
					break;
				case MString.MAPINFOBAR:
					onSceneInfoBar();
					break;	
				case MString.SWITCHBAR:
					onSwitchBar();
					break;	
				case MString.SETMAPBAR:
					onSetSceneBar();
					break;	
				case MString.COPYMAPIMAGEBAR:
					onCopyMapImageBar();
					break;					
				case MString.HELPBAR:
					onHelpBar();
					break;
				case MString.ABOUTBAR:
					onAboutBar();
					break;
			}	
			bindableP=null;
			uiP=null;	
			select=null;				
		}
		/**
		 * 未编辑状态
		 */
		private function EditStateFlase(str:String):void
		{
			switch (str)
			{
				case MString.CREATEFILEBAR:
					onCreateFileBar();
					break;
				case MString.OPENFILEBAR:
					onOpenFileBar();
					break;
				case MString.HELPBAR:
					onHelpBar();
					break;
				case MString.ABOUTBAR:
					onAboutBar();
					break;
			}	
			bindableP=null;
			uiP=null;	
			select=null;		
		}
		/**
		 * 如果地图未保存,检查当前操作是否是以下三个操作
		 * @param str
		 * @return 
		 */
		private function isOtherState(str:String):Boolean
		{
			var bol:Boolean=false;
			switch(str)
			{
				case MString.CREATEFILEBAR:
					bol=true;
					break;
				case MString.CLOSEFILEBAR:
					bol=true;
					break;
				case MString.OPENFILEBAR:
					bol=true;
					break;
			}
			return bol;
		}		
		/**
		 * 新建
		 */
		private function onCreateFileBar():void
		{
			var nc:NewCreate=NewCreate(PopUpManager.createPopUp(uiP.app, NewCreate, true));
			PopUpManager.centerPopUp(nc);
			this.facade.registerMediator(new NewCreateMediator(nc));
			nc=null;
		}
		/**
		 * 保存
		 */
		private function onSaveFileBar():void
		{
			var smVO:SaveMapVO=new SaveMapVO();
			smVO.operateType=SaveMapVO.SM_SAVE_MAP;
			this.sendNotification(SaveMapCommand.SMC_SAVE_MAP,smVO);
		}
		/**
		 * 关闭
		 */
		private function onCloseFileBar():void
		{
			this.sendNotification(CloseMapCommand.CMC_CLOSE_MAP,MString.CLOSEFILEBAR);
		}
		/**
		 * 打开
		 */
		private function onOpenFileBar():void
		{
			this.sendNotification(OpenMapMediator.OMM_OPEN_MAP);
		}
		/**
		 * 地图信息
		 */
		private function onSceneInfoBar():void
		{
			this.sendNotification(MapEditPanelMediator.MEPM_DISPLAY_INFO_PANEL,mapP.getInfo());
		}
		/**
		 * 设置地图
		 */
		private function onSetSceneBar():void
		{
			this.sendNotification(SetMapMediator.SMM_SET_MAP);
		}
		/**
		 *交换地图中UI1和UI2的深度
		 */
		private function onSwitchBar():void
		{
			this.sendNotification(SwitchDepthCommand.SDC_SWITCH_DEPTH);
		}
		/**
		 * 复制地图效果图
		 */
		private function onCopyMapImageBar():void
		{
			this.sendNotification(CopyMapImageCommand.SMIC_COPY_MAP_IMAGE);
		}
		/**
		 * 帮助
		 */
		private function onHelpBar():void
		{
			this.sendNotification(HelpLoaderCommand.HLC_HELPLOADER);
		}
		/**
		 * 关于
		 */
		private function onAboutBar():void
		{
			var about:About=About(PopUpManager.createPopUp(uiP.app, About, true));
			PopUpManager.centerPopUp(about);
			about=null;
		}
	}
}