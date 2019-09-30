package com.myclient2sample3.pureMVC.model
{
	import com.myclient2.core.engine.MCamera;
	import com.myclient2.core.engine.MEngine;
	import com.myclient2.core.engine.MMap;
	import com.myclient2.core.engine.MViewPort;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 
	 * @author 王明凡
	 */
	public class EngineProxy extends Proxy
	{
		public static const NAME:String="EngineProxy";
		
		public var engine:MEngine;
		
		public var map:MMap;
		
		public var viewPort:MViewPort;
		
		public var camera:MCamera;

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
		}		
	}
}