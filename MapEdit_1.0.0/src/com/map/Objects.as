/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.map
{
	import com.maptype.vo.RoadVO;
	
	import flash.display.Shape;
	import flash.filters.*;
	
	import com.basic.BasicObjects;
	import com.consts.MString;
	import com.vo.material.MaterialTileVO;

	/**
	 * 	对象显示层
	 * @author wangmingfan
	 */
	public class Objects extends BasicObjects
	{
		//对象索引
		public var index:int;
		//对象ID
		public var id:String;
		//深度
		public var depth:int;
		//材质平铺对象
		public var mTileVO:MaterialTileVO;
		//绘制路点
		public var road:Shape;
		//对象边框
		public var border:Shape;
		
		public function Objects(mTileVO:MaterialTileVO,index:int)
		{
			this.tabChildren=false;
			this.useHandCursor=false;
						
			this.index=index;
			this.id=MString.OBJECT+"_" +index;
			this.mTileVO=mTileVO;
			//滤镜参数设置
			this.distance=0;
			this.angleInDegrees=45;
			this.colors=[0xffffff, 0x088dea, 0x088dea];
			this.alphas=[0, 1, 0.3];
			this.ratios=[0, 128, 225];
			this.blurX=10;
			this.blurY=10;
			this.strength=1;
			this.quality=BitmapFilterQuality.HIGH;
			this.type=BitmapFilterType.OUTER;
			this.knockout=false;
			super();
		}	
		/**
		 * 扩展绘制
		 * @param tileH
		 */
		public function extendsDraws(tileH:int):void
		{
			super.draws(mTileVO.mdVO.elementType,mTileVO.mClass);
			if(mTileVO.mdVO.type==MString.OBJECT)
			{
				displayRoad(tileH);		
			 	onborder();
			}	
		}		
		/**
		 * 显示场景对象的障碍/阴影路点
		 * @param tileH
		 * @param visible
		 */
		public function displayRoad(tileH:int,visible:Boolean=false):void
		{
			road=new Shape();	
			road.visible=visible;		
			this.addChild(road);	
			for (var y:int=0; y < mTileVO.roadArr.length; y++)
			{
				for (var x:int=0; x < mTileVO.roadArr[0].length; x++)
				{
					var rVO:RoadVO=mTileVO.roadArr[y][x] as RoadVO;
					if(rVO.type==1 || rVO.type==2)
					{
						road.graphics.beginFill(rVO.type == 1 ?MString.OBSTACLE : MString.SHADOW);
						road.graphics.drawCircle(rVO.point.x, rVO.point.y,tileH>>2);
						road.graphics.endFill();	
					}	
					rVO=null;			
				}
			}			
		}
		/**
		 * 当前对象的边框
		 */
		private function onborder():void
		{
			border=new Shape();
			border.visible=false;			
			border.graphics.lineStyle(1,0x088dea);
			border.graphics.drawRect(0,0,mTileVO.mdVO.width,mTileVO.mdVO.height);
			this.addChild(border);
		}
		/**
		 * 显示,隐藏路点
		 * @param boo
		 */
		public function visibleRoad(bol:Boolean):void
		{
			if(road)
				road.visible=bol;	
		}	
		/**
		 * 显示,隐藏边框
		 * @param bol
		 */
		public function visibleBorder(bol:Boolean):void
		{
			if(border)
				border.visible=bol;
		}
		/**
		 * 重写父类垃圾清理,删除引用
		 */
		override public function clear():void
		{
			index=0;
			id=null;
			mTileVO=null;
			if (road)
			{
				this.removeChild(road);
				road.graphics.clear();
				road=null;
			}
			if (border)
			{
				this.removeChild(border);
				border.graphics.clear();
				border=null;
			}
			super.clear();
		}
	}
}