package com.controller.business
{
	import com.model.MaterialProxy;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 序列化/反序列化
	 * @author wangmingfan
	 */
	public class SerializableCommand extends SimpleCommand
	{
		//序列化(通知)
		public static const SERIALIZABLE:String="serializable";
		//序列化结果(通知)
		public static const SERIALIZABLE_RESULT:String="serializable_result";

		[RemoteClass]
		private var materialP:MaterialProxy;

		public function SerializableCommand()
		{
			super();
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}
		override public function execute(note:INotification):void
		{
			//1.序列化,2.反序列化
			if(note.getType()=="1")
				serializable(materialP.miVO.serializablePath);
			else
				unSerializable(materialP.miVO.serializablePath)
		}
		/**
		 * 序列化
		 * @param path
		 */
		public function serializable(path:String):void
		{
			var file:File=new File(path);
			var stream:FileStream=new FileStream();
			try
			{
				stream.open(file,FileMode.WRITE);
				stream.writeObject(materialP.materialNodeVOArr);
				stream.close();			
			}catch(er:Error)
			{
				this.facade.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());		
			}
			stream=null;
			file=null;
		}
		
		/**
		 * 反序列化
		 * @param path
		 * @return 
		 */
		public function unSerializable(path:String):void
		{
			var file:File=new File(path);
			var stream:FileStream=new FileStream();		
			var tmp:Array;
			try
			{
				stream.open(file,FileMode.READ);
				tmp=stream.readObject();
				stream.close();				
			}
			catch(er:Error)
			{
				
			}
			stream=null;
			file=null;			
			this.sendNotification(SERIALIZABLE_RESULT,tmp);
		}				
	}
}