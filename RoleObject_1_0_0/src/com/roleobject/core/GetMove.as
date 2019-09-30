package com.roleobject.core
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import com.roleobject.interfaces.IGetMove;
	import com.roleobject.vo.MoveVO;

	/**
	 * 计算获得移动数组
	 * @author 王明凡
	 */
	public class GetMove extends EventDispatcher implements IGetMove
	{
		protected var mapType:String;
		protected var tileW:int;
		protected var tileH:int;
		/**
		 * "交错排列"地图类型
		 * @default 
		 */
		public static const STAGGERED:String="staggered";	
		/**
		 * 1.2247的精确计算
		 * @default 
		 */
		public static const Y_CORRECT:Number = Math.cos(-Math.PI / 6) * Math.SQRT2;
		
				
		public function GetMove(mapType:String,tileW:int, tileH:int)
		{
			this.mapType=mapType;
			this.tileW=tileW;
			this.tileH=tileH;
		}
		/**
		 * 获得移动数组
		 * @param roadArr
		 * @param first
		 * @param move3D
		 * @return 
		 */
		public function getMoveArr(roadArr:Array, first:Point,move3D:RoleObjectIsoPoint3D):Array
		{
			var moveArr:Array=new Array();
			//计算数组第一段路
			var end1:Point=getPoint(roadArr[0].rhombusX, roadArr[0].rhombusY, tileW, tileH, move3D);
			moveArr.push(getMoveVO(first, end1));
			end1=null;
			//计算数组剩余的路
			for (var i:int=0; i < roadArr.length - 1; i++)
			{
				var tmpStart:Point=getPoint(roadArr[i].rhombusX, roadArr[i].rhombusY, tileW, tileH, move3D);
				var tmpEnd:Point=getPoint(roadArr[i + 1].rhombusX, roadArr[i + 1].rhombusY, tileW, tileH, move3D);
				moveArr.push(getMoveVO(tmpStart, tmpEnd));
				tmpStart=null;
				tmpEnd=null;
			}
			//剔除相同方向的路
			var len:int=moveArr.length;
			for (var j:int; j < len - 1; j++)
			{
				if (moveArr[j].direct == moveArr[j + 1].direct)
				{
					moveArr.splice(j, 1);
					len-=1;
					j-=1;
				}
			}			
			roadArr=null;
			return moveArr;
		}

		/**
		 * 交错排列/等角"索引" → 交错排列/等角"坐标"(路点中心点坐标)
		 * @param rhombusX
		 * @param rhombusY
		 * @param tileW
		 * @param tileH
		 * @param move3D
		 * @return
		 */
		private function getPoint(rhombusX:int, rhombusY:int, tileW:int, tileH:int, move3D:RoleObjectIsoPoint3D):Point
		{
			var pt:Point;
			if (mapType == STAGGERED)
				pt=getStaggeredPoint(new Point(rhombusX, rhombusY), tileW, tileH);
			else
				pt=getIsometricPoint(rhombusX, rhombusY, tileH, move3D);
			move3D=null;
			return pt;
		}
		/**
		 * 获得移动对象
		 * @param start
		 * @param end
		 * @param speed
		 * @return 
		 */
		private function getMoveVO(start:Point, end:Point,speed:int=3):MoveVO
		{
			//获得终点到起点的弧度
			var radian:Number=Math.atan2(end.y - start.y, end.x - start.x);
			var velocity:Point=getVelocity(radian, speed);
			var mVO:MoveVO=new MoveVO();
			mVO.velocityX=velocity.x;
			mVO.velocityY=velocity.y;
			mVO.direct=getDirect(radian);
			mVO.endX=end.x;
			mVO.endY=end.y;
			start=null;
			end=null;
			velocity=null;
			return mVO;
		}

		/**
		 * 计算速度向量
		 * @param radian	弧度
		 * @param speed		速度
		 * @return
		 */
		public function getVelocity(radian:Number, speed:int):Point
		{
			var vx:Number=Math.cos(radian) * speed;
			var vy:Number=Math.sin(radian) * speed;
			return new Point(vx, vy);
		}

		/**
		 * 计算移动方向
		 * 0/8    =   左
		 * 1      =   左上
		 * 2      =   上
		 * 3      =   右上
		 * 4      =   右
		 * 5      =   右下
		 * 6      =   下
		 * 7      =   左下
		 * @param radian
		 * @return
		 */
		public function getDirect(radian:Number):int
		{
			var angle:Number=(radian * 180) / Math.PI;
			var dire:int=Math.round((((angle * Math.PI) / 180) + Math.PI) / (Math.PI / 4));
			if (dire == 8)
				dire=0;
			return dire;
		}
		/**
		 * 交错排列"索引" → 交错排列"坐标"(路点中心点坐标)
		 * @param pt
		 * @param tileW
		 * @param tileH
		 * @return
		 */
		public function getStaggeredPoint(pt:Point, tileW:int, tileH:int):Point
		{
			var tileCenter:Number=(pt.x * tileW) + (tileW >>1);
			var xPixel:Number=tileCenter + ((pt.y & 1) * tileW >>1);
			var yPixel:Number=(pt.y + 1) * tileH >>1;
			pt=null;
			return new Point(xPixel, yPixel);
		}	
		/**
		 *  等角"索引" → 等角"坐标"(屏幕2D中心点坐标)
		 * @param ix
		 * @param iy
		 * @param tileH
		 * @param move3D	
		 * @return 
		 */
		public function getIsometricPoint(ix:int,iy:int,tileH:int,move3D:RoleObjectIsoPoint3D):Point
		{
			var mx:Number=move3D.x+(ix*tileH);
			var my:Number=move3D.y+0;
			var mz:Number=move3D.z+(iy*tileH);
			var pt3D:RoleObjectIsoPoint3D=new RoleObjectIsoPoint3D(mx,my,mz);
			move3D=null;	
			return isoToScreen(pt3D);				
		}
		/**
		 * 等角空间中的3D坐标点转换成屏幕上的2D坐标点
		 * @param pt3D
		 * @return 
		 */
		public function isoToScreen(pt3D:RoleObjectIsoPoint3D):Point
		{
			var screenX:Number = pt3D.x - pt3D.z;
			var screenY:Number = pt3D.y * Y_CORRECT + ((pt3D.x + pt3D.z) >>1);
			pt3D=null;
			return new Point(screenX, screenY);
		}					
	}
}