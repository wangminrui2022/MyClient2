/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.engine
{
	import com.myclient2.core.MIsoPoint3D;
	import com.myclient2.core.MSprite;
	import com.myclient2.interfaces.ITiles;
	import com.myclient2.util.MIsoUtils;
	import com.myclient2.util.MStaUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * MTiles用于显示到MMap中的平铺地砖对象，平铺整个MMap
	 * @author 王明凡
	 */	
	public class MTiles extends MSprite implements ITiles
	{
		public function MTiles()
		{
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.tabChildren=false;
			this.useHandCursor=false;
		}
		
		/**
		 * 平铺整个MMap
		 * @param type			IMap类型"isometric"和"staggered"
		 * @param diffuse		IMap材质的类定义名称
		 * @param SWFLoaderArr	要搜索的材质集合
		 * @param row			IMap行
		 * @param column		IMap列
		 * @param tileH			地砖高
		 */
		public function onTiles(type:String, diffuse:String, SWFLoaderArr:Array, row:int, column:int, tileH:int):void
		{
			var cls:Class=getMaterialClass(diffuse, SWFLoaderArr);
			var data:BitmapData=getTile(cls);
			if (type == MStaUtils.STAGGERED)
				onStaggeredTiles(data, row, column, tileH);
			else
				onIsometricTiles(data, row, column, tileH);
			cls=null;
			data=null;
			SWFLoaderArr=null;
		}

		/**
		 * 绘制"交错排列"平铺地砖
		 * @param data
		 * @param row
		 * @param column
		 * @param tileH
		 */
		private function onStaggeredTiles(data:BitmapData, row:int, column:int, tileH:int):void
		{
			if (!data)
				return;
			var maxW:int=column * (tileH << 1);
			var maxH:int=(row * tileH) >> 1;
			var min:BitmapData=getStaggeredMin(data, maxW >> 2, maxH >> 2);
			var nRow:int=Math.floor(maxH / min.height);
			var nColumn:int=Math.floor(maxW / min.width);
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
		private function getStaggeredMin(data:BitmapData, minW:Number, minH:Number):BitmapData
		{
			var row:int=Math.ceil(minH / data.height);
			var column:int=Math.ceil(minW / data.width);
			var min:BitmapData=new BitmapData(minW, minH, true, 0);
			var rect:Rectangle=new Rectangle(0, 0, data.width, data.height);
			var pt:Point=new Point();
			for (var y:int=0; y < row; y++)
			{
				for (var x:int=0; x < column; x++)
				{
					pt.x=x * data.width;
					pt.y=y * data.height;
					min.copyPixels(data, rect, pt, null, null, true);
				}
			}
			rect=null;
			pt=null;
			data=null;
			return min;
		}

		/**
		 * 绘制"等角"平铺地砖
		 * @param data
		 * @param row
		 * @param column
		 * @param tileH
		 * @param divide
		 */
		private function onIsometricTiles(data:BitmapData, row:int, column:int, tileH:int):void
		{
			if (!data)
				return;
			//当前路点偏移的3D坐标	
			var move3D:MIsoPoint3D=MIsoUtils.getMove3D(row, column, tileH);
			//当前位图大小
			var isoRect:Rectangle=MIsoUtils.getIsoRect(row, column, tileH);
			//创建透明位图数据				
			var max:BitmapData=new BitmapData(isoRect.width, isoRect.height, true, 0);
			var rect:Rectangle=new Rectangle(0, 0, data.width, data.height);
			var pt:Point=new Point();
			for (var z:int=0; z < row; z++)
			{
				for (var x:int=0; x < column; x++)
				{
					var pt2D:Point=MIsoUtils.isoToScreen(new MIsoPoint3D(move3D.x + (x * tileH), move3D.y + 0, move3D.z + (z * tileH)));
					pt.x=pt2D.x-=tileH;
					pt.y=pt2D.y-=tileH >> 1;
					max.copyPixels(data, rect, pt, null, null, true);
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
		/**
		 * 垃圾清理
		 */
		override public function clear():void
		{
			if (this.numChildren > 0)
			{
				var len:int=this.numChildren;
				for (var i:int=0; i < len; i++)
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