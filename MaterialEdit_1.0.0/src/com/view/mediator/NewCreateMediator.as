package com.view.mediator
{
	import com.consts.Msg;
	import com.controller.business.BrowseCommand;
	import com.controller.business.CreateDirectoryCommand;
	import com.controller.business.InitDataCommand;
	import com.controller.business.Message2Command;
	import com.controller.business.PageClearCommand;
	import com.controller.business.ValidateCommand;
	import com.view.ui.NewCreate;
	import com.vo.BrowseVO;
	import com.vo.MaterialInfoVO;
	import com.vo.MessageAlert2VO;
	import com.vo.ValidateErrorVO;
	import com.vo.ValidateVO;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 新建材质
	 * @author wangmingfan
	 */
	public class NewCreateMediator extends Mediator
	{
		public static const NAME:String="NewCreateMediator";
		public static const TYPE:String="NewCreateMediator_Type";

		public function NewCreateMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			newCreate.txtPath.text=File.applicationDirectory.nativePath;
			newCreate.browse.addEventListener(MouseEvent.CLICK, onBrowseClick);
			newCreate.confirmBtn.addEventListener(MouseEvent.CLICK, onNewCreate);
		}

		override public function listNotificationInterests():Array
		{
			return [
			BrowseCommand.BROWSE_DIRECTORY_RESULT, 
			CreateDirectoryCommand.CREATE_DIRECTORY_RESULT,
			ValidateCommand.VC_VALIDATA_RESULT];
		}

		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case BrowseCommand.BROWSE_DIRECTORY_RESULT:
					if (note.getType() == TYPE)
						onBrowseDirectoryResult(note.getBody().toString());
					break;
				case CreateDirectoryCommand.CREATE_DIRECTORY_RESULT:
					if (note.getType() == TYPE)
						onCreateDirectoryResult(note.getBody() as Boolean);
					break;
				case ValidateCommand.VC_VALIDATA_RESULT:
					if(note.getType()==TYPE)
						onValidateResult(note.getBody() as ValidateErrorVO);					
					break;
			}
		}

		/**
		 * 选择路径结果
		 * @param body
		 */
		private function onBrowseDirectoryResult(body:String):void
		{
			newCreate.txtPath.text=body;
		}
		/**
		 * 创建目录结果
		 * @param body
		 */
		private function onCreateDirectoryResult(body:Boolean):void
		{
			if(!body)
			{
				errorAlert(Msg.Msg_3,true,70,5,newCreate);
				return;
			}
			var miVO:MaterialInfoVO=new MaterialInfoVO();
			miVO.name=newCreate.sname.text;
			miVO.savePath=newCreate.txtPath.text + "\\" + newCreate.sname.text;
			miVO.serializablePath=miVO.savePath + "\\" + miVO.name + ".mt";
			miVO.materialPath=miVO.savePath + "\\" + miVO.name + ".xml";
			this.sendNotification(MainMediator.CREATE_COMPLETE);
			this.sendNotification(InitDataCommand.INIT_DATA,miVO,"1");
			clear();
		}

		/**
		 * 浏览
		 */
		private function onBrowseClick(e:MouseEvent):void
		{
			var bVO:BrowseVO=new BrowseVO();
			bVO.path=newCreate.txtPath.text;
			bVO.browseType="2";
			this.sendNotification(BrowseCommand.BROWSE_DIRECTORY, bVO, TYPE);
		}

		/**
		 * 创建
		 */
		private function onNewCreate(e:MouseEvent):void
		{
			var vArr:Array=new Array();
			vArr.push(getVlidateVO("材质名称", newCreate.sname.text,true,false));
			vArr.push(getVlidateVO("保存路径", newCreate.txtPath.text,true,false));
			this.sendNotification(ValidateCommand.VC_VALIDATA, vArr, TYPE);	
		}
		/**
		 * 空验证结果
		 * @param nvVO
		 */
		private function onValidateResult(veVO:ValidateErrorVO):void
		{
			if(veVO)
				errorAlert(veVO.result+veVO.vVO.id,true,70,5,newCreate);
			else
				this.sendNotification(CreateDirectoryCommand.CREATE_DIRECTORY, newCreate.txtPath.text + "\\" + newCreate.sname.text, TYPE);
			veVO=null;	
		}
		/**
		 * 返回NewCreate
		 * @return
		 */
		private function get newCreate():NewCreate
		{
			return this.viewComponent as NewCreate;
		}
		/**
		 * 错误消息提示
		 * @param msg
		 * @param position
		 * @param x
		 * @param y
		 * @param appUI
		 */
		private function errorAlert(msg:String,position:Boolean=false,x:int=0,y:int=0,appUI:UIComponent=null):void
		{
	  		var msgVO:MessageAlert2VO=new MessageAlert2VO();
	  		msgVO.msg=msg;
	  		if(position)
	  		{
	  			msgVO.x=x;
	  			msgVO.y=y;
	  			msgVO.appUI=appUI;
	  		}
	  		this.sendNotification(Message2Command.MESSAGE2,msgVO);		
	  		appUI=null;
	  		msgVO=null;
		}		
		/**
		 * 获得验证对象
		 * @param id
		 * @param text
		 * @return 
		 */
		private function getVlidateVO(id:String, text:String,is_Null:Boolean,is_MaxZero:Boolean):ValidateVO
		{
			var vVO:ValidateVO=new ValidateVO();
			vVO.id=id;
			vVO.text=text;
			vVO.is_Null=is_Null;
			vVO.is_MaxZero=is_MaxZero;
			return vVO;
		}			
		/**
		 * 垃圾清理
		 */
		private function clear():void
		{
			this.sendNotification(PageClearCommand.PAGECLEAR, newCreate, "1");
			this.facade.removeMediator(NAME);
			PopUpManager.removePopUp(newCreate);
		}
	}
}