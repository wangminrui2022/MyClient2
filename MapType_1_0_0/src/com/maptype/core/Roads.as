/**
 *  MapType - Copyright (c) 2010 王明凡
 */
package com.maptype.core
{
	import flash.display.*;
	import flash.geom.*;
	
	import com.maptype.core.isometric.IsoPoint3D;
	import com.maptype.core.isometric.IsoUtils;
	import com.maptype.core.staggered.StaUtils;
	import com.maptype.interfaces.IRoad;
	import com.maptype.vo.PointVO;
	import com.maptype.vo.RoadVO;
	/**
	 * 
	 * @author 王明凡
	 */
	public class Roads extends  Sprite implements IRoad
	{
		public function Roads()
		{
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.tabChildren=false;
			this.useHandCursor=false;						
		}

		/**
		 * 该方法绘制"交错排列"路点,并返回路点数组
		 * @param createType	创建类型(1.新建,2.打开)
		 * @param tileH
		 * @param roadArr		路点字符串数组	
		 * @param mapW
		 * @param mapH
		 * @return 
		 */
		public function onStaggered(createType:int,tileH:int,roadArr:Array=null,mapW:int=0,mapH:int=0):Array
		{
			var row:int;
			var column:int;
			if(createType==1)
			{
				roadArr=new Array();			
				column=Math.ceil(mapW / (tileH<<1));
				row=Math.ceil(mapH / tileH) <<1;			
			}
			else
			{
				row=roadArr.length;
				column=roadArr[0].length;				
			}
			for (var y:int=0; y < row; y++)
			{
				if(createType==1)
					roadArr.push(new Array());				
				for (var x:int=0; x < column; x++)
				{
					var type:int=0;	
					//如果是打开场景
					if(createType==2)
						type=roadArr[y][x];								
					//路点对象
					var rVO:RoadVO=new RoadVO;
					rVO.index=new PointVO(x, y);
					rVO.point=StaUtils.getStaggeredPoint(new PointVO(x, y), (tileH<<1), tileH);
					rVO.type=type;
					rVO.shape=rVO.drawRoad(StaUtils.PASS,tileH,rVO.point);
					this.addChild(rVO.shape);
					roadArr[y][x]=rVO;
					rVO=null;
				}
			}
			return roadArr;
		}
		
		/**
		 * 该方绘制"等角"路点,并返回路点数组
		 * @param createType	创建类型(1.新建,2.打开)
		 * @param tileH
		 * @param roadArr		路点字符串数组
		 * @param mapW
		 * @param mapH
		 * @return 
		 */
		public function onIsometric(createType:int,tileH:int,roadArr:Array=null,mapW:int=0,mapH:int=0):Array
		{
			var row:int;
			var column:int;
			if(createType==1)
			{
				roadArr=new Array();
				column=Math.ceil(mapW / tileH);
				row=Math.ceil(mapH / tileH);		
			}
			else
			{
				row=roadArr.length;
				column=roadArr[0].length;			
			}	
			//当前路点偏移的3D坐标	
			var move3D:IsoPoint3D=IsoUtils.getMove3D(row,column,tileH);	
			//绘制等角对象
			for(var z:int=0;z<row;z++)
			{
				if(createType==1)
					roadArr.push(new Array());					
				for(var x:int=0;x<column;x++)
				{
					var type:int=0;
					//如果是打开场景
					if(createType==2)
						type=roadArr[z][x];				
					//路点对象
					var rVO:RoadVO=new RoadVO;
					rVO.index=new PointVO(x,z);					
					rVO.point=IsoUtils.isoToScreen(new IsoPoint3D(
					move3D.x + (x * tileH),
					move3D.y +0,
					move3D.z + (z * tileH)));
					rVO.type=type;
					rVO.shape=rVO.drawRoad(StaUtils.PASS,tileH,rVO.point);
					this.addChild(rVO.shape);
					roadArr[z][x]=rVO;
					rVO=null;										
				}
			}		
			move3D=null;
			return roadArr;
		}
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			var num:int=this.numChildren;
			for (var i:int=0; i < num; i++)
			{
				var sp:Shape=this.getChildAt(0) as Shape;
				sp.graphics.clear();
				sp=null;
				this.removeChildAt(0);
			}
		}		
	}
}