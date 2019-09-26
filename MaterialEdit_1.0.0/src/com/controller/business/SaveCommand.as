package com.controller.business
{
	
	import com.model.MaterialProxy;
	import com.vo.FileVO;
	import com.vo.MaterialDefinitionVO;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 保存场景
	 * @author wangmingfan
	 */
	public class SaveCommand extends SimpleCommand
	{
		//(通知)
		public static const SC_SAVE:String="sc_save";
		
		private var materialP:MaterialProxy;
		
		public function SaveCommand()
		{
			super();
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}

		override public function execute(note:INotification):void
		{
			try
			{
				var file:File=new File(materialP.miVO.materialPath);
				//组成xml文件
				setMaterialXML();
				var byte:ByteArray=new ByteArray();
				byte.writeUTFBytes(materialP.miVO.materialXML.toXMLString());
				//文件流的形式读取xml
		 		var fVO:FileVO=new FileVO();
		 		fVO.file=file;
		 		fVO.byte=byte;
		 		fVO.workType="write";
				this.sendNotification(FileCommand.FILE, fVO, "保存使用");	
		  		//保存场景完成垃圾清理
		  		materialP.miVO.materialXML=null;
				file=null;	
				byte=null;
				fVO=null;	
				//发送保存状态
				this.sendNotification(EditStateCommand.ESC_EDITSTATE,false);
							  		
			}catch(er:Error)
			{
				this.facade.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
			}	  		
		}
		/**
		 *组成场景xml
		 */
		private function setMaterialXML():void
		{
			try
			{
				materialP.miVO.materialXML=<definitions></definitions>;
				mediaNode(materialP.miVO.materialXML);
				materialDefinitionNode(materialP.miVO.materialXML)
			}
			catch (er:Error)
			{
				this.facade.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
			}

		}
		/**
		 * <media>节点
		 * @param xml
		 */
		private function mediaNode(xml:XML):void
		{
			for(var i:int=0;i<materialP.materialNodeVOArr.length;i++)
			{
				xml.appendChild(<media/>);
				xml.media[i].@src=materialP.miVO.savePath+"\\"+materialP.materialNodeVOArr[i].label;
			}
		}
		/**
		 * <materialDefinition>节点
		 * @param xml
		 */
		private function materialDefinitionNode(xml:XML):void
		{
			for(var i:int=0;i<materialP.miVO.MaterialDefinitionVOArr.length;i++)
			{
				var mdVO:MaterialDefinitionVO=materialP.miVO.MaterialDefinitionVOArr[i] as MaterialDefinitionVO;
				xml.appendChild(<materialDefinition/>);
				xml.materialDefinition[i].@name=mdVO.name;
				xml.materialDefinition[i].@type=mdVO.type;
				xml.materialDefinition[i].@used=mdVO.used;
				xml.materialDefinition[i].@width=mdVO.width;
				xml.materialDefinition[i].@height=mdVO.height;
				xml.materialDefinition[i].@elementType=mdVO.elementType;
				xml.materialDefinition[i].appendChild(<diffuse/>);
				xml.materialDefinition[i].diffuse=mdVO.diffuse;				
			}
		}		
	}
}