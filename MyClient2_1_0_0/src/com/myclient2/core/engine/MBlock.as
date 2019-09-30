/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.engine
{
	import com.myclient2.core.vo.MObjectsVO;
	
	import flash.geom.Rectangle;

	/**
	 * MBlock用于地图基本分块显示渲染，主要用于对四叉树搜索后的结果进行分块显示渲染，深度计算显示。
	 * @author 王明凡
	 */
	public class MBlock
	{
		private var map:MMap;
		private var _mObjectsArr:Array;

		/**
		 * 构造函数
		 * @param map
		 */
		public function MBlock(map:MMap)
		{
			this.map=map;
			this._mObjectsArr=new Array();
		}
		/**
		 * 根据矩形区域分块显示地图对象以及材质信息集合到场景中
		 * @param mObjectsVOArr		对象以及材质信息集合
		 * @param rect				矩形区域
		 */
		public function onBlockDisplay(mObjectsVOArr:Array, rect:Rectangle):void
		{
			//如果当前显示集合里已有显示对象
			if (mObjectsArr.length > 0)
				onMObjectsArrIntersection(rect);
			onLoopDisplay(mObjectsVOArr);
			mObjectsVOArr.splice(0, mObjectsVOArr.length);
			mObjectsVOArr=null;
			rect=null;
		}
		/**
		 * 设置地图显示对象集合
		 * @param mObjectsArr
		 */
		public function set mObjectsArr(mObjectsArr:Array):void
		{
			_mObjectsArr=mObjectsArr;
		}
		/**
		 * 返回地图显示对象集合
		 * @return
		 */
		public function get mObjectsArr():Array
		{
			return _mObjectsArr;
		}
		/**
		 *垃圾清理
		 */
		public function clear():void
		{
			map=null;
			if (mObjectsArr)
			{
				for each (var oj:MObjects in mObjectsArr)
				{
					oj.clear();
					oj=null;
				}
				mObjectsArr.splice(0, mObjectsArr.length);
			}
			mObjectsArr=null;
		}		
		/**
		 * 矩形区与地图中现有显示对象是否相交,如果是未相交,则从地图中移除该对象
		 * @param rect
		 */
		private function onMObjectsArrIntersection(rect:Rectangle):void
		{
			var len:int=mObjectsArr.length;
			for (var i:int=0; i < len; i++)
			{
				var oj:MObjects=mObjectsArr[i] as MObjects;
				if (rect.intersection(oj.ojVO.getRectangle()).isEmpty())
				{
					oj.clear();
					map.removeChild(oj);
					mObjectsArr.splice(i, 1);
					i-=1;
					len-=1;
					MPool.CheckIn(oj);
				}
				oj=null;
			}
			rect=null;
		}
		/**
		 * 循环显示场景对象
		 * @param mObjectsVOArr
		 */
		private function onLoopDisplay(mObjectsVOArr:Array):void
		{
			mObjectsVOArr.sort(onSortMObjectsVO);
			for each (var ojVO:MObjectsVO in mObjectsVOArr)
			{
				if (!existMObjects(ojVO.id))
				{
					var oj:MObjects=MPool.CheckOut(MObjects) as MObjects;
					oj.mouseChildren=false;
					oj.mouseEnabled=false;
					oj.tabChildren=false;
					oj.useHandCursor=false;
					oj.onDisplay(ojVO, map.SWFLoaderArr);
					oj.x=oj.ojVO.x;
					oj.y=oj.ojVO.y;
					map.addChild(oj);
					addedSort(oj);
					mObjectsArr.push(oj);
				}
				ojVO=null;
			}
			mObjectsVOArr=null;
		}	
		/**
		 * 当前对象被添加到地图后，找出于该对象相交的其他对象，"只对当前对象"进行深度排序
		 * @param oj
		 */
		private function addedSort(oj:MObjects):void
		{
			for each(var i:MObjects in mObjectsArr)
			{
				if(oj.getRect(map).intersection(i.getRect(map)).isEmpty()==false)
				{
					addDepth(oj,i);
				}
				i=null;
			}
			oj=null;
		}
		/**
		 * 递归判断对象1和对象2的深度，并且递归加或减深度
		 * @param oj1
		 * @param oj2
		 */
		private function addDepth(oj1:MObjects,oj2:MObjects):void
		{
			if(oj1.ojVO.depth>oj2.ojVO.depth)
			{
				if(map.getChildIndex(oj1)<map.getChildIndex(oj2))
				{
					var depth1:int=map.getChildIndex(oj1);
					map.setChildIndex(oj1,++depth1);
					addDepth(oj1,oj2);
				}
			}
			else
			{
				if(map.getChildIndex(oj1)>map.getChildIndex(oj2))
				{
					var depth2:int=map.getChildIndex(oj1);
					map.setChildIndex(oj1,--depth2);
					addDepth(oj1,oj2);
				}			
			}
			oj1=null;
			oj2=null;
		}
		/**
		 * 地图对象实体类进行大小排序
		 * 临时对当前场景对象进行深度排序,用于解决四叉树数据结构破坏的深度问题
		 * @param a
		 * @param b
		 */
		private function onSortMObjectsVO(a:MObjectsVO, b:MObjectsVO):Number
		{
			if (a.depth > b.depth)
				return 1;
			else if (a.depth < b.depth)
				return -1;
			else
				return 0;
		}

		/**
		 * 是否已经存在显示对象
		 * @param id
		 * @return
		 */
		private function existMObjects(id:String):Boolean
		{
			for each (var oj:MObjects in mObjectsArr)
			{
				if (oj.ojVO.id == id)
					return true;
			}
			return false;
		}
	}
}