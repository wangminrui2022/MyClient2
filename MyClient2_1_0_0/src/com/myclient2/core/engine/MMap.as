/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.engine
{
	import flash.display.Loader;
	import flash.events.*;
	import flash.geom.Rectangle;

	import com.myclient2.core.MIsoPoint3D;
	import com.myclient2.core.MSprite;
	import com.myclient2.core.vo.MInfoVO;
	import com.myclient2.interfaces.IMap;
	import com.myclient2.loader.MOpenMap;
	import com.myclient2.util.MIsoUtils;

	/**
	 * MMap用于创建一个地图对象，将显示对象添加到地图对象中显示
	 * @author 王明凡
	 */	
	public class MMap extends MSprite implements IMap
	{
		private var _info:MInfoVO;
		private var _SWFLoaderArr:Array;
		private var _move3D:MIsoPoint3D;

		/**
		 *构造函数 
		 */
		public function MMap()
		{

		}
		/**
		 * 根据地图路径RUL，创建一个地图，注意地图文件格式为(.mcmap)
		 * @param path	地图路径
		 */
		public function createMap(url:String):void
		{
			var openMap:MOpenMap=new MOpenMap(url);
			openMap.addEventListener(Event.COMPLETE, onMOpenMapComplete);
			openMap.addEventListener(ProgressEvent.PROGRESS, onProgress);
			openMap.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			openMap.onOpen();
			openMap=null;
		}

		/**
		 * 加载.mcmap文件完成
		 * @param e
		 */
		private function onMOpenMapComplete(e:Event):void
		{
			var openMap:MOpenMap=e.currentTarget as MOpenMap;
			info=openMap.getInfo();
			SWFLoaderArr=openMap.getSWFLoaderArr();
			move3D=MIsoUtils.getMove3D(info.row, info.column, info.tileHeight);
			clearBasicOpen(openMap);
			openMap=null;
			this.dispatchEvent(e);
		}

		/**
		 * 加载.mcmap文件进度
		 * @param e
		 */
		private function onProgress(e:ProgressEvent):void
		{
			this.dispatchEvent(e);
		}

		/**
		 * 加载.mcmap文件错误
		 * @param e
		 */
		private function onIoError(e:IOErrorEvent):void
		{
			clearBasicOpen(e.currentTarget as MOpenMap);
			this.dispatchEvent(e);
		}

		/**
		 * 清理基本打开类
		 */
		private function clearBasicOpen(openMap:MOpenMap):void
		{
			openMap.removeEventListener(Event.COMPLETE, onMOpenMapComplete);
			openMap.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			openMap.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			openMap.clear();
			openMap=null;
		}

		/**
		 * 设置当前地图的信息
		 * @param info
		 */
		public function set info(info:MInfoVO):void
		{
			_info=info;
		}

		/**
		 * 返回当前地图的信息
		 * @return
		 */
		public function get info():MInfoVO
		{
			return _info;
		}

		/**
		 * 设置当前地图的材质对象集合
		 * @param SWFLoaderArr
		 */
		public function set SWFLoaderArr(SWFLoaderArr:Array):void
		{
			_SWFLoaderArr=SWFLoaderArr;
		}

		/**
		 * 返回当前地图的材质对象集合
		 * @return
		 */
		public function get SWFLoaderArr():Array
		{
			return _SWFLoaderArr;
		}

		/**
		 * 如果当前地图为“等角”类型地图，则设置当前“等角”地图的3D移动坐标
		 * @param move3D
		 */
		public function set move3D(move3D:MIsoPoint3D):void
		{
			_move3D=move3D;
		}

		/**
		 * 如果当前地图为“等角”类型地图，则设置当前“等角”地图的3D移动坐标
		 * @return
		 */
		public function get move3D():MIsoPoint3D
		{
			return _move3D;
		}

		/**
		 * 清理当前地图所有显示对象以及地图信息数据
		 */	
		override public function clear():void
		{
			clearDispaly();
			info=null;
			move3D=null;
			if (SWFLoaderArr)
			{
				for each (var ld:Loader in SWFLoaderArr)
				{
					ld.unload();
					ld.unloadAndStop();
					ld=null;
				}
				SWFLoaderArr.splice(0, SWFLoaderArr.length);
			}
			SWFLoaderArr=null;
		}

		/**
		 * 清理地图上的所有显示对象
		 */
		private function clearDispaly():void
		{
			var len:int=this.numChildren;
			for (var i:int; i < len; i++)
			{
				this.removeChildAt(0);
			}
		}

	}
}