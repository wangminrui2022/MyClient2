package com.pureMVC.view.ui.as_
{
	import flash.display.*;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import com.consts.MString;
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import com.pureMVC.core.AppFacade;
	import com.vo.material.MaterialTileVO;
	/**
	 * 
	 * @author 王明凡
	 */
	public class OnlyImage extends Image
	{
		//材质平铺对象
		public var mTileVO:MaterialTileVO;

		public function OnlyImage()
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreateComplete);
		}
		private function onCreateComplete(e:FlexEvent):void
		{	
			this.source=getImage();
			this.toolTip=getAttribute();
			this.removeEventListener(FlexEvent.CREATION_COMPLETE,onCreateComplete);
		}
		/**
		  * 设置材质属性
		  * @param item
		  */
		public function getAttribute():String
		{
			var s:String;
			try
			{
				//添加材质信息	
				s="名字:" + mTileVO.mdVO.name + 
				"\n类型:" + mTileVO.mdVO.type+ 
				"\n宽:" + mTileVO.mdVO.width + 
				"\n高:" + mTileVO.mdVO.height + 
				"\n使用方式:" + mTileVO.mdVO.used +  
				"\n元件类型:"+mTileVO.mdVO.elementType+ 
				"\n元件类名:" + mTileVO.mdVO.diffuse;				
				
			}catch(er:Error)
			{
				AppFacade.getInstace().sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}	
			return s;
		}		
		/**
		 * 获得image
		 * @param mClass
		 * @param elementType
		 * @return 
		 */
		private function getImage():DisplayObject
		{
			if (mTileVO.mdVO.elementType == MString.BITMAPDATA)
			{
				var btm:Bitmap=new Bitmap(new mTileVO.mClass(null, null) as BitmapData);
				return btm;		
			}
			else if (mTileVO.mdVO.elementType == MString.MOVIECLIP)
			{
				var mc:MovieClip=new mTileVO.mClass() as MovieClip;
				return mc;
			}
			return null;
		}		
	}
}