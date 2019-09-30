/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.map
{
	import com.maptype.core.Grids;
	import com.maptype.core.Roads;
	import com.maptype.core.isometric.IsoUtils;
	import com.maptype.core.staggered.StaUtils;
	
	import com.consts.MString;
	import com.pureMVC.model.MapProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 网格和路点
	 * @author 王明凡
	 */
	public class GridAndRoadCommand extends SimpleCommand
	{
		//创建UI1(通知)
		public static const GARC_GRID_AND_ROAD:String="garc_grid_and_road";
				
		private var mapP:MapProxy; 

		private var operateType:String;
		
		public function GridAndRoadCommand()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
		}
		override public function execute(note:INotification):void
		{
			//操作类型(新建,打开)
			operateType=note.getBody().toString();				
			var mapW:int=mapP.map.info.mapwidth;
			var mapH:int=mapP.map.info.mapheight;
			var tileH:int=mapP.map.info.tileHeight;
			var mapType:String=mapP.map.info.mapType;
			//创建网格和路点并显示
			mapP.grid=new Grids(mapW,mapH,tileH,MString.GRIDS);
			mapP.road=new Roads();	
			//创建网格和路点,新建设置路点数组,行,列参数
			if (operateType == MString.CREATEFILEBAR)
			{
				if(mapType==StaUtils.STAGGERED)
				{
					mapP.grid.onStaggered();
					mapP.map.roadArr=mapP.road.onStaggered(1,tileH,null,mapW,mapH);					
				}
				else
				{
					mapP.grid.onIsometric();
					mapP.map.roadArr=mapP.road.onIsometric(1,tileH,null,mapW,mapH);				
				}
				mapP.map.info.row=mapP.map.roadArr.length;
				mapP.map.info.column=mapP.map.roadArr[0].length;								
			}				
			else
			{
				//根据路点字符串产生路点网格
				mapP.map.roadArr=getRoadArray(mapP.map.info.floor,mapP.map.info.row,mapP.map.info.column);
				if(mapType==StaUtils.STAGGERED)
				{
					mapP.grid.onStaggered();
					mapP.road.onStaggered(2,tileH,mapP.map.roadArr);
				}
				else
				{
					mapP.grid.onIsometric();
					mapP.road.onIsometric(2,tileH,mapP.map.roadArr);				
				}				
			}
			//如果地图类型为等角类型,则设置当前路点偏移的3D坐标	
			if(mapType==IsoUtils.ISOMETRIC)
				mapP.setMove3D(IsoUtils.getMove3D(
				mapP.map.info.row,
				mapP.map.info.column,
				mapP.map.info.tileHeight));		
			mapP=null;				
		}
		/**
		 * 根据路点字符串获得路点二维数组
		 * @param str
		 * @param row
		 * @param column
		 * @return 
		 */
		private function getRoadArray(str:String, row:int, column:int):Array
		{
			var strArr:Array=str.split(',');
			var roadArr:Array=new Array();
			var count:int=0;
			for (var y:int=0; y < row; y++)
			{
				roadArr.push(new Array());
				for (var x:int=0; x < column; x++)
				{
					roadArr[y][x]=strArr[count];
					count++;
				}
			}
			strArr.splice(0,strArr.length);
			strArr=null;
			return roadArr;
		}								
	}
}