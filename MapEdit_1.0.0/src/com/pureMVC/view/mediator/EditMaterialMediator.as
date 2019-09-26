package com.pureMVC.view.mediator
{
	import com.consts.MString;
	import com.maptype.core.Grids;
	import com.maptype.core.Roads;
	import com.maptype.vo.RectangleVO;
	import com.maptype.vo.RoadVO;
	import com.pureMVC.controller.business.common.*;
	import com.pureMVC.controller.business.map.MEComand;
	import com.pureMVC.controller.business.material.MaterialObstacleRectCommand;
	import com.pureMVC.controller.business.material.URMapMaterialCommand;
	import com.pureMVC.model.*;
	import com.pureMVC.view.ui.EditMaterial;
	import com.vo.map.SetRoadVO;
	import com.vo.material.MaterialTileVO;
	import com.vo.material.URMapMaterialVO;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 
	 * @author wangmingfan
	 */
	public class EditMaterialMediator extends Mediator
	{
		public static const NAME:String="EditMaterialMediator";
		//弹出编辑材质(通知)
		public static const EMM_EDIT_MATERIAL:String="emm_edit_material";
		//关闭编辑材质(通知)
		public static const EMM_CLOSE_EDIT_MATERIAL:String="emm_close_edit_material";
		//资源模型
		private var assetP:AssetProxy;
		//地图模型层
		private var mapP:MapProxy;
		//材质平铺对象
		private var mTileVO:MaterialTileVO;
		//材质位图	
		private var materialBtm:Bitmap;
		//材质影片	
		private var materialMC:MovieClip;
		//材质容器
		private var ui:UIComponent;
		//地砖宽
		private var tileW:int;
		//地砖高
		private var tileH:int;
		//临时路点数组
		private var tmpRoadArr:Array;
		//是否保存
		private var isSave:Boolean;
														
		public function EditMaterialMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			assetP=this.facade.retrieveProxy(AssetProxy.NAME) as AssetProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			tileH=mapP.map.info.tileHeight;
			tileW=mapP.map.info.tileWidth;			
			//添加材质容器		
			ui=new UIComponent();
			editMaterial.editCanvas.addChild(ui);
			//复选框
			editMaterial.mCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			//保存
			editMaterial.save.addEventListener(MouseEvent.CLICK, onSaveClick);			
		}
		override public function listNotificationInterests():Array
		{
			return [
			EMM_EDIT_MATERIAL,
			EMM_CLOSE_EDIT_MATERIAL,
			MaterialObstacleRectCommand.MORC_MATERIAL_OBSTACLE_RECT_RESULT];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case EMM_EDIT_MATERIAL:
					onEditMaterial(note.getBody() as MaterialTileVO);
					break;
				case EMM_CLOSE_EDIT_MATERIAL:
					onCloseEditMaterial();
					break;
				case MaterialObstacleRectCommand.MORC_MATERIAL_OBSTACLE_RECT_RESULT:
					onMaterialObstacleRectResult(note.getBody() as RectangleVO);
					break;
			}
		}
		/**
		 * 复选框【按钮】
		 * @param e
		 */
		private function onCheckBoxClick(e:MouseEvent):void
		{
			if (editMaterial.mCheckBox.selected)
			{
				if (materialBtm)
					materialBtm.visible=true;
				else
					materialMC.visible=true;
			}
			else
			{
				if (materialBtm)
					materialBtm.visible=false;
				else
					materialMC.visible=false;
			}
		}		
		/**
		 * 保存【按钮】
		 * @param e
		 */
		private function onSaveClick(e:MouseEvent=null):void
		{
			isSave=true;
			//保存路点数组
			this.mTileVO.roadArr= tmpRoadArr;
			//设置材质障碍点的矩形
			this.sendNotification(MaterialObstacleRectCommand.MORC_MATERIAL_OBSTACLE_RECT,this.mTileVO.roadArr);
		}
		/**
		 * 获得当前设置材质障碍点的矩形结果
		 * @param rect
		 */
		private function onMaterialObstacleRectResult(rect:RectangleVO):void
		{
			//如果没有障碍点矩形,就默认自身大小
			if(!rect)
				mTileVO.obstacleRect=new RectangleVO(0,0,int(mTileVO.mdVO.width),int(mTileVO.mdVO.height));				
			else
				mTileVO.obstacleRect=rect;
			rect=null
			//序列化材质到本地.me文件
			this.sendNotification(MEComand.MC_ME,"A");				
			//更新场景中用到该材质的对象
			var urmmVO:URMapMaterialVO=new URMapMaterialVO();
			urmmVO.operateType=URMapMaterialVO.UPDATE;
			urmmVO.oj=this.mTileVO;
			this.sendNotification(URMapMaterialCommand.URMMC_MAP_MATERIAL,urmmVO);
			urmmVO=null;			
			//清理	
			clear();		
		}
		/**
		 * 关闭编辑材质【按钮】
		 */
		private function onCloseEditMaterial():void
		{
			clear();	
		}	
		/**
		 * 初始化,显示材质
		 * @param mTileVO
		 */
		private function onEditMaterial(mTileVO:MaterialTileVO):void
		{
			this.mTileVO=mTileVO;
			mTileVO=null;
			if (this.mTileVO.mdVO.elementType == MString.BITMAPDATA)
			{
				materialBtm=new Bitmap(new this.mTileVO.mClass(null, null) as BitmapData);
				ui.width=materialBtm.width;
				ui.height=materialBtm.height;
				ui.addChild(materialBtm);
			}
			else if (this.mTileVO.mdVO.elementType == MString.MOVIECLIP)
			{
				materialMC=new this.mTileVO.mClass() as MovieClip;
				ui.width=materialMC.width;
				ui.height=materialMC.height;			
				ui.addChild(materialMC);
			}	
			//显示材质选中
			editMaterial.mCheckBox.selected=true;
			//如果是object类型材质,是否可以编辑该材质
			if (this.mTileVO.mdVO.type == MString.OBJECT)
			{	
				//添加材质网格和路点并显示
				var grid:Grids=new Grids(ui.width,ui.height,tileH,MString.GRIDS);
				grid.onStaggered();
				//设置材质容器剧中
				setMaterialCenter(grid.width,grid.height);					
				ui.addChild(grid);
				var road:Roads=new Roads();	
				ui.addChild(road);		
				//材质的二维数组网格
				if (this.mTileVO.roadArr)
				{
					//材质路点的网格大小(x,y)必须等于当前地图路点的网格大小(x,y)
					if(compareRoadGridSize(this.mTileVO.roadArr,mapP.map.roadArr))
					{
						//将路点数组复制到临时路点数组	
						tmpRoadArr=ObjectUtil.copy(this.mTileVO.roadArr) as Array;				
						displayRoadArray();						
					}
					else
					{
						clearRoadArr(this.mTileVO.roadArr);
						tmpRoadArr=road.onStaggered(1,tileH,null,ui.width,ui.height);						
					}
				}
				else
				{
					clearRoadArr(this.mTileVO.roadArr);
					tmpRoadArr=road.onStaggered(1,tileH,null,ui.width,ui.height);
				}
				//背景
				displayBasckground();
				//注册SetRoadMediato
				onRegisterSetRoad();
			}
			else
			{
				//设置材质容器剧中
				setMaterialCenter(ui.width,ui.height);				
				editMaterial.setRoad.obstacleBtn.enabled=false;
				editMaterial.setRoad.passBtn.enabled=false;
				editMaterial.setRoad.shadowBtn.enabled=false;
				editMaterial.save.enabled=false;
			}		
		}
		/**
		 * 获得材质在容器剧中的位置
		 * @param W
		 * @param H
		 * @return 
		 */
		private function setMaterialCenter(W:int,H:int):void
		{
			if(W>editMaterial.editCanvas.width)
			{
				ui.x=0;
				ui.width=W;
			}	
			else
			{
				ui.x=(editMaterial.editCanvas.width - W) >>1;
			}
			if(H>editMaterial.editCanvas.height)
			{
				ui.y=0;
				ui.height=H;
			}
			else
			{
				ui.y=(editMaterial.editCanvas.height - H) >>1;
			}	
		}
		/**
		 * 给UI添加一个背景层,用于扩大在UI路点设计面
		 */
		private function displayBasckground():void
		{
			var row:int=Math.round((ui.height / tileH) <<1);
			var column:int=Math.round(ui.width / tileW);
			var addRow:int=(row & 1)==1?tileH>>1:tileH;
			var addColumn:int=(column & 1)==1?tileW>>1:tileW;
			
			var background:Shape=new Shape();
			background.graphics.beginFill(0x505151,0);
			background.graphics.drawRect(0, 0, ui.width+addColumn, ui.height+addRow);
			background.graphics.endFill();
			ui.addChildAt(background, 0);	
			background=null;			
		}
		/**
		 * 注册SetRoadMediator,并发送路点设置通知
		 * 移除场景快捷面板中的SetRoadMediator
		 */
		private function onRegisterSetRoad():void
		{
			if(this.facade.hasMediator(SetRoadMediator.NAME))
				this.sendNotification(SetRoadMediator.SRM_CLEAR);
			this.facade.registerMediator(new SetRoadMediator(editMaterial.setRoad));
			var srVO:SetRoadVO=new SetRoadVO();
			srVO.setRoadType=2;
			srVO.roadArr=tmpRoadArr;
			srVO.tileH=tileH;
			srVO.tileW=tileW;
			srVO.UI=ui;
			this.sendNotification(SetRoadMediator.SRM_SETROAD,srVO);			
		}	
		/**
		 * 显示材质的二维数组网格路点
		 */
		private function displayRoadArray():void
		{
			for (var y:int=0; y < tmpRoadArr.length; y++)
			{
				for (var x:int=0; x < tmpRoadArr[0].length; x++)
				{
					var rVO:RoadVO=tmpRoadArr[y][x] as RoadVO;
					if(!rVO.shape)
					{
						if(rVO.type==0)
							rVO.shape=rVO.drawRoad(MString.PASS,tileH,rVO.point)
						else
							rVO.shape=rVO.drawRoad(rVO.type == 1 ? MString.OBSTACLE : MString.SHADOW,tileH,rVO.point);
					}
					ui.addChild(rVO.shape);
				}
			}
		}	
		/**
		 * 清理路点数组垃圾
		 * @param roadArr
		 */
		public function clearRoadArr(roadArr:Array):void
		{		
			if(roadArr)
			{
				for(var y:int=0;y<roadArr.length;y++)
				{
					for(var x:int=0;x<roadArr[0].length;x++)
					{
						var rVO:RoadVO=roadArr[y][x] as RoadVO;
						rVO.index=null;
						rVO.point=null;
						if(rVO.shape)
							rVO.shape.graphics.clear();
						rVO.shape=null;
						rVO=null;
					}
				}
				var len:int=roadArr.length;
				for(var y2:int=0;y2<len;y2++)
				{
					var xRoadArr:Array=roadArr[0] as Array;
					xRoadArr.splice(0,xRoadArr.length);
					xRoadArr=null;
					roadArr.splice(0,1);
				}
			}
			roadArr=null;
		}		
		/**
		 * 比较路点数组中的路点网格之间大小是否相等
		 * @param roadArr_1
		 * @param roadArr_2
		 * @return 
		 */
		private function compareRoadGridSize(roadArr_1:Array,roadArr_2:Array):Boolean
		{
			var bol:Boolean;
			var pt_1:Point=getRoadGridSize(roadArr_1);
			var pt_2:Point=getRoadGridSize(roadArr_2);
			roadArr_1=null;
			roadArr_2=null;
			if(pt_1==null || pt_2==null)
			{
				bol=false;
			}
			else
			{
				if(pt_1.x==pt_2.x && pt_1.y==pt_2.y)
					bol=true;
				else
					bol=false;
			}
			pt_1=null;
			pt_2=null;				
			return bol;			
		}		
		/**
		 * 计算路点网格之间的路点大小(x,y)
		 * @return 
		 */
		private function getRoadGridSize(roadArr:Array):Point
		{
			if(roadArr.length<2)
				return null;
			var pt:Point=new Point();
			var _0_0:RoadVO;
			var _1_0:RoadVO;
			if(roadArr[0][0])
				_0_0=roadArr[0][0] as RoadVO;
			if(roadArr[1][0])
				_1_0=roadArr[1][0] as RoadVO;
			if(_0_0 && _1_0)
			{
				pt.x=Math.abs(_1_0.point.x-_0_0.point.x);
				pt.y=Math.abs(_1_0.point.y-_0_0.point.y);	
			}	
			else
			{
				pt=null;
			}	
			roadArr=null;
			return pt;
		}
		/**
		 * 垃圾清理
		 */
		private function clear():void
		{
			this.sendNotification(QuicklyPanelMediator.QPM_REGISTERSETROAD);
			this.sendNotification(PageClearCommand.PC_PAGECLEAR, ui, "2");
			editMaterial.mCheckBox.removeEventListener(MouseEvent.CLICK, onCheckBoxClick);
			editMaterial.save.removeEventListener(MouseEvent.CLICK, onSaveClick);			
			assetP=null;
			mapP=null;
			tileW=0;
			tileH=0;
			ui=null;
			mTileVO=null;
			materialBtm=null;
			materialMC=null;
			if(!isSave)
				if(tmpRoadArr)
					tmpRoadArr.splice(0, tmpRoadArr.length);
			tmpRoadArr=null;
			isSave=false;
			this.sendNotification(PageClearCommand.PC_PAGECLEAR, editMaterial, "1");
			this.facade.removeMediator(NAME);
			PopUpManager.removePopUp(editMaterial);
		}
		/**
		 *
		 * @return
		 */
		private function get editMaterial():EditMaterial
		{
			return this.viewComponent as EditMaterial;
		}
	}
}