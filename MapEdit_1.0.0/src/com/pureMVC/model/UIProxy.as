/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.model
{
	import com.consts.MString;
	import com.map.Objects;
	import com.maptype.vo.PointVO;
	import com.pureMVC.view.ui.MapEditPanel;
	import com.pureMVC.view.ui.MaterialPanel;
	import com.pureMVC.view.ui.QuicklyPanel;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.core.UIComponentCachePolicy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 
	 * @author wangmingfan
	 */
	public class UIProxy extends Proxy
	{
		public static const NAME:String="UIProxy";
		//主容器UI(ui1,ui2)
		public var mainUI:UIComponent;
		//显示容器1(background,titles,grid,road)
		public var ui1:UIComponent;
		//显示容器2(objects)
		public var ui2:UIComponent;		
		//mainUI扩展宽高
		public var addUI:int=200;
			
		public function UIProxy(data:Object=null)
		{
			super(NAME, data);
			init();
		}
		/**
		 * 初始化
		 */
		private function init():void
		{
			//创建主容器UI
			mainUI=new UIComponent();
			mapEdit.addChild(mainUI);	
			//创建UI1
			ui1=new UIComponent();
			mainUI.addChild(ui1);
			//创建UI2
			ui2=new UIComponent();
			mainUI.addChild(ui2);								
		}
		/**
		 * 设置MainUI的显示位置,宽高
		 * @param gridW
		 * @param gridH
		 */
		public function setMainUI(gridW:int,gridH:int):void
		{
			if(gridW<mapEdit.width)
			{
				if((mapEdit.width-gridW)>>1<addUI)
				{
					mainUI.x=addUI;
					mainUI.width=gridW+addUI;						
				}
				else
				{
					mainUI.x=(mapEdit.width-gridW)>>1;
					mainUI.width=gridW;					
				}
			}	
			else
			{
				mainUI.x=addUI;
				mainUI.width=gridW+addUI;				
			}
			if(gridH<mapEdit.height)
			{
				if((mapEdit.height-gridH)>>1<addUI)
				{
					mainUI.y=addUI;
					mainUI.height=gridH+addUI;						
				}
				else
				{
					mainUI.y=(mapEdit.height-gridH)>>1;
					mainUI.height=gridH;			
				}				
			}	
			else
			{
				mainUI.y=addUI;
				mainUI.height=gridH+addUI;				
			}	
		}
		/**
		 * 设置场景UI1和UI2的初始化属性(宽,高,位图缓存策略)
		 * *[注]:地图或UI的宽高,始终根据网格的宽高决定
		 * @param ui
		 */
		public function setUIAttribute(ui:UIComponent,width:int,height:int):void
		{
			ui.width=width;
			ui.height=height;
			//地图宽,高超过4000像素,将不在进行位图缓存
			if(ui.width<=MString.MAPCACHEWIDTH && ui.height<=MString.MAPCACHEHEIGHT)
				ui.cachePolicy=UIComponentCachePolicy.ON;	
			ui=null;			
		}
		/**
		 * 返回拖动材质移动位置
		 * @param oj
		 * @param useType
		 * @return 
		 */
		public function getDragPoint(oj:Objects,useType:String):PointVO
		{
			var pt:PointVO;
			if(useType==MString.OBJECT)
			{
				pt=getMaxPoint(oj.mTileVO.obstacleRect.width,oj.mTileVO.obstacleRect.height);
				pt.x-=oj.mTileVO.obstacleRect.x+(oj.mTileVO.obstacleRect.width>>1);
				pt.y-=oj.mTileVO.obstacleRect.y+(oj.mTileVO.obstacleRect.height>>1);					
			}
			else
			{
				pt=getMaxPoint(oj.width,oj.height);
				pt.x-=oj.width>>1;
				pt.y-=oj.height>>1;
			}
			oj=null;
			return pt;
		}
		/**
		 * 返回场景对象移动时的最大x,y，根据UI决定
		 * @param width
		 * @param height
		 * @return 
		 */
		public function getMaxPoint(width:int,height:int):PointVO
		{
			var pt:PointVO=new PointVO();
			if (ui2.mouseX - (width >>1) < 0)
				pt.x=width >>1;
			else if (ui2.mouseX + (width >>1) > ui2.width)
				pt.x=ui2.width - (width >>1);
			else
				pt.x=ui2.mouseX;
				
			if (ui2.mouseY - (height >>1) < 0)
				pt.y=height >>1;
			else if (ui2.mouseY + (height >>1) > ui2.height)
				pt.y=ui2.height - (height >>1);
			else
				pt.y=ui2.mouseY;
				
			return pt;
		}	
		/**
		 * 返回UI2的Objects
		 * @param name
		 * @return 
		 */
		public function getUI2ChildArr(name:String):Array
		{
			var childArr:Array=new Array();
			var len:int=ui2.numChildren;
			for(var i:int=0;i<len;i++)
			{
				var oj:Objects=ui2.getChildAt(i) as Objects;
				if(oj.mTileVO.mdVO.name==name)
					childArr.push(oj);
			}
			return childArr;	
		}	
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			app.mapEdit.verticalScrollPosition=0;
			app.mapEdit.horizontalScrollPosition=0;
			clearUI1Child();
			clearUI2Child();			
		}
		/**
		 * 清空UI1显示列表
		 */
		public function clearUI1Child():void
		{
			var len:int=ui1.numChildren;
			for(var i:int=0;i<len;i++)
			{
				ui1.removeChildAt(0);
			}
		}	
		/**
		 * 清空UI2显示列表
		 */
		public function clearUI2Child():void
		{
			var len:int=ui2.numChildren;
			for(var i:int=0;i<len;i++)
			{
				var oj:Objects=ui2.getChildAt(0) as Objects;
				oj.clear();
				oj=null;
				ui2.removeChildAt(0);
			}
			ui2.visible=true;
		}						
		/**
		 * 主容器
		 * @return 
		 */
		public function get app():MapEdit
		{
			return this.data as MapEdit;
		}
		/**
		 * 业务容器
		 * @return 
		 */
		public function get operatePanel():Canvas
		{
			return app.operatePanel;
		}		
		/**
		 * 快捷键容器
		 * @return 
		 */
		public function get quickly():QuicklyPanel
		{
			return app.quickly;
		}
		/**
		 * 地图编辑容器
		 * @return 
		 */
		public function get mapEdit():MapEditPanel
		{
			return app.mapEdit;
		}
		/**
		 * 材质容器
		 * @return 
		 */
		public function get material():MaterialPanel
		{
			return app.material;
		}						
	}
}