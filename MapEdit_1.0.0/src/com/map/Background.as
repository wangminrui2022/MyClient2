/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.map
{
	import flash.display.Sprite;

	/**
	 * 场景背景层
	 * 用户交错排序类型地图，充当鼠标单击触发事件的条件
	 * @author 王明凡
	 */
	public class Background extends Sprite
	{
		public function Background()
		{
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.tabChildren=false;
			this.useHandCursor=false;
		}

		public function drawBackground(w:int, h:int):void
		{
			this.graphics.beginFill(0xffffff,0);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();		
		}
		/**
		 * 当前类垃圾清理
		 */		
		public function clear():void
		{
			this.graphics.clear();
		}
	}
}