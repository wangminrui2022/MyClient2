package com.mapfile.core
{
	import flash.filesystem.*;
	import flash.utils.ByteArray;
	
	import com.mapfile.interfaces.ISaveMap;
	import com.mapfile.vo.MInfoVO;
	import com.mapfile.vo.MMaterialDefinitionVO;
	import com.mapfile.vo.MObjectsVO;

	/**
	 * 
	 * @author wangmingfan
	 */
	public class MSaveMap implements ISaveMap
	{
		private var infoByte:ByteArray;
		private var SWFLengthByte:ByteArray;
		private var SWFByte:ByteArray;
		private var file:File;
		private var stream:FileStream;
				
		public function MSaveMap(path:String)
		{
			this.infoByte=new ByteArray();
			this.SWFLengthByte=new ByteArray();
			this.SWFByte=new ByteArray();
			this.file=new File(path);
			this.stream=new FileStream();			
		}
		/**
		 * 保存地图文件,顺序:
		 * 1.写入-地图信息字节数组的字节长度
		 * 2.写入-地图信息字节数组
		 * 3.写入-swf长度字节数组的长度
		 * 4.写入-swf长度字节数组
		 * 5.写入-swf字节数组
		 */
		public function onSave():void
		{
			if (file.exists)
				file.deleteFile();
			try
			{
				stream.open(file, FileMode.WRITE);
				stream.writeInt(infoByte.length);
				stream.writeBytes(infoByte, 0, infoByte.length);
				stream.writeInt(SWFLengthByte.length);
				stream.writeBytes(SWFLengthByte, 0, SWFLengthByte.length);
				stream.writeBytes(SWFByte, 0, SWFByte.length);			
			}catch(er:Error)
			{
				trace(er.message + "\n" + er.getStackTrace());
			}	
			stream.close();			
		}
		/**
		 * 写入地图信息
		 * @param info
		 * @return
		 */
		public function writeInfo(info:MInfoVO):void
		{
			if(infoByte.length>0)
				infoByte.clear();
			try
			{
				infoByte.writeUTF(info.name);
				infoByte.writeUTF(info.mapType);
				infoByte.writeInt(info.mapwidth);
				infoByte.writeInt(info.mapheight);
				infoByte.writeUTF(info.diffuse);
				writeFloor(info.floor);
				infoByte.writeInt(info.tileWidth);
				infoByte.writeInt(info.tileHeight);
				infoByte.writeInt(info.row);
				infoByte.writeInt(info.column);
				if(info.mObjectsVOArr.length>0)
					writeMObjectsVOArr(info.mObjectsVOArr);			
			}catch(er:Error)
			{
				trace(er.message + "\n" + er.getStackTrace());
			}
			info=null;
		}	
		/**
		 * 写入swf长度以及swf
		 * @param swf
		 */
		public function writeSWF(swf:ByteArray):void
		{
			//1.添加swf的字节数组长度
			var swfLength:String="";
			if (SWFLengthByte.length > 0)
			{
				SWFLengthByte.position=0;
				swfLength=SWFLengthByte.readUTF();
				swfLength+=swf.length + ",";
			}
			else
			{
				swfLength+=swf.length + ",";
			}
			SWFLengthByte.position=0;
			SWFLengthByte.clear();
			SWFLengthByte.writeUTF(swfLength);
			//2.添加swf的字节数组
			SWFByte.writeBytes(swf, 0, swf.length);
		}
		/**
		 * 写入路点字符串
		 * @param by
		 * @param str
		 */
		private function writeFloor(str:String):void
		{
			var multiBy:ByteArray=new ByteArray();
			multiBy.writeMultiByte(str,"gb2312");
			infoByte.writeInt(multiBy.length);
			infoByte.writeBytes(multiBy,0,multiBy.length);	
			multiBy.clear();
			multiBy=null;
		}	
		/**
		 * 写入地图对象的字节数组集合
		 * @param mObjectsVOArr
		 */
		private function writeMObjectsVOArr(mObjectsVOArr:Array):void
		{
			var len:String="";
			var byArr:ByteArray=new ByteArray();
			for each(var oj:MObjectsVO in mObjectsVOArr)
			{
				var byte:ByteArray=writeMObjectsVO(oj);
				len+=byte.length+",";
				byArr.writeBytes(byte,0,byte.length);
				byte.clear();
				byte=null;
				oj=null;
			}
			infoByte.writeUTF(len);
			infoByte.writeInt(byArr.length);
			infoByte.writeBytes(byArr,0,byArr.length);	
			byArr.clear();
			byArr=null;	
			mObjectsVOArr=null;	
		}		
		/**
		 * 写入地图对象的字节数组
		 * @param oj
		 * @return 
		 */
		private function writeMObjectsVO(oj:MObjectsVO):ByteArray
		{
			var byte:ByteArray=new ByteArray();
			byte.writeUTF(oj.id);
			byte.writeInt(oj.index);
			byte.writeInt(oj.depth);
			byte.writeInt(oj.x);
			byte.writeInt(oj.y);
			var tmp:ByteArray=writeMMaterialDefinitionVO(oj.materialDefinition);
			byte.writeInt(tmp.length);
			byte.writeBytes(tmp,0,tmp.length);
			tmp.clear();
			tmp=null;
			oj=null;
			return byte;
		}
		/**
		 * 写入材质定义对象的字节数组
		 * @param mdVO
		 * @return 
		 */
		private function writeMMaterialDefinitionVO(mdVO:MMaterialDefinitionVO):ByteArray
		{
			var byte:ByteArray=new ByteArray();
			byte.writeUTF(mdVO.name);
			byte.writeUTF(mdVO.type);
			byte.writeUTF(mdVO.used);
			byte.writeInt(mdVO.width);
			byte.writeInt(mdVO.height);
			byte.writeUTF(mdVO.elementType);
			byte.writeUTF(mdVO.diffuse);
			mdVO=null;
			return byte;
		}					
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			clearByteArray(infoByte);
			clearByteArray(SWFLengthByte);
			clearByteArray(SWFByte);	
			if (stream)
				stream.close();
			stream=null;
			file=null;			
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
	}
}