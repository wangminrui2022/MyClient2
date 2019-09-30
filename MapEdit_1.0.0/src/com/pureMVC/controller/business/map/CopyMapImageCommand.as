package com.pureMVC.controller.business.map
{
	import com.consts.MString;
	import com.maptype.core.isometric.IsoUtils;
	import com.maptype.core.staggered.StaUtils;
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.UIProxy;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 复制地图效果
	 * @author 王明凡
	 */
	public class CopyMapImageCommand extends SimpleCommand
	{
		public static const SMIC_COPY_MAP_IMAGE:String="smic_copy_map_image";
		
		private var mapP:MapProxy;
		private var uiP:UIProxy;
		
		public function CopyMapImageCommand()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		override public function execute(note:INotification):void
		{
					
			var cW:int;
			var cH:int;
			//获得复制位图的宽高
			if(mapP.map.info.mapType==StaUtils.STAGGERED)
			{
				cW=mapP.tiles.width==0?mapP.map.info.mapwidth:mapP.tiles.width;
				cH=mapP.tiles.height==0?mapP.map.info.mapheight:mapP.tiles.height;
			}
			else
			{
				var rect:Rectangle=IsoUtils.getIsoRect(mapP.map.info.row,mapP.map.info.column,mapP.map.info.tileHeight);
				cW=rect.width;
				cH=rect.height
			}
			var copy:BitmapData=new BitmapData(cW,cH,true,0);
			copy.draw(uiP.mainUI);
			saveCopy(copy);
			copy.dispose();
			copy=null;	
			mapP=null;
			uiP=null;					
		}
		private function saveCopy(copy:BitmapData):void
		{
			try
			{
				var end:int=mapP.map.mapPath.lastIndexOf(MString.MCMAPS);
				var savePath:String=mapP.map.mapPath.substring(0,end)+".png";	
				var byArr:ByteArray=new PNGEncoder().encode(copy);
				var fs:FileStream=new FileStream();
				fs.open(new File(savePath),FileMode.WRITE);
				fs.writeBytes(byArr,0,byArr.length);
				fs.close();
				fs=null;
				byArr.clear();
				byArr=null;			
			}catch(er:Error)
			{
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}