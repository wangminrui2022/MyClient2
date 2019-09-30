package com.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * 资源模型
	 * @author 王明凡
	 */
	public class AssetProxy extends Proxy
	{
		public static const NAME:String="AssetProxy";	
								
		//swf图片
		[Embed(source="com/asset/image/other/swf.png")]
		public var swf:Class;	
					
		public function AssetProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
	}
}