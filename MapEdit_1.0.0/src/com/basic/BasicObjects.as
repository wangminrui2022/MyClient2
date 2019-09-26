/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.basic
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.filters.*;

	import com.consts.MString;
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import com.pureMVC.core.AppFacade;
	

	/**
	 * 基本对象显示类
	 * @author wangmingfan
	 */
	public class BasicObjects extends Sprite
	{
		//显示位图
		protected var btm:Bitmap;
		//显示影片
		protected var mc:MovieClip;
		//滤镜
		protected var btmFilter:BitmapFilter;
		//滤镜特效参数
		protected var distance:Number=0;
		protected var angleInDegrees:Number=0;
		protected var colors:Array;
		protected var alphas:Array;
		protected var ratios:Array;
		protected var blurX:Number=0;
		protected var blurY:Number=0;
		protected var strength:Number=0;
		protected var quality:Number=0;
		protected var type:String;
		protected var knockout:Boolean;

		public function BasicObjects()
		{
			btmFilter=new GradientGlowFilter(distance, angleInDegrees, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		/**
		 * 绘制对象
		 * @param elementType
		 * @param mClass
		 */
		public function draws(elementType:String,mClass:Class):void
		{
			if (elementType == MString.BITMAPDATA)
			{
				btm=new Bitmap(new mClass(null, null) as BitmapData);
				this.addChild(btm);				
			}
			else if (elementType == MString.MOVIECLIP)
			{
				mc=new mClass() as MovieClip;
				this.addChild(mc);
			}
		}
		/**
		 * 鼠标移过当前对象
		 * @param e
		 */
		protected function onMouseMove(e:MouseEvent):void
		{
				if(btm)
					btm.filters=[btmFilter];
				else
					mc.filters=[btmFilter];		
		}

		/**
		 * 鼠标移走当前对象
		 * @param e
		 */
		protected function onMouseOut(e:MouseEvent):void
		{
				if(btm)
					btm.filters=null;
				else
					mc.filters=null;
		}
		/**
		 * 清理Bitmap
		 */
		public function clearBitmap():void
		{
			try
			{
				if (btm)
				{
					this.removeChild(btm);
					if(btm.bitmapData)
					{
						btm.bitmapData.dispose();
						btm.bitmapData=null;
					}
					btm=null;
				}
				if(mc)
				{
					this.removeChild(mc);
					mc.stop();
					mc=null;
				}
			}
			catch (er:Error)
			{
				AppFacade.getInstace().sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			clearBitmap();
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			btmFilter=null;
			
			colors=null;
			alphas=null;
			ratios=null;
		}		
	}
}