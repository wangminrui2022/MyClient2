package com.mapfile.vo
{
	/**
	 * 地图信息类
	 * @author 王明凡
	 */
	public class MInfoVO
	{
		/**
		 * 地图名
		 * @default 
		 */		
		public var name:String;
		/**
		 * 地图类型
		 * @default 
		 */		
		public var mapType:String;
		/**
		 * 地图宽 
		 * @default 
		 */		
		public var mapwidth:int;
		/**
		 * 地图高 
		 * @default 
		 */		
		public var mapheight:int;
		/**
		 * 地图地砖影片剪辑材质类名
		 * @default 
		 */		
		public var diffuse:String;	
		
		/**
		 * 路点字符串
		 * @default 
		 */		
		public var floor:String;
		/**
		 * 网格宽
		 * @default 
		 */		
		public var tileWidth:int;
		/**
		 * 网格高
		 * @default 
		 */		
		public var tileHeight:int;
		/**
		 * 路点行
		 * @default 
		 */		
		public var row:int;		
		/**
		 * 路点列
		 * @default 
		 */		
		public var column:int;
		/**
		 * objects显示对象集合(MObjectsVO)
		 * @default 
		 */		
		public var mObjectsVOArr:Array;							
	}
}