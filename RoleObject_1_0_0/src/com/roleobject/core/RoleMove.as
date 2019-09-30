package com.roleobject.core
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	/**
	 * 角色移动类
	 * @author 王明凡
	 */
	public class RoleMove extends GetMove
	{
		/**
		 * 移动路数组
		 * @default 
		 */
		private var moveArr:Array;
		/**
		 * 当前移动路数量
		 * @default 
		 */
		private var moveCount:int;			
		/**
		 * 是否正在移动
		 * @default 
		 */
		private var isMove:Boolean; 
		/**
		 * 一段路的距离
		 * @default 
		 */
		private var distance:Number=0;	
		/**
		 * 移动Timer
		 * @default 
		 */
		private var tm:Timer;
		/**
		 * 移动方向
		 * @default 
		 */
		private var direct:int=-1;
		/**
		 * 移动对象
		 * @default 
		 */
		private var role:Role;
		/**
		 * 
		 * @default 
		 */		
		private var move3D:RoleObjectIsoPoint3D;
		/**
		 * 移动回调函数
		 * @default 
		 */
		public var moveCall:Function;
				
		public function RoleMove(mapType:String,tileW:int, tileH:int,move3D:RoleObjectIsoPoint3D)
		{
			this.tm=new Timer(5);
			this.move3D=move3D;
			super(mapType,tileW,tileH);
			
		}
		/**
		 * 
		 * @param roadArr
		 * @param first
		 * @param moveObject
		 */
		public function onRoleMove(roadArr:Array,first:Point,role:Role):void
		{
			if(isMove)
				clearRoad();	
			if(roadArr.length>0)	
				moveArr=getMoveArr(roadArr,first,move3D);
			roadArr.splice(0,roadArr.length);
			roadArr=null;
			this.role=role;
			//开始移动角色
			onStart();						
		}
		/**
		 * 开始移动
		 */
		private function onStart():void
		{
			if(!moveArr)
				return;
			if(moveCount<moveArr.length)
			{								
				isMove=true;
				//计算当前路程距离,采用勾股定理:a2+b2=c2;在开平方根
				var pt:Point=new Point(moveArr[moveCount].endX,moveArr[moveCount].endY);
				distance=Point.distance(new Point(role.x,role.y),pt);	
				pt=null;		
				tm.addEventListener(TimerEvent.TIMER,onTimer);
				tm.start();	
				if(direct!=moveArr[moveCount].direct)
				{
					direct=moveArr[moveCount].direct;	
					role.Run(direct);
				}				
			}
			else
			{
				role.Stand(direct);
				clearRoad();
			}
		}	
		/**
		 * Timer移动
		 * @param e
		 */
		private function onTimer(e:TimerEvent):void
		{
			//计算当前动态移动距离
			var pt:Point=new Point(moveArr[moveCount].endX,moveArr[moveCount].endY);
			var newD:Number =Point.distance(new Point(role.x,role.y),pt);
			pt=null;
			if(distance <newD)
			{	
//				role.x+=moveArr[moveCount].endX-role.x;
//				role.y+=moveArr[moveCount].endY-role.y;				
				tm.stop();
				tm.removeEventListener(TimerEvent.TIMER,onTimer);
				moveCount++;
				onStart();
			}
			else
			{
				role.x+=moveArr[moveCount].velocityX;
				role.y+=moveArr[moveCount].velocityY;
				distance=newD;		
				moveCall.call(this);			
			}		
		}
		/**
		 * 清理垃圾
		 */		
		public function clear():void
		{
			if(role)
				role.Stand(direct);
			clearRoad();
			tm=null;
			move3D=null;
		}					
		/**
		 * 清理当前移动路垃圾
		 */
		public function clearRoad():void
		{
			if(tm)
			{
				tm.stop();
				tm.removeEventListener(TimerEvent.TIMER,onTimer);
			}
			if(moveArr)				
				moveArr.splice(0,moveArr.length);
			moveArr=null;
			moveCount=0;
			isMove=false;
			distance=0;
			direct=-1;		
			role=null;	
		}
		
	}
}