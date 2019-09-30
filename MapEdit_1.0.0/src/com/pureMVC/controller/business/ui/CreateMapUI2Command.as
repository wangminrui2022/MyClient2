/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.ui
{
	import com.mapfile.core.MSaveMap;
	
	import mx.collections.ArrayCollection;
	
	import com.consts.MString;
	import com.pureMVC.controller.business.map.AddObjectsArrayCommand;
	import com.pureMVC.controller.business.map.MEComand;
	import com.pureMVC.controller.business.map.SaveMapCommand;
	import com.pureMVC.model.*;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.map.SaveMapVO;


	/**
	 * 
	 * @author 王明凡
	 */
	public class CreateMapUI2Command extends SimpleCommand
	{
		public static const CMUI2C_CREATE_MAP_UI2:String="cmui2c_create_map_ui2";
		//创建地图UI完成(通知)
		public static const CREATE_MAP_UI_COMPLETE:String="create_map_ui_complete";
				
		private var operateType:String;
		//地图模型层
		private var mapP:MapProxy;
		//UI模型层
		private var uiP:UIProxy; 
		//数据绑定模型层
		private var bindableP:BindableProxy;
		//材质模型层
		private var materialP:MaterialProxy;	
				
		public function CreateMapUI2Command()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}
		override public function execute(note:INotification):void
		{
			//操作类型(新建,打开)
			operateType=note.getBody().toString();
			//设置UI2属性(位图缓存策略,宽,高)
			uiP.setUIAttribute(uiP.ui2,mapP.grid.width,mapP.grid.height);		
			//初始化BindableProxy
			bindableP.init();			
			//初始化MapProxy
			mapP.mSave=new MSaveMap(mapP.map.mapPath);					
			if (operateType == MString.OPENFILEBAR)
				onOpen();
			else
				onNewCreate();									
		}	
		/**
		 * 新建
		 */
		private function onNewCreate():void
		{
			//初始化MaterialProxy
			materialP.materialTileArr=new ArrayCollection();
			//保存.me
			this.sendNotification(MEComand.MC_ME,"A");
			//保存.map
			var smVO:SaveMapVO=new SaveMapVO();
			smVO.operateType=SaveMapVO.SM_SAVE_MAP;			
			this.sendNotification(SaveMapCommand.SMC_SAVE_MAP,smVO);			
			//垃圾清理
			clear();
			//创建完成
			this.sendNotification(CreateMapUI2Command.CREATE_MAP_UI_COMPLETE,operateType);
		}	
		/**
		 * 打开
		 */
		private function onOpen():void
		{
			//初始化MapProxy
			mapP.map.objectsArr=new Array();			
			//如果该地图文件有swf字节数组,将当前读到的swf字节数组保存到.map的字节数组
			if(mapP.map.SWFByteArr)
			{
				var smVO:SaveMapVO=new SaveMapVO();
				smVO.operateType=SaveMapVO.SM_MATERIAL
				smVO.SWFByteArr=mapP.map.SWFByteArr;		
				this.sendNotification(SaveMapCommand.SMC_SAVE_MAP,smVO);				
			}
			if(mapP.map.info.mObjectsVOArr)
			{
				//垃圾清理
				clear();			
				//添加Objects对象	
				this.sendNotification(AddObjectsArrayCommand.AOAC_ADD_OBJECTS_ARRAY,operateType);								
			}
			else
			{
				//垃圾清理
				clear();				
				//创建完成
				this.sendNotification(CreateMapUI2Command.CREATE_MAP_UI_COMPLETE,operateType);					
			}
		}						
		/**
		 * 垃圾清理,删除引用
		 */
		private function clear():void
		{
			mapP=null;
			uiP=null;	
			bindableP=null;	
			materialP=null;		
		}				
	}
}