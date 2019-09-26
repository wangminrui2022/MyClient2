/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.engine
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	import com.myclient2.core.MSprite;
	import com.myclient2.core.vo.MObjectsVO;

	/**
	 * MObjects在地图中显示，该显示对象包含了为object和tile类型的材质对象，可以是BitmapData或MovieClip的材质
	 * @author 王明凡
	 */
	public class MObjects extends MSprite
	{
		public static const BITMAPDATA:String="BitmapData";

		public static const MOVIECLIP:String="MovieClip";
		/**
		 * 地图对象以及材质信息
		 * @default
		 */
		public var ojVO:MObjectsVO;
		/**
		 * 构造对象
		 */
		public function MObjects()
		{

		}
		/**
		 * 根据“地图对象以及材质信息”显示地图对象
		 * @param ojVO				地图对象以及材质信息
		 * @param SWFLoaderArr		材质集合
		 * @throws Error
		 * @throws Error
		 */
		public function onDisplay(ojVO:MObjectsVO, SWFLoaderArr:Array):void
		{
			this.ojVO=ojVO;
			ojVO=null;
			var cls:Class=getMaterialClass(this.ojVO.materialDefinition.diffuse, SWFLoaderArr);
			SWFLoaderArr=null;
			try
			{
				if (this.ojVO.materialDefinition.elementType == BITMAPDATA)
				{
					var btm:Bitmap=new Bitmap(new cls(null, null) as BitmapData);
					this.addChild(btm);
				}
				else if (this.ojVO.materialDefinition.elementType == MOVIECLIP)
				{
					var mc:MovieClip=new cls() as MovieClip;
					this.addChild(mc);
				}
				else
				{
					throw new Error("显示对象的材质元件类型属性错误");
				}
			}
			catch (er:Error)
			{
				throw new Error("显示对象发生错误");
			}
			cls=null;
		}

		/**
		 *显示对象垃圾清理
		 */
		override public function clear():void
		{
			var child:DisplayObject=this.getChildAt(0);
			if (child is Bitmap)
			{
				var btm:Bitmap=child as Bitmap;
				btm.bitmapData.dispose();
				btm=null;
			}
			else if (child is MovieClip)
			{
				var mc:MovieClip=child as MovieClip;
				mc.stop();
				mc=null;
			}
			this.removeChild(child);
			child=null;
			ojVO=null;
		}
	}
}