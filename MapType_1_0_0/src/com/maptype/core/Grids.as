/**
 *  MapType - Copyright (c) 2010 王明凡
 */
package com.maptype.core
{
	import com.maptype.core.isometric.*;
	import com.maptype.core.staggered.StaUtils;
	import com.maptype.interfaces.IGrid;
	
	import flash.display.Sprite;
	import flash.geom.*;
	/**
	 * 
	 * @author 王明凡
	 */
	public class Grids extends Sprite implements IGrid
	{
		private var mapW:int;
		private var mapH:int;
		private var tileH:int;
		private var row:int;
		private var column:int;
		private var color:int;
		//创建地图类型 "staggered","isometric"
		private var type:String;
		
		public static const gridsAlpha:Number=0.3;

		public function Grids(mapW:int, mapH:int,tileH:int, color:int)
		{
			this.mapW=mapW;
			this.mapH=mapH;
			this.tileH=tileH;
			this.color=color;
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.tabChildren=false;
			this.useHandCursor=false;		
			this.graphics.lineStyle(1, color, gridsAlpha);
		}

		/**
		 * 该方法绘制"交错排列"网格
		 */
		public function onStaggered():void
		{
			type=StaUtils.STAGGERED;
			column=Math.ceil(mapW / (tileH<<1));
			row=Math.ceil(mapH / tileH) <<1;
			var halfTW:int=Math.round((tileH<<1) >>1);
			var halfTH:int=Math.round(tileH >>1);
			var nColumn:int=(column <<1) + 1;
			var nRow:int=row;
			//线条1-从右上开始画
			for (var i:int=1; i < nColumn; i+=2)
			{
				graphics.moveTo(i * halfTW, 0);
				if (nRow + i > nColumn)
					graphics.lineTo(nColumn * halfTW, (nColumn - i) * halfTH);
				else
					graphics.lineTo((nRow + i) * halfTW, nRow * halfTH);
			}
			//线条2-从左上开始画
			var k2:int=0;
			var sort2:int=0;
			for (var k:int=1; k < nColumn; k+=2)
			{
				graphics.moveTo(halfTW * k, 0);
				if(halfTH * k>(row>>1)*tileH)
				{
					var long:int=halfTH * k;
					var standard:int=(row>>1)*tileH;
					var sort:int=long-standard;
					if(k2==0)
						sort2=sort;					
					graphics.lineTo(((tileH<<1)*k2)+(sort2<<1),long-sort);
					k2++;
				}
				else
				{
					graphics.lineTo(0,halfTH * k);	
				}
			}
			//线条3-从左下开始画
			for (var j:int=1; j < nRow; j+=2)
			{
				graphics.moveTo(0, j * halfTH);
				if (nRow - j >= nColumn)
					graphics.lineTo(nColumn * halfTW, (nColumn + j) * halfTH);
				else
					graphics.lineTo((nRow - j) * halfTW, nRow * halfTH);
			}
			//线条4-从右下开始画
			for (var n:int=0; n < nRow; n+=2)
			{
				graphics.moveTo(nColumn * halfTW, n * halfTH);
				if (nColumn < nRow - n)
					graphics.lineTo(0, (nColumn + n) * halfTH);
				else
					graphics.lineTo((nColumn - nRow + n) * halfTW, nRow * halfTH);
			}	
		}		
				
		/**
		 * 该方法绘制"等角"网格
		 */
		public function onIsometric():void
		{
			type=IsoUtils.ISOMETRIC;
			row=Math.ceil(mapH / tileH);
			column=Math.ceil(mapW / tileH);
			var move3D:IsoPoint3D=IsoUtils.getMove3D(row,column,tileH);			
			//绘制等角对象
			for (var z:int=0; z < row; z++)
			{
				for (var x:int=0; x < column; x++)
				{
					//根据行列做创建等角3D坐标	
					var pt3D:IsoPoint3D=new IsoPoint3D(
					move3D.x + x * tileH, 
					move3D.y + 0, 
					move3D.z + z * tileH);
					var tile:IsoTile=new IsoTile(tileH, pt3D, color);
					tile.drawTile();
					this.addChild(tile);
					pt3D=null;
					tile=null;
				}
			}
			 //[设置当前网格对象宽高]
			var isoRect:Rectangle=IsoUtils.getIsoRect(row,column,tileH);
			this.width=isoRect.width;
			this.height=isoRect.height;		
			move3D=null;			
			isoRect=null;					
		}
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			if(type==StaUtils.STAGGERED)
				clearStaggered();
			else
				clearIsometric();
			type=null;
		}
		/**
		 * "交错排列"垃圾清理
		 */
		public function clearStaggered():void
		{
			graphics.clear();
		}
		/**
		 * "等角"垃圾清理
		 */
		public function clearIsometric():void
		{
			var num:int=this.numChildren;
			for (var i:int=0; i < num; i++)
			{
				var tile:IsoTile=this.getChildAt(0) as IsoTile;
				tile.graphics.clear();
				tile=null;
				this.removeChildAt(0);
			}			
		}
	}
}