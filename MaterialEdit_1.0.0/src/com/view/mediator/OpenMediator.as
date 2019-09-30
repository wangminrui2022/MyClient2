package com.view.mediator
{
	import com.controller.business.*;
	import com.model.MaterialProxy;
	import com.vo.*;
	
	import flash.net.FileFilter;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 打开-【选项】
	 * 1.解析材质文件.xml
	 * 2.序列化材质文件.mt
	 * 3.加载swf
	 * @author 王明凡
	 */
	public class OpenMediator extends Mediator
	{
		public static const NAME:String="OpenMediator";
		public static const TYPE_1:String="OpenMediator_type_1";
		public static const TYPE_2:String="OpenMediator_type_2";
		//(通知)
		public static const OM_OPEN:String="om_open";
		
		private var materialP:MaterialProxy;
		private var i:int;
		
		public function OpenMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}

		override public function listNotificationInterests():Array
		{
			return [
			OM_OPEN,
			BrowseCommand.BROWSE_DIRECTORY_RESULT,
			BasicLoaderCommand.BLC_BASICLOADER_COMPLETE,
			BasicLoaderCommand.BLC_BASICLOADER_ERROR,
			SerializableCommand.SERIALIZABLE_RESULT];
		}

		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case OM_OPEN:
					onOpen();
					break;
				case BrowseCommand.BROWSE_DIRECTORY_RESULT:
					if(note.getType()==TYPE_1)
						onBrowseDirectoryResult(note.getBody().toString());
					break;
				case BasicLoaderCommand.BLC_BASICLOADER_COMPLETE:
					if(note.getType()==TYPE_1)
						onBasicLoaderComplete(note.getBody() as BasicLoaderVO);
					else if(note.getType()==TYPE_2)
						onBasicLoaderComplete2(note.getBody() as BasicLoaderVO);
					break;
				case BasicLoaderCommand.BLC_BASICLOADER_ERROR:
					if(note.getType()==TYPE_1)
						errorAlert("材质XML加载错误");
					break;
				case SerializableCommand.SERIALIZABLE_RESULT:
					onSerializableResult(note.getBody() as Array);
					break;
			}
		}

		/**
		 * 打开浏览
		 */
		private function onOpen():void
		{
			var bVO:BrowseVO=new BrowseVO();
			bVO.browseType="1";
			bVO.fFilter=new FileFilter(".xml","*.xml");
			this.sendNotification(BrowseCommand.BROWSE_DIRECTORY,bVO,TYPE_1);
		}
		/**
		 * 浏览完成,获得路径
		 * @param path
		 */
		private function onBrowseDirectoryResult(path:String):void
		{
			var blVO:BasicLoaderVO=new BasicLoaderVO();
			blVO.url=path;
			blVO.type=1;
			this.sendNotification(BasicLoaderCommand.BLC_BASICLOADER,blVO,TYPE_1);	
			blVO=null;		
		}
		/**
		 * 加载xml完成-1
		 * @param blVO
		 */
		private function onBasicLoaderComplete(blVO:BasicLoaderVO):void
		{
			try
			{
				materialP.miVO=new MaterialInfoVO();
				materialP.miVO.name=blVO.name.substring(0,blVO.name.lastIndexOf("."));
				materialP.miVO.savePath=blVO.url.substring(0,blVO.url.lastIndexOf("\\"));
				materialP.miVO.serializablePath=materialP.miVO.savePath+"\\"+materialP.miVO.name+".mt";
				materialP.miVO.materialPath=blVO.url;
				materialP.miVO.materialXML=new XML(blVO.byte);
				blVO=null;
			}catch(er:Error)
			{
				materialP.miVO=null;
				errorAlert("加载材质文件错误");
				return;				
			}
			this.sendNotification(SerializableCommand.SERIALIZABLE,materialP.miVO.serializablePath,"2");
		}
		/**
		 * 序列化完成-2
		 * @param arr
		 */
		private function onSerializableResult(arr:Array):void
		{
			if(!arr)
			{
				materialP.miVO=null;
				errorAlert("加载材质文件(.mt)错误");
				return;
			}
			materialP.materialNodeVOArr=arr;
			//确定序列化的材质节点集合里有材质节点
			if(materialP.materialNodeVOArr.length>0)
			{
				this.sendNotification(ProgressReportMediator.PRM_PROGRESS);
				loop();
			}
			else
			{
				this.sendNotification(MainMediator.CREATE_COMPLETE);
				this.sendNotification(InitDataCommand.INIT_DATA,null,"2");				
			}
		}
		/**
		 * 循环加载swf
		 */
		private function loop():void
		{
			var blVO:BasicLoaderVO=new BasicLoaderVO();
			blVO.url=materialP.miVO.savePath+"\\"+materialP.materialNodeVOArr[i].label;
			blVO.type=2;
			this.sendNotification(BasicLoaderCommand.BLC_BASICLOADER,blVO,TYPE_2);		
			blVO=null;	
		}	
		/**
		 * 加载xml完成-3
		 * @param blVO
		 */
		private function onBasicLoaderComplete2(blVO:BasicLoaderVO):void
		{
	  		//加载
	  		var pgVO:ProgressReportVO=new ProgressReportVO();
	  		pgVO.descreption="加载中";
	 		pgVO.load=(i+1);
	  		pgVO.total=materialP.materialNodeVOArr.length;
	  		this.sendNotification(ProgressReportMediator.PRM_PROGRESS_LOAD,pgVO);		
			materialP.setMaterialNodeArrLoaderInfo(blVO);		
			if((i+1)==materialP.materialNodeVOArr.length)
			{
				i=0;
				this.sendNotification(ProgressReportMediator.PRM_PROGRESS_COMPLETE);
				this.sendNotification(MainMediator.CREATE_COMPLETE);
				this.sendNotification(InitDataCommand.INIT_DATA,null,"2");	
			}
			else
			{	
				i++;	
				loop();
			}
	  		pgVO=null;				
			blVO=null;
		}	
		/**
		 * 错误消息提示
		 * @param msg
		 */
		private function errorAlert(msg:String):void
		{
	  		var msgVO:MessageAlert2VO=new MessageAlert2VO();
	  		msgVO.msg=msg;
	  		this.sendNotification(Message2Command.MESSAGE2,msgVO);			
		}
	}
}