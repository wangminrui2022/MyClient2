package com.myclient2sample3.pureMVC.view.mediator
{
	import com.myclient2.util.MIsoUtils;
	import com.myclient2.util.MStaUtils;
	import com.myclient2sample3.consts.Keys;
	import com.myclient2sample3.pureMVC.controller.business.mapoperate.MapConvertCommand;
	import com.myclient2sample3.pureMVC.model.EngineProxy;
	import com.myclient2sample3.pureMVC.model.RoleProxy;
	import com.myclient2sample3.pureMVC.model.UIProxy;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 移动键盘
	 * @author 王明凡
	 */
	public class MoveKeyboardMediator extends Mediator
	{
		public static const NAME:String="MoveKeyboardMediator";
		
		public static const MKM_START_KEYBOARD_LISTENER:String="mkm_start_keyboard_listener";
		
		public static const MKM_STOP_KEYBOARD_LISTENER:String="mkm_stop_keyboard_listener";
		
		private var uiP:UIProxy;
		private var roleP:RoleProxy;
		private var engineP:EngineProxy;
				
		private var min:Rectangle;

		private var up:Boolean;
		private var down:Boolean;
		private var left:Boolean;
		private var right:Boolean;
		private var jump:Boolean;
		private var run:Boolean;
		private var attack:Boolean;

		private var vx:int;
		private var vy:int;
		private var second:uint;
		private var delay:uint=350;
				
		public function MoveKeyboardMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
		}
		override public function listNotificationInterests():Array
		{
			return [
			MKM_START_KEYBOARD_LISTENER,
			MKM_STOP_KEYBOARD_LISTENER];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case MKM_START_KEYBOARD_LISTENER:
					onStartKeyboardListener(true);
					break;
				case MKM_STOP_KEYBOARD_LISTENER:
					onStartKeyboardListener(false);
					break;					
			}
		}
		/**
		 * 监听舞台
		 * @param bol
		 */
		private function onStartKeyboardListener(bol:Boolean):void
		{
			if(bol)
			{
				uiP.app.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				uiP.app.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				uiP.app.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);			
			}
			else
			{
				up=false;
				down=false;
				left=false;
				right=false;
				jump=false;
				run=false;
				attack=false;
				vx=0;
				vy=0;
				uiP.app.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);	
				uiP.app.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				uiP.app.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
		}
		/**
		 * 键盘按下
		 * @param e
		 */
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keys.UP:
					up=true;
					break;
				case Keys.DOWN:
					down=true;
					break;
				case Keys.LEFT:
					left=true;
					break;
				case Keys.RIGHT:
					right=true;
					break;
				case Keys.JUMP:
					if (!jump)
					{
						jump=true;
						up=false;
						down=false;
						left=false;
						right=false;
						roleP.role2.onPlay(4);
					}
					break;
				case Keys.ATTACK_1:
					if (!attack)
					{
						attack=true;
						up=false;
						down=false;
						left=false;
						right=false;
						roleP.role2.onPlay(5);
					}
					break;
			}
			if (!run && (up || down || left || right))
			{
				if (getTime() - second > delay)
				{
					second=getTime();
					roleP.role2.onPlay(2);
					vx=5;
					vy=5;
				}
				else
				{
					second=0;
					roleP.role2.onPlay(3);
					vx=10;
					vy=10;
				}
				run=true;
			}
		}
		/**
		 * 键盘弹起
		 * @param e
		 */
		private function onKeyUp(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keys.UP:
					up=false;
					break;
				case Keys.DOWN:
					down=false;
					break;
				case Keys.LEFT:
					left=false;
					break;
				case Keys.RIGHT:
					right=false;
					break;
				case Keys.JUMP:
					jump=false;
					break;
				case Keys.ATTACK_1:
					attack=false;
					break;
			}
			if (run && !up && !down && !left && !right)
			{
				run=false;
				roleP.role2.onPlay(1);
			}
		}

		/**
		 * 动画事件
		 * @param e
		 */
		private function onEnterFrame(e:Event):void
		{
			if (up)
			{
				onMoveRole(0, -vy);
			}
			if (down)
			{
				onMoveRole(0, vy);
			}
			if (left)
			{
				roleP.role2.rotationY=180;
				onMoveRole(-vx, 0);
			}
			if (right)
			{
				roleP.role2.rotationY=0;
				onMoveRole(vx, 0);
			}
		}
		/**
		 * 移动角色
		 * @param vx
		 * @param vy
		 */
		private function onMoveRole(vx:int, vy:int):void
		{
			var _x:int=roleP.role2.x + vx;
			var _y:int=roleP.role2.y + vy;
			if (isGO(new Point(_x, _y)))
			{
				roleP.moveDirection=vx;
				roleP.role2.x+=vx;
				roleP.role2.y+=vy;
				onMoveCamera(vx, vy);
			}
			//移动地图导航
			this.sendNotification(MapNavigateMediator.MNM_MOVE_MAP_NAVIGATE);
			//检查地图切换
			this.sendNotification(MapConvertCommand.MCC_MAP_CONVERT);
		}

		/**
		 * 获得当前移动点是否可通过
		 * @param pt
		 * @return
		 */
		private function isGO(pt:Point):Boolean
		{
			var result:Boolean;
			var tileH:int=engineP.map.info.tileHeight;
			if (engineP.map.info.mapType == MStaUtils.STAGGERED)
				pt=MStaUtils.getStaggeredIndex(pt, tileH << 1, tileH);
			else
				pt=MIsoUtils.getIsometricIndex(pt, tileH, engineP.map.move3D);

			if (pt.x < engineP.map.info.column && pt.y < engineP.map.info.row)
			{
				if (engineP.engine.mapSeeker.strRoadArr[pt.y][pt.x] == 1)
					result=false;
				else
					result=true;
			}

			pt=null;
			return result;
		}
		/**
		 * 移动摄像机
		 * @param sx
		 * @param sy
		 */
		private function onMoveCamera(sx:int, sy:int):void
		{
			var pt:Point=uiP.roleConatainer.localToGlobal(new Point(roleP.role2.x, roleP.role2.y));
			min=new Rectangle(pt.x - (roleP.role2.width >> 1), pt.y - roleP.role2.height, roleP.role2.width, roleP.role2.height);
			pt=null;
			engineP.engine.moveCamera2(sx, sy, min, uiP.max);
			//1.将移动摄像机的信息(矩形区域)给地图操作对象容器
			uiP.mapOperateContainer.scrollRect=engineP.camera.getRectangle();
			//2.将移动摄像机的信息(矩形区域)给地图角色容器
			uiP.roleConatainer.scrollRect=engineP.camera.getRectangle();
		}
		/**
		 * 获取毫秒数
		 * @return
		 */
		private function getTime():uint
		{
			return new Date().getTime();
		}				
	}
}