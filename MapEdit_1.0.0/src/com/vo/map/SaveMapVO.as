/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.vo.map
{
	import flash.utils.ByteArray;
	
	/**
	 * 保存地图
	 * @author wangmingfan
	 */
	public class SaveMapVO
	{
		//保存场景信息字节数组以及材质字节数组
		public static const SM_SAVE_MAP_MATERIAL:String="sm_save_map_material";
		//保存场景信息字节数组
		public static const SM_SAVE_MAP:String="sm_save_map";
		//保存材质字节数组
		public static const SM_MATERIAL:String="sm_material";
		
		
		//操作类型
		public var operateType:String;
		//材质字节数组
		public var SWFByteArr:Array;
		
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			operateType=null;
			if(SWFByteArr)
			{
				var len:int=SWFByteArr.length;
				for(var i:int=0;i<len;i++)
				{
					var byte:ByteArray=SWFByteArr[0] as ByteArray;
					byte.clear();
					byte=null;
					SWFByteArr.splice(0,1);
				}
			}
			SWFByteArr=null;
		}
	}
}