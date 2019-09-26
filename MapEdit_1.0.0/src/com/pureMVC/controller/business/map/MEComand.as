/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.business.map
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.MaterialProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * [保存/打开].me文件
	 * @author Administrator
	 */
	public class MEComand extends SimpleCommand
	{
		public static const MC_ME:String="mc_me";
		
		public static const MC_ME_RESULT:String="mc_me_result";
		
		private var type:String;
		
		private var materialP:MaterialProxy;
		
		private var mapP:MapProxy;
				
		public function MEComand()
		{
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
		}
		override public function execute(note:INotification):void
		{
			type=note.getType();
			/**
			 * note.getBody() 序列化类型
			 * A.序列化
			 * B.反序列化
			 * */			
			if (note.getBody().toString()=="A")
				serializable();
			else
				unSerializable();
			materialP=null;				
		}
		/**
		 * 序列化
		 */
		public function serializable():void
		{
			//创建一个序列化对象oj
			var meOJ:Object={materialTileArr:materialP.materialTileArr};
			var file:File=new File(mapP.map.serializablePath);
			var stream:FileStream=new FileStream();
			try
			{
				stream.open(file, FileMode.WRITE);
				stream.writeObject(meOJ);
			}
			catch (er:Error)
			{
				this.facade.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
			stream.close();
			stream=null;
			file=null;			
			meOJ=null;			
		}
		/**
		 * 反序列化
		 */
		public function unSerializable():void
		{
			var file:File=new File(mapP.map.serializablePath);
			var stream:FileStream=new FileStream();
			var meOJ:Object;
			try
			{
				stream.open(file, FileMode.READ);
				meOJ=stream.readObject();
			}
			catch (er:Error)
			{
				
			}
			stream.close();
			stream=null;
			file=null;
			this.sendNotification(MC_ME_RESULT, meOJ, type);			
		}		
	}
}