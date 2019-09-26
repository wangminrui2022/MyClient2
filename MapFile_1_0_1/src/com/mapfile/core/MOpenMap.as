package com.mapfile.core
{
	import flash.events.*;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import com.mapfile.interfaces.IOpenMap;
	import com.mapfile.loader.MLoader;
	import com.mapfile.loader.MLoopLoader;
	import com.mapfile.vo.MInfoVO;
	import com.mapfile.vo.MMaterialDefinitionVO;
	import com.mapfile.vo.MObjectsVO;
	import com.mapfile.vo.MapVO;

	/**
	 * 
	 * @author wangmingfan
	 */
	public class MOpenMap extends EventDispatcher implements IOpenMap
	{
		private var map:MapVO;
		
		private var path:String;
				
		public function MOpenMap(path:String)
		{
			this.path=path;	
			this.map=new MapVO();						
		}

		/**
		 * 
		 */
		public function onOpen():void
		{
			var mLoader:MLoader=new MLoader();
			mLoader.addEventListener(Event.COMPLETE,onMLoaderComplete);
			mLoader.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
			mLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			mLoader.onLoaderURL(path,URLLoaderDataFormat.BINARY);
			mLoader=null;				
		}
		/**
		 * 返回地图信息
		 * @return 
		 */
		public function getMapVO():MapVO
		{
			return map;
		}		
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			map=null;
		}
		/**
		 * 加载地图字节数组完成
		 * @param e
		 */
		private function onMLoaderComplete(e:Event):void
		{
			var mLoader:MLoader=e.currentTarget as MLoader;
			onReadMapByte(mLoader.getByte());
			clearMLoader(mLoader);
			mLoader=null;
		}
		/**
		 * 加载过程
		 * @param e
		 */
		private function onProgress(e:ProgressEvent):void
		{
			this.dispatchEvent(e);
		}
		/**
		 * 加载错误
		 * @param e
		 */
		private function onIoError(e:IOErrorEvent):void
		{
			if(e.currentTarget is MLoader)
				clearMLoader(e.currentTarget as MLoader);
			else if(e.currentTarget as MLoopLoader)
				clearMLoopLoader(e.currentTarget as MLoopLoader);
			this.dispatchEvent(e);
		}
		/**
		 * 清理BasicLoader
		 * @param bl
		 */
		private function clearMLoader(mLoader:MLoader):void
		{
			mLoader.removeEventListener(Event.COMPLETE,onMLoaderComplete);
			mLoader.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
			mLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			mLoader.clear();
			mLoader=null;		
		}	
		/**
		 * 清理LoopLoader
		 * @param bl
		 */
		private function clearMLoopLoader(loop:MLoopLoader):void
		{
			loop.removeEventListener(Event.COMPLETE,onMLoopLoaderComplete);
			loop.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
			loop.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loop.clear();
			loop=null;		
		}	
		/**
		 * 读取地图字节数组
		 * 顺序:
		 * 1.读取-地图信息字节数组的字节长度
		 * 2.读取-地图信息字节数组
		 * 3.读取-swf长度字节数组的长度
		 * 4.读取-swf长度字节数组
		 * 5.读取-swf
		 * @param mapByte
		 */
		private function onReadMapByte(mapByte:ByteArray):void
		{
			var infoByte:ByteArray=new ByteArray();
			var SWFByte:ByteArray=new ByteArray();
			var SWFLengthByte:ByteArray=new ByteArray();
			try
			{
				var infoByteLen:int=mapByte.readInt();
				mapByte.readBytes(infoByte,0,infoByteLen);
				map.info=getMInfoVO(infoByte);			
				var swfByteLen:int=mapByte.readInt();	
				//如果没有swf材质
				if(swfByteLen==0)
				{
					clearByteArray(mapByte);
					mapByte=null;
					clearByteArray(infoByte);
					infoByte=null;
					SWFLengthByte=null;
					this.dispatchEvent(new Event(Event.COMPLETE));
					return;
				}
				mapByte.readBytes(SWFLengthByte,0,swfByteLen);
				mapByte.readBytes(SWFByte,0,mapByte.bytesAvailable);
				//循环加载swf的字节数组
				onLoopLoader(getArray(SWFLengthByte.readUTF()),SWFByte);
			}catch(er:Error)
			{
				clearByteArray(SWFByte);
				this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			}	
			clearByteArray(mapByte);
			mapByte=null;
			clearByteArray(infoByte);
			infoByte=null;
			SWFByte=null;
			clearByteArray(SWFLengthByte);		
			SWFLengthByte=null;									
		}
		/**
		 * 循环加载swf的字节数组
		 * @param SWFLengthArr
		 * @param SWFByte
		 */
		private function onLoopLoader(SWFLengthArr:Array,SWFByte:ByteArray):void
		{
			var loop:MLoopLoader=new MLoopLoader();
			loop.addEventListener(Event.COMPLETE,onMLoopLoaderComplete);
			loop.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
			loop.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loop.onLoopLoader(SWFLengthArr,SWFByte);
			loop=null;					
		}
		/**
		 * 循环加载swf的字节数组完成
		 * @param e
		 */
		private function onMLoopLoaderComplete(e:Event):void
		{
			var loop:MLoopLoader=e.currentTarget as MLoopLoader;
			map.SWFLoaderArr=loop.getSWFLoaderArr();
			map.SWFByteArr=loop.getSWFByteArr();
			clearMLoopLoader(loop);
			loop=null;
			this.dispatchEvent(e);
		}				
		/**
		 * 清理字节数组
		 * @param byte
		 */
		private function clearByteArray(byte:ByteArray):void
		{
			if(byte)
				byte.clear();
			byte=null;
		}		
		/**
		 * 获得地图信息对象
		 * @param infoByte
		 * @return 
		 */
		private function getMInfoVO(infoByte:ByteArray):MInfoVO
		{
			var info:MInfoVO=new MInfoVO();
			info.name=infoByte.readUTF();
			info.mapType=infoByte.readUTF();
			info.mapwidth=infoByte.readInt();
			info.mapheight=infoByte.readInt();
			info.diffuse=infoByte.readUTF();
			info.floor=readFloor(infoByte);
			info.tileWidth=infoByte.readInt();
			info.tileHeight=infoByte.readInt();
			info.row=infoByte.readInt();
			info.column=infoByte.readInt();
			if(infoByte.bytesAvailable>0)
				info.mObjectsVOArr=readMObjectsVOArr(infoByte);
			infoByte=null;
			return info;
		}
		/**
		 * 读取路点字符串
		 * @param by
		 * @param str
		 */
		private function readFloor(infoByte:ByteArray):String		
		{
			var byFloor:ByteArray=new ByteArray();
			var len:int=infoByte.readInt();
			infoByte.readBytes(byFloor,0,len);
			var floor:String=byFloor.readMultiByte(byFloor.length,"gb2312");
			infoByte=null;
			byFloor.clear();
			byFloor=null;
			return floor;
		}
		/**
		 * 读取地图对象集合
		 * @param infoByte
		 * @return 
		 */
		private function readMObjectsVOArr(infoByte:ByteArray):Array
		{
			var lenArr:Array=getArray(infoByte.readUTF());
			var len:int=infoByte.readInt();
			var byArr:ByteArray=new ByteArray();
			infoByte.readBytes(byArr,0,len);
			infoByte=null;
			var mObjectsVOArr:Array=new Array();
			for each(var i:String in lenArr)
			{
				var byte:ByteArray=new ByteArray();
				byArr.readBytes(byte,0,int(i));
				mObjectsVOArr.push(readMObjectsVO(byte));
				byte.clear();
				byte=null;
			}
			lenArr.splice(0,lenArr.length);
			lenArr=null;
			byArr.clear();
			byArr=null;
			return mObjectsVOArr;
		}	
		/**
		 * 读取地图对象
		 * @param byte
		 * @return 
		 */
		private function readMObjectsVO(byte:ByteArray):MObjectsVO
		{
			var ojVO:MObjectsVO=new MObjectsVO();
			ojVO.id=byte.readUTF();
			ojVO.index=byte.readInt();
			ojVO.depth=byte.readInt();
			ojVO.x=byte.readInt();
			ojVO.y=byte.readInt();
			ojVO.materialDefinition=readMMaterialDefinitionVO(byte);
			byte=null;
			return ojVO;
		}		
		/**
		 * 读取材质定义对象
		 * @param byte
		 * @return 
		 */
		private function readMMaterialDefinitionVO(byte:ByteArray):MMaterialDefinitionVO
		{
			var len:int=byte.readInt();
			var tmp:ByteArray=new ByteArray();
			byte.readBytes(tmp,0,len);
			byte=null;
			var mdVO:MMaterialDefinitionVO=new MMaterialDefinitionVO();
			mdVO.name=tmp.readUTF();
			mdVO.type=tmp.readUTF();
			mdVO.used=tmp.readUTF();
			mdVO.width=tmp.readInt();
			mdVO.height=tmp.readInt();
			mdVO.elementType=tmp.readUTF();
			mdVO.diffuse=tmp.readUTF();
			tmp.clear();
			tmp=null;
			return mdVO;
		}
		/**
		 * 获得字符串的数组集合
		 * @param len
		 * @return 
		 */
		private function getArray(len:String):Array
		{
			var tmp:Array=len.split(",");
			tmp.splice(tmp.length-1,1);
			return tmp;
		}		
	}
}