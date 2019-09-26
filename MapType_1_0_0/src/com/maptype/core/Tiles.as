package com.maptype.core
{
	import com.maptype.core.isometric.IsoPoint3D;
	import com.maptype.core.isometric.IsoUtils;
	import com.maptype.core.staggered.StaUtils;
	import com.maptype.interfaces.ITiles;
	import com.maptype.vo.PointVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 平铺地砖层
	 * @author wangmingfan
	 */
	public class Tiles extends Sprite implements ITiles
	{
		public function Tiles()
		{
			
		}
		/**
		 * 
		 * @param type
		 * @param data
		 * @param row
		 * @param column
		 * @param tileH
		 */
		public function onTiles(type:String, data:BitmapData, row:int, column:int, tileH:int):void
		{
			if(type==StaUtils.STAGGERED)
				onStaggeredTiles(data,row,column,tileH);
			else	
				onIsometricTiles(data,row,column,tileH);	
			data=null;			
		}
		/**
		 * 绘制"交错排列"平铺地砖
		 * @param data
		 * @param row
		 * @param column
		 * @param tileH
		 */
		private function onStaggeredTiles(data:BitmapData, row:int, column:int,tileH:int):void
		{
			if(!data)
				return;
			var maxW:int=column*(tileH<<1);
			var maxH:int=(row*tileH)>>1;
			var min:BitmapData=getStaggeredMin(data,maxW>>2,maxH>>2);
			var nRow:int=Math.floor(maxH/min.height);
			var nColumn:int=Math.floor(maxW/min.width);
			for (var y:int=0; y < nRow; y++)
			{
				for (var x:int=0; x < nColumn; x++)
				{
					var btm:Bitmap=new Bitmap(min);
					btm.x=x * btm.width;
					btm.y=y * btm.height;
					this.addChild(btm);					
				}
			}
			data=null;
			min=null;
		}
		/**
		 * 获得"交错排列"的小位图数据
		 * @param data
		 * @param minW
		 * @param minH
		 * @return 
		 */
		private function getStaggeredMin(data:BitmapData,minW:Number,minH:Number):BitmapData
		{
			var row:int=Math.ceil(minH/data.height);
			var column:int=Math.ceil(minW/data.width);
			var min:BitmapData=new BitmapData(minW,minH,true,0);
			var rect:Rectangle=new Rectangle(0, 0, data.width, data.height);
			var pt:Point=new Point();			
			for(var y:int=0;y<row;y++)
			{
				for(var x:int=0;x<column;x++)
				{
					pt.x=x*data.width;
					pt.y=y*data.height;
					min.copyPixels(data,rect,pt,null,null,true);
				}
			}
			rect=null;
			pt=null;
			data=null;
			return min;	
		}
		/**
		 * 绘制"等角"
		 * @param data
		 * @param row
		 * @param column
		 * @param tileH
		 */
		private function onIsometricTiles(data:BitmapData, row:int, column:int,tileH:int):void
		{
			if(!data)
				return;
			//当前路点偏移的3D坐标	
			var move3D:IsoPoint3D=IsoUtils.getMove3D(row,column,tileH);	
			//当前位图大小
			var isoRect:Rectangle=IsoUtils.getIsoRect(row,column,tileH);
			//创建透明位图数据				
			var max:BitmapData=new BitmapData(isoRect.width,isoRect.height,true,0);	
			var rect:Rectangle=new Rectangle(0, 0, data.width, data.height);
			var pt:Point=new Point();						
			for(var z:int=0;z<row;z++)
			{				
				for(var x:int=0;x<column;x++)
				{
					var pt2D:PointVO=IsoUtils.isoToScreen(new IsoPoint3D(
										move3D.x + (x * tileH),
										move3D.y +0,
										move3D.z + (z * tileH)));	
					pt.x=pt2D.x-=tileH;
					pt.y=pt2D.y-=tileH>>1;
					max.copyPixels(data,rect,pt,null,null,true);		
					pt2D=null;		
				}
			}		
			this.addChild(new Bitmap(max));
			move3D=null;
			isoRect=null;
			rect=null;
			pt=null;	
			data=null;							
		}				
		/**
		 * 当前类垃圾清理
		 */
		public function clear():void
		{
			if (this.numChildren > 0)
			{
				var len:int=this.numChildren;
				for(var i:int=0;i<len;i++)
				{
					var btm:Bitmap=this.getChildAt(0) as Bitmap;
					btm.bitmapData.dispose();
					btm=null;	
					this.removeChildAt(0);				
				}
			}
		}					
	}
}