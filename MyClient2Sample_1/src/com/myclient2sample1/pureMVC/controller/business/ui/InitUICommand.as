package com.myclient2sample1.pureMVC.controller.business.ui
{
	import com.myclient2sample1.pureMVC.model.UIProxy;
	import com.myclient2sample1.vo.MapConvertVO;
	
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 初始化UI模型层(只初始化一次)
	 * @author 王明凡
	 */
	public class InitUICommand extends SimpleCommand
	{
		public static const IUC_INIT_UI_COMMAND:String="iuc_init_ui_command";

		private var uiP:UIProxy;

		public function InitUICommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			//地图引擎显示容器(No.1)
			uiP.engineContainer=new UIComponent();
			uiP.app.addChild(uiP.engineContainer);
			//地图操作对象显示容器(No.2)
			uiP.mapOperateContainer=new UIComponent();
			uiP.app.addChild(uiP.mapOperateContainer);
			//地图角色显示容器(No.3)
			uiP.roleConatainer=new UIComponent();
			uiP.app.addChild(uiP.roleConatainer);
			//地图组件显示容器(No.4)
			uiP.componetContainer=new UIComponent();
			uiP.app.addChild(uiP.componetContainer);
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
			var setW:int=uiP.app.stage.stageWidth;
			var setH:int=uiP.app.stage.stageHeight;
							
			var mapConvertVOArr:Array=new Array();
			
			var SpringVC:Rectangle=getVC(setW,setH,2800,1800);
			var SummerVC:Rectangle=getVC(setW,setH,4000,4000);
			var AutumnVC:Rectangle=getVC(setW,setH,3600,2800);
			var WinterVC:Rectangle=getVC(setW,setH,1800,1800);
			
			var Room1VC:Rectangle=getVC(setW,setH,1200,600);
			var Room2VC:Rectangle=getVC(setW,setH,1100,550);
			var Room3VC:Rectangle=getVC(setW,setH,1100,550);
			var Room4VC:Rectangle=getVC(setW,setH,2400,1200);
			var Room5VC:Rectangle=getVC(setW,setH,640,480);
			var Room6VC:Rectangle=getVC(setW,setH,640,480);
			var PictureMapVC:Rectangle=getVC(setW,setH,1280,960);
			var Room8VC:Rectangle=getVC(setW,setH,960,720);
			
			//Start  → Spring
			mapConvertVOArr.push(getMapConvertVO("Start", "start_1", "com/myclient2sample1/asset/maps/Spring.mcmap", 1140, 650,SpringVC.x,SpringVC.y,SpringVC.width,SpringVC.height,MapConvertVO.START));

			//Spring → Summer
			mapConvertVOArr.push(getMapConvertVO("Spring", "object_256", "com/myclient2sample1/asset/maps/Summer.mcmap", 3750,110,SummerVC.x,SummerVC.y,SummerVC.width,SummerVC.height,MapConvertVO.CONVERT));
			//Spring → Winter
			mapConvertVOArr.push(getMapConvertVO("Spring", "object_258", "com/myclient2sample1/asset/maps/Winter.mcmap", 1600, 1655,WinterVC.x,WinterVC.y,WinterVC.width,WinterVC.height,MapConvertVO.CONVERT));
			//Spring → Room1
			mapConvertVOArr.push(getMapConvertVO("Spring", "object_490", "com/myclient2sample1/asset/maps/Room1.mcmap", 355,408 ,Room1VC.x,Room1VC.y,Room1VC.width,Room1VC.height,MapConvertVO.CONVERT));
			//Spring → Room2
			mapConvertVOArr.push(getMapConvertVO("Spring", "object_533", "com/myclient2sample1/asset/maps/Room2.mcmap", 285, 311,Room2VC.x,Room2VC.y,Room2VC.width,Room2VC.height,MapConvertVO.CONVERT));
			

			//Summer → Spring
			mapConvertVOArr.push(getMapConvertVO("Summer", "object_86", "com/myclient2sample1/asset/maps/Spring.mcmap",1241 , 1772,SpringVC.x,SpringVC.y,SpringVC.width,SpringVC.height,MapConvertVO.CONVERT));
			//Summer → Autumn
			mapConvertVOArr.push(getMapConvertVO("Summer", "object_1165", "com/myclient2sample1/asset/maps/Autumn.mcmap", 2605,60,AutumnVC.x,AutumnVC.y,AutumnVC.width,AutumnVC.height,MapConvertVO.CONVERT));
			//Summer → Room3
			mapConvertVOArr.push(getMapConvertVO("Summer", "object_1169", "com/myclient2sample1/asset/maps/Room3.mcmap",766 ,138 ,Room3VC.x,Room3VC.y,Room3VC.width,Room3VC.height,MapConvertVO.CONVERT));
			//Summer → Room4
			mapConvertVOArr.push(getMapConvertVO("Summer", "object_1167", "com/myclient2sample1/asset/maps/Room4 New.mcmap",1290 ,1088,Room4VC.x,Room4VC.y,Room4VC.width,Room4VC.height,MapConvertVO.CONVERT));


			//Autumn → Summer
			mapConvertVOArr.push(getMapConvertVO("Autumn", "object_982", "com/myclient2sample1/asset/maps/Summer.mcmap", 1405,3915,SummerVC.x,SummerVC.y,SummerVC.width,SummerVC.height,MapConvertVO.CONVERT));
			//Autumn → Winter
			mapConvertVOArr.push(getMapConvertVO("Autumn", "object_939", "com/myclient2sample1/asset/maps/Winter.mcmap", 140, 58,WinterVC.x,WinterVC.y,WinterVC.width,WinterVC.height,MapConvertVO.CONVERT));
			//Autumn → Room5
			mapConvertVOArr.push(getMapConvertVO("Autumn", "object_1158", "com/myclient2sample1/asset/maps/Room5.mcmap", 518,410 ,Room5VC.x,Room5VC.y,Room5VC.width,Room5VC.height,MapConvertVO.CONVERT));
			//Autumn → Room6
			mapConvertVOArr.push(getMapConvertVO("Autumn", "object_931", "com/myclient2sample1/asset/maps/Room6.mcmap",512 ,407,Room6VC.x,Room6VC.y,Room6VC.width,Room6VC.height,MapConvertVO.CONVERT));
				

			//Winter → Autumn
			mapConvertVOArr.push(getMapConvertVO("Winter", "object_401", "com/myclient2sample1/asset/maps/Autumn.mcmap", 3455, 2584,AutumnVC.x,AutumnVC.y,AutumnVC.width,AutumnVC.height,MapConvertVO.CONVERT));
			//Winter → Spring
			mapConvertVOArr.push(getMapConvertVO("Winter", "object_403", "com/myclient2sample1/asset/maps/Spring.mcmap", 311, 88,SpringVC.x,SpringVC.y,SpringVC.width,SpringVC.height,MapConvertVO.CONVERT));
			//Winter → PictureMap
			mapConvertVOArr.push(getMapConvertVO("Winter", "object_573", "com/myclient2sample1/asset/maps/PictureMap.mcmap",1190 , 890,PictureMapVC.x,PictureMapVC.y,PictureMapVC.width,PictureMapVC.height,MapConvertVO.CONVERT));
			//Winter → Room8
			mapConvertVOArr.push(getMapConvertVO("Winter", "object_565", "com/myclient2sample1/asset/maps/Room8.mcmap",224 , 652,Room8VC.x,Room8VC.y,Room8VC.width,Room8VC.height,MapConvertVO.CONVERT));

						
			//Room1 → Spring
			mapConvertVOArr.push(getMapConvertVO("Room1", "object_27", "com/myclient2sample1/asset/maps/Spring.mcmap", 962,571 ,SpringVC.x,SpringVC.y,SpringVC.width,SpringVC.height,MapConvertVO.CONVERT));


			//Room2 → Spring
			mapConvertVOArr.push(getMapConvertVO("Room2", "object_18", "com/myclient2sample1/asset/maps/Spring.mcmap", 1851,1472 ,SpringVC.x,SpringVC.y,SpringVC.width,SpringVC.height,MapConvertVO.CONVERT));


			//Room3 → Summer
			mapConvertVOArr.push(getMapConvertVO("Room3", "object_49", "com/myclient2sample1/asset/maps/Summer.mcmap", 1860, 1160,SummerVC.x,SummerVC.y,SummerVC.width,SummerVC.height,MapConvertVO.CONVERT));


			//Room4 → Summer
			mapConvertVOArr.push(getMapConvertVO("Room4 New", "object_210", "com/myclient2sample1/asset/maps/Summer.mcmap", 2440, 2833,SummerVC.x,SummerVC.y,SummerVC.width,SummerVC.height,MapConvertVO.CONVERT));


			//Room5 → Autumn
			mapConvertVOArr.push(getMapConvertVO("Room5", "object_19", "com/myclient2sample1/asset/maps/Autumn.mcmap",1000 , 510,AutumnVC.x,AutumnVC.y,AutumnVC.width,AutumnVC.height,MapConvertVO.CONVERT));


			//Room6 → Autumn
			mapConvertVOArr.push(getMapConvertVO("Room6", "object_9", "com/myclient2sample1/asset/maps/Autumn.mcmap", 1340,2380 ,AutumnVC.x,AutumnVC.y,AutumnVC.width,AutumnVC.height,MapConvertVO.CONVERT));


			//PictureMap → Winter 
			mapConvertVOArr.push(getMapConvertVO("PictureMap", "object_25", "com/myclient2sample1/asset/maps/Winter.mcmap", 540, 1600,WinterVC.x,WinterVC.y,WinterVC.width,WinterVC.height,MapConvertVO.CONVERT));
			//PictureMap → Room8
			mapConvertVOArr.push(getMapConvertVO("PictureMap", "object_27", "com/myclient2sample1/asset/maps/Room8.mcmap", 845, 525,Room8VC.x,Room8VC.y,Room8VC.width,Room8VC.height,MapConvertVO.CONVERT));
	
	
			//Room8 → Winter
			mapConvertVOArr.push(getMapConvertVO("Room8", "object_5", "com/myclient2sample1/asset/maps/Winter.mcmap",948 ,830 ,WinterVC.x,WinterVC.y,WinterVC.width,WinterVC.height,MapConvertVO.CONVERT));
			//Room8 → PictureMap
			mapConvertVOArr.push(getMapConvertVO("Room8", "object_30", "com/myclient2sample1/asset/maps/PictureMap.mcmap", 120, 376,PictureMapVC.x,PictureMapVC.y,PictureMapVC.width,PictureMapVC.height,MapConvertVO.CONVERT));
				
						
			return mapConvertVOArr;
		}
		/**
		 * 根据地图大小获得观察口的位置和摄像机宽高(注意：这里是地图的平铺宽，高)
		 * @param setW
		 * @param setH
		 * @param mapW
		 * @param mapH
		 * @return 
		 */
		private function getVC(setW:int,setH:int,mapW:int,mapH:int):Rectangle
		{
			var rect:Rectangle=new Rectangle();
			if(mapW>setW)
			{
				rect.x=0;
				rect.width=setW;
			}
			else
			{
				rect.x=(setW-mapW)/2;
				rect.width=mapW;
			}
			if(mapH>setH)
			{
				rect.y=0;
				rect.height=setH;
			}
			else
			{
				rect.y=(setH-mapH)/2;
				rect.height=mapH;
			}
			return rect;
		}
		/**
		 * 获得地图切换对象
		 * @param mapName
		 * @param id
		 * @param url
		 * @param x
		 * @param y
		 * @param mapViewPortX
		 * @param mapViewPortY
		 * @param CWidth
		 * @param CHeight
		 * @param state
		 * @return 
		 */
		private function getMapConvertVO(mapName:String, id:String, url:String, x:int, y:int,mapViewPortX:int,mapViewPortY:int,CWidth:int,CHeight:int,state:String):MapConvertVO
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