/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.vo.material
{
	import com.mapfile.vo.MMaterialDefinitionVO;
	import com.maptype.vo.RectangleVO;
	
	/**
	 * 材质平铺对象
	 * @author wangmingfan
	 */
	[RemoteClass]
	public class MaterialTileVO
	{
		//Class类
		[Bindable]
		public var mClass:Class;		
		//节点属性 <materialDefinition/>
		[Bindable]
		public var mdVO:MMaterialDefinitionVO;	
		//材质二维数组路点(RoadVO)
		[Bindable]
		public var roadArr:Array;	
		//障碍点的矩形局域
		public var obstacleRect:RectangleVO;
	}
}