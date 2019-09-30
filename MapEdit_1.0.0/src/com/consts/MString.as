/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.consts
{
	/**
	 * 字符串常量
	 * @author 王明凡
	 */
	public class MString
	{
		/**
		 * 地图缓存最大宽高
		 * */
		 public static const MAPCACHEWIDTH:int=4000;
		 public static const MAPCACHEHEIGHT:int=4000;
		 
		/**
		 * 菜单选项
		 */
		public static const CREATEFILEBAR:String="creatFileBar";
		public static const SAVEFILEBAR:String="saveFileBar";
		public static const CLOSEFILEBAR:String="closeFileBar";
		public static const OPENFILEBAR:String="openFileBar";
		public static const ABOUTBAR:String="aboutMeBar";
		public static const HELPBAR:String="helpBar";
		public static const MAPINFOBAR:String="mapInfoBar";		
		public static const SWITCHBAR:String="switchBar";	
		public static const SETMAPBAR:String="setMapBar";
		public static const COPYMAPIMAGEBAR:String="copyMapImageBar";	
		
		/**
		 * 材质类型
		 */		
		public static const OBJECT:String="object";
		public static const TILE:String="tile";

		/**
		 * 材质使用方式
		 */			
		public static const NULL:String="null";
		public static const TILES:String="tiles";
		public static const ONLY:String="only";
		public static const OPERATE:String="operate";
		
		/**
		 * 元件类型
		 */			
		public static const BITMAPDATA:String="BitmapData";
		public static const MOVIECLIP:String="MovieClip";
		
		/**
		 * 路点
		 */			
		public static const ROAD:String="road";
		
		/**
		 * 上下文菜单选项
		 */		
		public static const IMPORT_MATERIAL:String="导入材质          ";
		public static const USE_MATERIAL:String="使用材质          ";
		public static const EDIT_MATERIAL:String="编辑材质          ";		
		public static const DELETE_MATERIAL:String="删除材质          ";
		public static const OBJECTINFO:String="对象信息          ";
		public static const REMOVE:String="移除          ";
		public static const RESET:String="重置          ";
		public static const DEPTH_1:String="深度+1          ";
		public static const DEPTH_2:String="深度-1          ";
		public static const DISPLAY_ROAD:String="显示路点和边框    ";
		public static const HIDE_ROAD:String="隐藏路点和边框    ";
		public static const DISPLAY_DEPTH:String="显示深度          ";
		public static const HIDE_DEPTH:String="隐藏深度          ";
		public static const CANCEL:String="取消          ";
		
		/**
		 * 标题
		 */		
		public static const TITLE:String="MyClient2 地图编辑器";
		public static const VERSION:String="Version 1.0.0";
		public static const COPYTIGHT:String="copyright © 2010 黑色闪电工作室";
		public static const URL:String="www.heiseshandian.com";	

		/**
		 * 路点颜色
		 * 0  通过
		 * 1  障碍
		 * 2  阴影
		 */			
		public static const PASS:int=0xade68f;
		public static const OBSTACLE:int=0xe34935;
		public static const SHADOW:int=0xa7a4a3;

		/**
		 * 网格颜色
		 */	
		public static const GRIDS:int=0xf5b61e;
		
		
		/**
		 * 地图文件格式
		 * @default 
		 */
		public static const MCMAPS:String=".mcmap";
		public static const ME:String=".me";
		
	}
}