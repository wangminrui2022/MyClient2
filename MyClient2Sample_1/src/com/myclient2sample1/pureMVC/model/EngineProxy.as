package com.myclient2sample1.pureMVC.model
{
	import com.myclient2.core.engine.MCamera;
	import com.myclient2.core.engine.MEngine;
	import com.myclient2.core.engine.MMap;
	import com.myclient2.core.engine.MViewPort;
	
	import flash.display.Shape;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	/**
	 * 
	 * @author 王明凡
	 */
	public class EngineProxy extends Proxy
	{
		public static const NAME:String="EngineProxy";
		//渲染引擎
		public var engine:MEngine;
		//观察口
		public var viewPort:MViewPort;
		//摄像机
		public var camera:MCamera;
		//地图
		public var map:MMap;	
//		//寻路线条
//		public var lineSP:Shape;
										
		public function EngineProxy(data:Object=null)
		{
			super(NAME, data);
		}
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			engine.removeMap();
			engine=null;
			viewPort=null;
			camera=null;
			map=null;
//			lineSP.graphics.clear();
//			lineSP=null;
		}			
	}
}