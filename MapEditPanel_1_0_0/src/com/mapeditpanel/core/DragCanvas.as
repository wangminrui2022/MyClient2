package com.mapeditpanel.core
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;

	/**
	 * 拖动画布
	 * @author wangmingfan
	 */
	public class DragCanvas extends Canvas
	{
		[Embed(source="com/mapeditpanel/assets/dragHand.swf")]
		public var dragHand:Class;
		
		private var regX:Number;
		private var regY:Number;
		private var regHScrollPosition:Number;
		private var regVScrollPosition:Number;
		
		/**
		 * 是否点中子对象也能拖动画布
		 * @default 
		 */
		private var childrenDoDrag:Boolean=true;

		/**
		 * 重写父类创建组件的子对象方法
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			startDragging();
		}
		/**
		 * 开始监听鼠标拖动事件
		 */
		public function startDragging():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		/**
		 * 清理拖动
		 */
		public function clearDragging():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		/**
		 * 鼠标按下事件
		 * @param event
		 */
		private function onMouseDown(e:MouseEvent):void
		{		
			if (e.target.parent == this.verticalScrollBar || e.target.parent == this.horizontalScrollBar)
				return;			
			this.cursorManager.setCursor(dragHand);		
			if (childrenDoDrag || e.target == this)
			{

				regX=e.stageX;
				regY=e.stageY;

				regHScrollPosition=this.horizontalScrollPosition;
				regVScrollPosition=this.verticalScrollPosition;

				this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				this.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			}
		}
	    /**
	     * 鼠标移动
	     * @param e
	     */
	    private function onMouseMove(e:MouseEvent):void
	    {
	    	e.stopImmediatePropagation();
	    	this.verticalScrollPosition = regVScrollPosition - (e.stageY - regY);
	    	this.horizontalScrollPosition = regHScrollPosition - (e.stageX - regX);
	    }
	    /**
	     * 鼠标弹起
	     * @param e
	     */
	    private function onMouseUp(e:MouseEvent):void
	    {
	        if (!isNaN(regX))
	            stopDragging();
	    }
		/**
		 * 鼠标离开当前画布时候
		 * @param e
		 */
		private function onRollOut(e:MouseEvent):void
		{
	        if (!isNaN(regX))
	            stopDragging();
		}	    	
	    /**
	     * 停止拖动
	     */
	    private function stopDragging():void
	    {
			this.cursorManager.removeAllCursors();	 
	        this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	        this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	        this.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);			   	
	        regX = NaN;
	        regY = NaN;
	    }			        	
		/**
		 * 
		 * @return 
		 */
		public function get ChildrenDoDrag():Boolean
		{
			return this.childrenDoDrag;
		}	
		/**
		 * 
		 * @param value
		 */
		public function set ChildrenDoDrag(value:Boolean):void
		{
			this.childrenDoDrag=value;
		}
	}
}