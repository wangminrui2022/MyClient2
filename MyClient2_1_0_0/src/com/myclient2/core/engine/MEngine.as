/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.engine
{
	import com.myclient2.core.quadtree.*;
	import com.myclient2.core.search.MMapSeeker;
	import com.myclient2.core.vo.MObjectsVO;
	import com.myclient2.interfaces.*;
	import com.myclient2.util.MIsoUtils;
	import com.myclient2.util.MStaUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * MEngine 用于渲染地图显示对象(也可以称作贴图)，以及操作地图显示对象
	 * @author 王明凡
	 */
	public class MEngine implements IEngine
	{
		private var container:Sprite;
		private var map:MMap;
		private var viewPort:MViewPort;
		private var camera:MCamera;
		private var quadtree:MQuadtree;
		private var rootNode:MQuadtreeNode;
		private var tiles:MTiles;
		private var moveRectangle:MMoveRectangle;
		
		private var _mapSeeker:MMapSeeker;
		private var _block:MBlock;
		private var _clippingOperateArr:Array;
		/**
		 * 是否需要引擎剔除场景里的操作对象(显示对象的材质类型为"operate"),不对剔除对象进行渲染
		 * @default
		 */
		public var isClippingOperate:Boolean;

		/**
		 * 构造函数
		 * @param container
		 */
		public function MEngine(container:Sprite)
		{
			this.container=container;
		}

		/**
		 * 通过给定的"地图","观察口"以及"摄像机",进行地图渲染
		 * @param map		地图
		 * @param viewPort	观察口
		 * @param camera	摄像机
		 */
		public function renderMap(map:IMap, viewPort:MViewPort, camera:IRectangle):void
		{
			this.map=map as MMap;
			this.viewPort=viewPort;
			this.camera=camera as MCamera;
			initRenderScene();
		}

		/**
		 * 根据给定的移动坐标移动摄像机，移动范围是当前摄像机记录的"矩形"信息
		 * @param move		要移动的坐标(通常是当前角色坐标)
		 * @return 			是否移动
		 * @param easing	移动时的缓动系数0-1之间
		 */
		public function moveCamera(move:Point,easing:Number=1):void
		{
			moveRectangle.onMoveRectangle(move,easing);
			quadtree.selectQuadtree(rootNode, camera.getRectangle());
			move=null;
		}
		
		/**
		 * 根据给定的移动坐标移动摄像机，移动范围是当前摄像机记录的"矩形"信息
		 * @param x			要移动的坐标x
		 * @param y			要移动的坐标y
		 * @param min		最小移动范围
		 * @param max		最大移动范围
		 * @param easing	移动时的缓动系数0-1之间
		 */
		public function moveCamera2(x:int,y:int,min:Rectangle,max:Rectangle,easing:Number=0.6):void
		{
			var result:Boolean=moveRectangle.onMoveRectangle2(x,y,min,max,easing);
			if(result)
				quadtree.selectQuadtree(rootNode, camera.getRectangle());
			min=null;
			max=null;
		}
		/**
		 * 根据起点和终点搜索当前地图的路径
		 * @param start		起点
		 * @param end		终点
		 * @return 			搜索的结果
		 */
		public function searchRoad(start:Point, end:Point):Array
		{
			var tileW:int=map.info.tileWidth;
			var tileH:int=map.info.tileHeight;
			var row:int=map.info.row
			var startIndex:Point;
			var endIndex:Point;
			var startDpt:Point;
			var endDpt:Point;
			if (map.info.mapType == MStaUtils.STAGGERED)
			{
				startIndex=MStaUtils.getStaggeredIndex(start, tileW, tileH);
				endIndex=MStaUtils.getStaggeredIndex(end, tileW, tileH);
				startDpt=MStaUtils.getDirectPoint(startIndex.x, startIndex.y, row);
				endDpt=MStaUtils.getDirectPoint(endIndex.x, endIndex.y, row);

			}
			else
			{
				startDpt=MIsoUtils.getIsometricIndex(start, tileH, map.move3D);
				endDpt=MIsoUtils.getIsometricIndex(end, tileH, map.move3D);
			}
			start=null;
			end=null;
			startIndex=null;
			endIndex=null;
			return mapSeeker.getRoad(startDpt, endDpt);
		}

		/**
		 * 从当前显示容器中移除当前引擎渲染的地图,包含清理该地图中所有的显示对象以及地图信息数据
		 */
		public function removeMap():void
		{
			if (map)
			{
				container.removeChild(map);
				map.clear();
			}
			if (quadtree)
			{
				quadtree.deleteQuadtree(rootNode);
				quadtree.clear();
			}
			if (tiles)
				tiles.clear();
			if (block)
				block.clear();
			if (mapSeeker)
				mapSeeker.clear();
			if (moveRectangle)
				moveRectangle.clear();
			if (clippingOperateArr)
				clippingOperateArr.splice(0, clippingOperateArr.length);
			container=null;
			map=null;
			viewPort=null;
			camera=null;
			quadtree=null;
			rootNode=null;
			tiles=null;
			block=null;
			mapSeeker=null;
			moveRectangle=null;
			clippingOperateArr=null;
		}

		/**
		 * 添加某个显示对象在地图中的阴影点透明
		 * @param shadow	当前显示对象(一般是移动角色)
		 */
		public function onShadow(shadow:DisplayObject):void
		{
			var tileH:int=map.info.tileHeight;
			var pt:Point=new Point(shadow.x, shadow.y);
			if (map.info.mapType == MStaUtils.STAGGERED)
				pt=MStaUtils.getStaggeredIndex(pt, tileH << 1, tileH);
			else
				pt=MIsoUtils.getIsometricIndex(pt, tileH, map.move3D);
			if (pt.x < map.info.column && pt.y < map.info.row)
			{
				if (mapSeeker.strRoadArr[pt.y][pt.x] == 2)
					shadow.alpha=0.4;
				else
					shadow.alpha=1;
			}
			pt=null;
			shadow=null;
		}

		/**
		 * 设置当前引擎剔除不渲染对象的(用户自定义操作对象)集合
		 */
		public function set clippingOperateArr(clippingOperateArr:Array):void
		{
			_clippingOperateArr=clippingOperateArr;
		}

		/**
		 * 返回当前引擎剔除不渲染对象的(用户自定义操作对象)集合
		 * @return
		 */
		public function get clippingOperateArr():Array
		{
			return _clippingOperateArr;
		}

		/**
		 * 设置当前地图渲染显示对象
		 * @return
		 */
		public function set block(block:MBlock):void
		{
			_block=block;
		}

		/**
		 * 获得当前地图渲染显示对象
		 * @return
		 */
		public function get block():MBlock
		{
			return _block;
		}
		/**
		 * 设置地图寻路类
		 * @param mapSeeker
		 */
		public function set mapSeeker(mapSeeker:MMapSeeker):void
		{
			_mapSeeker=mapSeeker;
		}		
		/**
		 * 获得地图寻路类
		 * @return 
		 */
		public function get mapSeeker():MMapSeeker
		{
			return _mapSeeker;
		}
		/**
		 * 引擎初始化场景,平铺地图层,分块显示,寻路,四叉树根节点,四叉树整个数据结构节点
		 */
		private function initRenderScene():void
		{
			//是否需要引擎剔除场景里的操作对象
			if (isClippingOperate)
				clippingOperate();
			//初始化地图对象,如果地图类型为等角类型,则设置当前路点偏移的3D坐标
			map.x=viewPort.x;
			map.y=viewPort.y;
			map.scrollRect=camera.getRectangle();
			container.addChild(map);
			//创建平铺地图
			tiles=new MTiles();
			map.addChild(tiles);
			if (map.info.diffuse != MMaterialUsed.NULL)
				tiles.onTiles(map.info.mapType, map.info.diffuse, map.SWFLoaderArr, map.info.row, map.info.column, map.info.tileHeight);
			//地图加载完成后重新设置地图宽,高
			resetMapWH();
			//创建移动矩形
			moveRectangle=new MMoveRectangle(map, camera);
			//创建分块加载
			block=new MBlock(map);
			//创建地图寻路
			mapSeeker=new MMapSeeker(map.info.mapType, map.info.floor, map.info.row, map.info.column);
			//创建当前地图显示对象集合的根节点
			rootNode=new MQuadtreeNode(1, map.x, map.y, map.info.mapwidth, map.info.mapheight, map.info.mObjectsVOArr, null);
			//创建四叉树
			quadtree=new MQuadtree(map.info.mapwidth / 10, map.info.mapheight / 10, onCreateComplete, onSerachComplete);
			quadtree.createQuadtree(rootNode);
		}

		/**
		 * 地图加载完成后重新设置地图宽,高
		 */
		private function resetMapWH():void
		{
			if (map.info.mapType == MIsoUtils.ISOMETRIC)
			{
				var isoRect:Rectangle=MIsoUtils.getIsoRect(map.info.row, map.info.column, map.info.tileHeight);
				map.info.mapwidth=isoRect.width;
				map.info.mapheight=isoRect.height;
				isoRect=null;
			}
			else
			{
				if (tiles.width > 0 && tiles.height > 0)
				{
					map.info.mapwidth=tiles.width;
					map.info.mapheight=tiles.height;
				}
			}
		}

		/**
		 * 四叉树创建完成
		 * 根据初始化的摄像机参数，进行四叉树区域搜索
		 */
		private function onCreateComplete():void
		{
			//初始化移动
			moveRectangle.onInitMove(new Point(camera.getRectangle().x, camera.getRectangle().y));
			//进行四叉树区域搜索
			quadtree.selectQuadtree(rootNode, camera.getRectangle());
		}

		/**
		 * 四叉树搜索完成,根据摄像机的信息分块显示场景中显示对象
		 * @param serachResult
		 */
		private function onSerachComplete(serachResult:Array):void
		{
			block.onBlockDisplay(serachResult, camera.getRectangle());
		}

		/**
		 * 剔除地图中要操作的对象，并添加到剔除集合里
		 * @param sceneObjectArr
		 */
		private function clippingOperate():void
		{
			//创建被剔除对象的集合
			clippingOperateArr=new Array();
			//地图对象以及材质信息描述规范集合
			if (!map.info.mObjectsVOArr)
				return;
			var len:int=map.info.mObjectsVOArr.length;
			for (var i:int=0; i < len; i++)
			{
				var ojVO:MObjectsVO=map.info.mObjectsVOArr[i] as MObjectsVO;
				if (ojVO.materialDefinition.used == MMaterialUsed.OPERATE)
				{
					map.info.mObjectsVOArr.splice(i, 1);
					len-=1;
					i-=1;
					clippingOperateArr.push(ojVO);
				}
				ojVO=null;
			}
		}
	}
}