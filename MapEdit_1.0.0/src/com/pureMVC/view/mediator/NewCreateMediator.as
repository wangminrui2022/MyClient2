package com.pureMVC.view.mediator
{
	import com.consts.MString;
	import com.consts.Msg;
	import com.mapfile.vo.MInfoVO;
	import com.mapfile.vo.MapVO;
	import com.pureMVC.controller.business.common.*;
	import com.pureMVC.controller.business.ui.CreateMapUI1Command;
	import com.pureMVC.model.*;
	import com.pureMVC.view.ui.NewCreate;
	import com.vo.common.*;
	
	import flash.events.*;
	import flash.filesystem.File;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * NewCreate.mxml
	 * @author Administrator
	 */
	public class NewCreateMediator extends Mediator
	{
		public static const NAME:String="NewCreateMediator";
		public static const TYPE:String="NewCreateMediator_type";
		
		private var mapP:MapProxy;
		
		public function NewCreateMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			newCreate.txtPath.text=File.applicationDirectory.nativePath;
			newCreate.browse.addEventListener(MouseEvent.CLICK, onBrowseClick);
			newCreate.confirmBtn.addEventListener(MouseEvent.CLICK, onNewCreate);
		}

		override public function listNotificationInterests():Array
		{
			return [
			BrowseCommand.BC_BROWSE_DIRECTORY_RESULT, 
			CreateDirectoryCommand.CDC_CREATE_DIRECTORY_RESULT, 
			ValidateCommand.VC_VALIDATA_RESULT];
		}

		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case BrowseCommand.BC_BROWSE_DIRECTORY_RESULT:
					if (note.getType() == TYPE)
						;
					onBrowseDirectoryResult(note.getBody().toString());
					break;
				case CreateDirectoryCommand.CDC_CREATE_DIRECTORY_RESULT:
					if (note.getType() == TYPE)
						;
					onCreateDirectoryResult(note.getBody() as Boolean);
					break;
				case ValidateCommand.VC_VALIDATA_RESULT:
					if (note.getType() == TYPE)
						onValidateResult(note.getBody() as ValidateErrorVO);
					break;
			}
		}

		/**
		 * 创建
		 */
		private function onNewCreate(e:MouseEvent):void
		{
			var vArr:Array=new Array();
			vArr.push(getVlidateVO("地图名称", newCreate.mname.text,true,false,false));
			vArr.push(getVlidateVO("保存路径", newCreate.txtPath.text,true,false,false));
			vArr.push(getVlidateVO("地图宽", newCreate.mapwidth.text,true,true,false));
			vArr.push(getVlidateVO("地图高", newCreate.mapheight.text,true,true,false));
			vArr.push(getVlidateVO("网格高", newCreate.tileHeight.text,true,true,true));
			this.sendNotification(ValidateCommand.VC_VALIDATA, vArr, TYPE);
		}
		/**
		 * 空验证结果
		 * @param nvVO
		 */
		private function onValidateResult(veVO:ValidateErrorVO):void
		{
			if (veVO)
			{
				errorAlert(veVO.result+veVO.vVO.id,true,40,5,newCreate);
				veVO=null;
			}
			else
			{
				var path:String=newCreate.txtPath.text + "\\" + newCreate.mname.text;
				this.sendNotification(CreateDirectoryCommand.CDC_CREATE_DIRECTORY, path, TYPE);
			}
		}
		/**
		 * 获得验证对象
		 * @param id
		 * @param text
		 * @param is_Null
		 * @param is_MaxZero
		 * @param is_Even
		 * @return 
		 */
		private function getVlidateVO(id:String, text:String,is_Null:Boolean,is_MaxZero:Boolean,is_Even:Boolean):ValidateVO
		{
			var vVO:ValidateVO=new ValidateVO();
			vVO.id=id;
			vVO.text=text;
			vVO.is_Null=is_Null;
			vVO.is_MaxZero=is_MaxZero;
			vVO.is_Even=is_Even;
			return vVO;
		}
		/**
		 * 创建结果
		 * @param bol
		 */
		private function onCreateDirectoryResult(bol:Boolean):void
		{
			if (!bol)
			{
				errorAlert(newCreate.mname.text + " " + Msg.Msg_5,true,40,5,newCreate);
				return;
			}
			try
			{
				//获得保存路径
				var savePath:String=newCreate.txtPath.text + "\\" + newCreate.mname.text;		
				//创建地图信息对象
				var info:MInfoVO=new MInfoVO();
				info.name=newCreate.mname.text;
				info.mapType=newCreate.MapType.selectedLabel;
				info.mapwidth=int(newCreate.mapwidth.text);
				info.mapheight=int(newCreate.mapheight.text);
				info.diffuse="null";			
				info.tileHeight=int(newCreate.tileHeight.text);
				info.tileWidth=info.tileHeight<<1;
				//创建地图对象
				mapP.map=new MapVO();
				mapP.map.serializablePath=savePath + "\\" + info.name + MString.ME;
				mapP.map.mapPath=savePath+ "\\" +info.name+MString.MCMAPS;		
				mapP.map.objectsArr=new Array();				
				mapP.map.info=info;
				info=null;
			}
			catch (er:Error)
			{
				mapP.map=null;
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
				return;
			}
			clear();
			//创建UI
			this.sendNotification(CreateMapUI1Command.CMUI1C_CREATE_MAP_UI1,MString.CREATEFILEBAR);				
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
	  		this.sendNotification(Message2Command.MC2_MESSAGE,msgVO);		
	  		appUI=null;
	  		msgVO=null;
		}
		/**
		 * 浏览
		 */
		private function onBrowseClick(e:MouseEvent):void
		{
			var bVO:BrowseVO=new BrowseVO();
			bVO.path=newCreate.txtPath.text;
			bVO.browseType="2";
			this.sendNotification(BrowseCommand.BC_BROWSE_DIRECTORY, bVO, TYPE);
			bVO=null
		}

		/**
		 * 浏览结果
		 * @param path
		 */
		private function onBrowseDirectoryResult(path:String):void
		{
			newCreate.txtPath.text=path;
		}

		/**
		 * 垃圾清理
		 */
		private function clear():void
		{
			mapP=null;
			this.sendNotification(PageClearCommand.PC_PAGECLEAR, newCreate, "1");
			this.facade.removeMediator(NAME);
			PopUpManager.removePopUp(newCreate);
		}

		/**
		 * 返回NewCreate
		 * @return
		 */
		private function get newCreate():NewCreate
		{
			return this.viewComponent as NewCreate;
		}
	}
}