package com.view.mediator
{
	import com.controller.business.*;
	import com.model.*;
	import com.view.ui.*;
	import com.vo.*;
	
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 
	 * @author wangmingfan
	 */
	public class MaterialPanelMediator extends Mediator
	{
		public static const NAME:String="MaterialPanelMediator";
		public static const TYPE:String="MaterialPanelMediator_Type";
		//导入材质(通知)
		public static const IMPORT_MATERIAL:String="import_material";	
		//删除材质(通知)
		public static const DELETE:String="delete";
		//添加节点(通知)
		public static const ADDNODE:String="addnode";
		
		private var materialP:MaterialProxy;
		private var uiP:UIProxy;
		private var assetP:AssetProxy;
		private var bindableP:BindableProxy;
		
		public function MaterialPanelMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			assetP=this.facade.retrieveProxy(AssetProxy.NAME) as AssetProxy;
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			materialPanel.swf=assetP.swf;
		}
		override public function listNotificationInterests():Array
		{
			return [
			IMPORT_MATERIAL,
			DELETE,
			BrowseCommand.BROWSE_DIRECTORY_RESULT,
			BasicLoaderCommand.BLC_BASICLOADER_COMPLETE,
			ADDNODE,
			MainMediator.MEMM_CLOSE_COMPLETE,
			MainMediator.CREATE_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case DELETE:
					onDelete();
					break;
				case IMPORT_MATERIAL:
					onImportMaterial();
					break;
				case BrowseCommand.BROWSE_DIRECTORY_RESULT:
					if(note.getType()==TYPE)
						onBrowseDirectoryResult(note.getBody().toString());
					break;
				case BasicLoaderCommand.BLC_BASICLOADER_COMPLETE:
					if(note.getType()==TYPE)
						onBasicLoadderComplete(note.getBody() as BasicLoaderVO);
					break;
				case ADDNODE:
					onAddNode();
					break;
				case MainMediator.CREATE_COMPLETE:
					materialPanel.updateTreeNode(materialP.materialNodeVOArr);	
					break;
				case MainMediator.MEMM_CLOSE_COMPLETE:
					//更新节点
					materialPanel.updateTreeNode(materialP.materialNodeVOArr);						
					break;
			}
		}
		/**
		 * 删除【选项】
		 * */
		private function onDelete():void
		{
			var index:int=materialPanel.trees.selectedIndex;	
			if(index!=-1)
			{			
				//删除以及删除磁盘swf
				deleteFile(materialP.miVO.savePath+"\\"+materialPanel.trees.selectedItem.label);
				materialP.materialNodeVOArr.splice(index, 1);
				//序列化节点集合
				this.sendNotification(SerializableCommand.SERIALIZABLE,null,"1");
				//更新节点
				materialPanel.updateTreeNode(materialP.materialNodeVOArr);			
			}
			else
			{
			  	var msgVO:MessageAlert2VO=new MessageAlert2VO();
			  	msgVO.msg="请选中材质面板中的节点";
			  	this.sendNotification(Message2Command.MESSAGE2,msgVO);					
			}	
		}	
		/**
		 * 删除磁盘上的swf
		 * @param path
		 */
		private function deleteFile(path:String):void
		{
			var file:File;
			try
			{
				file=new File(path);
				if(file.exists)
					file.deleteFile();				
			}catch(er:Error)
			{
			
			}
			file=null;
		}	
		/**
		 * 导入材质【选项】
		 */
		private function onImportMaterial():void
		{
			var bVO:BrowseVO=new BrowseVO();
			bVO.browseType="1";
			bVO.fFilter=new FileFilter(".swf", "*.swf");
			this.sendNotification(BrowseCommand.BROWSE_DIRECTORY,bVO,TYPE);			
		}	
		/**
		 * 浏览选择的材质文件
		 * @param path
		 */
		private function onBrowseDirectoryResult(path:String):void
		{
			var blVO:BasicLoaderVO=new BasicLoaderVO();
			blVO.url=path;
			blVO.type=2;
			this.sendNotification(BasicLoaderCommand.BLC_BASICLOADER,blVO,TYPE);
		}
		/**
		 * 导入材质完成
		 * @param li
		 */
		private function onBasicLoadderComplete(blVO:BasicLoaderVO):void
		{
			try
			{
				var mnVO:MaterialNodeVO=new MaterialNodeVO();
				mnVO.loaderInfo=blVO.loaderInfo;
				mnVO.byte=blVO.byte;
				mnVO.label=blVO.name;	
					
				materialP.materialNodeVOArr.push(mnVO);
				//更新节点
				materialPanel.updateTreeNode(materialP.materialNodeVOArr);	
				//写入文件
		   		var fVO:FileVO=new FileVO();
		   		fVO.file=new File(materialP.miVO.savePath+"\\"+mnVO.label);
		   		fVO.byte=mnVO.byte;
		   		fVO.workType="write";
		   		this.sendNotification(FileCommand.FILE, fVO,TYPE);
		   		//清空字节数组		
		   		mnVO.byte.clear();
		   		mnVO.byte=null;	
				//序列化节点集合
				this.sendNotification(SerializableCommand.SERIALIZABLE,null,"1");		   		
		   		blVO=null;	
		   		mnVO=null;
			}catch(er:Error)
			{
				this.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
			}	   			
		}	
		/**
		 *  添加节点【选项】
		 */
		private function onAddNode():void
		{
			var tmp:Object=materialPanel.trees.selectedItem;
			if(tmp)
			{
				var matp:MaterialAttributePanel=MaterialAttributePanel(PopUpManager.createPopUp(uiP.app, MaterialAttributePanel, true));
				PopUpManager.centerPopUp(matp);
				this.facade.registerMediator(new MaterialAttributePanelMeidator(matp));
				this.sendNotification(MaterialAttributePanelMeidator.MAPM_ADDNODE,tmp);
				matp=null;				
			}
			else
			{
			  	var msgVO:MessageAlert2VO=new MessageAlert2VO();
			  	msgVO.msg="请选中材质面板中的节点";
			  	this.sendNotification(Message2Command.MESSAGE2,msgVO);					
			}
			tmp=null;
		
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