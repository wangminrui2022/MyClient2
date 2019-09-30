package com.mapfile.vo
{
	/**
	 * 地图信息类
	 * @author 王明凡
	 */
	public class MapVO
	{
		//地图信息
		public var info:MInfoVO;
		//序列化文件路径
		public var serializablePath:String;
		//地图文件路径
		public var mapPath:String;	
		//路点数组(RoadVO) 
		public var roadArr:Array;					
		//场景对象索引(自动递增,唯一索引,ID同步)
		public var objectIndex:int; 		
		//objects显示对象集合(Objects)
		public var objectsArr:Array;
		//swf的Loader对象集合
		public var SWFLoaderArr:Array;
		//swf的Byte字节数组集合(打开场景时候，需要将map文件原有的swf字节数组写入当前编辑状态)
		public var SWFByteArr:Array;
		
		/**
		 * 地图信息以及材质对象垃圾清理
		 */
		public function clear():void
		{
			info=null;
			clearRoadArr();	
			clearObjectsArr();	
			//这两个数组已经被清理过了	
			SWFLoaderArr=null;
			SWFByteArr=null;
		}
		/**
		 * 清理路点数组
		 */
		public function clearRoadArr():void
		{		
			if(roadArr)
			{
				for(var y:int=0;y<roadArr.length;y++)
				{
					for(var x:int=0;x<roadArr[0].length;x++)
					{
						var oj:Object=roadArr[y][x];
						oj.index=null;
						oj.point=null;
						if(oj.shape)
							oj.shape.graphics.clear();
						oj.shape=null;
						oj=null;
					}
				}				
				var len:int=roadArr.length;
				for(var y2:int=0;y2<len;y2++)
				{
					var xRoadArr:Array=roadArr[0] as Array;
					xRoadArr.splice(0,xRoadArr.length);
					xRoadArr=null;
					roadArr.splice(0,1);
				}
			}
			roadArr=null;
		}
		/**
		 * 清理objects显示对象集合
		 */
		public function clearObjectsArr():void
		{
			if(objectsArr)
			{
				var len:int=objectsArr.length;
				for(var i:int=0;i<len;i++)
				{
					var oj:Object=objectsArr[0];
					oj.clear();
					oj=null;
					objectsArr.splice(0,1);
				}
			}
			objectsArr=null;
		}	
	}
}