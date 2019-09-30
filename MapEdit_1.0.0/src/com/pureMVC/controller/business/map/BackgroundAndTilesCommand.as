/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.map
{
	import com.consts.MString;
	import com.map.Background;
	import com.maptype.core.Tiles;
	import com.maptype.core.staggered.StaUtils;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.MaterialProxy;
	import com.pureMVC.model.UIProxy;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 背景和平铺地砖
	 * @author 王明凡
	 */
	public class BackgroundAndTilesCommand extends SimpleCommand
	{
		//创建UI1(通知)
		public static const BATC_BACKGROUND_AND_TILES:String="batc_background_and_tiles";

		private var mapP:MapProxy;
		
		private var uiP:UIProxy;
		
		private var materialP:MaterialProxy;
		
		public function BackgroundAndTilesCommand()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}

		override public function execute(note:INotification):void
		{
			//操作类型(新建,打开)
			var operateType:String=note.getBody().toString();
			//如果是创建交错排列类型地图，需要创建背景层
			if (mapP.map.info.mapType == StaUtils.STAGGERED)
			{
				if (!mapP.background)
					mapP.background=new Background();
				mapP.background.clear();
				mapP.background.drawBackground(mapP.grid.width, mapP.grid.height);
				if (!mapP.background.parent)
				{
					uiP.ui1.addChild(mapP.background);
					uiP.ui1.setChildIndex(mapP.background, 0);
				}
			}
			else
			{
				if (mapP.background)
				{
					uiP.ui1.removeChild(mapP.background);
					mapP.background.clear();
					mapP.background=null;
				}
			}
			//平铺地砖层
			if(!mapP.tiles)
				mapP.tiles=new Tiles();
			if (operateType == MString.OPENFILEBAR && mapP.map.info.diffuse != "null")
			{
				var cls:Class=materialP.getClass(mapP.map.info.diffuse);
				var data:BitmapData=getTile(cls);
				mapP.tiles.onTiles(
				mapP.map.info.mapType,
				data,
				mapP.map.info.row,
				mapP.map.info.column,
				mapP.map.info.tileHeight);
				cls=null;
				data=null;
			}
			mapP=null;
			uiP=null;
			materialP=null;
		}
		/**
		 * 获得地砖单个位图
		 * @param cls
		 * @return 
		 */
		private function getTile(cls:Class):BitmapData
		{
			var dataBM:BitmapData;
			var dataMC:MovieClip;	
			try
			{
				dataBM=new cls(null,null) as BitmapData;
			}catch(er:Error)
			{
				dataMC=new cls() as MovieClip;
				dataBM=new BitmapData(dataMC.width,dataMC.height,true,0);
				dataBM.draw(dataMC);
				dataMC=null;
				cls=null;
			}
			return dataBM;		
		}
	}
}