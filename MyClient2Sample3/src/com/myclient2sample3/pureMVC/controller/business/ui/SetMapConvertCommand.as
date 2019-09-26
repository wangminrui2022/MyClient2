package com.myclient2sample3.pureMVC.controller.business.ui
{
	import com.myclient2sample3.pureMVC.model.UIProxy;
	import com.myclient2sample3.vo.MapConvertVO;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 设置地图切换
	 * @author 王明凡
	 */
	public class SetMapConvertCommand extends SimpleCommand
	{
		public static const SMCC_SET_MAP_CONVERT_COMMAND:String="smcc_set_map_convert_command";

		private var uiP:UIProxy;

		public function SetMapConvertCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			//创建地图切换对象
			uiP.mapConvertVOArr=getMapConvertVOArr();
			uiP=null;
		}

		/**
		 * 获得地图切换对象集合
		 * @return
		 */
		private function getMapConvertVOArr():Array
		{
			var stageW:int=uiP.app.stage.stageWidth;
			var stageH:int=uiP.app.stage.stageHeight;		
			var setW:int=1000;
			var setH:int=480;
			var mapConvertVOArr:Array=new Array();
			var hb001VC:Rectangle=getVC(stageW,stageH,setW, setH);
			var map002VC:Rectangle=getVC(stageW,stageH,setW, setH);
			var map003VC:Rectangle=getVC(stageW,stageH,setW, setH);
			
			//Start  → map002
			mapConvertVOArr.push(getMapConvertVO("Start", "start_1", "com/myclient2sample3/asset/maps/map002.mcmap", 440, 385, map002VC.x, map002VC.y, map002VC.width, map002VC.height, MapConvertVO.START));

			//map002 → map003
			mapConvertVOArr.push(getMapConvertVO("map002", "object_107", "com/myclient2sample3/asset/maps/map003.mcmap", 3553, 405, map003VC.x, map003VC.y, map003VC.width, map003VC.height, MapConvertVO.CONVERT));
			//map002 → hb001
			mapConvertVOArr.push(getMapConvertVO("map002", "object_104", "com/myclient2sample3/asset/maps/hb001.mcmap",135 , 380, hb001VC.x, hb001VC.y, hb001VC.width, hb001VC.height, MapConvertVO.CONVERT));

			
			//hb001 → map002
			mapConvertVOArr.push(getMapConvertVO("hb001", "object_236", "com/myclient2sample3/asset/maps/map002.mcmap",2430 ,383 , map002VC.x, map002VC.y, map002VC.width, map002VC.height, MapConvertVO.CONVERT));
			//hb001 → map003
			mapConvertVOArr.push(getMapConvertVO("hb001", "object_241", "com/myclient2sample3/asset/maps/map003.mcmap",140,430, map003VC.x, map003VC.y, map003VC.width, map003VC.height, MapConvertVO.CONVERT));


			//map003 → hb001
			mapConvertVOArr.push(getMapConvertVO("map003", "object_61", "com/myclient2sample3/asset/maps/hb001.mcmap",3070 ,388 , hb001VC.x, hb001VC.y, hb001VC.width, hb001VC.height, MapConvertVO.CONVERT));
			//map003 → map002
			mapConvertVOArr.push(getMapConvertVO("map003", "object_57", "com/myclient2sample3/asset/maps/map002.mcmap",145 , 420, map002VC.x, map002VC.y, map002VC.width, map002VC.height, MapConvertVO.CONVERT));
				
			return mapConvertVOArr;
		}

		/**
		 * 根据地图大小获得观察口的位置和摄像机宽高(注意：这里是地图的平铺宽，高)
		 * @return
		 */
		private function getVC(stageW:int,stageH:int,setW:int, setH:int):Rectangle
		{	
			var rect:Rectangle=new Rectangle();
			rect.x=(stageW-setW)/2;
			rect.y=(stageH-setH)/2;
			rect.width=setW;
			rect.height=setH;
			return rect;
		}

		/**
		 * 获得地图切换对象
		 * @return
		 */
		private function getMapConvertVO(mapName:String, id:String, url:String, x:int, y:int, mapViewPortX:int, mapViewPortY:int, CWidth:int, CHeight:int, state:String):MapConvertVO
		{
			var mcVO:MapConvertVO=new MapConvertVO();
			mcVO.state=state;
			mcVO.mapName=mapName;
			mcVO.id=id;
			mcVO.url=url;
			mcVO.x=x;
			mcVO.y=y;
			mcVO.mapViewPortX=mapViewPortX;
			mcVO.mapViewPortY=mapViewPortY;
			mcVO.CWidth=CWidth;
			mcVO.CHeight=CHeight;
			return mcVO;
		}
	}
}