/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * 资源模型
	 * @author wangmingfan
	 */
	public class AssetProxy extends Proxy
	{
		public static const NAME:String="AssetProxy";
		
		//障碍点图片
		[Embed(source="com/asset/image/curs/obstacle.png")]
		public var obstacle:Class;	
		
		//通过点图片
		[Embed(source="com/asset/image/curs/pass.png")]
		public var pass:Class;	
		
		//阴影点图片
		[Embed(source="com/asset/image/curs/shadow.png")]
		public var shadow:Class;		
					
		public function AssetProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
	}
}