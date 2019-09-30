package com.pureMVC.view.mediator
{
	import com.consts.MString;
	import com.consts.Msg;
	import com.pureMVC.controller.business.common.*;
	import com.pureMVC.controller.business.map.*;
	import com.pureMVC.controller.business.material.MaterialTileArrCommand;
	import com.pureMVC.controller.business.ui.CreateMapUI1Command;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.MaterialProxy;
	import com.vo.common.BrowseVO;
	import com.vo.common.MessageAlert2VO;
	
	import flash.net.FileFilter;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 打开地图
	 * @author 王明凡
	 */
	public class OpenMapMediator extends Mediator
	{
		public static const NAME:String="OpenMapMediator";
		
		public static const TYPE:String="OpenMapMediator_type";
		
		public static const OMM_OPEN_MAP:String="omm_open_map";
				
		private var mapP:MapProxy;
		
		private var materialP:MaterialProxy;
		
		public function OpenMapMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}
		override public function listNotificationInterests():Array
		{
			return [
			OMM_OPEN_MAP,
			BrowseCommand.BC_BROWSE_DIRECTORY_RESULT,
			LoaderMapCommand.LMC_LOADER_MAP_COMPLETE,
			MEComand.MC_ME_RESULT,
			MaterialTileArrCommand.MTC_MATERIALTILEARR_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case OMM_OPEN_MAP:
					onOpenMap();
					break;
				case BrowseCommand.BC_BROWSE_DIRECTORY_RESULT:
					if(note.getType()==TYPE)
						onBrowseDirectoryResult(note.getBody().toString());
					break;	
				case LoaderMapCommand.LMC_LOADER_MAP_COMPLETE:
					if(note.getType()==TYPE)
						onLoaderMapComplete(note.getBody().toString());
					break;	
				case MEComand.MC_ME_RESULT:
					if(note.getType()==TYPE)
						onMeResult(note.getBody());
					break;		
				case MaterialTileArrCommand.MTC_MATERIALTILEARR_COMPLETE:
					if(note.getType()==TYPE)
						onMaterialTileArrComplete(note.getBody() as Boolean);
					break;	
			}
		}
		/**
		 * 打开地图
		 */
		private function onOpenMap():void
		{
		 	var bVO:BrowseVO=new BrowseVO();
		  	bVO.browseType="1";
		  	bVO.fFilter=new FileFilter(MString.MCMAPS, "*"+MString.MCMAPS);
		 	this.sendNotification(BrowseCommand.BC_BROWSE_DIRECTORY,bVO,TYPE);				
		}
		/**
		 * 浏览路径
		 * @param path
		 */
		private function onBrowseDirectoryResult(path:String):void
		{
			//加载地图.map文件
			this.sendNotification(LoaderMapCommand.LMC_LOADER_MAP,path,TYPE);
		}	
		/**
		 * 加载地图.map文件完成
		 */
		private function onLoaderMapComplete(path:String):void
		{
			//设置.map和.me文件路径
			mapP.map.mapPath=path;
			mapP.map.serializablePath=path.replace(MString.MCMAPS,MString.ME);			
			//反序列化.me文件
			this.sendNotification(MEComand.MC_ME,"B",TYPE);
		}
		/**
		 * 反序列化.me文件完成
		 * @param meOJ
		 */
		private function onMeResult(meOJ:Object):void
		{
			if(meOJ==null)
			{
				//清理地图模型层
				mapP.clear();
				errorAlert(Msg.Msg_14);					
			}
			else
			{
				materialP.materialTileArr=meOJ.materialTileArr;
				this.sendNotification(MaterialTileArrCommand.MTC_MATERIALTILEARR,mapP.map.SWFLoaderArr,TYPE);
			}
		}
		/**
		 * 材质平铺数组完成
		 */
		private function onMaterialTileArrComplete(bol:Boolean):void
		{
			if(!bol)
			{
				//清理地图模型层
				mapP.clear();
				//清理材质模型层
				materialP.clear();				
				errorAlert(Msg.Msg_16);	
			}
			else
			{
				this.sendNotification(CreateMapUI1Command.CMUI1C_CREATE_MAP_UI1,MString.OPENFILEBAR);
			}						
		}
		/**
		 * 错误消息提示
		 * @param msg
		 */
		private function errorAlert(msg:String):void
		{
			var msgVO:MessageAlert2VO=new MessageAlert2VO();
			msgVO.msg=msg;
			this.sendNotification(Message2Command.MC2_MESSAGE, msgVO);
		}			
	}
}