package com.controller.business
{
	import com.model.MaterialProxy;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 保存材质png图片
	 * @author 王明凡
	 */
	public class SaveImageCommand extends SimpleCommand
	{
		public static const SIC_SAVE_IMAGE:String="sic_save_image";
		
		public static const SIC_SAVE_IMAGE_COMPLETE:String="sic_save_image_complete";
		
		private var materialP:MaterialProxy;

		public function SaveImageCommand()
		{
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}

		override public function execute(note:INotification):void
		{
			var bol:Boolean;
			var meOJ:Object=note.getBody();
			try
			{
				var savePath:String=materialP.miVO.savePath + "\\" + meOJ.param2.toString() + ".png";
				var byArr:ByteArray=new PNGEncoder().encode(meOJ.param1 as BitmapData);
				var fs:FileStream=new FileStream();
				fs.open(new File(savePath), FileMode.WRITE);
				fs.writeBytes(byArr, 0, byArr.length);
				fs.close();
				fs=null;
				byArr.clear();
				byArr=null;
				meOJ.param1.dispose();
				meOJ.param1=null;	
				bol=true;			
			}
			catch (er:Error)
			{
				bol=false;
			}
			this.sendNotification(SIC_SAVE_IMAGE_COMPLETE,bol);
			meOJ=null;
			materialP=null;
		}
	}
}