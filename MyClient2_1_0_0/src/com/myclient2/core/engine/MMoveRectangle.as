/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.engine
{
	import com.myclient2.core.MSprite;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * MMoveRectangle用于ARGP或ACT游戏的地图或场景的移动
	 * @author 王明凡
	 */
	public class MMoveRectangle extends MSprite
	{
		//程序启动第一次移动
		private var first:Boolean;
		//是否在移动
		private var isMove:Boolean;
		//地图
		private var map:MMap;
		//摄像机
		private var camera:MCamera;
		//速度x
		private var vx:int;
		//速度y
		private var vy:int;
		//缓动比例系数
		private var easing:Number;		
		//缓动矩形框
		private var rect:Rectangle;	
		
		/**
		 * 构造函数
		 * @param map
		 * @param camera
		 */
		public function MMoveRectangle(map:MMap, camera:MCamera)
		{
			first=true;
			isMove=false;
			this.map=map;
			this.camera=camera;
		}

		/**
		 * 初始化移动
		 * @param move
		 */
		public function onInitMove(move:Point):void
		{
			if (first)
			{
				first=false;
				onMoveRange(move);
				map.scrollRect=camera.getRectangle();
				rect=map.scrollRect;
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			move=null;
		}

		/**
		 * 根据给定的移动坐标移动摄像机，移动范围是当前摄像机记录的"矩形"信息(ARGP)
		 * @param move		要移动的坐标(通常是当前角色坐标)
		 * @return 			是否移动
		 */
		public function onMoveRectangle(move:Point,easing:Number):void
		{
			this.easing=easing;
			onMoveRange(move);
			isMove=true;
		}

		/**
		 * 根据给定的移动坐标移动摄像机，移动范围是当前摄像机记录的"矩形"信息(ACT)
		 * @param x			要移动的坐标x
		 * @param y			要移动的坐标y
		 * @param min		最小移动范围
		 * @param max		最大移动范围
		 */
		public function onMoveRectangle2(x:int, y:int, min:Rectangle, max:Rectangle,easing:Number):Boolean
		{
			this.easing=easing;
			var _x:int=camera.x;
			var _y:int=camera.y;
			//向左走
			if ((camera.x + x) > camera.x)
			{
				if (max.contains(min.x, min.y))
				{
					if (!max.containsRect(min))
					{
						onMoveRange2(x, y);
						isMove=true;
					}
				}
			}
			//向右走
			if ((camera.x + x) < camera.x)
			{
				if (max.contains(min.x + min.width, min.y + min.height))
				{
					if (!max.containsRect(min))
					{
						onMoveRange2(x, y);
						isMove=true;
					}
				}
			}
			//向上走
			if ((camera.y + y) < camera.y)
			{
				if (max.contains(min.x, min.y + min.height))
				{
					if (!max.containsRect(min))
					{
						onMoveRange2(x, y);
						isMove=true;
					}
				}
			}
			//向下走
			if ((camera.y + y) > camera.y)
			{
				if (max.contains(min.x, min.y))
				{
					if (!max.containsRect(min))
					{
						onMoveRange2(x, y);
						isMove=true;
					}
				}
			}
			//摄像机是否被移动
			if (_x == camera.x && _y == camera.y)
				isMove=false;
			return isMove;
		}

		/**
		 * 摄像机移动范围(ARGP)
		 * @param move
		 */
		private function onMoveRange(move:Point):void
		{
			if (camera.width < map.info.mapwidth)
			{
				if (move.x < (camera.width >> 1))
					camera.x=0;
				else if (move.x > map.info.mapwidth - (camera.width >> 1))
					camera.x=Math.floor(map.info.mapwidth - camera.width);
				else
					camera.x=Math.floor(move.x - (camera.width >> 1));
			}
			else
			{
				camera.x=0;
			}
			if (camera.height < map.info.mapheight)
			{
				if (move.y < (camera.height >> 1))
					camera.y=0;
				else if (move.y > map.info.mapheight - (camera.height >> 1))
					camera.y=Math.floor(map.info.mapheight - camera.height);
				else
					camera.y=Math.floor(move.y - (camera.height >> 1));
			}
			else
			{
				camera.y=0;
			}
			move=null;
		}

		/**
		 * 摄像机移动范围(ACT)
		 * @param move
		 */
		private function onMoveRange2(x:int, y:int):void
		{
			if ((camera.x + x) < 0)
				camera.x=0;
			else if ((camera.x + x + camera.width) > map.info.mapwidth)
				camera.x == Math.floor(map.info.mapwidth - camera.width);
			else
				camera.x+=x;

			if ((camera.y + y) < 0)
				camera.y=0;
			else if ((camera.y + y + camera.height) > map.info.mapheight)
				camera.y == Math.floor(map.info.mapheight - camera.height);
			else
				camera.y+=y;
		}		
		/**
		 * 开始移动动画
		 * @param e
		 */
		private function onEnterFrame(e:Event):void
		{
			if (isMove)
			{
				if(easing==1)
				{
					isMove=false;
					map.scrollRect=camera.getRectangle();
				}
				else
				{
					vx=camera.getRectangle().x-map.scrollRect.x;
					vy=camera.getRectangle().y-map.scrollRect.y;
					rect.x+= Number((vx*easing).toFixed(2));
					rect.y+= Number((vy*easing).toFixed(2));
					map.scrollRect=rect;
					var distance:Number=Point.distance(new Point(map.scrollRect.x,map.scrollRect.y),new Point(camera.getRectangle().x,camera.getRectangle().y));
					if(Math.abs(distance)<1)
						isMove=false;					
				}
			}
		}
		/**
		 * 清理垃圾
		 */
		override public function clear():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			map=null;
			camera=null;
			rect=null;
		}
	}
}