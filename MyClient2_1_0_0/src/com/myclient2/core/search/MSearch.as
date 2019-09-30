/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.search
{
	import com.myclient2.core.vo.MRoadVO;
	import com.myclient2.interfaces.ISearch;

	import flash.geom.Point;

	/**
	 * MSearch主要用于A*寻路,用于对直角路点数组进行寻路
	 * @author 王明凡
	 */
	public class MSearch implements ISearch
	{
		private var mapArr:Array;
		private var row:int;
		private var column:int;
		private var openList:Array;
		private var closeList:Array;
		private var start:MRoadVO;
		private var end:MRoadVO;

		/**
		 * 构造函数
		 * @param mapArr
		 */
		public function MSearch(mapArr:Array)
		{
			this.mapArr=mapArr;
			this.row=this.mapArr.length - 1;
			this.column=this.mapArr[0].length - 1;
			openList=new Array();
			closeList=new Array();
		}

		/**
		 * 根据起点和终点返回寻路结果
		 * @param start		起点
		 * @param end		终点
		 * @return			结果集合
		 */
		public function getRoad(start:Point, end:Point):Array
		{
			var searchRoadArr:Array=new Array();
			if (end.y < mapArr.length && end.x < mapArr[0].length)
			{
				this.start=mapArr[start.y][start.x] as MRoadVO;
				this.end=mapArr[end.y][end.x] as MRoadVO;
				if (this.end.type != 1)
				{
					this.openList.push(this.start);
					while (true)
					{
						try
						{
							var searchRoad:MRoadVO=openList.splice(getMinF(), 1)[0];
							if (searchRoad.ix == this.end.ix && searchRoad.iy == this.end.iy)
							{
								while (searchRoad.father != this.start.father)
								{
									searchRoadArr.push(searchRoad);
									searchRoad=searchRoad.father;
								}
								searchClear();
								searchRoadArr.reverse();
								return searchRoadArr;
								break;
							}
							closeList.push(searchRoad);
							checkRoad(searchRoad);
						}
						catch (er:Error)
						{
							searchClear();
							break;
						}
					}
				}
			}
			start=null;
			end=null;
			searchRoadArr=null;
			return null;
		}

		/**
		 * 当前点的周围八点寻路
		 * @param searchRoad
		 */
		private function checkRoad(searchRoad:MRoadVO):void
		{
			var ix:int=searchRoad.ix;
			var iy:int=searchRoad.iy;
			if (ix > 0 && mapArr[iy][ix - 1].type != 1)
			{
				searchMain(mapArr[iy][ix - 1], searchRoad, 10);
				if (iy > 0 && mapArr[iy - 1][ix - 1].type != 1 && mapArr[iy - 1][ix].type != 1)
					searchOther(mapArr[iy - 1][ix - 1], searchRoad, 14);
				if (iy < row && mapArr[iy + 1][ix - 1].type != 1 && mapArr[iy + 1][ix].type != 1)
					searchOther(mapArr[iy + 1][ix - 1], searchRoad, 14);
			}
			if (ix < column && mapArr[iy][ix + 1].type != 1)
			{
				searchMain(mapArr[iy][ix + 1], searchRoad, 10);
				if (iy > 0 && mapArr[iy - 1][ix + 1].type != 1 && mapArr[iy - 1][ix].type != 1)
					searchOther(mapArr[iy - 1][ix + 1], searchRoad, 14);
				if (iy < row && mapArr[iy + 1][ix + 1].type != 1 && mapArr[iy + 1][ix].type != 1)
					searchOther(mapArr[iy + 1][ix + 1], searchRoad, 14);
			}
			if (iy > 0 && mapArr[iy - 1][ix].type != 1)
				searchMain(mapArr[iy - 1][ix], searchRoad, 10);
			if (iy < row && mapArr[iy + 1][ix].type != 1)
				searchMain(mapArr[iy + 1][ix], searchRoad, 10);
			searchRoad=null;
		}

		/**
		 * 搜索主要4点(上下左右)
		 * @param current
		 * @param searchRoad
		 * @param G
		 */
		private function searchMain(current:MRoadVO, searchRoad:MRoadVO, G:int):void
		{
			if (!inList(current, closeList))
			{
				if (!inList(current, openList))
				{
					setGHF(current, searchRoad, G);
					openList.push(current);
				}
				else
				{
					checkG(current, searchRoad);
				}
			}
			current=null;
			searchRoad=null;
		}

		/**
		 * 搜索其他4点
		 * @param current
		 * @param searchRoad
		 * @param G
		 */
		private function searchOther(current:MRoadVO, searchRoad:MRoadVO, G:int):void
		{
			if (!inList(current, closeList) && !inList(current, openList))
			{
				setGHF(current, searchRoad, G);
				openList.push(current);
			}
			current=null;
			searchRoad=null;
		}

		/**
		 * 设置节点的G/H/F值
		 * @param current
		 * @param searchRoad
		 * @param G
		 */
		private function setGHF(current:MRoadVO, searchRoad:MRoadVO, G:int):void
		{
			if (!searchRoad.G)
				searchRoad.G=0;
			current.G=searchRoad.G + G;
			//曼哈顿估价法(Manhattan heuristic)
			current.H=(Math.abs(current.ix - end.ix) + Math.abs(current.iy - end.iy)) * 10;
			current.F=current.G + current.H;
			current.father=searchRoad;
			current=null;
			searchRoad=null;
		}

		/**
		 * 如果当前路点已在开放列表,则检查当前搜索的点到检查路点是否G值更小
		 * @param check
		 * @param searchRoad
		 */
		private function checkG(check:MRoadVO, searchRoad:MRoadVO):void
		{
			var newG:int=searchRoad.G + 10
			if (newG <= check.G)
			{
				check.G=newG;
				check.F=check.H + check.G;
				check.father=searchRoad;
			}
			check=null;
			searchRoad=null;
		}

		/**
		 * 当前路点是否在(开放/关闭)列表
		 * @param searchRoad
		 * @param arr
		 * @return
		 */
		private function inList(searchRoad:MRoadVO, arr:Array):Boolean
		{
			for each (var rVO:MRoadVO in arr)
			{
				if (rVO.ix == searchRoad.ix && rVO.iy == searchRoad.iy)
					return true;
			}
			searchRoad=null;
			arr=null;
			return false;
		}

		/**
		 * 获取开启列表中的F值最小的节点，返回的是该节点所在的索引
		 * @return
		 */
		private function getMinF():uint
		{
			var tmpF:uint=10000000;
			var id:int=0;
			var rid:int;
			for each (var rVO:MRoadVO in openList)
			{
				if (rVO.F < tmpF)
				{
					tmpF=rVO.F;
					rid=id;
				}
				rVO=null;
				id++;
			}
			return rid;
		}

		/**
		 * 清理当前寻路垃圾
		 */
		private function searchClear():void
		{
			start=null;
			end=null;
			openList.splice(0, openList.length);
			closeList.splice(0, closeList.length);
		}

		/**
		 * 清理全部垃圾
		 */
		public function clear():void
		{
			searchClear();
			openList=null;
			closeList=null;
			mapArr.splice(0, mapArr.length);
			mapArr=null;
			row=0;
			column=0;
		}
	}
}