/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.material
{
	import com.mapfile.vo.MMaterialDefinitionVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import com.basic.MaterialLoader;
	import com.consts.Msg;
	import com.pureMVC.controller.business.common.Message2Command;
	import com.pureMVC.view.mediator.ProgressReportMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.common.MessageAlert2VO;
	import com.vo.common.ProgressReportVO;
	import com.vo.material.MaterialVO;

	/**
	 * 材质加载
	 * @author 王明凡
	 */
	public class MaterialLoaderCommand extends SimpleCommand
	{
		//材质加载(通知)
		public static const MLC_MATERIAL_LOADER:String="mlc_material_loader";
		
		public static const MLC_MATERIAL_LOADER_COMPLETE:String="mlc_material_loader_complete";	
			
		private var type:String;
		
		public function MaterialLoaderCommand()
		{

		}
		override public function execute(note:INotification):void
		{
			type=note.getType();
			//进度条
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS);		
			var ml:MaterialLoader=new MaterialLoader();
			ml.addEventListener(Event.COMPLETE, onComplete);
			ml.addEventListener(ProgressEvent.PROGRESS,onProgress);
			ml.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			ml.onLoader(note.getBody() as XML);			
		}
		/**
		 * 加载完成
		 * @param e
		 */
		private function onComplete(e:Event):void
		{
			var ml:MaterialLoader=e.currentTarget as  MaterialLoader;
			var tmp:MaterialVO=ml.getMaterialVO();
			try
			{
				tmp.MaterialDefinitionVOArr=getMaterialDefinitionVOArr(tmp.xml.materialDefinition);	
			}catch(er:Error)
			{
				tmp=null;
				onIoErrorMessage(ml,Msg.Msg_8);
				return;
			}
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS_COMPLETE); 				
			this.sendNotification(MLC_MATERIAL_LOADER_COMPLETE,tmp,type);
			onClearMaterialLoader(ml);
			ml=null;
		}
		/**
		 * 加载过程
		 * @param e
		 */
		private function onProgress(e:ProgressEvent):void
		{
			var pgVO:ProgressReportVO=new ProgressReportVO();
			pgVO.descreption=Msg.Msg_12;
			pgVO.load=e.bytesLoaded;
			pgVO.total=e.bytesTotal;
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS_LOAD, pgVO);	
		}
		/**
		 * 加载错误
		 * @param e
		 */
		private function onIoError(e:IOErrorEvent):void
		{
			onIoErrorMessage(e.currentTarget as MaterialLoader,Msg.Msg_3);
		}
		/**
		 * 加载错误消息提示
		 * @param ml
		 * @param msg
		 */
		private function onIoErrorMessage(ml:MaterialLoader,msg:String):void
		{
			this.sendNotification(ProgressReportMediator.PRM_PROGRESS_COMPLETE); 			
			onClearMaterialLoader(ml);
			ml=null;
	  		var msgVO:MessageAlert2VO=new MessageAlert2VO();
	  		msgVO.msg=msg;
	  		this.sendNotification(Message2Command.MC2_MESSAGE,msgVO);				
		}
		/**
		 * 导入垃圾清理
		 * @param e
		 */
		private function onClearMaterialLoader(ml:MaterialLoader):void
		{
			ml.removeEventListener(Event.COMPLETE, onComplete);
			ml.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			ml.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			ml.clear();
			ml=null;
		}	
		/**
		 * 获得材质对象集合
		 * @param xmlList
		 * @return 
		 */
		private function getMaterialDefinitionVOArr(xmlList:XMLList):Array
		{
			var tmp:Array=new Array();
			for each(var xml:XML in xmlList)
			{
				var md:MMaterialDefinitionVO=new MMaterialDefinitionVO();
				md.name=xml.@name;
				md.type=xml.@type;
				md.used=xml.@used;
				md.width=xml.@width;
				md.height=xml.@height;
				md.elementType=xml.@elementType;
				md.diffuse=xml.diffuse;		
				tmp.push(md);	
			}
			return tmp;			
		}
//		/**
//		 * 获得材质文件名集合
//		 * @param xmlList
//		 * @return 
//		 */
//		private function getMaterialFileNameArr(xmlList:XMLList):Array
//		{
//			var tmp:Array=new Array();
//			for each(var xml:XML in xmlList)
//			{
//				var fileName:String=getFileName(xml.@src.toXMLString());
//				tmp.push(fileName);
//			}
//			return tmp;				
//		}
//		/**
//		 * 获得文件名,"/" 替换 "\\"
//		 * @param url
//		 * @return 
//		 */
//		private function getFileName(url:String):String
//		{
//			var urlPattern:RegExp =/[\/]/g;	
//			var str:String=url.replace(urlPattern,"\\");
//			var name:String=str.substring(str.lastIndexOf("\\")+1,str.length);	
//			urlPattern=null;
//			return name;			
//		}		
			
	}
}