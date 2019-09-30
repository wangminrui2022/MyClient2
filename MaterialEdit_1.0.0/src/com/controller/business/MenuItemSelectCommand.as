package com.controller.business
{
	import com.core.consts.MString;
	import com.model.StateProxy;
	import com.model.UIProxy;
	import com.view.mediator.MessageAlert1Mediator;
	import com.view.mediator.NewCreateMediator;
	import com.view.mediator.OpenMediator;
	import com.view.ui.About;
	import com.view.ui.MessageAlert1;
	import com.view.ui.NewCreate;
	import com.vo.MessageAlert1VO;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 菜单选择命令
	 * @author 王明凡
	 */
	public class MenuItemSelectCommand extends SimpleCommand
	{
		//菜单项选择(通知)
		public static const MENUITEM_SELECT:String="menuitem_select";
		//选择的菜单项
		private var onSelectMenu:String;
		//状态模型层
		private var stateP:StateProxy;
		//UI模型层
		private var uiP:UIProxy;
		
		private var select:String;

		public function MenuItemSelectCommand()
		{
			super();
			stateP=this.facade.retrieveProxy(StateProxy.NAME) as StateProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			onSelect(note.getBody().toString());	
		}
		/**
		 * 选择
		 * @param str
		 */
		private function onSelect(str:String):void
		{
			//编辑状态
			if(stateP.editState)
			{
				//保存状态
				if(stateP.saveState && isOtherState(str))
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
			msgVO.msg="是否保存保存当前材质文件?";
			msgVO.confirm=onConfirm;
			msgVO.cancel=onCancel;
			this.sendNotification(MessageAlert1Mediator.MAM_MESSAGEALERT1, msgVO);
			mAlert1=null;
			msgVO=null;
		}

		/**
		 * 确定选择
		 */
		private function onConfirm():void
		{
			this.sendNotification(MessageAlert1Mediator.MAM_MESSAGEALERT1_RESULT);
			onSaveFileBar();
			EditStateTrue(select);			
		}

		/**
		 * 取消选择
		 */
		private function onCancel():void
		{
			this.sendNotification(MessageAlert1Mediator.MAM_MESSAGEALERT1_RESULT);
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
				case MString.ABOUTBAR:
					onAboutBar();
					break;
			}	
			stateP=null;
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
				case MString.ABOUTBAR:
					onAboutBar();
					break;
			}	
			stateP=null;
			uiP=null;	
			select=null;		
		}
		/**
		 * 如果场景未保存,检查当前操作是否是以下三个操作
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
		 * 新建【选项】
		 */
		private function onCreateFileBar():void
		{
			var newCreate:NewCreate=NewCreate(PopUpManager.createPopUp(uiP.app, NewCreate, true));
			PopUpManager.centerPopUp(newCreate);
			this.facade.registerMediator(new NewCreateMediator(newCreate));
			newCreate=null;
		}

		/**
		 * 保存【选项】
		 */
		private function onSaveFileBar():void
		{
			this.sendNotification(SaveCommand.SC_SAVE);
		}

		/**
		 * 关闭【选项】
		 */
		private function onCloseFileBar():void
		{
			this.sendNotification(CloseCommand.CC_CLOSE);
		}
		/**
		 * 打开【选项】
		 */
		private function onOpenFileBar():void
		{
			this.sendNotification(OpenMediator.OM_OPEN);
		}
		/**
		 * 关于【选项】
		 */
		private function onAboutBar():void
		{
			var about:About=About(PopUpManager.createPopUp(uiP.app, About, true));
			PopUpManager.centerPopUp(about);
			about=null;
		}

	}
}