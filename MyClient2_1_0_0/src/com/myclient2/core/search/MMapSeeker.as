/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.search
{
	import com.myclient2.core.vo.MRoadVO;
	import com.myclient2.util.MStaUtils;
	
	import flash.geom.Point;

	/**
	 * MMapSeeker地图寻路类，用于"等角"和"交错排列"类型地图进行寻路，继承MSearch
	 * @author 王明凡
	 */
	public class MMapSeeker extends MSearch
	{
		//字符串路点数组集合
		private var _strRoadArr:Array;

		/**
		 * 构造函数
		 * @param mapType
		 * @param floor
		 * @param row
		 * @param column
		 */
		public function MMapSeeker(mapType:String, floor:String, row:int, column:int)
		{
			strRoadArr=getTwoArray(floor, row, column);
			var dArr:Array=getDirectRoadArray(mapType, row, column);
			setDirectRoadArray(mapType, dArr,row, column);
			super(dArr);
			dArr=null;
		}
		/**
		 * 设置直角路点对象数组
		 * @param mapType
		 * @param dArr
		 * @param row
		 * @param column
		 */
		private function setDirectRoadArray(mapType:String, dArr:Array,row:int, column:int):void
		{
			for (var y:int=0; y < row; y++)
			{
				for (var x:int=0; x < column; x++)
				{
					var dpt:Point;
					if(mapType==MStaUtils.STAGGERED)
						dpt=MStaUtils.getDirectPoint(x, y, row);
					else
						dpt=new Point(x,y);
					dArr[dpt.y][dpt.x].type=strRoadArr[y][x];
					dArr[dpt.y][dpt.x].rhombusX=x;
					dArr[dpt.y][dpt.x].rhombusY=y;
					dpt=null;
				}
			}
			dArr=null;
		}

		/**
		 * 获得直角路点对象数组
		 * @param mapType
		 * @param row
		 * @param column
		 * @return
		 */
		private function getDirectRoadArray(mapType:String, row:int, column:int):Array
		{
			var dArr:Array=new Array();
			var nRow:int=row;
			var nColumn:int=column;
			if (mapType == MStaUtils.STAGGERED)
			{
				nRow=MStaUtils.getDirectPoint(column, 0, row).x;
				nColumn=MStaUtils.getDirectPoint(column, row, row).y;
			}
			for (var y:int=0; y < nRow + 1; y++)
			{
				dArr.push(new Array());
				for (var x:int=0; x < nColumn + 1; x++)
				{
					var rVO:MRoadVO=new MRoadVO();
					rVO.ix=x;
					rVO.iy=y;
					dArr[y][x]=rVO;
					rVO=null;
				}
			}
			return dArr;
		}

		/**
		 * 获得路点字符串的二维数组
		 * @param floor
		 * @param row
		 * @param column
		 * @return
		 */
		private function getTwoArray(floor:String, row:int, column:int):Array
		{
			var arr:Array=floor.split(',');
			var roadArr:Array=new Array();
			var count:int=0;
			for (var y:int=0; y < row; y++)
			{
				roadArr.push(new Array());
				for (var x:int=0; x < column; x++)
				{
					roadArr[y][x]=arr[count];
					count++;
				}
			}
			return roadArr;
		}
		/**
		 * 设置字符串路点数组(0,1,2)集合
		 * @param strRoadArr
		 */
		public function set strRoadArr(strRoadArr:Array):void
		{
			_strRoadArr=strRoadArr;
		}
		/**
		 * 获得字符串路点数组(0,1,2)集合
		 * @return 
		 */
		public function get strRoadArr():Array
		{
			return _strRoadArr;
		}
		/**
		 * 垃圾清理
		 */
		override public function clear():void
		{
			if(strRoadArr)
				strRoadArr.splice(0,strRoadArr.length);
			strRoadArr=null;
			super.clear();
		}
	}
}