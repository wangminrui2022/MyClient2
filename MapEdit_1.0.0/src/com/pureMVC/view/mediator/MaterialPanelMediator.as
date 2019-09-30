package com.pureMVC.view.mediator
{
	import com.consts.MString;
	import com.consts.Msg;
	import com.pureMVC.controller.business.common.*;
	import com.pureMVC.controller.business.map.*;
	import com.pureMVC.controller.business.material.MaterialLoaderCommand;
	import com.pureMVC.controller.business.material.URMapMaterialCommand;
	import com.pureMVC.controller.business.ui.CreateMapUI2Command;
	import com.pureMVC.model.MaterialProxy;
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.ui.EditMaterial;
	import com.pureMVC.view.ui.MaterialPanel;
	import com.pureMVC.view.ui.as_.OnlyImage;
	import com.vo.common.BrowseVO;
	import com.vo.common.FileVO;
	import com.vo.common.MessageAlert2VO;
	import com.vo.map.SaveMapVO;
	import com.vo.material.MaterialVO;
	import com.vo.material.URMapMaterialVO;
	
	import flash.events.ContextMenuEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 材质面板
	 * @author 王明凡
	 */
	public class MaterialPanelMediator extends Mediator
	{
		public static const NAME:String="MaterialPanelMediator";
		
		public static const TYPE:String="MaterialPanelMediator_type";
		//导入材质(通知)
		public static const MPM_IMPORT_MATERIAL:String="mpm_import_material";
		//编辑材质(通知)
		public static const MPM_EDIT_MATERIAL:String="mpm_edit_material";
		//删除材质(通知)
		public static const MPM_DELETE_MATERIAL:String="mpm_delete_material";		
		//更新材质(通知)
		public static const MPM_UPDATE_MATERIAL:String="mpm_update_material";	
			
		private var materialP:MaterialProxy;
		
		private var uiP:UIProxy;
		/**
		 * 
		 * @param viewComponent
		 */
		public function MaterialPanelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		override public function listNotificationInterests():Array
		{
			return [
			MPM_IMPORT_MATERIAL,
			BrowseCommand.BC_BROWSE_DIRECTORY_RESULT,
			FileCommand.FC_FILE_COMPLETE,
			FileCommand.FC_FILE_ERROR,
			MaterialLoaderCommand.MLC_MATERIAL_LOADER_COMPLETE,
			MPM_DELETE_MATERIAL,
			MPM_EDIT_MATERIAL,
			CloseMapCommand.CMC_CLOSE_MAP_COMPLETE,
			CreateMapUI2Command.CREATE_MAP_UI_COMPLETE,
			MPM_UPDATE_MATERIAL,
			URMapMaterialCommand.URMMC_MAP_MATERIAL_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case MPM_IMPORT_MATERIAL:
					onImportMaterial();
					break;
				case BrowseCommand.BC_BROWSE_DIRECTORY_RESULT:
					if(note.getType()==TYPE)
						onBrowseDirectoryResult(note.getBody().toString());
					break;
				case FileCommand.FC_FILE_COMPLETE:
					if(note.getType()==TYPE)
						onFileComplete(note.getBody() as ByteArray);
					break;
				case FileCommand.FC_FILE_ERROR:
					if(note.getType()==TYPE)
						onError(Msg.Msg_2);
					break;
				case MaterialLoaderCommand.MLC_MATERIAL_LOADER_COMPLETE:
					if(note.getType()==TYPE)
						onMaterialLoaderComplete(note.getBody() as MaterialVO);
					break;
				case MPM_DELETE_MATERIAL:
						onDeleteMaterial(note.getBody() as ContextMenuEvent);
					break;
				case MPM_EDIT_MATERIAL:
						onEditMaterial(note.getBody() as ContextMenuEvent);
					break;
				case CloseMapCommand.CMC_CLOSE_MAP_COMPLETE:
					if(note.getBody().toString()==MString.CLOSEFILEBAR)
						materialPanel.clear();			
					break;
				case CreateMapUI2Command.CREATE_MAP_UI_COMPLETE:
					if(note.getBody().toString()==MString.OPENFILEBAR)
						//更新TileList显示			
						materialPanel.updateTileList(materialP.materialTileArr);
					break;
				case MPM_UPDATE_MATERIAL:
						//更新TileList显示			
						materialPanel.updateTileList(materialP.materialTileArr);				
					break;
				case URMapMaterialCommand.URMMC_MAP_MATERIAL_COMPLETE:
						onMapMaterialComplete(note.getBody() as OnlyImage);
					break;
			}
		}
		/**
		 * 导入材质【选项】
		 */
		private function onImportMaterial():void
		{
			var bVO:BrowseVO=new BrowseVO();
			bVO.browseType="1";
			bVO.fFilter=new FileFilter(".xml", "*.xml");
			this.sendNotification(BrowseCommand.BC_BROWSE_DIRECTORY,bVO,TYPE);
		}
		/**
		 * 浏览结果
		 * @param path
		 */
		private function onBrowseDirectoryResult(path:String):void
		{
			var fVO:FileVO=new FileVO();
			fVO.file=new File(path);
			this.sendNotification(FileCommand.FC_FILE,fVO,TYPE);
		}	
		/**
		 * 读取材质xml完成
		 * @param byte
		 */
		private function onFileComplete(byte:ByteArray):void
		{
			this.sendNotification(MaterialLoaderCommand.MLC_MATERIAL_LOADER,new XML(byte),TYPE);
		}	
		/**
		 * 错误消息提示
		 * @param msg
		 */
		private function onError(msg:String):void
		{
	  		var msgVO:MessageAlert2VO=new MessageAlert2VO();
	  		msgVO.msg=msg;
	  		this.sendNotification(Message2Command.MC2_MESSAGE,msgVO);		
		}
		/**
		 * 导入材质swf完成
		 * @param mtVO
		 */
		private function onMaterialLoaderComplete(mtVO:MaterialVO):void
		{ 	
			//将导入材质添加材质平铺数组	
			materialP.addMaterialTileArr(mtVO);					
			//更新TileList显示
			materialPanel.updateTileList(materialP.materialTileArr);
			//序列化材质到本地.me文件
			this.sendNotification(MEComand.MC_ME,"A");				
			//保存材质字节数组到.map文件
			var smVO:SaveMapVO=new SaveMapVO();
			smVO.operateType=SaveMapVO.SM_SAVE_MAP_MATERIAL;
			smVO.SWFByteArr=mtVO.byteVOArr;		
			this.sendNotification(SaveMapCommand.SMC_SAVE_MAP,smVO);
			//清空mtVO临时对象
			mtVO.clear();								
			mtVO=null;
		}
		/**
		 * 删除材质【选项】
		 * @param e
		 */
		private function onDeleteMaterial(e:ContextMenuEvent):void
		{
			//删除场景中的显示的对象
			var urmmVO:URMapMaterialVO=new URMapMaterialVO();
			urmmVO.operateType=URMapMaterialVO.DELETE;
			urmmVO.oj=materialP.getOnlyImage(e);
			this.sendNotification(URMapMaterialCommand.URMMC_MAP_MATERIAL,urmmVO);	
			urmmVO=null;
		}
		/**
		 * 删除材质-删除场景中的显示的对象完成
		 * @param onlyImage
		 */
		private function onMapMaterialComplete(onlyImage:OnlyImage):void
		{
			// 删除材质平铺对象
			materialP.deleteMaterialTileVO(onlyImage.mTileVO.mdVO.name);
			//序列化材质到本地.me文件
			this.sendNotification(MEComand.MC_ME,"A");	
			//更新TileList显示
			materialPanel.updateTileList(materialP.materialTileArr);		
			onlyImage=null		
		}
		/**
		 * 编辑材质【选项】
		 * @param e
		 */
		private function onEditMaterial(e:ContextMenuEvent):void
		{	
			var tmpOI:OnlyImage=materialP.getOnlyImage(e);
			if(tmpOI)
			{
				var editMaterial:EditMaterial=EditMaterial(PopUpManager.createPopUp(uiP.app,EditMaterial,true));
				PopUpManager.centerPopUp(editMaterial);
				this.facade.registerMediator(new EditMaterialMediator(editMaterial));
				this.sendNotification(EditMaterialMediator.EMM_EDIT_MATERIAL,tmpOI.mTileVO);	
				editMaterial=null;			
			}	
			tmpOI=null;
		}		
		/**
		 * 
		 * @return 
		 */
		private function get materialPanel():MaterialPanel
		{
			return this.viewComponent as MaterialPanel;
		}
	}
}